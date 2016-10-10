#ifndef _WEB_APP_SERVER_H_
#define _WEB_APP_SERVER_H_

#include "../../include/base/thread.h"
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
typedef bool (*webAccessRoutine)(string name, string pwd, int *profile);

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

typedef struct
{
	string				web_port;
	string				document_root;
	string				default_page;
	string				login_uri;			// "/login.html";
	string				bad_user_uri;		//
	string				closed_session_uri;	//
	string				secret;				// Clave para encriptado...
	int					session_time;		// Duracion de las Sesiones.
	bool				enable_login;
	vector<string>		sec_uris;			// Lista de URIS que no se ven afectadas por la seguridad. Dependen de la aplicacion.
	webAccessRoutine	access_control;		// Rutina que permite el acceso o no en función de los usuarios.
	SessionControl		session_control;
} web_config;


/** */
class WebAppServer :
	public CThread
{
public:
	WebAppServer(void);
	~WebAppServer(void);

public:
	void Start();
	void Dispose();

protected:
	void Run();
	int  WebHandler(struct mg_connection *conn, enum mg_event ev);
	int ProcessRequest(struct mg_connection * conn);
	webCallback FindRest(string url);
	string current_user(struct mg_connection *conn);
	int check_login_form_submission(struct mg_connection *conn);
	int check_auth(struct mg_connection *conn) ;
	void generate_ssid(const char *user_name, int profile, const char *expiration_date,
                          char *ssid, size_t ssid_size);
	string CookieTime(char *buffer, struct tm stime);
	bool Check4SecureUri(string uri);

private:
	static int  stWebHandler(struct mg_connection *conn, enum mg_event ev);

private:
	virtual restHandler *handlers()=0;
	virtual web_config *config()=0;

private:
	struct mg_server *server;
};

#endif
