#include "../../include/config/comm-config.h"
#include "../../include/rapidxml-1.13/rapidxml.hpp"

using namespace rapidxml;

/** */
bool CommConfig::soap_parse(vector<string> &soap_strings)
{
	if (soap_strings.size() == 11)
	{
		soap_parse_idconfig(soap_strings[0], (*this));
		soap_parse_gwconfig(soap_strings[2], (*this));
		return true;
	}
	return false;
}

/** */
bool CommConfig::soap_parse_idconfig(string xml_string, string &version)
{
	xml_document<> doc;
	xml_node<> * root_node;

	doc.parse<0>((char *)xml_string.c_str());
	root_node = doc.first_node("string");
	
	version = root_node->value();
	return true;
}

/** */
bool CommConfig::soap_parse_multicast(string xml_string, string &ip, int &puerto)
{
	xml_document<> doc;
	xml_node<> * root_node;

	doc.parse<0>((char *)xml_string.c_str());
	root_node = doc.first_node("ParametrosMulticast");

	xml_node<> *ipnode = root_node->first_node("GrupoMulticastConfiguracion");
	ip = ipnode->value();

	xml_node<> *portnode = root_node->first_node("PuertoMulticastConfiguracion");
	puerto = atoi(portnode->value());

	return true;
}

/** */
bool CommConfig::soap_parse_idconfig(string xml_string, CommConfig &cfg)
{
	cfg.idConf = "ULISES-CONF";
	return soap_parse_idconfig(xml_string, cfg.fechaHora);
}

/** */
bool CommConfig::soap_parse_gwconfig(string xml_string,  CommConfig &cfg)
{
	xml_document<> doc;
	xml_node<> * root_node;

	doc.parse<0>((char *)xml_string.c_str());
	root_node = doc.first_node("CfgPasarela");

	/** */
	cfg.general.name = root_node->first_node("Nombre")->value();
	int nrec = atoi(root_node->first_node("NumRecursos")->value());

	/** TODO. Comprobar. */
	cfg.servicios.sincr.ntp = atoi(root_node->first_node("ModoSincronizacion")->value());
	cfg.servicios.sincr.servidores.push_back(CommSerServidor(root_node->first_node("MasterSincronizacion")->value(), 1));

	/** TODO */
	int SnmpPuertoLocal = atoi(root_node->first_node("PuertoLocalSNMP")->value());
	int SnmpPuertoRemoto=atoi(root_node->first_node("PuertoRemotoSNMP")->value());
	int SnmpPuertoTrap=atoi(root_node->first_node("PuertoRemotoTrapsSNMP")->value());

	/** TODO. Comprobar */
	cfg.servicios.sip.PuertoLocalSIP = atoi(root_node->first_node("PuertoLocalSIP")->value());
	cfg.servicios.sip.PeriodoSupervisionSIP = atoi(root_node->first_node("PeriodoSupervisionSIP")->value());

	root_node = root_node->first_node("ListaRecursos");
	for (xml_node<> * res_node = root_node->first_node("RecursosSCV"); res_node; res_node = res_node->next_sibling())
	{
		CommResConfig res;

		string IdRecurso = res_node->first_node("IdRecurso")->value();
		int Tipo = atoi(res_node->first_node("Tipo")->value());
		string Interface = res_node->first_node("Interface")->value();
		int SlotPasarela = atoi(res_node->first_node("SlotPasarela")->value());
		int NumDispositivoSlot = atoi(res_node->first_node("NumDispositivoSlot")->value());
		string ServidorSIP = res_node->first_node("ServidorSIP")->value();
		bool Diffserv = res_node->first_node("ServidorSIP")->value()=="false" ? false : true;
		string IdSistema = res_node->first_node("IdSistema")->value();
		int TipoRecurso = atoi(res_node->first_node("TipoRecurso")->value());

		/** Parametros generales de recurso */
		res.IdRecurso = IdRecurso;
		res.Radio_o_Telefonia = 1;							// TODO.
		res.SlotPasarela = SlotPasarela;
		res.NumDispositivoSlot = NumDispositivoSlot;
		res.TamRTP = 20;									// TODO.
		res.Codec = 0;
		res.Uri_Local = "sip:"+IdRecurso+"@127.0.0.1";		// TODO.
		res.enableRegistro = 0;								// TODO.
		res.szClave = "";									// TODO.

		res.Buffer_jitter.max = 0;							// TODO.
		res.Buffer_jitter.min = 0;							// TODO.

		res.hardware.AD_AGC = 0;							// TODO.
		res.hardware.AD_Gain= 0;							// TODO.
		res.hardware.DA_AGC = 0;							// TODO.
		res.hardware.DA_Gain= 0;							// TODO.

		/** Parametros Generales Radio */
		res.radio.tipo=0;									// TODO.
		res.radio.sq=0;
		res.radio.ptt=0;
		res.radio.bss=0;
		res.radio.modoConfPtt=0;
		res.radio.repSqBss=1;
		res.radio.desactivacionSq=1;
		res.radio.timeoutPtt=200;
		res.radio.metodoBss=0;
		res.radio.umbralVad=-33;
		res.radio.numFlujosAudio=1;
		res.radio.tiempoPtt=0;
		res.radio.tmVentanaRx=100;
		res.radio.climaxDelay=1;
		res.radio.tmRetardoFijo=100;
		res.radio.bssRtp=0;
		res.radio.retrasoSqOff=50;
		res.radio.evtPTT=0;
		res.radio.tjbd=20;
		res.radio.tGRSid=10;
		res.radio.iEnableGI=0;

		res.radio.tabla_indices_calidad.clear();			// TODO.
		
		res.radio.iSesionPrio=0;
		res.radio.iPttPrio=0;
		res.radio.iPrecisionAudio=1;

		res.radio.colateral.name="";						// TODO.
		res.radio.colateral.tipoConmutacion=0;
		res.radio.colateral.emplazamientos.clear();

		/** Parametros Generales Telefonia */
		res.telefonia.tipo = 0;								// TODO.
		res.telefonia.lado = 1;
		res.telefonia.t_eym = 0;
		res.telefonia.h2h4 = 0;
		res.telefonia.ladoeym = 0;
		res.telefonia.modo = 0;
		res.telefonia.r_automatica = 1;
		res.telefonia.no_test_local = "";
		res.telefonia.no_test_remoto = "";
		res.telefonia.it_release = 5;
		res.telefonia.uri_remota = "";
		res.telefonia.detect_vox = 0;
		res.telefonia.umbral_vox = -10;
		res.telefonia.tm_inactividad = 2;
		res.telefonia.superv_options = 1;
		res.telefonia.tm_superv_options = 2;
		res.telefonia.colateral_scv = 0;
		res.telefonia.iT_Int_Warning = 5;
		res.telefonia.ats_rangos_dst.clear();
		res.telefonia.ats_rangos_org.clear();

		res.LlamadaAutomatica=0;							// TODO.
		res.restriccion=0;									// TODO.
		res.blanca.clear();									// TODO.
		res.negra.clear();									// TODO.

		cfg.recursos.push_back(res);
		nrec--;
	}

	return true;
}

