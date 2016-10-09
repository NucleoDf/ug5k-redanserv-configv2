#ifndef _UV5KIGWCFG_WEB_APP_H_
#define _UV5KIGWCFG_WEB_APP_H_

#include "web-app-server.h"
#include "uv5kigwcfg-web-app-data.h"

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

	static bool stAccessControl(string name, string pwd, int *profile);

	void GetHandlers();
	void GetConfig();

private:
	virtual restHandler *handlers(){return &_handlers_list;}
	virtual web_config *config(){return &_web_config;}

private:
	static restHandler _handlers_list;
	static web_config  _web_config;
};

#endif
