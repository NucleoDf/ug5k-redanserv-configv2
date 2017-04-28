#ifndef _HTTP_CLIENT_
#define _HTTP_CLIENT_
#include <string>
#include <stdio.h>
#include "../base/code-base.h"
#include "../base/thread.h"
#include "../base/socket.h"
#include "../config/local-config.h"
#include "./tools.h"
#include "./parse.h"

using namespace std;

/** */
class HttpClient : public CodeBase
{
public:
	HttpClient(string host="localhost") {
		server = host;
		char_timeout = LocalConfig::p_cfg->getint(strRuntime, strRuntimeItemHttpCharTimeout, "100");
		conn_timeout = LocalConfig::p_cfg->getint(strRuntime, strRuntimeItemTcpConnTimeout, "60");
	}
	~HttpClient(void){}

public:
	ParseResponse SendHttpCmd(string cmd, int ms_timeout);
	ParseResponse SendHttpCmd(string metodo, string cmd, int ms_timeout, string jdata="");

public:
	static void ParseHost(string host, string &ip, int &port);

private:
	string server;
	int char_timeout;
	int conn_timeout;
};

#endif
