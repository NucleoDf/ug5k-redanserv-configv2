#ifndef __COMM_UV5_CONFIG_H__
#define __COMM_UV5_CONFIG_H__

#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream#include <utility>
#include <queue>
#include <algorithm>

#include "../base/code-base.h"
#include "../websrv/uv5kigwcfg-web-app-data.h"
#include "../tools/tools.h"
#include "../config/local-config.h"
#include "./cfgpasa.hpp"

/** */
class CommUlises_st_no_abonado  : public jData
{
public:
	CommUlises_st_no_abonado(){
	}
	CommUlises_st_no_abonado(soap_DireccionamientoSIP::soap_StrNumeroAbonado abo) {
		prefijo = atoi(abo.Prefijo.c_str());
		abonado = abo.NumeroAbonado;
	}
	~CommUlises_st_no_abonado(){}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "prefijo", prefijo);
		write_key(writer, "abonado", abonado);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "prefijo", prefijo);
		read_key(base, "abonado", abonado);
	}

public:
	void copyto(st_no_abonado *ab){
		strncpy(ab->abonado, abonado.c_str(), LONG_AB);
		ab->prefijo = (unsigned int)prefijo;
	}

public:
    int prefijo;
    string abonado;
};

/** */
class CommUlises_st_rango  : public jData
{
public:
	CommUlises_st_rango(){
	}
	CommUlises_st_rango(soap_NumeracionATS::soap_RangosSCV sRango) {
		inicial = sRango.Inicial;
		final = sRango.Final;
		abonado.abonado = sRango.IdAbonado;
		abonado.prefijo = atoi(sRango.IdPrefijo.c_str());

		//TODO: �Que se hace con estos campos?
		//sRango.IdSistema;
		//sRango.Central;
		//sRango.Tipo;
	}
	~CommUlises_st_rango(){}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "inicial", inicial);
		write_key(writer, "final", final);
		write_key(writer, "abonado", abonado);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "inicial", inicial);
		read_key(base, "final", final);
		read_key(base, "abonado", abonado);
	}
public:
	void copyto(st_rango *pr) {
		strncpy(pr->inicial, inicial.c_str(), LONG_AB_ATS);
		strncpy(pr->final, final.c_str(), LONG_AB_ATS);
		abonado.copyto(&pr->abonado);
	}
public:
	string inicial;
	string final;
	CommUlises_st_no_abonado abonado;
};

/** */
class CommUlises_st_planrutas  : public jData
{
public:
	CommUlises_st_planrutas(){
	}
	CommUlises_st_planrutas(soap_NumeracionATS::soap_PlanRutas sRuta){
		tiporuta = atoi(sRuta.TipoRuta.c_str());		// TODO: Convertir los tipos de Ruta.... 
		listatroncales = sRuta.ListaTroncales;
	}
	~CommUlises_st_planrutas(){}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tiporuta", tiporuta);
		write_key(writer, "listatroncales", listatroncales);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "tiporuta", tiporuta);
		read_key(base, "listatroncales", listatroncales);
	}
public:
	void copyto(st_planrutas *pr) {
		pr->tiporuta = (unsigned char )tiporuta;
		for (size_t i=0; i<listatroncales.size(); i++) {
			if (i < N_TRONCALES_RUTA) {
				strncpy(pr->listatroncales[i], listatroncales[i].c_str(), CFG_MAX_LONG_NOMBRE);
			}
		}
	}
public:
    int tiporuta; 
    vector<string> listatroncales;
};

/** */
class CommUlises_st_numeracionats  : public jData
{
public:
	CommUlises_st_numeracionats() {
	}
	CommUlises_st_numeracionats(soap_NumeracionATS sPlanAts);
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "centralpropia", centralpropia);
		write_key(writer, "throwswitching", throwswitching);
		write_key(writer, "no_test", no_test);
		write_key(writer, "rangosoperador", rangosoperador);
		write_key(writer, "rangosprivilegiados", rangosprivilegiados);
		write_key(writer, "listarutas", listarutas);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "centralpropia", centralpropia);
		read_key(base, "throwswitching", throwswitching);
		read_key(base, "no_test", no_test);
		read_key(base, "rangosoperador", rangosoperador);
		read_key(base, "rangosprivilegiados", rangosprivilegiados);
		read_key(base, "listarutas", listarutas);
	}
public:
	void copyto(st_numeracionats *pa) {
		size_t r;

		pa->centralpropia = (unsigned char )centralpropia;
		pa->throwswitching = (unsigned char )throwswitching;
		strncpy(pa->no_test, no_test.c_str(), LONG_AB_ATS);
		for (r=0; r<rangosoperador.size(); r++) {
			if (r<N_MAX_RANGOS) {
				rangosoperador[r].copyto(&pa->rangosoperador[r]);
			}
		}
		for (r=0; r<rangosprivilegiados.size(); r++) {
			if (r<N_MAX_PRIV) {
				rangosprivilegiados[r].copyto(&pa->rangosprivilegiados[r]);
			}
		}
		for (r=0; r<listarutas.size(); r++) {
			if (r<N_MAX_RUTAS) {
				listarutas[r].copyto(&pa->listarutas[r]);
			}
		}
	}
public:
	int centralpropia;
	int throwswitching;
	string no_test;
	vector<CommUlises_st_rango> rangosoperador;
	vector<CommUlises_st_rango> rangosprivilegiados;
	vector<CommUlises_st_planrutas> listarutas;
};

/** */
class CommUlises_st_direccionamientoip  : public jData
{
public:
	CommUlises_st_direccionamientoip() {
	}
	CommUlises_st_direccionamientoip(soap_DireccionamientoIP sDir) {
		idhost = sDir.IdHost;
		ipred1 = sDir.IpRed1;
		ipred2 = sDir.IpRed2;
		tipohost = atoi(sDir.TipoHost.c_str());		// TODO: Transformar el Tipo de HOST

		// TODO: �que se hace con estos parametros del SOAP?
		//bool Interno;
		//int Min;
		//int Max;
	}
	~CommUlises_st_direccionamientoip() {
	}

public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idhost", idhost);
		write_key(writer, "ipred1", ipred1);
		write_key(writer, "ipred2", ipred2);
		write_key(writer, "tipohost", tipohost);
	}
	virtual void jread(Value &base) {
		read_key(base, "idhost", idhost);
		read_key(base, "ipred1", ipred1);
		read_key(base, "ipred2", ipred2);
		read_key(base, "tipohost", tipohost);
	}
public:
	void copyto(st_direccionamientoip *dip) {
		strncpy(dip->idhost, idhost.c_str(), CFG_MAX_LONG_NOMBRE);
		strncpy(dip->ipred1, ipred1.c_str(), MAX_LONG_DIRIP);
		strncpy(dip->ipred2, ipred2.c_str(), MAX_LONG_DIRIP);
		dip->tipohost = (unsigned char)tipohost;
	}

public:
    string idhost;
    string ipred1;
    string ipred2;
	int tipohost;

};

/** */
class CommUlises_st_plan_recursos : public jData
{
public:
	CommUlises_st_plan_recursos() {
	}
	CommUlises_st_plan_recursos(soap_ListaTroncales::soap_PlanRecursos sRec) {
		tipo = atoi(sRec.Tipo.c_str());	// TODO: Convertir el tipo....
		idrec = sRec.IdRecurso;
	}
	CommUlises_st_plan_recursos(soap_ListaRedes::soap_PlanRecursos sRec) {
		tipo = atoi(sRec.Tipo.c_str());	// TODO: Convertir el tipo....
		idrec = sRec.IdRecurso;
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "tipo", tipo);
		write_key(writer, "idrec", idrec);
	}
	virtual void jread(Value &base) {
		read_key(base, "tipo", tipo);
		read_key(base, "idrec", idrec);
	}
public:
	void copyto(st_plan_recursos *prec) {
		prec->tipo = (unsigned char )tipo;
		strncpy((char *)prec->idrec, idrec.c_str(), CFG_MAX_LONG_NOMBRE);
	}

public:
    int tipo;
    string idrec;
};


/** */
class CommUlises_st_listatroncales  : public jData
{
public:
	CommUlises_st_listatroncales() {
	}
	CommUlises_st_listatroncales(soap_ListaTroncales sTronc) {
		idtroncal = sTronc.IdTroncal;
		no_test = sTronc.NumeroTest;
		for (size_t iRec=0; iRec<sTronc.ListaRecursos.size(); iRec++) {
			listarecursos.push_back(CommUlises_st_plan_recursos(sTronc.ListaRecursos[iRec]));
		}
	}

public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idtroncal", idtroncal);
		write_key(writer, "no_test", no_test);
		write_key(writer, "listarecursos", listarecursos);
	}
	virtual void jread(Value &base) {
		read_key(base, "idtroncal", idtroncal);
		read_key(base, "no_test", no_test);
		read_key(base, "listarecursos", listarecursos);
	}
public:
	void copyto(st_listatroncales *pt) {
		strncpy(pt->idtroncal, idtroncal.c_str(), CFG_MAX_LONG_NOMBRE);
		strncpy(pt->no_test, no_test.c_str(), LONG_AB_ATS);
		for (size_t rec=0; rec<listarecursos.size(); rec++) {
			if (rec < N_MAX_REC_BY_TRONCAL) {
				listarecursos[rec].copyto(&pt->listarecursos[rec]);
			}
		}
	}

public:
    string idtroncal;
	string no_test;
	vector<CommUlises_st_plan_recursos> listarecursos;
};

/** */
class CommUlises_st_listaredes  : public jData
{
public:
	CommUlises_st_listaredes() {
	}
	CommUlises_st_listaredes(soap_ListaRedes sRed) {
		idred = sRed.IdRed;
		prefijo = atoi(sRed.Prefijo.c_str());
		for (size_t iRec=0; iRec<sRed.ListaRecursos.size(); iRec++) {
			listarecursos.push_back(CommUlises_st_plan_recursos(sRed.ListaRecursos[iRec]));
		}
	}

public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idred", idred);
		write_key(writer, "prefijo", prefijo);
		write_key(writer, "listarecursos", listarecursos);
	}
	virtual void jread(Value &base) {
		read_key(base, "idred", idred);
		read_key(base, "prefijo", prefijo);
		read_key(base, "listarecursos", listarecursos);
	}
public:
	void copyto(st_listaredes *pRed) {
		strncpy(pRed->idred, idred.c_str(), CFG_MAX_LONG_NOMBRE);
		pRed->prefijo = (unsigned int)prefijo;
		for (size_t irec=0; irec<listarecursos.size(); irec++) {
			if (irec < N_MAX_REC_BY_NET) {
				listarecursos[irec].copyto(&pRed->listarecursos[irec]);
			}
		}
	}

public:
    string idred;
    int prefijo;
	vector<CommUlises_st_plan_recursos> listarecursos;
};

///** */
class CommUlises_st_asignacionusuario_tv  : public jData
{
public:
	CommUlises_st_asignacionusuario_tv() {
	}
	CommUlises_st_asignacionusuario_tv(soap_AsignacionUsuariosTV usu) {
		idusuario = usu.IdUsuario;
		idhost = usu.IdHost;
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idusuario", idusuario);
		write_key(writer, "idhost", idhost);
	}
	virtual void jread(Value &base) {
		read_key(base, "idusuario", idusuario);
		read_key(base, "idhost", idhost);
	}
public:
	void copyto(st_asignacionusuario_tv *p_tv) {
		strncpy(p_tv->idhost, idhost.c_str(), CFG_MAX_LONG_NOMBRE);
		strncpy(p_tv->idusuario, idusuario.c_str(), CFG_MAX_LONG_NOMBRE);
	}

public:
    string idusuario;
    string idhost;
};

///** */
class CommUlises_st_asignacionusuario_gw  : public jData
{
public:
	CommUlises_st_asignacionusuario_gw() {
	}
	CommUlises_st_asignacionusuario_gw(soap_AsignacionRecursosGW gw) {
		idrecurso = gw.IdRecurso;
		idhost = gw.IdHost;
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idrecurso", idrecurso);
		write_key(writer, "idhost", idhost);
	}
	virtual void jread(Value &base) {
		read_key(base, "idrecurso", idrecurso);
		read_key(base, "idhost", idhost);
	}
public:
	void copyto(st_asignacionrecursos_gw *p_gw) {
		strncpy(p_gw->idhost, idhost.c_str(), CFG_MAX_LONG_NOMBRE);
		strncpy(p_gw->idrecurso, idrecurso.c_str(), CFG_MAX_LONG_NOMBRE);
	}

public:
    string idrecurso;
    string idhost;
};

///** */
class CommUlises_st_direccionamiento_sip  : public jData
{
public:
	CommUlises_st_direccionamiento_sip() {
	}
	CommUlises_st_direccionamiento_sip(soap_DireccionamientoSIP dsip) {
		idusuario = dsip.IdUsuario;
		for (size_t iAbo=0; iAbo<dsip.NumerosAbonadoQueAtiende.size(); iAbo++)
		{
			array_abonados.push_back(CommUlises_st_no_abonado(dsip.NumerosAbonadoQueAtiende[iAbo]));
		}
	}
	~CommUlises_st_direccionamiento_sip() {
	}

public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idusuario", idusuario);
		write_key(writer, "array_abonados", array_abonados);
	}
	virtual void jread(Value &base) {
		read_key(base, "idusuario", idusuario);
		read_key(base, "array_abonados", array_abonados);
	}

public:
	void copyto(st_direccionamiento_sip *pDest) {
		strncpy(pDest->idusuario, idusuario.c_str(), CFG_MAX_LONG_NOMBRE);
		for (size_t usu=0; usu<array_abonados.size(); usu++) {
			if (usu < N_ABONADOS_BY_TV) {
				array_abonados[usu].copyto(&pDest->array_abonados[usu]);
			}
		}
	}

public:
    string idusuario;
	vector<CommUlises_st_no_abonado> array_abonados;
};

/** */
class CommUv5Config : public jData
{
public:
	CommUv5Config() {
		MulticastGroup = "224.100.10.1";
		MulticastPort = 1000;
	}
	CommUv5Config(soap_config &sc);
	~CommUv5Config() {
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)	{
		write_key(writer, "MulticastGroup", MulticastGroup);
		write_key(writer, "MulticastPort", MulticastPort);
		write_key(writer, "plannumeracionats", plannumeracionats);
		write_key(writer, "plandireccionamientoip", plandireccionamientoip);
		write_key(writer, "plantroncales", plantroncales);
		write_key(writer, "planredes", planredes);
		write_key(writer, "planasignacionusuarios", planasignacionusuarios);
		write_key(writer, "planasignacionrecursos", planasignacionrecursos);
		write_key(writer, "plandireccionamientosip", plandireccionamientosip);
	}
	virtual void jread(Value &base)	{
		read_key(base, "MulticastGroup", MulticastGroup);
		read_key(base, "MulticastPort", MulticastPort);
		read_key(base, "plannumeracionats", plannumeracionats);
		read_key(base, "plandireccionamientoip", plandireccionamientoip);
		read_key(base, "plantroncales", plantroncales);
		read_key(base, "planredes", planredes);
		read_key(base, "planasignacionusuarios", planasignacionusuarios);
		read_key(base, "planasignacionrecursos", planasignacionrecursos);
		read_key(base, "plandireccionamientosip", plandireccionamientosip);
	}

public:
	string MulticastGroup;
	int MulticastPort;

	vector<CommUlises_st_numeracionats> plannumeracionats;
	vector<CommUlises_st_direccionamientoip> plandireccionamientoip;
	vector<CommUlises_st_listatroncales> plantroncales;
	vector<CommUlises_st_listaredes> planredes;
	vector<CommUlises_st_asignacionusuario_tv> planasignacionusuarios;
	vector<CommUlises_st_asignacionusuario_gw> planasignacionrecursos;
	vector<CommUlises_st_direccionamiento_sip> plandireccionamientosip ;
};

#endif
