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
		tlan=0;
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
		read_key(base, "tlan", tlan);
		read_key(base, "ip0", ip0);
		read_key(base, "ms0", ms0);
		read_key(base, "ip1", ip1);
		read_key(base, "ms1", ms1);
		read_key(base, "ipb", ipb);
		read_key(base, "msb", msb);
		read_key(base, "ipg", ipg);
	}

public:
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
		name="defecto";
		emplazamiento="defecto";
		dualidad = 1;
		ipv = "127.0.0.1";
		ips = "127.0.0.1";
		nivelconsola = 0;
		puertoconsola = 0;
		nivelIncidencias = 0;
	}
	~CommGenConfig() {
		clear_array(cpus);
	}
public:
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
		write_key(writer, "cpus", cpus);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "name", name);
		read_key(base, "emplazamiento", emplazamiento);
		read_key(base,"dualidad", dualidad);
		read_key(base, "ipv", ipv);
		read_key(base, "ips", ips);
		read_key(base,"nivelconsola", nivelconsola);
		read_key(base,"puertoconsola", puertoconsola);
		read_key(base,"nivelIncidencias", nivelIncidencias);
		read_key(base, "cpus", cpus);
	}

public:
	string name;
	string emplazamiento;
	int dualidad;
	string ipv;
	string ips;
	int nivelconsola;
	int puertoconsola;
	int nivelIncidencias;
#if __POR_REFERENCIA__
	vector<CommGenCpu> cpus;
#else
	vector<CommGenCpu *> cpus;
#endif
};

#endif
