#ifndef _UV5KIGWCFG_WEB_APP_H_
#define _UV5KIGWCFG_WEB_APP_H_

#include "web-app-server.h"
#include "uv5kigwcfg-web-app-data.h"
#include "../tools/tools.h"

#define CPU2CPU_MSG_CAMBIO_CONFIG	((const char *)"CambioConfig")
#define CPU2CPU_MSG_REMOTE_LOCK		((const char *)"RemoteLock")
#define CPU2CPU_MSG_REMOTE_UNLOCK	((const char *)"RemoteUnlock") 

/** */
class Uv5kiGwCfgWebApp :
	public WebAppServer
{
public:
	Uv5kiGwCfgWebApp(void);
	~Uv5kiGwCfgWebApp(void);

protected:
	static void stCb_(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_tses(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_logout(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_config(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_preconfig(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_importexport(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_mtto(struct mg_connection *conn, string user, web_response *resp);
	static void stCb_internos(struct mg_connection *conn, string user, web_response *resp);

	static bool stAccessControl(string name, string pwd, int *profile);

	void GetHandlers();
	void GetConfig();

protected:
	static vector<string> parse_uri(string uri)
	{
		vector<string> _levels;	
		Tools::split(_levels, uri, '/');
		return _levels;
	}
private:
	virtual restHandler *handlers(){return &_handlers_list;}
	virtual web_config *config(){return &_web_config;}

private:
	static restHandler _handlers_list;
	static web_config  _web_config;
};

#endif
