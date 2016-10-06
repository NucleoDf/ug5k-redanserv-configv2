#include "..\..\include\websrv\web-app-server.h"

#define _LOGIN_				0
#define _UPLOAD_			0
#define _SESSION_SUP_		1
#define _NO_EXPIRE_			0

/** */
WebAppServer::WebAppServer(void) 
	: document_root("appweb"), default_page("index.html"), enable_login(true)
{
}

/** */
WebAppServer::WebAppServer(string defaultDir, string defaultUrl, bool EnableLogin) 
{
	document_root = defaultDir;
	default_page = defaultUrl;
	enable_login = EnableLogin;
}

/** */
WebAppServer::~WebAppServer(void)
{
}

/** */
void WebAppServer::Start(string port, restHandler *pHandlers, web_config *pCfg)
{
	const char *ret;

	if ((server = mg_create_server(this, WebHandler))==NULL)
		throw Exception("Error al Crear Servidor HTTP");
	if ((ret=mg_set_option(server, "listening_port", port.c_str()))!=NULL)
		throw Exception("Error en mg_set_option: listening_port");
	if ((ret = mg_set_option(server, "document_root", document_root.c_str()))!=NULL)
		throw Exception("Error en mg_set_option: document_root");
	if ((ret = mg_set_option(server, "index_files", default_page.c_str()))!=NULL)
		throw Exception("Error en mg_set_option: index_files");

	p_handlers = pHandlers;
	p_cfg = pCfg;

	CThread::Start();
}

/** */
void WebAppServer::Dispose() 
{
	Stop();
	mg_destroy_server(&server);
}

/** */
void WebAppServer::Run()
{
	SetId("WebAppServer");

#if _SESSION_SUP_
	session_control.Reset();
#endif

	while(IsRunning())
	{
		try
		{
			this->sleep(10);
			mg_poll_server(server, 1000);
#if _SESSION_SUP_
#if _NO_EXPIRE_
			int t_inact = TIEMPO_SESION==0 ? TIEMPO_SESSION_DEFAULT : TIEMPO_SESION;
#else
			int t_inact = 30*60;
#endif
			if (session_control.Inactivo(t_inact)==true)      // Supervision de Tiempo de Inactividad.
				session_control.Reset();
#endif
		}
		catch(...)
		{
			PLOG_ERROR("WebAppServer::Run Excepcion en Lazo... ");
		}
	}
}

/** */
int WebAppServer::WebHandler(struct mg_connection *conn, enum mg_event ev)
{
	int result;
	WebAppServer *server = (WebAppServer *)conn->server_param;

	try 
	{
		switch (ev)
		{
		case MG_AUTH:

#if _LOGIN_
			if (enable_login==false)
				return MG_TRUE;
			return server->check_auth(conn);	  // return MG_TRUE;  
#else
			return MG_TRUE;
#endif

		case MG_RECV:
#if _UPLOAD_
			if (server->_hup.HandleRecv(conn, result))
				return result;
#endif
			return MG_FALSE;

		case MG_CLOSE:
#if _UPLOAD_
			if (server->_hup.HandleClose(conn, result))
				return result;
#endif
			return MG_FALSE;

		case MG_REQUEST:
#if _UPLOAD_
			if (server->_hup.HandleRequest(conn, result))
				return result;
#endif

#if _LOGIN_
			if (enable_login==true)
			{
				if (strcmp(conn->uri, s_login_uri) == 0 && (strcmp(conn->request_method, "POST") == 0 || strcmp(conn->request_method, "PUT") == 0) ) 		
				{		
					return server->check_login_form_submission(conn);		
				}	  	
			}
#endif
			return server->ProcessRequest(conn);

		default:
			return MG_FALSE;
		}
	}
	catch(...)
	{
		// PLOG_ERROR("WebAppServer::WebHandler Exception.");
	}
	return MG_FALSE;
}

/** */
int WebAppServer::ProcessRequest(struct mg_connection * conn)
{
	try 
	{
		web_response response;
#if _LOGIN_
		user = current_user(conn);
#else
		string user = "";
#endif
		webCallback wb = FindRest(conn->uri);
		if (wb != NULL) 
		{
			wb(conn, user, &response);
#if _SESSION_SUP_
			if (response.actividad=true)
				session_control.RegActividad();
#endif
			mg_send_status(conn, response.code);
			mg_send_header(conn, "Content-type", "application/json");
			mg_send_data(conn, response.data.c_str(), response.data.length());
			return MG_TRUE;
		}
		return MG_FALSE;
	}
	catch(Exception x) 
	{
		PLOG_EXCEP(x, "WebAppServer::ProcessRequest Exception.");		
	}
	return MG_FALSE;
}

/** */
webCallback WebAppServer::FindRest(string url)
{
	for (restHandler_iterator hit=p_handlers->begin(); hit != p_handlers->end(); ++hit)
	{
		if (hit->first == url)
			return hit->second;
	}
	return NULL;
}

/** */
string WebAppServer::current_user(struct mg_connection *conn)
{
	char ssid[100], name[100], str_profile[16];
	mg_parse_header(mg_get_header(conn, "Cookie"), "ssid", ssid, sizeof(ssid));
#ifdef _WIN32
	if (sscanf_s(ssid, "%[^|]|%[^|]|", name, str_profile) == 2) 
#else
	if (sscanf(ssid, "%[^|]|%[^|]|", name, str_profile) == 2) 
#endif
	{
		return string(name);
	}
	return "Unknow";
}

/** */
int WebAppServer::check_login_form_submission(struct mg_connection *conn)
{
	char name[100], password[100], ssid[100], expire_epoch[100];
#if _NO_EXPIRE_
#else
	char expire[100];
#endif

	mg_get_var(conn, "name", name, sizeof(name));
	mg_get_var(conn, "password", password, sizeof(password));

	if (Users::users.IsRoot(name, password)== true || _session.Get()==false)
	{
		int profile;
		if ((profile = Users::users.Acceso(name, password)) != 0)
		{
#if _NO_EXPIRE_
			// Tiempo Sesion infinito.
#ifdef _WIN32
			_snprintf(expire_epoch, sizeof(expire_epoch), "%lu", (unsigned long)0);
#else
			snprintf(expire_epoch, sizeof(expire_epoch), "%lu", (unsigned long)0);
#endif
			generate_ssid(name, profile, expire_epoch, ssid, sizeof(ssid));
			mg_printf(conn,
				"HTTP/1.1 302 Found\r\n"
				"Set-Cookie: ssid=%s \r\n"
				"Location: /\r\n\r\n\r\n",
				ssid);
#else
			int iexpire = TIEMPO_SESION;
			time_t t = time(NULL) + (iexpire==0 ? (24*3600) : iexpire);

#ifdef _WIN32
			_snprintf(expire_epoch, sizeof(expire_epoch), "%lu", (unsigned long) t);
#else
			snprintf(expire_epoch, sizeof(expire_epoch), "%lu", (unsigned long) t);
#endif
			strftime(expire, sizeof(expire), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&t));

			string expdate = Utilidades::CookieTime(expire, *(gmtime(&t)));

			generate_ssid(name, profile, expire_epoch, ssid, sizeof(ssid));

			// Set "session id" cookie, there could be some data encoded in it.
			mg_printf(conn, "HTTP/1.1 302 Found\r\n"
				"Set-Cookie: ssid=%s; expires=\"%s\"; \r\n"
				"Location: /\r\n\r\n\r\n",
				ssid, expire);

#endif
			_session.Set(name);
			return MG_TRUE;
		}
		else
		{
			mg_printf(conn, "HTTP/1.1 302 Found\r\nLocation: %s\r\n\r\n\r\n", s_err_baduser_uri);
		}
	}
	else
	{
		mg_printf(conn, "HTTP/1.1 302 Found\r\nLocation: %s\r\n\r\n\r\n", s_err_session_uri);
	}
	return MG_FALSE;
}


