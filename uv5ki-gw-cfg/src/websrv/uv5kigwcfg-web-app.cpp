#include "../../include/websrv/uv5kigwcfg-web-app.h"
#include "../../include/config/comm-config.h"
#include "../../include/config/comm-preconf.h"
#include "../../include/cfg-proc.h"
#include "../../include/man-proc.h"
#include "../../include/his-proc.h"

#define RETURN_NOT_IMPLEMENTED_RESP(r)			{r->code=404; r->data="{\"res\":\"Operacion no Implementada\"}";return;}
#define RETURN_OK200_RESP(r, d)					{r->code=200; r->data=d;return;}
#define RETURN_IERROR_RESP(r, d)				{r->code=500; r->data=d;PLOG_ERROR(d.c_str());return;}

#define P_HIS_PROC								(HistClient::p_hist)
#define P_CFG_PROC								(CfgProc::p_cfg_proc)
#define P_WORKING_CONFIG						(P_CFG_PROC->p_working_config)

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
	_handlers_list["/tses"]=stCb_tses;				// GET					TICK de Sesssion
	_handlers_list["/logout"]=stCb_logout;			// POST					LOGOUT.
	_handlers_list["/config"]=stCb_config;			// GET, POST, PUT		Configuracion Activa. Obtener (GET), Modificar (POST), Subir (PUT)
	_handlers_list["/preconf"]=stCb_preconfig;		// GET, POST, PUT, DEL	Preconfiguraciones
	_handlers_list["/impexp"]=stCb_importexport;	// GET, POST			EXPORTAR (GET) IMPORTAR (POST)

	_handlers_list["/mant"]=stCb_mtto;				// GET, POST
	//_handlers_list["/mant/std"]=stCb_mtto;		// GET					.
	//_handlers_list["/mant/ver"]=stCb_mtto;		// GET					.
	//_handlers_list["/mant/lver"]=stCb_mtto;		// GET					.
	//_handlers_list["/mant/bite"]=stCb_mtto;		// GET					.
	//_handlers_list["/mant/reset"]=stCb_mtto;		// RESET de UNIDAD		POST
	//_handlers_list["/mant/swactiva"]=stCb_mtto;	// ACTIVAR SW-VER		POST
	//_handlers_list["/mant/swrestore"]=stCb_mtto;	// RETAURAR SW-VER		POST

	_handlers_list["/cpu2cpu"]=stCb_internos;		// PUT.					COMUNICACIONES INTERNAS

	_handlers_list["/test"]=stCb_;					// GET, POST.			PARA PRUEBAS...
}

/** */
void Uv5kiGwCfgWebApp::GetConfig() 
{
	_web_config.web_port = "9090";
	_web_config.document_root = "ng-app";
	_web_config.default_page = "ug5kweb-index.html";
	_web_config.login_uri = "/login.html";
	_web_config.bad_user_uri = "/error1.html";
	_web_config.closed_session_uri = "/error2.html";
	_web_config.secret = ":-)";
	_web_config.enable_login = false;
	_web_config.enable_ssession = false;
	_web_config.session_time = 0;

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
		ifstream f((const char *)"./comm-config.json", ios_base::in);
		CommConfig cfg(f);
		RETURN_OK200_RESP(resp, cfg.JSerialize());
	}
	else if (string(conn->request_method)=="POST") 
	{
		webData_line ok("OK");
		RETURN_OK200_RESP(resp, ok.JSerialize());
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
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
		int std;
		string cfg_name, cfg_time;
		P_CFG_PROC->IdConfig(std, cfg_name, cfg_time);
		webData_tses data(std, cfg_name, cfg_time);
		RETURN_OK200_RESP(resp, data.JSerialize());
	}
#if LOCAL_TEST
	else if (string(conn->request_method)=="POST")
	{
		string data_in = string(conn->content, conn->content_len );
		webData_tses data;
		data.JDeserialize(data_in);

		RETURN_OK200_RESP(resp, "");
	}
#endif
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_logout(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=false;
	if (string(conn->request_method)=="POST") 
	{
		_web_config.session_control.Reset();
		webData_line ok("OK");
		RETURN_OK200_RESP(resp, ok.JSerialize());
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_config(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=true;
	if (string(conn->request_method)=="GET")
	{
		// Leer la configuracion activa de RAM.
		RETURN_OK200_RESP(resp, P_WORKING_CONFIG->JConfig());
	}
	else if (string(conn->request_method)=="POST") 
	{
		// Activar la Configuracion...
		string data_in = string(conn->content, conn->content_len );
		CommConfig cfg;
		cfg.JDeserialize(data_in);
		EventosHistoricos *ev = P_WORKING_CONFIG->set(cfg);
		P_WORKING_CONFIG->TimeStamp();
		P_WORKING_CONFIG->save_to(LAST_CFG);
		P_HIS_PROC->SetEventosHistoricos(user, ev);	// Generar los historicos de cambios.
			// TODO. Sincronizar Fichero....
		RETURN_OK200_RESP(resp, webData_line("Configuracion Activada...").JSerialize());
	}
	else if (string(conn->request_method)=="PUT") 
	{
		// Mirar si esta aislado...	
		if (P_CFG_PROC->IsIdle()){
			RETURN_IERROR_RESP(resp, webData_line("Error de UPLOAD. La Unidad esta aislada.").JSerialize());
		}
		// Dar aviso de carga de configuracion...
		P_CFG_PROC->AvisaSubirConfiguracion();
		RETURN_OK200_RESP(resp, webData_line("Peticion de Subida cursada...").JSerialize());
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_preconfig(struct mg_connection *conn, string user, web_response *resp)
{
	CommPreconfs preconfs;
	resp->actividad=true;
	if (string(conn->request_method)=="GET")
	{
		RETURN_OK200_RESP(resp, preconfs.JSerialize());
	}
	else if (string(conn->request_method)=="POST" || 
			 string(conn->request_method)=="PUT"  || 
			 string(conn->request_method)=="DELETE" ) 
	{
		string data_in = string(conn->content, conn->content_len );
		CommPreconf preconf_id(data_in);
		if (preconf_id.Error() == "")
		{
			bool res = true;
			if (string(conn->request_method)=="POST")	// Salvar Preconfiguracion activa como...
			{
				// Obtener la Configuracion activa...
				CommPreconf activa(preconf_id.name, Tools::Ahora(), P_WORKING_CONFIG->JConfig());
				res = preconfs.pos(preconf_id.name, activa);
				if (res == false) {
					RETURN_IERROR_RESP(resp, webData_line("Error al Salvar Preconfiguracion: " + preconf_id.name).JSerialize());
				}
				/** HIST 154 */
				P_HIS_PROC->SetEvent(INCI_GCFG, user, /*"CFG", */activa.name);
			}
			else if (string(conn->request_method)=="PUT") // Activar Configuracion..
			{
					// Comprobar estado AISLADO...
				if (P_CFG_PROC->IsIdle()==false) {
					RETURN_IERROR_RESP(resp, webData_line("Preconfiguracion No Activada. Pasarela NO AISLADA.").JSerialize());
				}
				CommPreconf activa;
				if (preconfs.get(preconf_id.name, activa)==false) {
					RETURN_IERROR_RESP(resp, webData_line("Error al Activar Preconfiguracion: " + preconf_id.name + ". No esta en BDT.").JSerialize());
				}
					// TODO. Comprobar formato de configuracion...
				bool correcta = true;
				if (correcta == false) {
					RETURN_IERROR_RESP(resp, webData_line("Error al Activar Preconfiguracion: " + preconf_id.name + ". Formato de Configuraicon incorrecto").JSerialize());
				}
				P_HIS_PROC->SetEvent(INCI_ACFG, user, /*"CFG", */activa.name);

					// Activar la configuracion...
				CommConfig cfg;
				cfg.JDeserialize(activa.data);
				P_WORKING_CONFIG->set(cfg);			// TODO. Historicos de cambios ???
				P_WORKING_CONFIG->save_to(LAST_CFG);
													// TODO. Sincronizar Fichero....
			}
			else if (string(conn->request_method)=="DELETE")		// Borra preconfiguracion.
			{
				if (preconfs.del(preconf_id.name)==false) {
					RETURN_IERROR_RESP(resp, webData_line("Preconfiguracion No Eliminada. Error en BDT.").JSerialize());
				}
					/** HIST 156 */
				P_HIS_PROC->SetEvent(INCI_DCFG, user, preconf_id.name);
			}

			RETURN_OK200_RESP(resp, CommPreconfs().JSerialize());
		}
		RETURN_IERROR_RESP(resp, webData_line("Error de formato: " + preconf_id.Error()).JSerialize());
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_importexport(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad = true;

	CommPreconfs preconfs;
	vector<string> levels = parse_uri(string(conn->uri));

	if (string(conn->request_method)=="GET")					// EXPORT...
	{
		if (levels.size() < 3 ) {
			RETURN_IERROR_RESP(resp, webData_line("Error al Exportar Preconfiguracion. Id no presente en peticion.").JSerialize());
		}
		CommPreconf exportada;
		if (preconfs.get(levels[2], exportada)==false) {
			RETURN_IERROR_RESP(resp, webData_line("Error al Exportar Preconfiguracion: " + levels[2] + ". No esta en la base de datos.").JSerialize());
		}
		RETURN_OK200_RESP(resp, exportada.data);
	}
	else if (string(conn->request_method)=="POST" )			// IMPORT... (Igual a salvar como, excepto por el nombre)...
	{
		string pcfg_name = levels[2]=="" ? Tools::FileUniqueName("IMPORT") : 
			preconfs.Exist(levels[2]) ? Tools::FileUniqueName(levels[2]) : levels[2];
		// Obtener la Configuracion activa...
		CommPreconf activa(pcfg_name, Tools::Ahora(), P_WORKING_CONFIG->JConfig());
		bool res = preconfs.pos(pcfg_name, activa);
		if (res == false) {
			RETURN_IERROR_RESP(resp, webData_line("Error al Salvar Preconfiguracion: " + pcfg_name).JSerialize());
		}
		/** HIST 154 */
		HistClient::p_hist->SetEvent(INCI_GCFG, user, /*"CFG", */activa.name);
		RETURN_OK200_RESP(resp, preconfs.JSerialize());
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_mtto(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=true;
	vector<string> levels = parse_uri(string(conn->uri));
	if (levels.size() != 3) {
		RETURN_NOT_IMPLEMENTED_RESP(resp);
	}
	if (string(conn->request_method)=="GET") {
		if (levels[2]=="std") {
			RETURN_OK200_RESP(resp, ManProc::p_man->jestado());
		}
		else if (levels[2]=="ver") {
			// TODO.
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		else if (levels[2]=="lver") {
			// TODO.
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		else if (levels[2]=="bite") {
			// TODO.
			// HistClient::hist.SetEvent(INCI_BITE, user, "");
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		RETURN_NOT_IMPLEMENTED_RESP(resp);
	}
	else if (string(conn->request_method)=="POST") {
		if (levels[2]=="reset") {
			// TODO.
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		else if (levels[2]=="swactiva") {
			// TODO.
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		else if (levels[2]=="swrestore") {
			// TODO.
			RETURN_OK200_RESP(resp, webData_line("En construccion").JSerialize());
		}
		RETURN_NOT_IMPLEMENTED_RESP(resp);
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}

/** */
void Uv5kiGwCfgWebApp::stCb_internos(struct mg_connection *conn, string user, web_response *resp)
{
	resp->actividad=false;
	if (string(conn->request_method)=="PUT") 
	{
		vector<string> levels = parse_uri(string(conn->uri));
		if (levels.size() != 3) {
			RETURN_IERROR_RESP(resp, webData_line("Error en Peticion interna.").JSerialize());
		}
		string data_in = string(conn->content, conn->content_len );
		if (levels[2]==CPU2CPU_MSG_CAMBIO_CONFIG)				// Han cambiado la Configuracion...
		{
			CommPreconf preconf_in(data_in);
			if (preconf_in.Error()!="") {
				RETURN_IERROR_RESP(resp, webData_line("Error de formato en Configuracion: " + preconf_in.Error()).JSerialize());
			}
			// TODO. Activar la Configuracion...
			RETURN_OK200_RESP(resp, webData_line("OK").JSerialize());
		}
		else if (levels[2]==CPU2CPU_MSG_REMOTE_LOCK)			// LOCK Fichero para cambiarlo
		{
			PLOG_INFO("Recibido Aviso LOCK Fichero: %s", data_in.c_str());
			// TODO.
			//FileSupervisor::fspv.LocalLock(data);
			RETURN_OK200_RESP(resp, webData_line("OK").JSerialize());
		}
		else if (levels[2]==CPU2CPU_MSG_REMOTE_UNLOCK)			// UNLOCK Fichero para cambiarlo
		{
			PLOG_INFO("Recibido Aviso UNLOCK Fichero: %s", data_in.c_str());
			// TODO.
			//FileSupervisor::fspv.LocalUnlock(data);
			RETURN_OK200_RESP(resp, webData_line("OK").JSerialize());
		}
		RETURN_NOT_IMPLEMENTED_RESP(resp);		
	}
	RETURN_NOT_IMPLEMENTED_RESP(resp);
}




