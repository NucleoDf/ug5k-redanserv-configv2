// uv5ki-gw-cfg.cpp: define el punto de entrada de la aplicación de consola.
//
#include ".\include\websrv\uv5kigwcfg-web-app.h"

#define VRS_ID_SOFTWARE			"UV5KI-GW CFG-SERVER"
#define VRS_VERSION_MAYOR		1
#define VRS_VERSION_MENOR_A		0
#define VRS_VERSION_MENOR_B		2

#ifdef _WIN32
char acBuildString[] =		"Version WIN";
#else
#include <mcheck.h>
#include <execinfo.h>
extern char acBuildString[]; 
/** */ 
char *acStrVersion()
{
	static char buffer[128];
	sprintf(buffer, " %s   V%d.%d.%d (%s)",
		VRS_ID_SOFTWARE,
		VRS_VERSION_MAYOR, VRS_VERSION_MENOR_A, VRS_VERSION_MENOR_B,
		acBuildString );
	return buffer;
}
#endif


/** */
class U5kiGwCfg : public CodeBase
{
public:
	void Run();
private:
#ifndef _WIN32
	void traceSIGSEGV()
	{
	}
	void catchAllSignal (int sig, siginfo_t *siginfo, void *context)
	{
	}
	void setAllSignalCatch() 
	{
	}

#endif
};

/** */
void U5kiGwCfg::Run()
{
	try 
	{
		plogInit();
		PLOG_INFO("UG5k-APPSERVER: (%s) Iniciado en \"%s\". ENTER para SALIR.", acBuildString, WORKING_DIR);

		/** Inicializacion Comun */
		Uv5kiGwCfgWebApp webApp;

		webApp.Start();

#ifdef _WIN32
			/** Lazo de Windows */				
		std::cin.get();
#else
			/** Lazo de LINUX */
#endif

		/** Finalizacion Comun */
		webApp.Dispose();

		PLOG_INFO("UG5k-APPSERVER Finalizado.");
		plogDispose();
	}
	catch(Exception x)
	{
		PLOG_EXCEP(x, "Main AppException");
	}
	catch(...)
	{
		PLOG_EXCEP(NULL, "Main Unknow Exception");
	}
}

/** */
#ifdef _WIN32
int _tmain(int argc, _TCHAR* argv[])
#else
int main(int argc, char* argv[])
#endif
{
	/** Imprime la Version */
	if ( 2==argc )
	{
		if (!strncmp(argv[1],"/V",3))
		{
			printf( " %s   V%d.%d.%d (%s)\n",
				VRS_ID_SOFTWARE,
				VRS_VERSION_MAYOR, VRS_VERSION_MENOR_A, VRS_VERSION_MENOR_B,
				acBuildString );
			return -1;
		}
	}

	/** Arranca la aplicacion */
	U5kiGwCfg app;
	app.Run();
	return 0;
}






