#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../include/base/sistema.h"
#include "../../include/config/local-config.h"

#define SIGU5K01        40
/**
*/
sistema::sistema(void)
{
}

/** */
sistema::~sistema(void)
{
}

/** */
void sistema::ExecuteCommand(char *cmd)
{
#ifdef _WIN32
	system(cmd);
#else
	system(cmd);
#endif
}

/** */
string sistema::ResultExecuteCommand(char* cmd)
{
#ifdef _WIN32
	#define POPEN	_popen
	#define PCLOSE	_pclose
#else
	#define POPEN	popen
	#define PCLOSE	pclose
#endif

    char buffer[128];
    std::string result = "";
    FILE* pipe = POPEN(cmd, "r");
    if (!pipe) /*throw std::runtime_error("popen() failed!");*/{
        return "Failed to run command";
    }
    try {
        while (!feof(pipe)) {
            if (fgets(buffer, 128, pipe) != NULL)
                result += buffer;
        }
    } catch (...) {
        PCLOSE(pipe);
        throw;
    }
    PCLOSE(pipe);
	result.erase(std::remove(result.begin(), result.end(), '\n'), result.end());
    return result;    
}

/** */
bool sistema::GetIpAddress(/*char *szIf, */string &ip)
{
	char *szIf = (char *)LocalConfig::cfg.NetworkInterfaceActiva().c_str();
#ifdef _WIN32
	ip = LocalConfig::cfg.ipWindows();
	return true;
#else
    int iSocket;
    struct ifreq sIfr;

    if ( 0 <= ( iSocket = socket( AF_INET, SOCK_DGRAM, 0 ) ) )
    {
        strcpy(sIfr.ifr_name, szIf );
        sIfr.ifr_addr.sa_family = AF_INET;
        if ( -1 != ioctl( iSocket, SIOCGIFADDR, &sIfr ) )
        {
			struct sockaddr_in* ipaddr = (struct sockaddr_in*)&sIfr.ifr_addr;
			ip = string(inet_ntoa(ipaddr->sin_addr));
            // return ( *(unsigned int*)(((char*)(&sIfr.ifr_ifru.ifru_addr.sa_data))+2) );
			close(iSocket);
			return true;
        }
		close(iSocket);
    }
    return false;    
#endif
}

/** */
void sistema::GetMacAddress(char *lan, char *mac)
{
#if defined _WIN32
	strcpy_s(mac,16,"11:11:11:11:11");
#elif defined __APPLE__
	strcpy(mac, "11:11:11:11:11");
#else
    int iSocket;
    struct ifreq sIfr;

    memset( mac, 0, 8);
    if ( 0 <= ( iSocket = socket( AF_INET, SOCK_DGRAM, 0 ) ) )
        {
        strcpy(sIfr.ifr_name, lan );
        if ( -1 != ioctl( iSocket, SIOCGIFHWADDR, &sIfr ) )
           memcpy( mac, sIfr.ifr_hwaddr.sa_data, 8);
        }    
#endif
}

/** */
void sistema::GetWorkingIpAddressAndName(string &ip, string &ipserv, string &name)
{
	GetIpAddress(ip);
#if defined _WIN32
	ipserv = LocalConfig::cfg.ServerURL();
	name = "CGW1";							// TODO.
#elif defined __APPLE__
	ipserv = LocalConfig::cfg.ServerURL();
	name = "CGW1";							// TODO.	
#else
	ipserv = LocalConfig::cfg.ServerURL();	// TODO.
	name = "CGW1";							// TODO.
#endif
}

/** */
void sistema::SignalNuevaConfiguracion(string npid)
{
#ifdef _WIN32
#else
	pid_t pid = pidof(npid);
    if (pid != 0)
		kill(pid, SIGU5K01);
#endif
}

/** */
int sistema::pidof(string name)
{
#ifdef _WIN32
	return 0;
#else
 #define LEN 128
	char line[LEN];
	FILE *cmd = popen((string("pidof -s ")+name).c_str(), "r");

	fgets(line, LEN, cmd);
	pid_t pid = strtoul(line, NULL, 10);

	pclose(cmd);
	return pid;
#endif
}

/** */
string sistema::NormalizePath(string path)
{
#ifdef _WIN32
	char sepi='/',sepo='\\';
#else
	char sepi='\\',sepo='/';
#endif
	replace( path.begin(), path.end(), sepi, sepo );
	return path;
}

/** */
string sistema::GetDelCommand(string path)
{
#ifdef _WIN32
	return "del " + NormalizePath(path);
#else
	return "rm " + NormalizePath(path);
#endif
}

/** */
string sistema::GetCpCommand(string src, string dest)
{
#ifdef _WIN32
	return "copy " + NormalizePath(src) + " " + NormalizePath(dest);
#else
	return "cp " + NormalizePath(src) + " " + NormalizePath(dest);
#endif
}

/** */
string sistema::PathFileName(string path)
{
#ifdef _WIN32
	char sep='\\';
#else
	char sep='/';
#endif
	path = sistema::NormalizePath(path);
	size_t i = path.rfind(sep, path.length());
	if (i != string::npos) 
	{
		return(path.substr(i+1, path.length() - i));
	}
	return path;
}

/** */
void sistema::DataSaveAs(string data, string filename)
{
	ofstream ff(ON_FLASH(filename));
	ff.write(data.c_str(), data.length());
}

/** 
	return: true => Main, false => Standby
 */
bool sistema::MainOrStandby()
{
	string filepath = LocalConfig::cfg.getString("M-S-CONTROL", "PATH", "/mnt/ramfs/cpumode");
	string isMain = LocalConfig::cfg.getString("M-S-CONTROL", "MAIN", "PRINCIPAL");
	ifstream ff(filepath.c_str());

	if (ff.good())
	{
		string estado;

		ff >> estado;
		if (estado==isMain)
			return true;
		return false;
	}
	return true;
}

/** */
time_t sistema::_TIMER_CLK()
{
	time_t tval;
	time(&tval);
	return tval;
}


/** */
string sistema::SnmpAgentVersion()
{
    //return ResultExecuteCommand((char *)"/home/snmp/ug5ksnmp /V");
	return ResultExecuteCommand((char *)(LocalConfig::cfg.snmpExe() + " /V").c_str());
}

/** */
string sistema::RecordServiceVersion() 
{
    //return ResultExecuteCommand((char *)"/home/rec/UG5KEd137b4Service /V");
	return ResultExecuteCommand((char *)(LocalConfig::cfg.recExe() + " /V").c_str());
}
