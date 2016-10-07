#include "..\..\include\websrv\uv5kigwcfg-web-app.h"

#define NOT_IMPLEMENTED_RESP(r)				{r->code=404; r->data="{\"res\":\"Operacion no Implementada\"}";}
#define OK200_RESP(r, d)					{r->code=200; r->data=d;}

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
	_handlers_list["/config"]=stCb_;			// GET, POST			Configuracion
	_handlers_list["/preconf"]=stCb_;			// GET, POST, PUT, DEL	Preconfiguraciones
	_handlers_list["/export"]=stCb_;			// GET					EXPORTAR CFG
	_handlers_list["/import"]=stCb_;			// POST					IMPORTAR CFG
	_handlers_list["/uploadcfg"]=stCb_;			// POST					Subir CONFIG.

	_handlers_list["/mant/std"]=stCb_;			// GET					.
	_handlers_list["/mant/ver"]=stCb_;			// GET					.
	_handlers_list["/mant/lver"]=stCb_;			// GET					.
	_handlers_list["/mant/bite"]=stCb_;			// GET					.
	_handlers_list["/mant/reset"]=stCb_;		// RESET de UNIDAD		POST
	_handlers_list["/mant/swactiva"]=stCb_;		// ACTIVAR SW-VER		POST
	_handlers_list["/mant/swrestore"]=stCb_;	// RETAURAR SW-VER		POST

	_handlers_list["/cpu2cpu"]=stCb_;			// PUT.					COMUNICACIONES INTERNAS
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
	string strdata = "{\"res\":\"Handler por Defecto\"}";
	
	resp->actividad=true;
	resp->code=200;
	resp->data=strdata;
}

/** */
void Uv5kiGwCfgWebApp::stCb_tses(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=false;
	if (string(conn->request_method)=="GET") 
	{
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
		webData_msg ok("OK");
		OK200_RESP(resp, ok.JSerialize());
		return;
	}
	NOT_IMPLEMENTED_RESP(resp);
}





