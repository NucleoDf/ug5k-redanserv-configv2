#ifndef __COMM_CONFIG_H__
#define __COMM_CONFIG_H__

#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream#include <utility>
#include <queue>
#include <algorithm>

#define _NUM_HW_ITFS_		16

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


/** Estructura de CONFIGURACION. Se parte de REDAN */

class CommConfig : public jData
{
public:
	CommConfig() {
	}
	CommConfig(string jstring) {
		JDeserialize(jstring);
	}
	CommConfig(string path, string file) {
		string data,linea;
		ifstream f(path + "/" + file, ios_base::in);
		while (std::getline(f, linea))
			data += linea;
		JDeserialize(data);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "idConf", idConf);
		write_key(writer, "fechaHora", fechaHora);
		users.jwrite(writer);
		write_key(writer, "general", general);
	}
	virtual void jread(Value &base) {
		idConf = to_string(base, "idConf");
		fechaHora = to_string(base, "fechaHora");
		users.jread(base);
		to_obj(base, "general", general);
	}
protected:
	string idConf;
	string fechaHora;
	UsersConfig users;
	CommGenConfig general;
};

#endif
