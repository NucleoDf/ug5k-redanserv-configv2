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
ParseResponse HttpClient::SendHttpCmd(string cmd)
{
	string ip;
	int port;
	ParseHost(server, ip, port);
	CIPAddress host(ip, port);
	CTCPSocket sck;

	try 
	{
		if (!sck.Connect(host))
			throw Exception("No puedo conectarme al HOST: " + server);
		if (sck.Send(cmd.c_str(), cmd.length()) != (int) cmd.length())
			throw Exception("Error al Enviar request: " + cmd);

		string respuesta;
		sck.Recv_text(respuesta, 5000);

		sck.Close();
		return ParseResponse(respuesta.c_str());

	} 
	catch (socket_error e) 
	{
		throw Exception(e);
	}
}

/** */
ParseResponse HttpClient::SendHttpCmd(string metodo, string cmd, string jdata)
{
	string request = metodo + "/" + cmd + " HTTP/1.1\r\nHost: " + server + "\r\nContent-Type: application/json\r\n" + jdata + "\r\n";
	return SendHttpCmd(request);
}
