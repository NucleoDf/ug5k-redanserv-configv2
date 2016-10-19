#include "../../include/config/comm-config.h"

/** */
CommConfig::CommConfig(soap_config &sConfig)
{
	/** Configuración de ULISES */
	this->tipo = 1;
	this->idConf = "ULISES-CONF";
	this->fechaHora = sConfig.IdConfig;
	
	/** Parametros Generales */
	this->general = CommGenConfig(sConfig);
	
	/** Servicios */
	this->servicios = CommSerConfig(sConfig);

	/** Configuracion de Hardware */
	this->hardware = CommHarConfig(sConfig);

	/** Configuracion de Recursos */
	for (size_t irec=0; irec<sConfig.CfgPasarela.ListaRecursos.size(); irec++)
	{
		this->recursos.push_back(CommResConfig(sConfig, irec));
	}

	/** En Ulises no hay usuarios */
	this->users.clear();
}

/** */
CommGenConfig::CommGenConfig(soap_config &sc)
{
	this->name = sc.CfgPasarela.Nombre;
	this->emplazamiento = "";					// TODO.
	this->dualidad = 0;							// TODO.
	this->ipv = sc.Ip;
	this->ips=sc.Server;
	this->nivelconsola = 0;						// TODO.
	this->puertoconsola = 0;
	this->nivelIncidencias = 0;

	this->cpus.push_back(CommGenCpu(sc.Ip,"255.255.255.0",sc.Ip));
	this->cpus.push_back(CommGenCpu());
}

/** */
CommSerConfig::CommSerConfig(soap_config &sc) 
{
	/** SIP */
	this->sip.PuertoLocalSIP = sc.CfgPasarela.PuertoLocalSIP;
	sc.firstRadioParams(this->sip.KeepAlivePeriod, this->sip.KeepAliveMultiplier, this->sip.SupresionSilencio);
	this->sip.PeriodoSupervisionSIP = sc.CfgPasarela.PeriodoSupervisionSIP;	
	
	vector<string> sipserver;
	sc.sip_servers(sipserver);
	for(vector<string>::iterator it=sipserver.begin(); it!=sipserver.end(); it++) 
	{
		if (this->sip.proxys.size() < 2)
		{
			this->sip.proxys.push_back(CommSerServidor(*it));
			this->sip.registrars.push_back(CommSerServidor(*it));
		}
	}

	/** WEB */
	this->web.wport = atoi(LocalConfig::cfg.PuertoEscucha().c_str());
	this->web.stime = atoi(LocalConfig::cfg.TiempoSesion().c_str());

	/** SNMP */
	LocalConfig snmpini(LocalConfig::cfg.snmpModule());
	this->snmp.sport = 65000;
	this->snmp.snmpp = snmpini.getInt("AGENTE","PORT");
	this->snmp.agcomm = snmpini.getString("AGENTE","SNMPV2COMM");
	this->snmp.agcont = snmpini.getString("AGENTE","CONTACT");
	this->snmp.agloc = snmpini.getString("AGENTE","LOCATION");
	this->snmp.agname = snmpini.getString("AGENTE","NAME");
	this->snmp.agv2 = snmpini.getInt("AGENTE","SNMPV2");

	/** Grabador */
	LocalConfig recini(LocalConfig::cfg.recModule());
	this->grab.rtsp_ip = recini.getString("RTSP","IP_REC_A");
	this->grab.rtsp_port = recini.getInt("RTSP","PORT");

	/** SINCR */
	if (sc.CfgPasarela.MasterSincronizacion != "")
		this->sincr.servidores.push_back(CommSerServidor(sc.CfgPasarela.MasterSincronizacion));
}

/** */
CommHarConfig::CommHarConfig(soap_config &sc)
{
	/** Inicializa los Arrays */
	for (int islv=0; islv<_NUM_SLAVES_; islv++) 
	{
		CommHarConfigSlv Slv;

		for (int ipos=0; ipos<_NUM_POS_; ipos++) 
		{
			Slv.pos.push_back(CommHarConfigPos());
		}

		this->slv.push_back(Slv);
	}

	/** Configura las posiciones con los recursos configurados */
	for (size_t irec=0; irec<sc.CfgPasarela.ListaRecursos.size(); irec++)
	{
		int islv = sc.CfgPasarela.ListaRecursos[irec].SlotPasarela;
		int ipos = sc.CfgPasarela.ListaRecursos[irec].NumDispositivoSlot;

		if (islv < _NUM_SLAVES_ && ipos < _NUM_POS_)
		{
			this->slv[islv].tp = 1;						// IA4
			this->slv[islv].pos[ipos].tp=0;
			this->slv[islv].pos[ipos].cfg=sc.CfgPasarela.ListaRecursos[irec].TipoRecurso==0 ? 1 : 2;
		}
	}

}

/** */
CommResConfig::CommResConfig(soap_config &sc, int irec)
{
	if (irec < (int )sc.CfgPasarela.ListaRecursos.size())
	{
		soap_RecursosSCV sres = sc.CfgPasarela.ListaRecursos[irec];

		/** Parametros generales de recurso */
		this->IdRecurso = sres.IdRecurso;
		this->Radio_o_Telefonia = sres.TipoRecurso==0 ? 1 : 2;
		this->SlotPasarela = sres.SlotPasarela;
		this->NumDispositivoSlot =sres. NumDispositivoSlot;
		this->TamRTP = sres.info.TamRTP;	
		this->Codec = sres.info.Codec;
		this->Uri_Local = "sip:" + sres.IdRecurso + "@" + sc.Ip;

		this->enableRegistro = 0;							// TODO.
		this->szClave = "";									// TODO.
		this->Buffer_jitter.max = 0;							// TODO.
		this->Buffer_jitter.min = 0;							// TODO.

		this->hardware.AD_AGC = sres.info.GananciaAGCRX;
		this->hardware.AD_Gain= sres.info.GananciaAGCRXdBm;
		this->hardware.DA_AGC = sres.info.GananciaAGCTX;
		this->hardware.DA_Gain= sres.info.GananciaAGCTXdBm;

		if (sres.TipoRecurso==0) 
		{
			/** Parametros Generales Radio */
			this->radio.tipo=4;												// Remoto RxTx
			this->radio.sq=sres.info.radio.SQ=="v" ? 1 : 0;
			this->radio.ptt=sres.info.radio.PTT=="s" ? 1 : 0;
			this->radio.bss=sres.info.radio.BSS==false ? 0 : 1;
			this->radio.modoConfPtt=sres.info.radio.ModoConfPTT;
			this->radio.repSqBss=sres.info.radio.RepSQyBSS;
			this->radio.desactivacionSq=sres.info.radio.DesactivacionSQ;
			this->radio.timeoutPtt=sres.info.radio.TimeoutPTT;
			this->radio.metodoBss=sres.info.radio.MetodoBSS;
			this->radio.umbralVad=sres.info.radio.UmbralVAD;
			this->radio.numFlujosAudio=sres.info.radio.NumFlujosAudio;
			this->radio.tiempoPtt=sres.info.radio.TiempoPTT;
			this->radio.tmVentanaRx=100;										// TODO.
			this->radio.climaxDelay=1;										// TODO.
			this->radio.tmRetardoFijo=100;									// TODO.
			this->radio.bssRtp=0;											// TODO.
			this->radio.retrasoSqOff=50;										// TODO.
			this->radio.evtPTT=0;											// TODO.
			this->radio.tjbd=20;												// TODO.
			this->radio.tGRSid=10;											// TODO.
			this->radio.iEnableGI=sres.info.GrabacionEd137==false ? 0 : 1;

			this->radio.tabla_indices_calidad.clear();						// TODO.
		
			this->radio.iSesionPrio=0;										// Solo en REDAN. Radio Local.
			this->radio.iPttPrio=0;											// 
			this->radio.iPrecisionAudio=1;									// Normal.

			this->radio.colateral.name="";									// Frecuencia. Solo REDAN
			this->radio.colateral.tipoConmutacion=0;
			this->radio.colateral.emplazamientos.push_back(CommResRadioEmplazamiento());
			this->radio.colateral.emplazamientos.push_back(CommResRadioEmplazamiento());
			this->radio.colateral.emplazamientos.push_back(CommResRadioEmplazamiento());
		}
		else 
		{
			/** Parametros Generales Telefonia */
			sc.TipoTelefonia((int )sres.Interface, this->telefonia.tipo);
			this->telefonia.lado = sres.info.telef.Lado;
			this->telefonia.t_eym = 0;								 // sres.info.telef.TipoEM; TODO. En REDAN no se utiliza.
			this->telefonia.h2h4 = 0;								 // sres.info.telef.Modo; TODO. En REDAN no se utiliza.
			this->telefonia.ladoeym = 0;								 // res.info.telef.Lado; TODO. En REDAN no se utiliza.
			this->telefonia.modo = 0;								 // sres.info.telef.Modo; TODO. En REDAN no se utiliza.
			this->telefonia.r_automatica = 0;						 // Solo en REDAN.
			this->telefonia.no_test_local = "";						 // TODO. Solo en REDAN.
			this->telefonia.no_test_remoto = "";						 // TODO. Solo en REDAN.
			this->telefonia.it_release = 5;							 // TODO. Solo en REDAN.
			this->telefonia.uri_remota = "";							 // TODO. Solo en REDAN.
			this->telefonia.detect_vox = 1;							 // TODO. 
			this->telefonia.umbral_vox = sres.info.UmbralTonoSQ;		 // TODO. Confirmar.
			this->telefonia.tm_inactividad = 2;						 // TODO. Confirmar.
			this->telefonia.superv_options = 1;						 // TODO. Confirmar.
			this->telefonia.tm_superv_options = 2;					 // TODO. Confirmar.
			this->telefonia.colateral_scv = 0;						 // TODO. Confirmar.
			this->telefonia.iT_Int_Warning = 5;						 // TODO. Confirmar.
			this->telefonia.ats_rangos_dst.clear();					 // TODO. Confirmar.
			this->telefonia.ats_rangos_org.clear();					 // TODO. Confirmar.
		}

		this->LlamadaAutomatica=0;							// Solo REDAN.

		this->restriccion=0;									// Solo REDAN.
		this->blanca.clear();								// Solo REDAN.
		this->negra.clear();									// Solo REDAN.
	}
}

