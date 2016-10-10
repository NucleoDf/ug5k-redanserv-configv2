#ifndef _SISTEMA_
#define _SISTEMA_

#include <time.h>

#ifdef _WIN32
	typedef __int32				int32_t;
	typedef unsigned __int32	uint32_t;
#else
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <netinet/in.h>
 #include <net/if.h>
 #include <arpa/inet.h>

 #include <unistd.h>
 #include <string.h>
 #include <netdb.h> 

 #include <signal.h>
#endif

#include <algorithm>
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

class sistema
{
public:
	sistema(void);
	~sistema(void);

public:
	static void ExecuteCommand(char *cmd);
    static string ResultExecuteCommand(char *cmd);
        
	//static void GetIfconfigCommand(char *cmd, const char *ift, const char *ip, const char *msc);
	//static void GetIfenslaveCommand(char *cmd, const char *ifbond, const char *if1, const char *if2);
	//static void GetRouteCommand(char *cmd, const char *src, const char *dest);
	//static void GetRebootCommand(char *cmd);
	//static void GetTarCommand(char *cmd, const char *file, const char *dir, const char *src);
	//static void GetUnTarCommand(char *cmd, const char *file, const char *dest);
	//static void GetCdCommand(char *cmd, const char *dir);
	//static void GetMvCommand(char *cmd, const char *src, const char *dest);

	//static void GetRouteAddCommand(char *cmd, const char *dest, const char *via, const char *src);
	//static void GetRouteDelCommand(char *cmd, const char *dest);
	//static void GetRouteGet(char *cmd);

	static bool GetIpAddress(char *lan, string &ip);
	static void GetMacAddress(char *lan, char *mac);

	static void SignalNuevaConfiguracion(string npid);
	static int  pidof(string name);

	static string GetDelCommand(string path);
	static string GetCpCommand(string src, string dest);
	static string NormalizePath(string path);
	static string PathFileName(string path);

	static void DataSaveAs(string data, string filename);

	static bool MainOrStandby();
	static time_t _TIMER_CLK();

	/** */
	static string SnmpAgentVersion();
	static string RecordServiceVersion();
	
};

/** Gestiona TEMPORIZADORES de Segundos */
#define _TIMER_SET( val, delta )	(val) = sistema::_TIMER_CLK() + (delta)
#define _TIMER_SUB( t1, t2 )		((int32_t)(((uint32_t)t1)-((uint32_t)t2)))
#define _TIMER_DELTA( val )			_TIMER_SUB( val, sistema::_TIMER_CLK() )
#define _TIMER_EXPIRED( val )		((val) && _TIMER_DELTA(val)<=0)
#define _TIMER_CLR( val ) 			(val) = 0
#define _TIMER_IS_RUNNING( val )	(val)
 
#endif
