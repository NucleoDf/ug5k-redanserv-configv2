#include "../../include/config/comm-config.h"

/** */
CommConfig::CommConfig(soap_config &sConfig)
{
	/** TODO */
}

///** */
//bool CommConfig::soap_parse(vector<string> &soap_strings)
//{
//	if (soap_strings.size() == 11)
//	{
//		soap_parse_idconfig(soap_strings[0], (*this));
//		soap_parse_gwconfig(soap_strings[2], (*this));
//		return true;
//	}
//	return false;
//}
//
///** */
//bool CommConfig::soap_parse_idconfig(string xml_string, string &version)
//{
//	xml_document<> doc;
//	xml_node<> * root_node;
//
//	doc.parse<0>((char *)xml_string.c_str());
//	root_node = doc.first_node("string");
//	
//	version = root_node->value();
//	return true;
//}
//
///** */
//bool CommConfig::soap_parse_multicast(string xml_string, string &ip, int &puerto)
//{
//	xml_document<> doc;
//	xml_node<> * root_node;
//
//	doc.parse<0>((char *)xml_string.c_str());
//	root_node = doc.first_node("ParametrosMulticast");
//
//	ip = RAPID_XML_NODE_VALUE(root_node, "GrupoMulticastConfiguracion");
//	puerto = atoi(RAPID_XML_NODE_VALUE(root_node, "PuertoMulticastConfiguracion"));
//	return true;
//}
//
///** */
//bool CommConfig::soap_parse_idconfig(string xml_string, CommConfig &cfg)
//{
//	cfg.idConf = "ULISES-CONF";
//	return soap_parse_idconfig(xml_string, cfg.fechaHora);
//}
//
///** */
//bool CommConfig::soap_parse_gwconfig(string xml_string,  CommConfig &cfg)
//{
//	xml_document<> doc;
//	xml_node<> * root_node;
//
//	doc.parse<0>((char *)xml_string.c_str());
//	root_node = doc.first_node("CfgPasarela");
//
//	/** */
//	cfg.general.name = RAPID_XML_NODE_VALUE(root_node,"Nombre");
//	int nrec = atoi(RAPID_XML_NODE_VALUE(root_node, "NumRecursos"));
//
//	/** TODO. Comprobar. */
//	cfg.servicios.sincr.ntp = atoi(RAPID_XML_NODE_VALUE(root_node, "ModoSincronizacion"));
//	cfg.servicios.sincr.servidores.push_back(CommSerServidor(RAPID_XML_NODE_VALUE(root_node, "MasterSincronizacion"), 1));
//
//	/** TODO */
//	int SnmpPuertoLocal = atoi(RAPID_XML_NODE_VALUE(root_node, "PuertoLocalSNMP"));
//	int SnmpPuertoRemoto=atoi(RAPID_XML_NODE_VALUE(root_node, "PuertoRemotoSNMP"));
//	int SnmpPuertoTrap=atoi(RAPID_XML_NODE_VALUE(root_node, "PuertoRemotoTrapsSNMP"));
//
//	/** TODO. Comprobar */
//	cfg.servicios.sip.PuertoLocalSIP = atoi(RAPID_XML_NODE_VALUE(root_node, "PuertoLocalSIP"));
//	cfg.servicios.sip.PeriodoSupervisionSIP = atoi(RAPID_XML_NODE_VALUE(root_node, "PeriodoSupervisionSIP"));
//
//	root_node = root_node->first_node("ListaRecursos");
//	for (xml_node<> * res_node = root_node->first_node("RecursosSCV"); res_node; res_node = res_node->next_sibling())
//	{
//		CommResConfig res;
//
//		string IdRecurso = RAPID_XML_NODE_VALUE(res_node, "IdRecurso");
//		int Tipo = atoi(RAPID_XML_NODE_VALUE(res_node, "Tipo"));
//		string Interface = RAPID_XML_NODE_VALUE(res_node, "Interface");
//		int SlotPasarela = atoi(RAPID_XML_NODE_VALUE(res_node, "SlotPasarela"));
//		int NumDispositivoSlot = atoi(RAPID_XML_NODE_VALUE(res_node, "NumDispositivoSlot"));
//		string ServidorSIP = RAPID_XML_NODE_VALUE(res_node, "ServidorSIP");
//		bool Diffserv = RAPID_XML_NODE_VALUE(res_node, "ServidorSIP")=="false" ? false : true;
//		string IdSistema = RAPID_XML_NODE_VALUE(res_node, "IdSistema");
//		int TipoRecurso = atoi(RAPID_XML_NODE_VALUE(res_node, "TipoRecurso"));
//
//		/** Parametros generales de recurso */
//		res.IdRecurso = IdRecurso;
//		res.Radio_o_Telefonia = 1;							// TODO.
//		res.SlotPasarela = SlotPasarela;
//		res.NumDispositivoSlot = NumDispositivoSlot;
//		res.TamRTP = 20;									// TODO.
//		res.Codec = 0;
//		res.Uri_Local = "sip:"+IdRecurso+"@127.0.0.1";		// TODO.
//		res.enableRegistro = 0;								// TODO.
//		res.szClave = "";									// TODO.
//
//		res.Buffer_jitter.max = 0;							// TODO.
//		res.Buffer_jitter.min = 0;							// TODO.
//
//		res.hardware.AD_AGC = 0;							// TODO.
//		res.hardware.AD_Gain= 0;							// TODO.
//		res.hardware.DA_AGC = 0;							// TODO.
//		res.hardware.DA_Gain= 0;							// TODO.
//
//		/** Parametros Generales Radio */
//		res.radio.tipo=0;									// TODO.
//		res.radio.sq=0;
//		res.radio.ptt=0;
//		res.radio.bss=0;
//		res.radio.modoConfPtt=0;
//		res.radio.repSqBss=1;
//		res.radio.desactivacionSq=1;
//		res.radio.timeoutPtt=200;
//		res.radio.metodoBss=0;
//		res.radio.umbralVad=-33;
//		res.radio.numFlujosAudio=1;
//		res.radio.tiempoPtt=0;
//		res.radio.tmVentanaRx=100;
//		res.radio.climaxDelay=1;
//		res.radio.tmRetardoFijo=100;
//		res.radio.bssRtp=0;
//		res.radio.retrasoSqOff=50;
//		res.radio.evtPTT=0;
//		res.radio.tjbd=20;
//		res.radio.tGRSid=10;
//		res.radio.iEnableGI=0;
//
//		res.radio.tabla_indices_calidad.clear();			// TODO.
//		
//		res.radio.iSesionPrio=0;
//		res.radio.iPttPrio=0;
//		res.radio.iPrecisionAudio=1;
//
//		res.radio.colateral.name="";						// TODO.
//		res.radio.colateral.tipoConmutacion=0;
//		res.radio.colateral.emplazamientos.clear();
//
//		/** Parametros Generales Telefonia */
//		res.telefonia.tipo = 0;								// TODO.
//		res.telefonia.lado = 1;
//		res.telefonia.t_eym = 0;
//		res.telefonia.h2h4 = 0;
//		res.telefonia.ladoeym = 0;
//		res.telefonia.modo = 0;
//		res.telefonia.r_automatica = 1;
//		res.telefonia.no_test_local = "";
//		res.telefonia.no_test_remoto = "";
//		res.telefonia.it_release = 5;
//		res.telefonia.uri_remota = "";
//		res.telefonia.detect_vox = 0;
//		res.telefonia.umbral_vox = -10;
//		res.telefonia.tm_inactividad = 2;
//		res.telefonia.superv_options = 1;
//		res.telefonia.tm_superv_options = 2;
//		res.telefonia.colateral_scv = 0;
//		res.telefonia.iT_Int_Warning = 5;
//		res.telefonia.ats_rangos_dst.clear();
//		res.telefonia.ats_rangos_org.clear();
//
//		res.LlamadaAutomatica=0;							// TODO.
//		res.restriccion=0;									// TODO.
//		res.blanca.clear();									// TODO.
//		res.negra.clear();									// TODO.
//
//		cfg.recursos.push_back(res);
//
//		/** Configuracion del hardware */
//
//		nrec--;
//	}
//
//	return true;
//}
//
