//#include "ftp-client.h"
//#include "local-config.h"
//#include "Thread.h"
//#include "Utilidades.h"
//#include "NLOG.h"
#include "../../include/tools/ftp-client.h"

//#define MIBUFSIZE			(1024*16)
//#define SEND_KSEG_TIMEOUT	(LocalConfig::cfg.FtpSendTimeout())
//#define DBG_VERBOSE
#define SCK_RECV_TIMEOUT	(LocalConfig::cfg.FtpGenTimeout())

/** */
FtpClient::FtpClient(string host, string user, string pwd, int port) 
{
    server = host;
    this->port = port;
    username = user;
    password = pwd;
    loggedin = false;

    pCtrl_Sck = pData_Sck = NULL;
}

/** */
FtpClient::~FtpClient(void) 
{
    cleanup();
}

/***
 * Procedimientos Internos.
 **/
/** */
int FtpClient::readResponse(string &data) 
{
    int resultcode;
    string linea;
    data = "";
    do 
	{
        readLine(linea);
        if (linea.length() <= 3)
            throw FtpClientException(string("Error. Linea de Respuesta demasiado corta: "), linea);
        // Formato Linea. CCC-texto -> hay mas lineas.
        //				  CCC texto -> Linea final con el resultado global de la aplicacion...
        if (linea.at(3) == ' ') 
		{
            resultcode = atoi(linea.substr(0, 3).c_str());
            data = linea.substr(4);
            return resultcode;
        }
    } while (1);
}

/** */
void FtpClient::readLine(string &line) 
{
    //char leido;
    //int leidos;

    if (pCtrl_Sck == NULL)
        throw FtpClientException(string("Error. El Socket de control no esta inicializado..."));

    line = "";
	pCtrl_Sck->Recv_text(line, SCK_RECV_TIMEOUT);

    //pCtrl_Sck->SetRecvTimeout(SCK_RECV_TIMEOUT);
    //do {
    //    leidos = pCtrl_Sck->Recv(&leido, 1);
    //    if (leidos > 0) {
		  //  pCtrl_Sck->SetRecvTimeout(1);
    //        line.push_back((char) leido);
    //        if (leido == '\n')
    //            break;
    //    }
    //} while (leidos > 0);

	PLOG_DEBUG("FTP-READ : %s", line.c_str());
}

/** */
bool FtpClient::sendCommand(string cmd, int &rcode, string &response) 
{
    if (pCtrl_Sck == NULL) // Control de Errores por Excepcion...
        throw FtpClientException(string("Error. El Socket de control no esta inicializado..."));

	PLOG_DEBUG("FTP-WRITE: %s", cmd.c_str());

    cmd += string("\r\n");
    pCtrl_Sck->Send(cmd.c_str(), cmd.length());
    rcode = readResponse(response);
    return rcode == 0 ? false : true;
}

/** */
bool FtpClient::createDataSocket() 
{
    if (pCtrl_Sck == NULL) // Control de Errores por Excepcion...
        throw FtpClientException(string("Error. El Socket de control no esta inicializado..."));

    int on = 1;
    CIPAddress ctrl_local = pCtrl_Sck->GetLocalAddress();
    sockaddr_in *ctrl_local_in = (sockaddr_in *) ctrl_local;
    ctrl_local_in->sin_port = 0;

    if (pData_Sck == NULL) 
	{
        pData_Sck = new CTCPServerSocket();
        pData_Sck->SetSockOpt(SOL_SOCKET, SO_REUSEADDR, &on, sizeof (on));
        pData_Sck->SetRecvTimeout(SCK_RECV_TIMEOUT);
        pData_Sck->Bind(CIPAddress(ctrl_local_in));
        pData_Sck->Listen(1);
    }

    // Mando el comando PORT....
    char cmd[64];
    int data_port = pData_Sck->GetLocalAddress().GetPort();
#ifdef _WIN32	
    sprintf_s(cmd, "PORT %d,%d,%d,%d,%d,%d", ctrl_local_in->sin_addr.S_un.S_un_b.s_b1,
            ctrl_local_in->sin_addr.S_un.S_un_b.s_b2,
            ctrl_local_in->sin_addr.S_un.S_un_b.s_b3,
            ctrl_local_in->sin_addr.S_un.S_un_b.s_b4,
            data_port / 256, data_port % 256);
#else
    sprintf(cmd, "PORT %d,%d,%d,%d,%d,%d",
            ((unsigned char *) &ctrl_local_in->sin_addr.s_addr)[0],
            ((unsigned char *) &ctrl_local_in->sin_addr.s_addr)[1],
            ((unsigned char *) &ctrl_local_in->sin_addr.s_addr)[2],
            ((unsigned char *) &ctrl_local_in->sin_addr.s_addr)[3],
            data_port / 256, data_port % 256);

#endif

    int retcode;
    string response;
    if (!sendCommand(string(cmd), retcode, response)) // Control de Errores por Excepcion...
        throw FtpClientException(string("Error. Enviando Comando PORT: "), response);

    return true;
}

/** */
void FtpClient::cleanup() 
{
    if (pCtrl_Sck != NULL) 
	{
		delete pCtrl_Sck;
    }
    if (pData_Sck != NULL) 
	{
        delete pData_Sck;
    }

    loggedin = false;
    pCtrl_Sck = pData_Sck = NULL;
}

/** */
void FtpClient::sendFile(string filename) 
{
	PLOG_DEBUG("FTP-SEND : %s", filename.c_str());

	ifstream file(filename.c_str());
	if (file.good())
	{
		char Byte;

	    CTCPSocket sck;
		pData_Sck->Accept(sck, 1);
		while (file.get(Byte))
		{
			if (sck.IsWritable(100)==false)
				throw FtpClientException("No se puede escribir el fichero remoto","");
			sck.Write(&Byte, 1);
		} 

	    sck.Close();
		PLOG_DEBUG("FTP-SENT : %s", filename.c_str());
		///** TODO... Timeout de espera segun el tamaño del fichero. 1 SEG por 6K. */
		//int nseg = (tlen/SEND_KSEG_TIMEOUT) +  1;
		//CThread::sleep(1000*nseg);
		//PLOG_DEBUG("FTP-END : %s", filename.c_str());
		return;
	}
   throw FtpClientException(string("Error. No se puede abrir el fichero local: "), filename);

 //   char buf[MIBUFSIZE];
 //   int len, rlen,tlen=0;
	//    CTCPSocket sck;

 //   FILE *src = fopen(filename.c_str(), "rb");
 //   if (src == NULL)
 //       throw FtpClientException(string("Error. No se puede abrir el fichero local: "), filename);

 //   pData_Sck->Accept(sck, 1);
 //   while ((rlen = fread(buf, 1, MIBUFSIZE, src)) > 0) {
 //       if (rlen > 0) {
 //           len = sck.Send(buf, rlen);
 //           if (len < 0) {
	//	        throw FtpClientException(string("Error enviando bloque de datos. "), filename);
 //           }
	//		tlen += len;
 //       }
 //   }
	//fclose(src);
 //   sck.Close();

	//PLOG_DEBUG("FTP-SENT : %s", filename.c_str());
	///** TODO... Timeout de espera segun el tamaño del fichero. 1 SEG por 6K. */
 //   int nseg = (tlen/SEND_KSEG_TIMEOUT) +  1;
	//CThread::sleep(1000*nseg);
	//PLOG_DEBUG("FTP-END : %s", filename.c_str());
}

/***
 * Procedimientos Publicos.
 **/
/** */
void FtpClient::Login() 
{
    if (pCtrl_Sck != NULL || loggedin)
        throw FtpClientException(string("Error. Cliente ya conectado..."));

    try 
	{
        CIPAddress remote(server, port);
        pCtrl_Sck = new CTCPSocket();
        pCtrl_Sck->SetRecvTimeout(SCK_RECV_TIMEOUT);
        if (!pCtrl_Sck->Connect(remote,SCK_RECV_TIMEOUT))
            throw FtpClientException(string("Error. No me puedo conectar al Servidor: "), remote.GetStringAddress());

        /** */
        retcode = readResponse(respuesta);
        if (retcode != 220)
            throw FtpClientException(string("Error. Servidor no Responde: "), respuesta);

        /** */
        sendCommand(string("USER ") + username, retcode, respuesta);
        if (!(retcode == 331 || retcode == 230))
            throw FtpClientException(string("Error. Enviando Comando USER: "), respuesta);

        if (retcode != 230) {
            sendCommand(string("PASS ") + password, retcode, respuesta);
            if (!(retcode == 230 || retcode == 202))
                throw FtpClientException(string("Error. Acceso no permitido: "), respuesta);
        }
        loggedin = true;
    } 
	catch (socket_error x) 
	{
        throw FtpClientException(x);
    }
}

/** */
void FtpClient::Close() 
{
    try 
	{
        if (pCtrl_Sck != NULL) 
		{
            sendCommand("QUIT", retcode, respuesta);
            cleanup();
        } 
		else
            throw FtpClientException(string("Error. CLiente no Inicializado..."));
    } 
	catch (socket_error x) 
	{
        throw FtpClientException(x);
    }
}

/** */
void FtpClient::Donwload(string rFile, string lFile) {
    // TODO: Ftp. Comando Download
}

/** */
void FtpClient::Upload(string lFile, string rFile) {
    try 
	{
        /** Ponerlo en modo Binario */
        sendCommand("TYPE I", retcode, respuesta);
        if (retcode != 200)
            throw FtpClientException(string("Error. Enviando Comando TYPE I: "), respuesta);

        if (!createDataSocket())
            throw FtpClientException(string("Error. Creando el SOCKET de Datos.."));

        sendCommand("STOR " + rFile, retcode, respuesta);
        if (retcode != 125 && retcode != 150)
            throw FtpClientException(string("Error. Enviando Comando STOR: "), respuesta);

        sendFile(lFile);
        readResponse(respuesta);
    } 
	catch (socket_error x) 
	{
        throw FtpClientException(x);
    }
}

/** */
void FtpClient::Delete(string rFile) 
{
    // TODO: Ftp. Comando Delete
}

/** */
void FtpClient::ChangeDir(string rDir) 
{
    // TODO: Ftp. Comando CD
}
