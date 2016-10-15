#include "../include/cfg-proc.h"
#include "../include/his-proc.h"

#define SCK_RECV_TIMEOUT	(LocalConfig::cfg.HttpGenTimeout())

/** */
#define HTTP_CLIENT_TICK	50
#ifdef _PARAMS_IN_INI_
#define SERVER_URL			(LocalConfig::cfg.ServerURL())
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


///////////////////////////////////////////////////////////////////////////////////////////////////////
/** */
void HttpClientProc::AvisaPideConfiguracion(string cfg) 
{
	CCSLock _lock(m_lock);

	stAviso aviso;
	aviso.ip = SERVER_URL;	// _host_config;
	aviso.main = MAIN_PIDE_CONFIG;
	aviso.cmd = cfg;

	avisos.set(aviso);
}

/** */
void HttpClientProc::AvisaChequearConfiguracion() 
{
	CCSLock _lock(m_lock);

#ifdef _WIN32
	if (LocalConfig::cfg.winSyncSer())
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

///** */
//ParseResponse HttpClient::Public_SendHttpCmd(string host, string cmd)
//{
//	CCSLock _lock(m_lock);
//	return SendHttpCmd(host, cmd);
//}

/** */
void HttpClientProc::Run() 
{
	SetId("HttpClient");

	_maxticks = (LocalConfig::cfg.ConfigTsup()*1000)/HTTP_CLIENT_TICK;
	sistema::GetIpAddress((char *)LocalConfig::cfg.NetworkInterfaceActiva().c_str(), _ip_propia);
	_cntticks = 0;

	p_working_config->load_from(LAST_CFG);

	// TODO...
	//StdClient::std.NotificaCambioConfig();

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
			} catch (HttpClientException e) {

				PLOG_EXCEP(e, "Excepcion en HttpClient::Run: %s", e.what());

				if (aviso.ip==SERVER_URL)
				{
					// TODO
					//	StdClient::std.NotificaCambioConfig();

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
}

/** */
void HttpClientProc::Dispose() 
{
	Stop();
}

/** */
bool HttpClientProc::Get(stAviso &aviso)
{
	CCSLock _lock(m_lock);
	return avisos.get(aviso);
}

/** */
void HttpClientProc::ParseHost(string host, string &ip, int &port) 
{
	vector<string> partes;
	Tools::split(partes, host, ':');
	if (partes.size() == 1) {
		ip = host;
		port = 80;
	} else {
		ip = partes[0];
		port = atoi(partes[1].c_str());
	}
}

/** */
ParseResponse HttpClientProc::SendHttpCmd(string _host, string cmd) 
{
	string ip;
	int port;
	ParseHost(_host, ip, port);
	CIPAddress host(ip, port);
	CTCPSocket sck;

	try 
	{
		if (!sck.Connect(host))
			throw HttpClientException("No puedo conectarme al HOST: " + _host);
		if (sck.Send(cmd.c_str(), cmd.length()) != (int) cmd.length())
			throw HttpClientException("Error al Enviar request: " + cmd);

		string respuesta;
		char leido;
		int leidos;

		sck.SetRecvTimeout(SCK_RECV_TIMEOUT);
		do {
			if ((leidos = sck.Recv(&leido, 1)) > 0)
			{
				respuesta.push_back(leido);
				sck.SetRecvTimeout(1);
			}
		} while (leidos > 0);

		sck.Close();

		return ParseResponse(respuesta.c_str());

	} 
	catch (socket_error e) 
	{
		throw HttpClientException(e);
	}
}

/** */
void HttpClientProc::PedirConfiguracion(string cfg) 
{
	string path = "/configurations/" + cfg + "/gateways/" + _ip_propia + "/all";
	string request = "GET " + path + " HTTP/1.1\r\nHost: " + SERVER_URL /*_host_config*/ + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = SendHttpCmd(SERVER_URL/*_host_config*/, request);
	if (response.Status() != "200")
	{
		throw HttpClientException("REQUEST ERROR: GET " + path + 
			" Host: " + SERVER_URL/*_host_config*/ +  ". " + response.StatusText());
	}

	/** Salva ultima configuracion */
	p_working_config->save_to(LAST_SAVE(Tools::Int2String(_lastcfg++ & 3)));

	/** Lee la configuracion recibida */
	cfg_redan.JDeserialize(response.Body());
	
	/** Activa la configuracion recibida */
 	p_working_config->set(cfg_redan);

	/** Actualiza la configuracion recibida... TODO. Comprobar los PATH */
	p_working_config->save_to(LAST_CFG);

	/** EstadoSicronizacion=slcSincronizado */
	StdSincrSet(slcSincronizado);
}

/** */
void HttpClientProc::ChequearConfiguracion() 
{
	string request = "GET /gateways/" + _ip_propia + "/" + MAIN_TEST_CONFIG + " HTTP/1.1\r\nHost: " + SERVER_URL/*_host_config*/ + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = SendHttpCmd(SERVER_URL/*_host_config*/, request);
	if (response.Status() != "200")
	{
		throw HttpClientException("REQUEST ERROR: GET /" + _ip_propia + "/" + MAIN_TEST_CONFIG + 
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
void HttpClientProc::SubirConfiguracion()
{
	string cfgname = cfg_redan.idConf;
	string cfg = cfg_redan.JSerialize();

	string path = "/configurations/" + cfgname + "/gateways/" + _ip_propia + "/all";
	string request = "POST " + path + " HTTP/1.1\r\nHost: " + SERVER_URL/*_host_config*/ + "\r\nContent-Type: application/json; charset=utf-8\r\n" +
		"Content-Length: " + Tools::Int2String((int )cfg.size()) + "\r\n\r\n" + 	cfg + "\r\n";
	ParseResponse response = SendHttpCmd(SERVER_URL/*_host_config*/, request);
	if (response.Status() != "200")
	{
		throw HttpClientException("REQUEST ERROR: POST " + path + 
			" Host: " + SERVER_URL/*_host_config*/ +  ". " + response.Status() + ":" + response.StatusText());
	}

	CommConfig cfgRemota(response.Body());
	p_working_config->TimeStamp(cfgRemota);
	p_working_config->save_to(LAST_CFG);
	PLOG_INFO("Configuracion Enviada Correctamente (%s).", cfgRemota.fechaHora.c_str());
}

/** */
void HttpClientProc::GeneraAvisosCpu(string host, string cmd) 
{
	/** Generar el comando y Espera Respuesta... */
	string request = "PUT /" + string(CPU2CPU_MSG) + "/" + cmd + " HTTP/1.1\r\nHost: " + host + "\r\nContent-Type: application/json\r\n\r\n";
	ParseResponse response = SendHttpCmd(host, request);
	if (response.Status() != "200")
	{
		throw HttpClientException("REQUEST ERROR: PUT /" + string(CPU2CPU_MSG) + "/" + cmd + " Host: " + host +  ". " + response.Status());
	}
}

/** */
void HttpClientProc::SupervisaProcesoConfiguracion()
{
	if (++_cntticks >= _maxticks)	
	{
		AvisaChequearConfiguracion();
		_cntticks = 0;
	}
}

/** */
void HttpClientProc::StdSincrSet(eStdLocalConfig nstd)
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
void HttpClientProc::ResourcesConfigClear()
{
	if (LocalConfig::cfg.ClearResourcesOnBdt()==1) 
	{
		PLOG_DEBUG("Procediendo a Limpiar los Recursos de la Pasarela por estar fuera de CFG-ACTIVA");

		if (cfg_redan.recursos.size() > 0) // Solo si la configuracion activa tiene recursos. Evita almacenar configuraciones vacias.
		{
			CommPreconfs pcfg;

			// Si existe la Preconfiguracion Borrarla...
			pcfg.del(LAST_CONFIG_ONLINE);

			// Crear la Preconfiguracion con los datos actuales.
			CommPreconf actual(LAST_CONFIG_ONLINE, Tools::Ahora(), cfg_redan.JSerialize());
			pcfg.pos(LAST_CONFIG_ONLINE, actual);

			// Borrar los recursos de la configuracion activa.
			p_working_config->ResourcesClear();
			p_working_config->TimeStamp();

			// Activar la nueva configuracion.
			p_working_config->set(cfg_redan);
		}

		PLOG_DEBUG("Recursos Limpiados de la Pasarela por estar fuera de CFG-ACTIVA");
	}
	else 
	{
		PLOG_DEBUG("Recursos No Limpiados en la Pasarela por no estar configurada la opcion...");
	}
}
