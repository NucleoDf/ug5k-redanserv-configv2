#include "../../include/config/working-config.h"
#include "../../include/config/comm-conversor.h"

/** */
WorkingConfig::WorkingConfig(WorkingConfigMode mode)
{
	cfg_mode = mode;
	init();
}

/** */
WorkingConfig::~WorkingConfig() 
{
	dispose();
}

/** */
void WorkingConfig::init()
{
#ifdef _WIN32
	p_mem_config =(ug5k_mem_config *)(new char[sizeof(ug5k_mem_config)+4]);	// new ug5k_mem_config();
#else
    /** Shared memory segment at 1234 */
	key_mem = 75218977; 
    /** Create the segment and set permissions.*/
	if ((shmid = shmget(key_mem, sizeof(ug5k_mem_config), IPC_CREAT | 0666)) < 0) 
	{
		perror("shmget");	
		return;
	}
   /** Now we attach the segment to our data space. */
	if ((p_mem_config = (ug5k_mem_config *)shmat(shmid, NULL, 0)) == (ug5k_mem_config *) -1) 
	{
		perror("shmat");
		return;
	}
#endif
}

/** */
void WorkingConfig::dispose()
{
#ifdef _WIN32
	delete p_mem_config;
#else
	if(shmdt(p_mem_config) != 0)
		fprintf(stderr, "Could not close memory segment.\n");
#endif
}

/** */
EventosHistoricos *WorkingConfig::set(CommConfig &redanCfg) 
{
	redanConfig = redanCfg;

	/** Actualizar la memoria y los ficheros INI */
	return CommConversor().convierte(redanConfig, p_mem_config);
}

/** */
void WorkingConfig::load_from(string file)
{
	if (cfg_mode == cfgRedan)
	{
		CommConfig cfg(ifstream(file.c_str(), ios_base::in));
		set(cfg);
		return;
	}
	throw Exception("Modo de Configuracion no implementado leyendo desde fichero...");
}

/** */
void WorkingConfig::save_to(string file)
{
	ofstream ff(ON_FLASH(file));	
	if (cfg_mode == cfgRedan) 
	{
		string data = redanConfig.JSerialize();
		ff.write(data.c_str(), data.length());
		return;
	}
	throw Exception("Modo de Configuracion no implementado escribiendo fichero...");
}

/** */
void WorkingConfig::TimeStamp()
{
	if (cfg_mode == cfgRedan) 
	{
		redanConfig.fechaHora = Tools::Ahora_Servidor();
		return;
	}
	throw Exception("Modo de Configuracion no implementado obteniendo timestamp...");
}

/** */
void WorkingConfig::ResourcesClear()
{
	if (cfg_mode == cfgRedan) 
	{
		// TODO...
		return;
	}
	throw Exception("Modo de Configuracion no implementado borrando recursos...");
}





