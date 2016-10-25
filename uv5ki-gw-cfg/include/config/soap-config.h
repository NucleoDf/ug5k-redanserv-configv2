#ifndef __SOAP_CONFIG__
#define __SOAP_CONFIG__

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

#include "../../include/rapidxml-1.13/rapidxml.hpp"

using namespace rapidxml;

#define RAPID_XML_NODE_VALUE(pnode, tag)			(pnode!=NULL ? (pnode->first_node(tag)!=NULL ? pnode->first_node(tag)->value() : tag) : tag)

typedef string (*remoteGetXdataFunc)(string proc, string p1, string p2, string p3);

enum TI_ {TI_Radio=0, TI_LCEN=1, TI_BC=2, TI_BL=3, TI_AB=4, TI_ATS_R2=5, TI_ATS_N5=6, TI_ATS_QSIG=7, TI_ISDN_2BD=8, TI_ISDN_30BD=9, TI_I_O=10, TI_DATOS=11};

/** */
class xml_data : public CodeBase
{
public:
	xml_data(){};
	virtual ~xml_data(){};
public:
	void XDeserialize(string xml_string, string rootNodeStr)
	{
		xml_document<> doc;
		xml_node<> * root_node;

		doc.parse<0>((char *)xml_string.c_str());
		root_node = doc.first_node((char *)rootNodeStr.c_str());
		xread(root_node);
	}
	virtual void xread(xml_node<> * xnode)=0;

protected:
	void read_key(xml_node<> * xnode, const char *indice, bool &val) {
		string sval = string(RAPID_XML_NODE_VALUE(xnode, indice));
		val = sval == "false" ? false : true;
	}
	void read_key(xml_node<> * xnode, const char *indice, int &val) {
		val = atoi(RAPID_XML_NODE_VALUE(xnode, indice));
	}
	void read_key(xml_node<> * xnode, const char *indice, TI_ &val) {
		string str_val = RAPID_XML_NODE_VALUE(xnode, indice);
		val = (TI_)(
			str_val=="TI_Radio" ? TI_Radio :
			str_val=="TI_LCEN" ? TI_LCEN :
			str_val=="TI_BC" ? TI_BC :
			str_val=="TI_BL" ? TI_BL :
			str_val=="TI_AB" ? TI_AB :
			str_val=="TI_ATS_R2" ? TI_ATS_R2 :
			str_val=="TI_ATS_N5" ? TI_ATS_N5 :
			-1);
	}
	void read_key(xml_node<> * xnode, const char *indice, string &val) {
		val = RAPID_XML_NODE_VALUE(xnode, indice);
	}
	template <typename T> void read_key(string data, const char *indice, T &val) {
		val.XDeserialize(data, string(indice));
	}
	void read_key(xml_node<> * xnode, const char *root, vector<string> &val) {
		xml_node<> *root_node = xnode->first_node((char *)root);
		val.clear();
		if (root_node==NULL)
			return;
		for (xml_node<> * res_node = root_node->first_node("string"); res_node; res_node = res_node->next_sibling())
		{
			val.push_back(res_node->value());
		}
	}
	template <typename T> void read_key(xml_node<> * xnode, const char *root, const char *name, vector<T> &val) {
		xml_node<> *root_node = xnode->first_node((char *)root);
		val.clear();
		if (root_node==NULL)
			return;
		for (xml_node<> * res_node = root_node->first_node(name); res_node; res_node = res_node->next_sibling())
		{
			T obj;
			obj.xread(res_node);
			val.push_back(obj);
		}
	}
	template <typename T> void read_key(xml_document<> &doc, const char *root, const char *name, vector<T> &val) {
		xml_node<> * root_node;		
		
		root_node = doc.first_node((char *)root);
		val.clear();
		if (root_node==NULL)
			return;
		for (xml_node<> * res_node = root_node->first_node(name); res_node; res_node = res_node->next_sibling())
		{
			T obj;
			obj.xread(res_node);
			val.push_back(obj);
		}
	}

protected:
	static remoteGetXdataFunc remote_get_xdata_func;
};

/** */
class soap_ParametrosGeneralesSistema : public xml_data
{
public:
	soap_ParametrosGeneralesSistema() {}
	~soap_ParametrosGeneralesSistema() {}

public:
	void xread(xml_node<> * xnode) {
		read_key(xnode, "TiempoMaximoPTT", TiempoMaximoPTT);
		read_key(xnode, "TiempoSinJack1", TiempoSinJack1);
		read_key(xnode, "TiempoSinJack2", TiempoSinJack2);
		read_key(xnode, "TamLiteralEnlExt", TamLiteralEnlExt);
		read_key(xnode, "TamLiteralEnlDA", TamLiteralEnlDA);
		read_key(xnode, "TamLiteralEnlIA", TamLiteralEnlIA);
		read_key(xnode, "TamLiteralEnlAG", TamLiteralEnlAG);
		read_key(xnode, "TamLiteralEmplazamiento", TamLiteralEmplazamiento);
	}
public:
	int TiempoMaximoPTT;
	int TiempoSinJack1;
	int TiempoSinJack2;
	int TamLiteralEnlExt;
	int TamLiteralEnlDA;
	int TamLiteralEnlIA;
	int TamLiteralEnlAG;
	int TamLiteralEmplazamiento;

};

/** */
class soap_ParametrosMulticast : public xml_data
{
public:
	soap_ParametrosMulticast(){}
	~soap_ParametrosMulticast(){}

public:
	void xread(xml_node<> * xnode) {
		read_key(xnode, "GrupoMulticastConfiguracion", GrupoMulticastConfiguracion);
		read_key(xnode, "PuertoMulticastConfiguracion",PuertoMulticastConfiguracion);
	}

public:
	string GrupoMulticastConfiguracion;
	int PuertoMulticastConfiguracion;
};

/** */
class soap_AsignacionRecursosGW : public xml_data
{
public:
	soap_AsignacionRecursosGW(){}
	~soap_AsignacionRecursosGW(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdRecurso", IdRecurso);
		read_key(xnode, "IdHost", IdHost);		
	}
public:
	string IdRecurso;
	string IdHost;
};

/** */
class soap_AsignacionUsuariosTV : public xml_data
{
public:
	soap_AsignacionUsuariosTV(){}
	~soap_AsignacionUsuariosTV(){}

public:
	void xread(xml_node<> * xnode) {
		read_key(xnode, "IdUsuario", IdUsuario);
		read_key(xnode, "IdHost", IdHost);		
	}
public:
	string IdUsuario;
	string IdHost;
};

/** */
class soap_DireccionamientoIP : public xml_data
{
public:
	soap_DireccionamientoIP(){}
	~soap_DireccionamientoIP(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdHost", IdHost);
		read_key(xnode, "IpRed1", IpRed1);
		read_key(xnode, "IpRed2", IpRed2);
		read_key(xnode, "TipoHost", TipoHost);
		read_key(xnode, "Interno", Interno);
		read_key(xnode, "Min", Min);
		read_key(xnode, "Max", Max);
	}
public:
	string IdHost;
	string IpRed1;
	string IpRed2;
	string TipoHost;
	bool Interno;
	int Min;
	int Max;

};

/** */
class soap_DireccionamientoSIP : public xml_data
{
public:
	class soap_StrNumeroAbonado : public xml_data
	{
	public:
		soap_StrNumeroAbonado(){}
		~soap_StrNumeroAbonado(){}
	public:
		void xread(xml_node<> * xnode) {	
			read_key(xnode, "Prefijo", Prefijo);
			read_key(xnode, "NumeroAbonado", NumeroAbonado);
		}
	public:
		string Prefijo;
		string NumeroAbonado;
	};

public:
	soap_DireccionamientoSIP(){}
	~soap_DireccionamientoSIP(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdUsuario", IdUsuario);
		read_key(xnode, "NumerosAbonadoQueAtiende", "StrNumeroAbonado", NumerosAbonadoQueAtiende);
	}
public:
	string IdUsuario;
	vector<soap_StrNumeroAbonado> NumerosAbonadoQueAtiende;
};

/** */
class soap_ListaRedes : public xml_data
{
public:
	class soap_PlanRecursos : public xml_data
	{
	public:
		soap_PlanRecursos(){}
		~soap_PlanRecursos(){}
	public:
		void xread(xml_node<> * xnode) {	
			read_key(xnode, "IdRecurso", IdRecurso);
			read_key(xnode, "Tipo", Tipo);
		}
	public:
		string IdRecurso;
		string Tipo;
	};

public:
	soap_ListaRedes(){}
	~soap_ListaRedes(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdRed", IdRed);
		read_key(xnode, "Prefijo", Prefijo);
		read_key(xnode, "ListaRecursos", "PlanRecursos", ListaRecursos);
	}
public:
	string IdRed;
	string Prefijo;
	vector<soap_PlanRecursos> ListaRecursos;
};

/** */
class soap_ListaTroncales : public xml_data
{
public:
	class soap_PlanRecursos : public xml_data
	{
	public:
		soap_PlanRecursos(){}
		~soap_PlanRecursos(){}
	public:
		void xread(xml_node<> * xnode) {	
			read_key(xnode, "IdRecurso", IdRecurso);
			read_key(xnode, "Tipo", Tipo);
		}
	public:
		string IdRecurso;
		string Tipo;
	};

public:
	soap_ListaTroncales(){}
	~soap_ListaTroncales(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdTroncal", IdTroncal);
		read_key(xnode, "NumeroTest", NumeroTest);
		read_key(xnode, "ListaRecursos", "PlanRecursos", ListaRecursos);
	}
public:
	string IdTroncal;
	string NumeroTest;
	vector<soap_PlanRecursos> ListaRecursos;
};

/** */
class soap_NumeracionATS : public xml_data
{
public:
	class soap_RangosSCV : public xml_data
	{
	public:
		soap_RangosSCV(){}
		~soap_RangosSCV(){}
	public:
		void xread(xml_node<> * xnode) {	
			read_key(xnode, "IdPrefijo", IdPrefijo);
			read_key(xnode, "IdAbonado", IdAbonado);
			read_key(xnode, "Inicial", Inicial);
			read_key(xnode, "Final", Final);
			read_key(xnode, "IdSistema", IdSistema);
			read_key(xnode, "Central", Central);
			read_key(xnode, "Tipo", Tipo);
		}
	public:
		string IdPrefijo;
		string IdAbonado;
		string Inicial;
		string Final;
		string IdSistema;
		string Central;
		int Tipo;
	};

	class soap_PlanRutas : public xml_data
	{
	public:
		soap_PlanRutas(){}
		~soap_PlanRutas(){}
	public:
		void xread(xml_node<> * xnode) {	
			read_key(xnode, "TipoRuta", TipoRuta);
			read_key(xnode, "ListaTroncales", ListaTroncales);
		}
	public:
		string TipoRuta;
		vector<string> ListaTroncales;
	};

public:
	soap_NumeracionATS(){}
	~soap_NumeracionATS(){}

public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "CentralPropia", CentralPropia);
		read_key(xnode, "Throwswitching", Throwswitching);
		read_key(xnode, "NumTest", NumTest);
		read_key(xnode, "RangosOperador", "RangosSCV", RangosOperador);
		read_key(xnode, "RangosPrivilegiados", "RangosSCV", RangosPrivilegiados);
		read_key(xnode, "ListaRutas", "PlanRutas", ListaRutas);
	}
public:
	bool CentralPropia;
	bool Throwswitching;
	string NumTest;
	vector<soap_RangosSCV> RangosOperador;
	vector<soap_RangosSCV> RangosPrivilegiados;
	vector<soap_PlanRutas> ListaRutas;
};

/** */
class soap_ResourceInfo : public xml_data
{
public:
	soap_ResourceInfo(){}
	~soap_ResourceInfo(){}
public:
	void xread(xml_node<> * xnode) {
		read_key(xnode, "GananciaAGCTX", GananciaAGCTX);
		read_key(xnode, "GananciaAGCTXdBm", GananciaAGCTXdBm);
		read_key(xnode, "GananciaAGCRX", GananciaAGCRX);
		read_key(xnode, "GananciaAGCRXdBm", GananciaAGCRXdBm);
		read_key(xnode, "SupresionSilencio", SupresionSilencio);
		read_key(xnode, "TamRTP", TamRTP);
		read_key(xnode, "Codec", Codec);
		read_key(xnode, "GrabacionEd137", GrabacionEd137);
		read_key(xnode, "TipoDestino", TipoDestino);
		read_key(xnode, "IdDestino", IdDestino);
		read_key(xnode, "FrqTonoSQ", FrqTonoSQ);
		read_key(xnode, "UmbralTonoSQ", UmbralTonoSQ);
		read_key(xnode, "FrqTonoPTT", FrqTonoPTT);
		read_key(xnode, "UmbralTonoPTT", UmbralTonoPTT);

		/** Telefonia */
		read_key(xnode, "ListaEnlacesInternos", telef.ListaEnlacesInternos);
		read_key(xnode, "IdPrefijo", telef.IdPrefijo);

		read_key(xnode, "RefrescoEstados", telef.RefrescoEstados);
		read_key(xnode, "Timeout", telef.Timeout);
		read_key(xnode, "LongRafagas", telef.LongRafagas);

		read_key(xnode, "Lado", telef.Lado);
		read_key(xnode, "Modo", telef.Modo);
		read_key(xnode, "TipoEM", telef.TipoEM);
		read_key(xnode, "IdRed", telef.IdRed);
		read_key(xnode, "IdTroncal", telef.IdTroncal);

		/** Radio */
		read_key(xnode, "EM", radio.EM);
		read_key(xnode, "SQ", radio.SQ);
		read_key(xnode, "PTT", radio.PTT);
		read_key(xnode, "FrqTonoE", radio.FrqTonoE);

		read_key(xnode, "UmbralTonoE", radio.UmbralTonoE);
		read_key(xnode, "FrqTonoM", radio.FrqTonoM);
		read_key(xnode, "UmbralTonoM", radio.UmbralTonoM);
		read_key(xnode, "BSS", radio.BSS);

		read_key(xnode, "NTZ", radio.NTZ);
		read_key(xnode, "TipoNTZ", radio.TipoNTZ);
		read_key(xnode, "Cifrado", radio.Cifrado);
		read_key(xnode, "SupervPortadoraTx", radio.SupervPortadoraTx);

		read_key(xnode, "SupervModuladoraTx", radio.SupervModuladoraTx);
		read_key(xnode, "ModoConfPTT", radio.ModoConfPTT);
		read_key(xnode, "RepSQyBSS", radio.RepSQyBSS);
		read_key(xnode, "DesactivacionSQ", radio.DesactivacionSQ);

		read_key(xnode, "TimeoutPTT", radio.TimeoutPTT);
		read_key(xnode, "MetodoBSS", radio.MetodoBSS);
		read_key(xnode, "UmbralVAD", radio.UmbralVAD);
		read_key(xnode, "TiempoPTT", radio.TiempoPTT);

		read_key(xnode, "NumFlujosAudio", radio.NumFlujosAudio);
		read_key(xnode, "KeepAlivePeriod", radio.KeepAlivePeriod);
		read_key(xnode, "KeepAliveMultiplier", radio.KeepAliveMultiplier);
		read_key(xnode, "IdEmplazamiento", radio.IdEmplazamiento);
		read_key(xnode, "Tipo", radio.Tipo);
	}
public:
	/** Comunes */
	int GananciaAGCTX;
	int GananciaAGCTXdBm;
	int GananciaAGCRX;
	int GananciaAGCRXdBm;
	bool SupresionSilencio;
	int TamRTP;
	int Codec;
	bool GrabacionEd137;
	int TipoDestino;
	string IdDestino;
	int FrqTonoSQ;
	int UmbralTonoSQ;
	int FrqTonoPTT;
	int UmbralTonoPTT;
	struct {
		/** Telefonia */
		vector<string> ListaEnlacesInternos;
		int IdPrefijo;
		/** LC */
		int RefrescoEstados;
		int Timeout;
		int LongRafagas;
		/** BC/BL/AB */
		int Lado;
		string Modo;
		string TipoEM;
		/** AB */
		string IdRed;
		/** R2/N5 */
		string IdTroncal;
	} telef;
	struct {
		bool EM;
		string SQ;
		string PTT;
		int FrqTonoE;
		int UmbralTonoE;
		int FrqTonoM;
		int UmbralTonoM;
		bool BSS;
		bool NTZ;
		int TipoNTZ;
		bool Cifrado;
		bool SupervPortadoraTx;
		bool SupervModuladoraTx;
		int ModoConfPTT;
		int RepSQyBSS;
		int DesactivacionSQ;
		int TimeoutPTT;
		int MetodoBSS;
		int UmbralVAD;
		int TiempoPTT;
		int NumFlujosAudio;
		int KeepAlivePeriod;
		int KeepAliveMultiplier;
		string IdEmplazamiento;
		int Tipo;
	} radio;
};

/** */
class soap_RecursosSCV : public xml_data
{
public:
	soap_RecursosSCV(){}
	~soap_RecursosSCV(){}
public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "IdRecurso", IdRecurso);
		read_key(xnode, "Tipo", Tipo);
		read_key(xnode, "Interface", Interface);
		read_key(xnode, "SlotPasarela", SlotPasarela);
		read_key(xnode, "NumDispositivoSlot", NumDispositivoSlot);
		read_key(xnode, "ServidorSIP", ServidorSIP);
		read_key(xnode, "Diffserv", Diffserv);
		read_key(xnode, "IdSistema", IdSistema);
		read_key(xnode, "TipoRecurso", TipoRecurso);
		read_key(xnode, "IdTifX", IdTifX);

		xdata_ResourceInfo = remote_get_xdata_func("GetParametrosRecursoById",
			"idSistema=departamento", 
			"idRecurso="+IdRecurso, 
			"tipo=" + Tools::Int2String((int)Interface));

		read_key(xdata_ResourceInfo, "Tablas", info);
	}

public:
	string IdRecurso;
	int Tipo;
	TI_ Interface;
	int SlotPasarela;
	int NumDispositivoSlot;
	string ServidorSIP;
	bool Diffserv;
	string IdSistema;
	int TipoRecurso;
	string IdTifX;
	soap_ResourceInfo info;

protected:
	string xdata_ResourceInfo;
};

/** */
class soap_CfgPasarela : public xml_data
{
public:
	soap_CfgPasarela(){}
	~soap_CfgPasarela(){}
public:
	void xread(xml_node<> * xnode) {	
		read_key(xnode, "Nombre", Nombre);
		read_key(xnode, "NumRecursos", NumRecursos);
		read_key(xnode, "ModoSincronizacion", ModoSincronizacion);
		read_key(xnode, "MasterSincronizacion", MasterSincronizacion);
		read_key(xnode, "PuertoLocalSNMP", PuertoLocalSNMP);
		read_key(xnode, "PuertoRemotoSNMP", PuertoRemotoSNMP);
		read_key(xnode, "PuertoRemotoTrapsSNMP", PuertoRemotoTrapsSNMP);
		read_key(xnode, "PuertoLocalSIP", PuertoLocalSIP);
		read_key(xnode, "PeriodoSupervisionSIP", PeriodoSupervisionSIP);
		read_key(xnode, "ListaRecursos", "RecursosSCV", ListaRecursos);
	}

public:
	string Nombre;
	int NumRecursos;
	int ModoSincronizacion;
	string MasterSincronizacion;
	int PuertoLocalSNMP;
	int PuertoRemotoSNMP;
	int PuertoRemotoTrapsSNMP;
	int PuertoLocalSIP;
	int PeriodoSupervisionSIP;
	vector<soap_RecursosSCV> ListaRecursos;
};


/** */
class soap_config : public xml_data
{
public:
	soap_config(remoteGetXdataFunc remoteFunc, string ip, string hwName, string ipServer);
	~soap_config(void);

public:
	void xread(xml_node<> * xnode) {
		xml_document<> doc;

		IdConfig = xnode->value();
		read_key(xdata_ParametrosGeneralesSistema, "ParametrosGeneralesSistema", ParametrosGeneralesSistema);
		read_key(xdata_ParametrosMulticast, "ParametrosMulticast", ParametrosMulticast);

		//read_key(xdata_ArrayOfAsignacionRecursosGW, "ArrayOfAsignacionRecursosGW", "AsignacionRecursosGW", ArrayOfAsignacionRecursosGW);
		doc.parse<0>((char *)xdata_ArrayOfAsignacionRecursosGW.c_str());
		read_key(doc, "ArrayOfAsignacionRecursosGW", "AsignacionRecursosGW", ArrayOfAsignacionRecursosGW);
		//read_key(xdata_ArrayOfAsignacionUsuariosTV, "ArrayOfAsignacionUsuariosTV", "AsignacionUsuariosTV", ArrayOfAsignacionUsuariosTV);
		doc.parse<0>((char *)xdata_ArrayOfAsignacionUsuariosTV.c_str());
		read_key(doc, "ArrayOfAsignacionUsuariosTV", "AsignacionUsuariosTV", ArrayOfAsignacionUsuariosTV);
		//read_key(xdata_ArrayOfDireccionamientoIP, "ArrayOfDireccionamientoIP", "DireccionamientoIP", ArrayOfDireccionamientoIP);
		doc.parse<0>((char *)xdata_ArrayOfDireccionamientoIP.c_str());
		read_key(doc, "ArrayOfDireccionamientoIP", "DireccionamientoIP", ArrayOfDireccionamientoIP);
		//read_key(xdata_ArrayOfDireccionamientoSIP, "ArrayOfDireccionamientoSIP", "DireccionamientoSIP", ArrayOfDireccionamientoSIP);
		doc.parse<0>((char *)xdata_ArrayOfDireccionamientoSIP.c_str());
		read_key(doc, "ArrayOfDireccionamientoSIP", "DireccionamientoSIP", ArrayOfDireccionamientoSIP);
		//read_key(xdata_ArrayOfListaRedes, "ArrayOfListaRedes", "ListaRedes", ArrayOfListaRedes);
		doc.parse<0>((char *)xdata_ArrayOfListaRedes.c_str());
		read_key(doc, "ArrayOfListaRedes", "ListaRedes", ArrayOfListaRedes);
		//read_key(xdata_ArrayOfListaTroncales, "ArrayOfListaTroncales", "ListaTroncales", ArrayOfListaTroncales);
		doc.parse<0>((char *)xdata_ArrayOfListaTroncales.c_str());
		read_key(doc, "ArrayOfListaTroncales", "ListaTroncales", ArrayOfListaTroncales);
		//read_key(xdata_ArrayOfNumeracionATS, "ArrayOfNumeracionATS", "NumeracionATS", ArrayOfNumeracionATS);
		doc.parse<0>((char *)xdata_ArrayOfNumeracionATS.c_str());
		read_key(doc, "ArrayOfNumeracionATS", "NumeracionATS", ArrayOfNumeracionATS);

		read_key(xdata_CfgPasarela, "CfgPasarela", CfgPasarela);
	}

public:
	string IdConfig;
	soap_ParametrosGeneralesSistema ParametrosGeneralesSistema;
	soap_ParametrosMulticast ParametrosMulticast;
	vector<soap_AsignacionRecursosGW> ArrayOfAsignacionRecursosGW;
	vector<soap_AsignacionUsuariosTV> ArrayOfAsignacionUsuariosTV;
	vector<soap_DireccionamientoIP> ArrayOfDireccionamientoIP;
	vector<soap_DireccionamientoSIP> ArrayOfDireccionamientoSIP;
	vector<soap_ListaRedes> ArrayOfListaRedes;
	vector<soap_ListaTroncales> ArrayOfListaTroncales;
	vector<soap_NumeracionATS> ArrayOfNumeracionATS;
	soap_CfgPasarela CfgPasarela;

public:
	string Ip;
	string Server;

public:
	string xdata_idConfig;
	string xdata_ParametrosGeneralesSistema;
	string xdata_ParametrosMulticast;
	string xdata_ArrayOfAsignacionRecursosGW;
	string xdata_ArrayOfAsignacionUsuariosTV;
	string xdata_ArrayOfDireccionamientoIP;
	string xdata_ArrayOfDireccionamientoSIP;
	string xdata_ArrayOfListaRedes;
	string xdata_ArrayOfListaTroncales;
	string xdata_ArrayOfNumeracionATS;
	string xdata_CfgPasarela;

public:
	void sip_servers(vector<string> &sipservers);
	void firstRadioParams(int &kap, int &kam, int &sm);
	void TipoTelefonia(int stipo, int &jtipo);
};

#endif
