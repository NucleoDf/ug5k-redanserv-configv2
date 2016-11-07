#include "../include/cfg-proc.h"
#include "../include/his-proc.h"

#define SCK_RECV_TIMEOUT	(LocalConfig::cfg.HttpGenTimeout()*1000)

/** */
#define HTTP_CLIENT_TICK	100
#ifdef _PARAMS_IN_INI_
#define SERVER_URL			(LocalConfig::p_cfg->get(strSection, strItemServidor))
#else
#define SERVER_URL			(jgw_config::cfg.ServerURL())
#endif

/** */
CfgProc *CfgProc::p_cfg_proc=NULL;

/** */
CfgProc::CfgProc(void) {
	_cntticks = 0;
	_bconflicto = false;
	_lastcfg=0;
	_stdLocalConfig = slcNoInicializado;
	_ip_propia = "";
	_bconflicto = false;
}

/** */
CfgProc::~CfgProc(void) {
}

/** */
bool CfgProc::IdConfig(int &std, string &id, string &tim)
{
	std = (int)GetStdLocalConfig();
	id = p_working_config->IdConfig();
	tim= p_working_config->TimConfig();
	return true;
}

/** */
void CfgProc::AvisaCambioConfiguracion(string ip) 
{
	CCSLock _lock(m_lock);

	stAviso aviso;
	aviso.ip = ip;
	aviso.main = CPU2CPU_MSG;
	aviso.cmd = CPU2CPU_MSG_CAMBIO_CONFIG;

	avisos.set(aviso);
}

/** */
void CfgProc::AvisaSubirConfiguracion() 
{
	CCSLock _lock(m_lock);
	stAviso aviso;

	aviso.ip = SERVER_URL; // _host_config;
	aviso.main = MAIN_SUBIR_CONFIG;
	aviso.cmd = "";

	avisos.set(aviso);
}


/** */
void CfgProc::AvisaPideConfiguracion(string cfg) 
{
	CCSLock _lock(m_lock);

	stAviso aviso;
	aviso.ip = SERVER_URL;	// _host_config;
	aviso.main = MAIN_PIDE_CONFIG;
	aviso.cmd = cfg;

	avisos.set(aviso);
}

/** */
void CfgProc::AvisaChequearConfiguracion() 
{
	CCSLock _lock(m_lock);

#ifdef _WIN32
	if (LocalConfig::p_cfg->get(strWindowsTest, strItemWindowsTestServidor)=="1"/*.winSyncSer()*/)
	{
#endif
		stAviso aviso;
		aviso.ip = SERVER_URL;		// _host_config;
		aviso.main = MAIN_TEST_CONFIG;
		aviso.cmd = "";

		avisos.set(aviso);
#ifdef _WIN32
	}
#endif
}

/** */
bool CfgProc::Get(stAviso &aviso)
{
	CCSLock _lock(m_lock);
	return avisos.get(aviso);
}

/** */
void CfgProc::StdSincrSet(eStdLocalConfig nstd)
{
	if (_stdLocalConfig != nstd)
	{
		/** Genera el Historico */
		if (nstd == slcConflicto)
		{
			HistClient::p_hist->SetEvent(INCI_CONFLICTO, "-", "GW", _ip_propia);
		}

		/** Marca el Valor en SNMP */
		HistClient::p_hist->SetSincrState(nstd==slcSincronizado ? "1" : nstd==slcConflicto ? "2" : "0");

		/** Marca el Valor en la Configuracion */
		_stdLocalConfig = nstd;

		switch(nstd) 
		{
		case slcNoBdt:
		case slcNoActiveCfg:
			ResourcesConfigClear();
			break;
		default:
			break;
		}

		PLOG_DEBUG("Cambio Estado sincronizacion => %d", (int )nstd);
	}
}

/** */
void CfgProc::GeneraAvisosCpu(string host, string cmd) 
{
	/** Generar el comando y Espera Respuesta... */
	string request = "PUT /" + string(CPU2CPU_MSG) + "/" + cmd + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = HttpClient(host).SendHttpCmd(request);
	if (response.Status() != "200")
	{
		throw Exception("REQUEST ERROR: PUT /" + string(CPU2CPU_MSG) + "/" + cmd + " Host: " + host +  ". " + response.Status());
	}
}

/** */
void CfgProc::ResourcesConfigClear()
{
	if (LocalConfig::p_cfg->get(strSection,strItemClearResourcesOnBdt)=="1")	// .ClearResourcesOnBdt()==1) 
	{
		PLOG_DEBUG("Procediendo a Limpiar los Recursos de la Pasarela por estar fuera de CFG-ACTIVA");

		if (p_working_config->HasResources()==true) // Solo si la configuracion activa tiene recursos. Evita almacenar configuraciones vacias.
		{
			CommPreconfs pcfg;

			// Si existe la Preconfiguracion Borrarla...
			pcfg.del(LAST_CONFIG_ONLINE);

			// Crear la Preconfiguracion con los datos actuales.
			CommPreconf actual(LAST_CONFIG_ONLINE, Tools::Ahora(), p_working_config->JConfig());
			pcfg.pos(LAST_CONFIG_ONLINE, actual);

			// Borrar los recursos de la configuracion activa.
			p_working_config->ResourcesClear();
			p_working_config->TimeStamp();

			// Activar la nueva configuracion.
			p_working_config->set();
		}

		PLOG_DEBUG("Recursos Limpiados de la Pasarela por estar fuera de CFG-ACTIVA");
	}
	else 
	{
		PLOG_DEBUG("Recursos No Limpiados en la Pasarela por no estar configurada la opcion...");
	}
}

/** */
void JsonClientProc::Run() 
{
	SetId("JsonClientProc");
	PLOG_INFO("JsonClientProc running...");
	modo="rd";

	_maxticks = (atoi(LocalConfig::p_cfg->get(strSection, strItemConfigTSUP).c_str())*1000)/HTTP_CLIENT_TICK;
	_cntticks = 0;
	sistema::GetIpAddress(_ip_propia);

	p_working_config->load_from(LAST_CFG);

	// TODO: StdClient::std.NotificaCambioConfig();
	AvisaChequearConfiguracion();
	while (IsRunning()) {

		this->sleep(HTTP_CLIENT_TICK);
		stAviso aviso;

		// _host_config = SERVER_URL;
		if (avisos.get(aviso)) {
			try {
				if (SERVER_URL!="")		// Si me han borrado el servidor no hago POLLING a EL...
				{
					if (aviso.main == MAIN_TEST_CONFIG) {
						ChequearConfiguracion();
					} else if (aviso.main == MAIN_PIDE_CONFIG) {
						PLOG_INFO("Solicitando Configuracion a: %s", aviso.ip.c_str());
						PedirConfiguracion(aviso.cmd);
					} else if (aviso.main == CPU2CPU_MSG) {
						PLOG_INFO("Avisando de cambio de Configuracion a: %s", aviso.ip.c_str());
						GeneraAvisosCpu(aviso.ip, aviso.cmd);
					} else if (aviso.main == MAIN_SUBIR_CONFIG) {
						PLOG_INFO("Subiendo Configuracion a: %s", aviso.ip.c_str());
						SubirConfiguracion();
					}
				}
				else
				{
					StdSincrSet(slcAislado/*, jgw_config::cfg*/);
				}
			} catch (Exception e) {

				PLOG_EXCEP(e/*, "Excepcion en HttpClient::Run: %s", e.what()*/,"");

				if (aviso.ip==SERVER_URL)
				{
					// TODO: StdClient::std.NotificaCambioConfig();
					//p_working_config->load_from(LAST_CFG);
					/** Estado Sincronizacion=slcAislado */
					StdSincrSet(slcAislado);
				}
			} catch (...) {
				PLOG_ERROR("Excepcion en HttpClient::Run");
			}
		}
		SupervisaProcesoConfiguracion();
	}
	PLOG_INFO("JsonClientProc leaving...");
}

/** */
void JsonClientProc::Dispose() 
{
	Stop();
}

/** */
void JsonClientProc::PedirConfiguracion(string cfg) 
{
	string path = "/configurations/" + cfg + "/gateways/" + _ip_propia + "/all";
	string request = "GET " + path + " HTTP/1.1\r\nHost: " + SERVER_URL /*_host_config*/ + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = HttpClient(SERVER_URL).SendHttpCmd(request);
	if (response.Status() != "200")
	{
		throw Exception("REQUEST ERROR: GET " + path + 
			" Host: " + SERVER_URL/*_host_config*/ +  ". " + response.StatusText());
	}

	/** Salva ultima configuracion */
	p_working_config->save_to(LAST_SAVE(Tools::Int2String(_lastcfg++ & 3)));

	/** Lee la configuracion recibida */
	cfg_redan.JDeserialize(response.Body());
	
	/** Activa la configuracion recibida */
 	p_working_config->set(cfg_redan);

	/** Actualiza la configuracion recibida... */
	p_working_config->save_to(LAST_CFG);

	/** EstadoSicronizacion=slcSincronizado */
	StdSincrSet(slcSincronizado);
}

/** */
void JsonClientProc::ChequearConfiguracion() 
{
	string request = "GET /gateways/" + _ip_propia + "/" + MAIN_TEST_CONFIG + " HTTP/1.1\r\nHost: " + SERVER_URL/*_host_config*/ + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = HttpClient(SERVER_URL).SendHttpCmd(request);
	if (response.Status() != "200")
	{
		throw Exception("REQUEST ERROR: GET /" + _ip_propia + "/" + MAIN_TEST_CONFIG + 
			" Host: " + SERVER_URL/*_host_config*/ +  ". " + response.Status() + ":" + response.StatusText());
	}

	CommConfig cfgRemota(response.Body());
	if (cfgRemota.idConf == "-1")
		StdSincrSet(slcNoBdt);
	else if (cfgRemota.idConf == "-2")
		StdSincrSet(slcNoActiveCfg);
	else if (cfg_redan == cfgRemota) 
		StdSincrSet(slcSincronizado);
	else if (cfg_redan < cfgRemota)
		AvisaPideConfiguracion(cfgRemota.idConf);
	else
		StdSincrSet(slcConflicto);
}

/** */
void JsonClientProc::SubirConfiguracion()
{
	string cfgname = cfg_redan.idConf;
	string cfg = cfg_redan.JSerialize();

	string path = "/configurations/" + cfgname + "/gateways/" + _ip_propia + "/all";
	string request = "POST " + path + " HTTP/1.1\r\nHost: " + SERVER_URL/*_host_config*/ + "\r\nContent-Type: application/json; charset=utf-8\r\n" +
		"Content-Length: " + Tools::Int2String((int )cfg.size()) + "\r\n\r\n" + 	cfg + "\r\n";
	ParseResponse response = HttpClient(SERVER_URL).SendHttpCmd(request);
	if (response.Status() != "200")
	{
		throw Exception("REQUEST ERROR: POST " + path + 
			" Host: " + SERVER_URL/*_host_config*/ +  ". " + response.Status() + ":" + response.StatusText());
	}

	CommConfig cfgRemota(response.Body());
	p_working_config->TimeStamp(cfgRemota);
	p_working_config->save_to(LAST_CFG);
	PLOG_INFO("Configuracion Enviada Correctamente (%s).", cfgRemota.fechaHora.c_str());
}

/** */
void JsonClientProc::SupervisaProcesoConfiguracion()
{
	if (++_cntticks >= _maxticks)	
	{
		AvisaChequearConfiguracion();
		_cntticks = 0;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// SoapClientProc
string SoapClientProc::hwName;
string SoapClientProc::hwIp;
string SoapClientProc::hwServer;
/** */
void SoapClientProc::Run()
{
	SetId("SoapClientProc");
	PLOG_INFO("SoapClientProc running...");
	modo="ul";

	_maxticks = (atoi(LocalConfig::p_cfg->get(strSection, strItemConfigTSUP).c_str())/*.ConfigTsup()*/*1000)/HTTP_CLIENT_TICK;
	_cntticks = 0;

	/** Leo los datos del Hardware */
	sistema::GetWorkingIpAddressAndName(_ip_propia, hwServer, hwName);
	PLOG_INFO("SoapClientProc running. GetWorkingIpAddressAndName (%s-%s-%s).", _ip_propia.c_str(), hwServer.c_str(), hwName.c_str());
	
	/** Actualizo los datos en mis ficheros */
	LocalConfig::p_cfg->set(strSection, strItemServidor, hwServer);
	hwIp = _ip_propia;

	/** Leer la ultima CFG recibida */
	p_working_config->load_from(LAST_CFG);
	PLOG_INFO("SoapClientProc running. Leida LAST_CFG");

	AvisaChequearConfiguracion();
	while (IsRunning()) 
	{
		this->sleep(HTTP_CLIENT_TICK);
		stAviso aviso;

		if (avisos.get(aviso)) 
		{
			try 
			{
				if (SERVER_URL!="")		// Si me han borrado el servidor no hago POLLING a EL...
				{
					if (aviso.main == MAIN_TEST_CONFIG) {
						PLOG_DEBUG("Chequeando Configuracion en: %s...", aviso.ip.c_str());
						ChequearConfiguracion();
					} else if (aviso.main == MAIN_PIDE_CONFIG) {
						PLOG_INFO("Solicitando Configuracion a: %s...", aviso.ip.c_str());
						PedirConfiguracion(aviso.cmd);
						PLOG_INFO("Configuraci�n Recibida...");
					} else if (aviso.main == CPU2CPU_MSG) {
						PLOG_INFO("Avisando de cambio de Configuracion a: %s", aviso.ip.c_str());
						GeneraAvisosCpu(aviso.ip, aviso.cmd);
					} else if (aviso.main == MAIN_SUBIR_CONFIG) {
						PLOG_INFO("Subiendo Configuracion a: %s", aviso.ip.c_str());
						SubirConfiguracion();
					}
				}
				else
				{
					StdSincrSet(slcAislado);
				}
			} 
			catch (Exception e) 
			{
				PLOG_EXCEP(e, /*"Excepcion en SoapClient::Run: %s", e.what()*/"");
			} 
			catch (...) 
			{
				PLOG_ERROR("Excepcion en SoapClient::Run");
			}
		}
		SupervisaProcesoConfiguracion();
		McastTest();
	}
	PLOG_INFO("SoapClientProc leaving...");
}

/** */
void SoapClientProc::Dispose()
{
	Stop();
	if (p_mcast_socket != NULL) delete p_mcast_socket;
}

/** */
string SoapClientProc::getXml(string proc, string p1, string p2, string p3)
{
	string path = "/NucleoDF/U5kCfg/InterfazSOAPConfiguracion/InterfazSOAPConfiguracion.asmx/" + proc;
	string data = "";		// "id_sistema=departamento";
	if (p1 != "") {
		data += ("&"+p1);
		if (p2 != "")
			data += ("&"+p2);
		if (p3 != "")
			data += ("&"+p3);
	}
	string request = "POST " + path + " HTTP/1.1\r\nHost: " + SERVER_URL/*hwServer*/ + 
		"\r\nContent-Type: application/x-www-form-urlencoded\r\n" +
		"Content-Length: " + Tools::Int2String((int )data.size()) + 
		"\r\n\r\n" + 	data /*+ "\r\n"*/;
	ParseResponse response = HttpClient(SERVER_URL).SendHttpCmd(request);
	if (response.Status() != "200")
	{
		PLOG_DEBUG("SoapClientProc::getXml: %s", response.Status().c_str());
		throw Exception("REQUEST ERROR: POST " + path + 
		" Host: " + SERVER_URL/*hwServer*/ +  ". " + response.Status() + ":" + response.StatusText());
	}

#ifdef _WIN32 
	sistema::DataSaveAs(response.Body(), proc+"_" + p2 + "_" + p3 + ".xml");
#endif
	
	return response.Body();
}

/** */
void SoapClientProc::SupervisaProcesoConfiguracion()
{
	if (++_cntticks >= _maxticks)	
	{
		AvisaChequearConfiguracion();
		_cntticks = 0;
	}
}

/** */
void SoapClientProc::ChequearConfiguracion()
{
	try 
	{
		xml_document<> doc;
		string xml_data = getXml("GetVersionConfiguracion","id_sistema=departamento");
		doc.parse<0>((char *)xml_data.c_str());
		string version = doc.first_node("string")->value();

		switch (_stdLocalConfig) 
		{
		case slcNoInicializado:
		case slcAislado:
			if (version != p_working_config->TimConfig())
				AvisaPideConfiguracion();
			else
			{
				McastActivateOrDeactivate(true);
				StdSincrSet(slcSincronizado);
			}
			break;
		case slcSincronizado:
			if (version != p_working_config->TimConfig()) 
			{
				PLOG_DEBUG("SoapClientProc::ChequearConfiguracion: Cambio de configuracion sin aviso previo!!!");
				AvisaPideConfiguracion();
			}
			break;
		default:
			//slcNoBdt = -1,
			//slcNoActiveCfg = -2,
			//slcConflico = -4;
			break;
		}
	}
	catch(...)
	{	// Evento CFG-A
		// Cierra si procede el puerto de Escucha MCAST.
		McastActivateOrDeactivate(false);
		StdSincrSet(slcAislado);
		throw;
	}
}

/** */
void SoapClientProc::PedirConfiguracion(string cfg)
{
	try
	{
		/** Lee la configuracion recibida */
		soap_config sConfig(getXml, hwIp, hwName, SERVER_URL/*hwServer*/);

		/** Salva ultima configuracion */
		p_working_config->save_to(LAST_SAVE(Tools::Int2String(_lastcfg++ & 3)));

		/** Activa la configuracion recibida */
 		p_working_config->set(sConfig);

		/** Actualiza la configuracion recibida... */
		p_working_config->save_to(LAST_CFG);

		/** Abre si procede el puerto de Escucha MCAST */
		McastActivateOrDeactivate(true);

		/** EstadoSicronizacion=slcSincronizado */
		StdSincrSet(slcSincronizado);
	}
	catch(...)
	{
		// Evento CFG-A
		McastActivateOrDeactivate(false);
		StdSincrSet(slcAislado);
		throw;
	}
}

/** */
void SoapClientProc::SubirConfiguracion()
{
}

/** */
void SoapClientProc::McastActivateOrDeactivate(bool activate)
{
	string ipmcast;
	int port;

	P_WORKING_CONFIG->UlisesParamsMulticast(ipmcast, port);

	try
	{
		if (activate==true) {
			if (p_mcast_socket!=NULL) {
				// Por si cambia la configuracion del puerto...
				p_mcast_socket->Close();
				delete p_mcast_socket;
				p_mcast_socket = NULL;
			}
			CIPAddress mcast_group(ipmcast);
                        CIPAddress mcast_itf(_ip_propia);
			p_mcast_socket = new CUDPSocket();
			p_mcast_socket->SetReusable();
			p_mcast_socket->Bind(port);
			p_mcast_socket->JoinMulticastGroup(mcast_group, mcast_itf);
			PLOG_DEBUG("SoapClientProc: MCAST-JOIN(%s:%d)", ipmcast.c_str(), port);
		}
		else if (activate==false && p_mcast_socket!=NULL) {
			p_mcast_socket->Close();
			delete p_mcast_socket;
			p_mcast_socket = NULL;
			PLOG_DEBUG("SoapClientProc: MCAST-UNJOIN");
		}
	}
	catch(socket_error x) 
	{
		PLOG_EXCEP(x, "McastActivateOrDeactivate(%s:%d): %s", ipmcast.c_str(), port, x.what());		
	}
}

/** */
void SoapClientProc::McastTest()
{
	if (p_mcast_socket == NULL)
		return;

	vector<byte> buff;
	if (p_mcast_socket->Recv_bin(buff, 10)>0)
	{
		PLOG_INFO("Mensaje MCAST: ");
		if (buff[0]==0x31) {
			AvisaPideConfiguracion();
		}
	}
}
