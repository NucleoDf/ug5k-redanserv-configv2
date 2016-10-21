#ifndef __WORKING_CONFIG_H__
#define __WORKING_CONFIG_H__

#ifdef _WIN32
#else
	#include <sys/types.h>
	#include <sys/ipc.h>
	#include <sys/shm.h>
#endif 

#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream#include <utility>
#include <queue>
#include <algorithm>

#include "../base/code-base.h"
#include "../base/thread.h"
#include "../base/socket.h"
#include "../base/sistema.h"
#include "../tools/tools.h"
#include "../config/local-config.h"
#include "../versiones.h"
#include "./comm-config.h"
#include "./soap-config.h"
#include "./comm-conversor.h"

#include "./cfgpasa.hpp"

/** La configuracion en memoria */
typedef struct cfgConfigPasarela ug5k_mem_config ;
enum WorkingConfigMode { cfgRedan, cfgSoap };

/** Estructura de CONFIGURACION. Se parte de REDAN */
class WorkingConfig : public CodeBase
{
public:
	WorkingConfig(WorkingConfigMode mode);
	~WorkingConfig();

public:
	EventosHistoricos *set(CommConfig &redanConfig);
	void set(soap_config &sConfig);
	void set();
	void load_from(string file);
	void save_to(string file);

public:
	void TimeStamp();
	void TimeStamp(CommConfig &remota);
	bool HasResources() {
		return (config.recursos.size() != 0);
	}
	void ResourcesClear();
	string JConfig();
	string IdConfig() {
		return config.idConf;
	}
	string TimConfig() {
		return config.fechaHora;
	}
	bool UserAccess(string user, string pwd, int *profile);
	bool IpColateral(string &ipCol) {
		return config.IpColateral(ipCol);
	}
	bool DualCpu() {
		return config.general.dualidad==1;
	}


public:
	bool IdConfig(string &idConfig, string &fechaHora);

	/** */
	int cpu1cpu2();
	string ipcpu(int cpu);	

protected:
	void init();
	void dispose();
	static void *DelayedSignal(void *arg);

private:
	WorkingConfigMode cfg_mode;
	ug5k_mem_config *p_mem_config;
	CommConfig config;
	CommConversor redanConv;
#ifdef _WIN32
#else
	key_t key_mem;
	int  shmid;
#endif 
};

#endif
