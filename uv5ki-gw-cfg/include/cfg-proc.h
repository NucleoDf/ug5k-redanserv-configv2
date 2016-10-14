#ifndef __CFG_PROC__
#define __CFG_PROC__

#include "./base/code-base.h"
#include "./base/thread.h"
#include "./base/socket.h"
#include "./tools/tools.h"
#include "./config/local-config.h"
#include "./websrv/uv5kigwcfg-web-app.h"
#include "./config/working-config.h"
#include "./config/comm-preconf.h"
#include "./tools/parse.h"

using namespace std;

#define MAIN_PIDE_CONFIG			((const char *)"pideconfig")
#define MAIN_TEST_CONFIG			((const char *)"testconfig")
#define MAIN_SUBIR_CONFIG			((const char *)"subirconfig")
#define LAST_CONFIG_ONLINE			((const char *)"Ultima Configuracion online")


/** Estado de la Configuracion respecto a la Base de Datos */
enum eStdLocalConfig
{
	slcSincronizado=0,
	slcNoBdt = -1,
	slcNoActiveCfg = -2,
	slcAislado=-3,
	slcConflicto=-4,
	slcNoInicializado=-5
};

class HttpClientException : public Exception
{
public:
	HttpClientException(string msg)		
	{
		_msg="HttpClientException: " + msg;
	}
	HttpClientException(socket_error error)
	{
		_msg = "Socket Error: " + string(error.what());
	}
	~HttpClientException() throw() {}

private:
	string _msg;
};

/** */
typedef struct
{
	string ip;
	string main;
	string cmd;
} stAviso;


/** */
class CfgProc : public CThread
{
public:
	CfgProc();
	~CfgProc();

public:
	static CfgProc *p_cfg_proc;
	WorkingConfig *p_working_config;

public:
	void AvisaCambioConfiguracion(string host);
	void AvisaSubirConfiguracion();
	bool IsIdle() {
		return (_stdLocalConfig==slcAislado || _stdLocalConfig==slcNoInicializado);
	}
	eStdLocalConfig GetStdLocalConfig()
	{
		CCSLock _lock(m_lock);
		return _stdLocalConfig;
	}
	//ParseResponse Public_SendHttpCmd(string host, string cmd);


protected:
	CCritSec m_lock;
	ColaAventos<stAviso> avisos;
	string _ip_propia;
	eStdLocalConfig _stdLocalConfig;
	int _lastcfg;
	int _cntticks;
	int _maxticks;
	bool _bconflicto;
};


/** */
class HttpClientProc : public CfgProc
{

public:
	HttpClientProc(void) {
		p_working_config = new WorkingConfig(cfgRedan);
	}
	~HttpClientProc(void){};

protected:
	void Run();
	void Dispose();
	bool Get(stAviso &aviso);

	void SupervisaProcesoConfiguracion();
	void ChequearConfiguracion();
	void PedirConfiguracion(string cfg);
	void SubirConfiguracion();

	void GeneraAvisosCpu(string host, string cmd);
	void ParseHost(string host, string &ip, int &port);
	void StdSincrSet(eStdLocalConfig nstd/*, jgw_config &local*/);
	ParseResponse SendHttpCmd(string host, string cmd);

	void AvisaPideConfiguracion(string cfg);
	void AvisaChequearConfiguracion();

	void ResourcesConfigClear();
private:
	CommConfig cfg_redan;
};

#endif

