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
	}
	~HttpClient(void){}

public:
	ParseResponse SendHttpCmd(string cmd);
	ParseResponse SendHttpCmd(string metodo, string cmd, string jdata="");

public:
	static void ParseHost(string host, string &ip, int &port);

private:
	string server;
};

#endif
