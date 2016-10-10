#ifndef __COMM_GEN_CONFIG_H__
#define __COMM_GEN_CONFIG_H__

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
class CommGenCpu : public jData
{
public:
	CommGenCpu() {
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tlan", tlan);
		write_key(writer, "ip0", ip0);
		write_key(writer, "ms0", ms0);
		write_key(writer, "ip1", ip1);
		write_key(writer, "ms1", ms1);
		write_key(writer, "ipb", ipb);
		write_key(writer, "msb", msb);
		write_key(writer, "ipg", ipg);
	}
	virtual void jread(Value &base)
	{
		tlan = to_int(base, "tlan");
		ip0 = to_string(base, "ip0");
		ms0 = to_string(base, "ms0");
		ip1 = to_string(base, "ip1");
		ms1 = to_string(base, "ms1");
		ipb = to_string(base, "ipb");
		msb = to_string(base, "msb");
		ipg = to_string(base, "ipg");
	}

protected:
	int tlan;
	string ip0;
	string ip1;
	string ipb;
	string ms0;
	string ms1;
	string msb;
	string ipg;
};

/** */
class CommGenConfig : public jData
{
public:
	CommGenConfig() {
	}
	~CommGenConfig() {
		clear_array(cpus);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "name", name);
		write_key(writer, "emplazamiento", emplazamiento);
		write_key(writer, "dualidad", dualidad);
		write_key(writer, "ipv", ipv);
		write_key(writer, "ips", ips);
		write_key(writer, "nivelconsola", nivelconsola);
		write_key(writer, "puertoconsola", puertoconsola);
		write_key(writer, "nivelIncidencias", nivelIncidencias);
		write_array(writer, "cpus", cpus);
	}
	virtual void jread(Value &base)
	{
		name = to_string(base, "name");
		emplazamiento = to_string(base, "emplazamiento");
		ipv = to_string(base, "ipv");
		ips = to_string(base, "ips");
		dualidad = to_int(base,"dualidad");
		nivelconsola = to_int(base,"nivelconsola");
		puertoconsola = to_int(base,"puertoconsola");
		nivelIncidencias = to_int(base,"nivelIncidencias");
		to_array(base, "cpus", cpus);
	}

protected:
	string name;
	string emplazamiento;
	int dualidad;
	string ipv;
	string ips;
	int nivelconsola;
	int puertoconsola;
	int nivelIncidencias;
	vector<CommGenCpu *> cpus;
};

#endif
