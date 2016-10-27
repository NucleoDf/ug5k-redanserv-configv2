#ifndef __COMM_HAR_CONFIG_H__
#define __COMM_HAR_CONFIG_H__

#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream#include <utility>
#include <queue>
#include <algorithm>

#include "../base/code-base.h"
#include "../base/thread.h"
#include "../base/socket.h"
#include "../base/sistema.h"
#include "../websrv/uv5kigwcfg-web-app-data.h"
#include "../tools/tools.h"
#include "../config/local-config.h"

#define _NUM_SLAVES_		4
#define _NUM_POS_			4

/** */
class CommHarConfigPos : public jData
{
public:
	CommHarConfigPos() {
		tp=0;
		cfg=0;
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tp", tp);
		write_key(writer, "cfg", cfg);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "tp", tp);
		read_key(base, "cfg", cfg);
	}
public:
	int cfg;
	int tp;
};

/** */
class CommHarConfigSlv : public jData
{
public:
	CommHarConfigSlv() {
		tp=0;
	}
	~CommHarConfigSlv() {
		clear_array(pos);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "tp", tp);
		write_key(writer, "pos", pos);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "tp", tp);
		read_key(base, "pos", pos);
	}
public:
	int tp;
#if __POR_REFERENCIA__
	vector<CommHarConfigPos> pos;
#else
	vector<CommHarConfigPos *> pos;
#endif
};

/** */
class CommHarConfig : public jData
{
public:
	CommHarConfig() {
	}
	CommHarConfig(soap_config &sc);
	~CommHarConfig() {
		clear_array(slv);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "slv", slv);
	}
	virtual void jread(Value &base)
	{
		read_key(base, "slv", slv);
	}

public:
#if __POR_REFERENCIA__
	vector<CommHarConfigSlv> slv;
#else
	vector<CommHarConfigSlv *> slv;
#endif
};

#endif
