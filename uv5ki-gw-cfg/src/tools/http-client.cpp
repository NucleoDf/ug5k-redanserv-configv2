#include "../../include/tools/http-client.h"


/** */
void HttpClient::ParseHost(string host, string &ip, int &port)
{
	vector<string> partes;
	Tools::split(partes, host, ':');
	if (partes.size() == 1) {
		ip = host;
		port = 80;
	} else {
		ip = partes[0];
		port = atoi(partes[1].c_str());
	}
}

/** */
ParseResponse HttpClient::SendHttpCmd(string cmd, int ms_timeout)
{
	string ip;
	int port;
	ParseHost(server, ip, port);
	CIPAddress host(ip, port);
	CTCPSocket sck;

	try 
	{
		if (!sck.Connect(host, conn_timeout))
			throw Exception("No puedo conectarme al HOST: " + server);
		if (sck.Send(cmd.c_str(), cmd.length()) != (int) cmd.length())
			throw Exception("Error al Enviar request: " + cmd);

		string respuesta;
		sck.Recv_text(respuesta, ms_timeout, char_timeout);

		sck.Close();
		return ParseResponse(respuesta.c_str());

	} 
	catch (socket_error e) 
	{
		// throw Exception(e);
		throw Exception("Error al Conectarme al HOST " + server + ": " + e.Message(), e.Code());
	}
}

/** */
ParseResponse HttpClient::SendHttpCmd(string metodo, string cmd, int ms_timeout, string jdata)
{
	string request = metodo + "/" + cmd + " HTTP/1.1\r\nHost: " + server + "\r\nContent-Type: application/json\r\n" + jdata + "\r\n";
	return SendHttpCmd(request, ms_timeout);
}
