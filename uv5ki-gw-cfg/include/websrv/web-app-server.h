#ifndef _WEB_APP_SERVER_H_
#define _WEB_APP_SERVER_H_

#include "..\..\include\base\thread.h"
#include "mongoose.h"

typedef struct
{
	bool actividad;
	int code;
	string data;
} web_response;

typedef void (*webCallback)(struct mg_connection *conn, string user, web_response *resp);
typedef map<string, webCallback> restHandler;
typedef restHandler::iterator restHandler_iterator;
typedef bool (*webAccessRoutine)(string name, string pwd);

typedef struct
{
	string						login_uri;			// "/login.html";
	vector<string>				sec_uris;			// Lista de URIS que no se ven afectadas por la seguridad. Dependen de la aplicacion.
	webAccessRoutine			access_control;		// Rutina que permite el acceso o no en función de los usuarios.
} web_config;

/** */
class SessionControl
{
public:
	SessionControl()
	{
		Reset();
	}
public:
	bool Get(){return _set;}
	void Set(string user = "")
	{
		_user = user;
		_start = _last = time(NULL);
		_set = true;
	}
	void Reset()
	{
		_set=false;
		_user = "";
		_start = _last = 0;
	}
	void RegActividad()
	{
		_last = time(NULL);
	}
	bool Inactivo(int _cuanto)
	{
        time_t _now = time(NULL);
		return (_set==true && (_now-_last)>_cuanto) ? true : false;
	}
	time_t TActividad()
	{
		return (_last-_start);
	}
private:
	bool _set;
	string _user;
	time_t _start;
	time_t _last;
};

/** */
class WebAppServer :
	public CThread
{
public:
	WebAppServer(void);
	WebAppServer(string defaultDir, string defaultUrl, bool htmlEncode=true);
	~WebAppServer(void);

public:
	void Start(string port, restHandler *pHandlers, web_config *pCfg);
	void Dispose();

protected:
	void Run();
	int ProcessRequest(struct mg_connection * conn);
	webCallback FindRest(string url);
	string current_user(struct mg_connection *conn);
	int check_login_form_submission(struct mg_connection *conn);
	int check_auth(struct mg_connection *conn) ;
	void generate_ssid(const char *user_name, int profile, const char *expiration_date,
                          char *ssid, size_t ssid_size);

private:
	static int  WebHandler(struct mg_connection *conn, enum mg_event ev);
	restHandler *p_handlers;
	string document_root;
	string default_page;
	bool enable_login;
	struct mg_server *server;
	SessionControl session_control;
	web_config *p_cfg;
};

#endif
