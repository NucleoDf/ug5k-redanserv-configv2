#ifndef __COMM_RES_TELEF_CONFIG_H__
#define __COMM_RES_TELEF_CONFIG_H__

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
class CommResTelefAtsRange : public jData
{
public:
	CommResTelefAtsRange() {
		inicial = final = "";
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "inicial", inicial);
		write_key(writer, "final", final);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "inicial", inicial);
		read_key(base, "final", final);
	}
public:
	string inicial;
	string final;
};

/** */
class CommResTelef : public jData
{
public:
	CommResTelef() {
		tipo = 0;
		lado = 1;
		t_eym = 0;
		h2h4 = 0;
		ladoeym = 0;
		modo = 0;
		r_automatica = 1;
		no_test_local = no_test_remoto = "";
		it_release = 5;
		uri_remota = "";
		detect_vox = 0;
		umbral_vox = -10;
		tm_inactividad = 2;
		superv_options = 1;
		tm_superv_options = 2;
		colateral_scv = 0;
		iT_Int_Warning = 5;

	}
	~CommResTelef() {
		clear_array(ats_rangos_dst);
		clear_array(ats_rangos_org);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tipo", tipo);
		write_key(writer, "lado", lado);
		write_key(writer, "t_eym", t_eym);
		write_key(writer, "h2h4", h2h4);
		write_key(writer, "ladoeym", ladoeym);
		write_key(writer, "modo", modo);
		write_key(writer, "r_automatica", r_automatica);
		write_key(writer, "no_test_local", no_test_local);
		write_key(writer, "no_test_remoto", no_test_remoto);
		write_key(writer, "it_release", it_release);
		write_key(writer, "uri_remota", uri_remota);
		write_key(writer, "detect_vox", detect_vox);
		write_key(writer, "umbral_vox", umbral_vox);
		write_key(writer, "tm_inactividad", tm_inactividad);
		write_key(writer, "superv_options", superv_options);
		write_key(writer, "tm_superv_options", tm_superv_options);
		write_key(writer, "colateral_scv", colateral_scv);
		write_key(writer, "ats_rangos_dst", ats_rangos_dst);
		write_key(writer, "ats_rangos_org", ats_rangos_org);
		write_key(writer, "iT_Int_Warning", iT_Int_Warning);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "tipo", tipo);
		read_key(base, "lado", lado);
		read_key(base, "t_eym", t_eym);
		read_key(base, "h2h4", h2h4);
		read_key(base, "ladoeym", ladoeym);
		read_key(base, "modo", modo);
		read_key(base, "r_automatica", r_automatica);
		read_key(base, "no_test_local", no_test_local);
		read_key(base, "no_test_remoto", no_test_remoto);
		read_key(base, "it_release", it_release);
		read_key(base, "uri_remota", uri_remota);
		read_key(base, "detect_vox", detect_vox);
		read_key(base, "umbral_vox", umbral_vox);
		read_key(base, "tm_inactividad", tm_inactividad);
		read_key(base, "superv_options", superv_options);
		read_key(base, "tm_superv_options", tm_superv_options);
		read_key(base, "colateral_scv", colateral_scv);
		read_key(base, "ats_rangos_dst", ats_rangos_dst);
		read_key(base, "ats_rangos_org", ats_rangos_org);
		read_key(base, "iT_Int_Warning", iT_Int_Warning);
	}

public:
	int tipo;
	int lado;
	int t_eym;
	int h2h4;
	int ladoeym;
	int modo;
	int r_automatica;
	string no_test_local;
	string no_test_remoto;
	int it_release;
	string uri_remota;
	int detect_vox;
	int umbral_vox;
	int tm_inactividad;
	int superv_options;
	int tm_superv_options;
	int colateral_scv;
	int iT_Int_Warning;
#if __POR_REFERENCIA__
	vector<CommResTelefAtsRange &> ats_rangos_dst;
	vector<CommResTelefAtsRange &> ats_rangos_org;
#else
	vector<CommResTelefAtsRange *> ats_rangos_dst;
	vector<CommResTelefAtsRange *> ats_rangos_org;
#endif
};

#endif
