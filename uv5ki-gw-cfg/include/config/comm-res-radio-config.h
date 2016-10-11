#ifndef __COMM_RES_RADIO_CONFIG_H__
#define __COMM_RES_RADIO_CONFIG_H__

#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream#include <utility>
#include <queue>
#include <algorithm>

#include "../base/code-base.h"
#include "../websrv/uv5kigwcfg-web-app-data.h"
#include "../tools/tools.h"
#include "../config/local-config.h"

/** */
class CommResRadioEmplazamiento : public jData
{
public:
	CommResRadioEmplazamiento() {
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "activoTx", activoTx);
		write_key(writer, "activoRx", activoRx);
		write_key(writer, "uriTxA", uriTxA);
		write_key(writer, "uriTxB", uriTxB);
		write_key(writer, "uriRxA", uriRxA);
		write_key(writer, "uriRxB", uriRxB);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "activoTx", activoTx);
		read_key(base, "activoRx", activoRx);
		read_key(base, "uriTxA", uriTxA);
		read_key(base, "uriTxB", uriTxB);
		read_key(base, "uriRxA", uriRxA);
		read_key(base, "uriRxB", uriRxB);
	}
public:
	int activoTx;
	int activoRx;
	string uriTxA;
	string uriTxB;
	string uriRxA;
	string uriRxB;
};

/** */
class CommResRadioColateral : public jData
{
public:
	CommResRadioColateral() {
	}
	~CommResRadioColateral() {
		clear_array(emplazamientos);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "name", name);
		write_key(writer, "tipoConmutacion", tipoConmutacion);
		write_key(writer, "emplazamientos", emplazamientos);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "name", name);
		read_key(base, "tipoConmutacion", tipoConmutacion);
		read_key(base, "emplazamientos", emplazamientos);
	}
public:
	string name;
	int tipoConmutacion;
	vector<CommResRadioEmplazamiento *> emplazamientos;
};

/** */
class CommResRadio : public jData
{
public:
	CommResRadio() {
	}
	~CommResRadio() {
		//clear_array(cpus);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tipo", tipo);
		write_key(writer, "sq", sq);
		write_key(writer, "ptt", ptt);
		write_key(writer, "bss", bss);
		write_key(writer, "modoConfPtt", modoConfPtt);
		write_key(writer, "repSqBss", repSqBss);
		write_key(writer, "desactivacionSq", desactivacionSq);
		write_key(writer, "timeoutPtt", timeoutPtt);
		write_key(writer, "metodoBss", metodoBss);
		write_key(writer, "umbralVad", umbralVad);
		write_key(writer, "numFlujosAudio", numFlujosAudio);
		write_key(writer, "tiempoPtt", tiempoPtt);
		write_key(writer, "tmVentanaRx", tmVentanaRx);
		write_key(writer, "climaxDelay", climaxDelay);
		write_key(writer, "tmRetardoFijo", tmRetardoFijo);
		write_key(writer, "bssRtp", bssRtp);
		write_key(writer, "retrasoSqOff", retrasoSqOff);
		write_key(writer, "evtPTT", evtPTT);
		write_key(writer, "tjbd", tjbd);
		write_key(writer, "tGRSid", tGRSid);
		write_key(writer, "iEnableGI", iEnableGI);
		write_key(writer, "tabla_indices_calidad", tabla_indices_calidad);
		write_key(writer, "iSesionPrio", iSesionPrio);
		write_key(writer, "iPttPrio", iPttPrio);
		write_key(writer, "colateral", colateral);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "tipo", tipo);
		read_key(base, "sq", sq);
		read_key(base, "ptt", ptt);
		read_key(base, "bss", bss);
		read_key(base, "modoConfPtt", modoConfPtt);
		read_key(base, "repSqBss", repSqBss);
		read_key(base, "desactivacionSq", desactivacionSq);
		read_key(base, "timeoutPtt", timeoutPtt);
		read_key(base, "metodoBss", metodoBss);
		read_key(base, "umbralVad", umbralVad);
		read_key(base, "numFlujosAudio", numFlujosAudio);
		read_key(base, "tiempoPtt", tiempoPtt);
		read_key(base, "tmVentanaRx", tmVentanaRx);
		read_key(base, "climaxDelay", climaxDelay);
		read_key(base, "tmRetardoFijo", tmRetardoFijo);
		read_key(base, "bssRtp", bssRtp);
		read_key(base, "retrasoSqOff", retrasoSqOff);
		read_key(base, "evtPTT", evtPTT);
		read_key(base, "tjbd", tjbd);
		read_key(base, "tGRSid", tGRSid);
		read_key(base, "iEnableGI", iEnableGI);
		read_key(base,"tabla_indices_calidad", tabla_indices_calidad);
		read_key(base,"iSesionPrio", iSesionPrio);
		read_key(base,"iPttPrio", iPttPrio);
		read_key(base,"colateral", colateral);
	}

public:
	int tipo;
	int sq;
	int ptt;
	int bss;
	int modoConfPtt;
	int repSqBss;
	int desactivacionSq;
	int timeoutPtt;
	int metodoBss;
	int umbralVad;
	int numFlujosAudio;
	int tiempoPtt;
	int tmVentanaRx;
	int climaxDelay;
	int tmRetardoFijo;
	int bssRtp;
	int retrasoSqOff;
	int evtPTT;
	int tjbd;
	int tGRSid;
	int iEnableGI;
	vector<string> tabla_indices_calidad;
	int iSesionPrio;
	int iPttPrio;
	CommResRadioColateral colateral;
};

#endif
