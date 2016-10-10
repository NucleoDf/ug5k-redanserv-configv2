#include "../../include/websrv/uv5kigwcfg-web-app.h"
#include "../../include/man-proc.h"

#define NOT_IMPLEMENTED_RESP(r)				{r->code=404; r->data="{\"res\":\"Operacion no Implementada\"}";}
#define OK200_RESP(r, d)					{r->code=200; r->data=d;}
#define IERROR_RESP(r, d)					{r->code=500; r->data=d;}

/** */
restHandler Uv5kiGwCfgWebApp::_handlers_list;
web_config  Uv5kiGwCfgWebApp::_web_config;

/** */
Uv5kiGwCfgWebApp::Uv5kiGwCfgWebApp(void)
{
	GetHandlers();
	GetConfig();
}

/** */
Uv5kiGwCfgWebApp::~Uv5kiGwCfgWebApp(void)
{
}

/** */
void Uv5kiGwCfgWebApp::GetHandlers() 
{
	_handlers_list["/tses"]=stCb_tses;			// GET					TICK de Sesssion
	_handlers_list["/logout"]=stCb_logout;		// POST					LOGOUT.
	_handlers_list["/config"]=stCb_config;		// GET, POST			Configuracion
	_handlers_list["/preconf"]=stCb_preconfig;	// GET, POST, PUT, DEL	Preconfiguraciones
	_handlers_list["/export"]=stCb_;			// GET					EXPORTAR CFG
	_handlers_list["/import"]=stCb_;			// POST					IMPORTAR CFG
	_handlers_list["/uploadcfg"]=stCb_;			// POST					Subir CONFIG.

	_handlers_list["/mant/std"]=stCb_mtto;		// GET					.
	_handlers_list["/mant/ver"]=stCb_mtto;		// GET					.
	_handlers_list["/mant/lver"]=stCb_mtto;		// GET					.
	_handlers_list["/mant/bite"]=stCb_mtto;		// GET					.
	_handlers_list["/mant/reset"]=stCb_mtto;	// RESET de UNIDAD		POST
	_handlers_list["/mant/swactiva"]=stCb_mtto;	// ACTIVAR SW-VER		POST
	_handlers_list["/mant/swrestore"]=stCb_mtto;// RETAURAR SW-VER		POST

	_handlers_list["/cpu2cpu"]=stCb_;			// PUT.					COMUNICACIONES INTERNAS

	_handlers_list["/test"]=stCb_;				// GET, POST.			PARA PRUEBAS...
}

/** */
void Uv5kiGwCfgWebApp::GetConfig() 
{
	_web_config.web_port = "8080";
	_web_config.document_root = "ng-app";
	_web_config.default_page = "ug5kweb-index.html";
	_web_config.login_uri = "/login.html";
	_web_config.bad_user_uri = "/error1.html";
	_web_config.closed_session_uri = "/error2.html";
	_web_config.secret = ":-)";
	_web_config.session_time = 0;
	_web_config.enable_login = true;

	_web_config.sec_uris.push_back(_web_config.login_uri);
	_web_config.sec_uris.push_back(_web_config.bad_user_uri);
	_web_config.sec_uris.push_back(_web_config.closed_session_uri);
	_web_config.sec_uris.push_back("/cpu2cpu");
	_web_config.sec_uris.push_back("/hojaExterna.css");

	_web_config.access_control = stAccessControl;	
}

/** */
bool Uv5kiGwCfgWebApp::stAccessControl(string name, string pwd, int *profile)
{
	if (profile != NULL)
		*profile = 64;

	return true;
}

/** */
void Uv5kiGwCfgWebApp::stCb_(struct mg_connection *conn, string user, web_response *resp)
{
#if LOCAL_TEST		
	resp->actividad=false;
	if (string(conn->request_method)=="GET") 
	{
		CommConfig cfg(".", "comm-config.json");
		OK200_RESP(resp, cfg.JSerialize());
		return;
	}
	else if (string(conn->request_method)=="POST") 
	{
		webData_line ok("OK");
		OK200_RESP(resp, ok.JSerialize());
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
#else
	string strdata = "{\"res\":\"Handler por Defecto\"}";
	
	resp->actividad=true;
	resp->code=200;
	resp->data=strdata;
#endif
}

/** */
void Uv5kiGwCfgWebApp::stCb_tses(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=false;
	if (string(conn->request_method)=="GET") 
	{
		// TODO. Enlazar con los datos reales en el constructor...
		webData_tses data;
		OK200_RESP(resp, data.JSerialize());
		return;
	}
#if LOCAL_TEST
	else if (string(conn->request_method)=="POST")
	{
		string data_in = string(conn->content, conn->content_len );
		webData_tses data;
		data.JDeserialize(data_in);

		OK200_RESP(resp, "");
		return;
	}
#endif
	NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_logout(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=false;
	if (string(conn->request_method)=="POST") 
	{
		_web_config.session_control.Reset();
		webData_line ok("OK");
		OK200_RESP(resp, ok.JSerialize());
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_config(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=true;
	if (string(conn->request_method)=="GET")
	{
		// TODO..
		OK200_RESP(resp, webData_line("En construccion").JSerialize());
		return;
	}
	else if (string(conn->request_method)=="POST") 
	{
		// TODO..
		OK200_RESP(resp, webData_line("En construccion").JSerialize());
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_preconfig(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=true;
	if (string(conn->request_method)=="GET")
	{
		OK200_RESP(resp, webData_preconfs().JSerialize());
		return;
	}
	else if (string(conn->request_method)=="POST") 
	{
		webData_preconf_id preconf;
		string data_in = string(conn->content, conn->content_len );
		preconf.JDeserialize(data_in);
		if (preconf.Error() == "")
		{
			// TODO.. Ejecutar Salvar como
			bool res = true;
			if (res)
			{
				OK200_RESP(resp, webData_preconfs().JSerialize());
				return;
			}
			IERROR_RESP(resp, webData_line("Error al Salvar Preconfiguracion").JSerialize());
			return;
		}
		IERROR_RESP(resp, webData_line("Error de formato: " + preconf.Error()).JSerialize());
		return;
	}
	else if (string(conn->request_method)=="PUT") 
	{
		webData_preconf_id preconf;
		string data_in = string(conn->content, conn->content_len );
		preconf.JDeserialize(data_in);
		// TODO.. Ejecutar Activar preconf
		bool res = true;
		if (res)
		{
			OK200_RESP(resp, webData_preconfs().JSerialize());
			return;
		}
		IERROR_RESP(resp, webData_line("Error al Activar Preconfiguracion").JSerialize());
		return;
	}
	else if (string(conn->request_method)=="DELETE") 
	{
		webData_preconf_id preconf;
		string data_in = string(conn->content, conn->content_len );
		preconf.JDeserialize(data_in);
		// TODO.. Ejecutar Eliminar preconf
		bool res = true;
		if (res)
		{
			OK200_RESP(resp, webData_preconfs().JSerialize());
			return;
		}
		IERROR_RESP(resp, webData_line("Error al Eliminar Preconfiguracion").JSerialize());
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_mtto(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=true;
	vector<string> levels = parse_uri(string(conn->uri));
	if (levels.size() != 3)
	{
		NOT_IMPLEMENTED_RESP(resp);
		return;
	}
	if (string(conn->request_method)=="GET") {
		if (levels[2]=="std") {
			OK200_RESP(resp, ManProc::p_man->jestado());
			return;
		}
		else if (levels[2]=="ver") {
			// TODO.
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		else if (levels[2]=="lver") {
			// TODO.
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		else if (levels[2]=="bite") {
			// TODO.
			// HistClient::hist.SetEvent(INCI_BITE, user, "");
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		NOT_IMPLEMENTED_RESP(resp);
		return;
	}
	else if (string(conn->request_method)=="POST") {
		if (levels[2]=="reset") {
			// TODO.
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		else if (levels[2]=="swactiva") {
			// TODO.
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		else if (levels[2]=="swrestore") {
			// TODO.
			OK200_RESP(resp, webData_line("En construccion").JSerialize());
			return;
		}
		NOT_IMPLEMENTED_RESP(resp);
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
}





