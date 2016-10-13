#ifndef __COMM_CONFIG_H__
#define __COMM_CONFIG_H__

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
#include "../versiones.h"

#include "./users-config.h"
#include "./comm-gen-config.h"
#include "./comm-ser-config.h"
#include "./comm-har-config.h"
#include "./comm-res-config.h"


/** Estructura de CONFIGURACION. Se parte de REDAN */

class CommConfig : public jData
{
public:
	CommConfig() {
	}
	CommConfig(string jstring) {
		JDeserialize(jstring);
	}
	CommConfig(ifstream f) {
		string data,linea;
		while (std::getline(f, linea))
			data += linea;
		JDeserialize(data);
	}
	~CommConfig() {
		clear_array(users);
		clear_array(recursos);
	}
public:
	bool operator == ( CommConfig &otra) {
		return (idConf == otra.idConf && fechaHora == otra.fechaHora) ? true : false;
	}
	bool operator < (  CommConfig &otra) {
		struct tm time_l,time_o;
		time_t loctime,othtime;

		Tools::DateString2time(fechaHora, time_l);
		Tools::DateString2time(otra.fechaHora, time_o);

		loctime = mktime(&time_l);
		othtime = mktime(&time_o);

		return loctime < othtime;	
	}

public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idConf", idConf);
		write_key(writer, "fechaHora", fechaHora);
		write_key(writer, "general", general);
		write_key(writer, "hardware", hardware);
		write_key(writer, "recursos", recursos);
		write_key(writer, "users", users);
		write_key(writer, "servicios", servicios);
	}
	virtual void jread(Value &base) {
		read_key(base, "idConf", idConf);
		read_key(base, "fechaHora", fechaHora);
		read_key(base, "users", users);
		read_key(base, "general", general);
		read_key(base, "servicios", servicios);
		read_key(base, "hardware", hardware);
		read_key(base, "recursos", recursos);
	}
public:
	string idConf;
	string fechaHora;
	vector<UserData *> users;
	CommGenConfig general;
	CommSerConfig servicios;
	CommHarConfig hardware;
	vector<CommResConfig *> recursos;
};

#endif
