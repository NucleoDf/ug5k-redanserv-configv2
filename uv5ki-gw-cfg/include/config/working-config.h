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
	bool TestConfig() {
		return config.test();
	}
	int cpu1cpu2() {
		string ippropia;
		if (sistema::GetIpAddress(ippropia))
		{
			if (ippropia == ipcpu(0))
				return 0;
			if (ippropia == ipcpu(1))
				return 1;
			PLOG_ERROR("CommConfig::cpu1cpu2: ERROR CPU0-CPU1 No coincide con IPPROPIA !!!");
			return -1;
		}	
		PLOG_ERROR("CommConfig::cpu1cpu2: ERROR. NO IP PROPIA !!!");
		return -1;
	}
	string ipcpu(int cpu) {
		return cpu==0 ? config.general.cpus[0].ipb : config.general.cpus[1].ipb;
	}
	/** Para ulises */
	void UlisesParamsMulticast(string &ip, int &port) {
		ip = config.ulises.MulticastGroup;
		port = config.ulises.MulticastPort;
	}

public:
	bool IdConfig(string &idConfig, string &fechaHora);

	/** */

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
