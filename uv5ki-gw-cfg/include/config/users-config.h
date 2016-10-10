#ifndef __USERS_CONFIG_H__
#define __USERS_CONFIG_H__

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
#include "../versiones.h"
#include "../config/local-config.h"

/** */
class UserData : public jData
{
public:
	UserData() {
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key(writer, "name", name);
		write_key(writer, "clave", clave);
		write_key(writer, "perfil", perfil);
	}
	virtual void jread(Value &base)
	{
		perfil = to_int(base, "perfil");
		clave = to_string(base, "clave");
		name = to_string(base, "name");
	}

protected:
	string name;
	string clave;
	int perfil;
};

/** */
class UsersConfig : public jData
{
public:
	UsersConfig() {
	}
	~UsersConfig() {
		clear_array(users);
	}
public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_array(writer, "users", users);
	}
	virtual void jread(Value &base)
	{
		to_array(base, "users", users);
	}

protected:
	vector<UserData *> users;
};

#endif
