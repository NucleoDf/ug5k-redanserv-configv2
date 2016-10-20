#ifndef _LOCALCONFIG_
#define _LOCALCONFIG_

#include "../base/code-base.h"

#include <iostream>
#include <string>
#include <list>
#include <map>
#include <vector>
#include <cstdlib>

#include "../tools/stlini.h"

using namespace std;
#define strFile							ON_WORKING_DIR("u5kweb-config.ini")

#define strSection						((const char *)"U5KWEB")
#define strItemWebPort					((const char *)"WEB-PORT")
#define strItemSessionTime				((const char *)"SESSION-TIME")
#define strItemPath2Ini					((const char *)"PATH-INI")
#define strItemPath2IniFlash			((const char *)"PATH-INI-FLASH")
#define strItemPath2RCSH				((const char *)"PATH-RCSH")
#define strItemPath2Versiones			((const char *)"PATH-VERSIONES")
#define strItemLog						((const char *)"LOG")
#define strItemLogin					((const char *)"LOGIN")
#define strItemFtpGenTimeout			((const char *)"FTP-GEN-TIMEOUT")
#define strItemFtpSendTimeout			((const char *)"FTP-SEND-TIMEOUT")
#define strItemHttpGenTimeout			((const char *)"HTTP-GEN-TIMEOUT")
#define strItemClearResourcesOnBdt		((const char *)"CLEAR-RESOURCES-ONNOBDT")

#define strItemServidor					((const char *)"CONFIG-SERVER")
#define strItemNetworkInterfaceActiva	((const char *)"ETH-ACTIVA")
#define strItemConfigFile				((const char *)"CONFIG-FILE")
#define strItemConfigTSUP				((const char *)"CONFIG-TSUP")

#define strItemNucleoProcName			((const char *)"NUCLEO-PROC-NAME")
#define strItemSnmpProcName				((const char *)"SNMP-PROC-NAME")
#define strItemRecordProcName			((const char *)"RECORD-PROC-NAME")

#define strSectionStrings				((const char *)"U5KWEB-KEY-IDENT")
#define strSectionLast					((const char *)"U5KWEB-LAST")
#define strLastIpDest					((const char *)"IP-DEST")
#define strLastIpVia					((const char *)"IP-VIA")
#define strLastIpSource					((const char *)"IP-SRC")

#define strModulos						((const char *)"MODULOS")
#define strItemModuloSnmp				((const char *)"SNMP-CONFIG-FILE")
#define strItemModuloGrabador			((const char *)"GRAB-CONFIG-FILE")
#define strItemExeSnmp					((const char *)"SNMP-EXE-FILE")
#define strItemExeGrabador				((const char *)"GRAB-EXE-FILE")

#define strUlises						((const char *)"ULISES-V5000")
#define strItemUlisesModo				((const char *)"MODO-ULISES")


#define strFilesSupervidor				((const char *)"FILESUPERVISOR")
#ifdef _WIN32
 #define strKeySupervisedFile			((const char *)"WFILE")
#else
 #define strKeySupervisedFile			((const char *)"FILE")
#endif
#define strSupervisedFileUnlockTime		((const char *)"UNLOCKTIME")

#ifdef _WIN32
 #define strWindowsTest					((const char *)"WINDOWS-TEST")
 #define strItemWindowsTestIp			((const char *)"IP-WINDOWS")
 #define strItemWindowsTestSyncFtp		((const char *)"SINCR-FTP")
 #define strItemWindowsTestSnmpStd		((const char *)"SNMPSTD")
 #define strItemWindowsTestServidor		((const char *)"SINCR-SERV")
#endif

/** */
#define ON_RAM(p)						(LocalConfig::onram(p).c_str())
#define ON_FLASH(p)						(LocalConfig::onflash(p).c_str())
#define ON_SWREP(p)						(LocalConfig::onswrep(p).c_str())

/** */
#define LAST_CFG						(LocalConfig::cfg.ConfigFile().c_str())
#define LAST_CFG_PRUEBA					"gw_config_prueba.json"
#define LAST_SAVE(n)					(string("last_gw_config_")+string(n)+string(".json"))

/** */
typedef map<string,string> MapString;

/** */
class stStrings
{
	public:
		MapString ToIdent;
		MapString ToKey;
};

/** */
class LocalConfig
{
public:
	static LocalConfig cfg;

private:
	INIFile ini;
	string namefile;

private:
	stStrings _strings;
#ifdef _LOCAL_LOCK_
	CCritSec _lock;
#endif

public:
	LocalConfig(void);
	LocalConfig(string strfile);
	~LocalConfig(void);

	string getString(string section, string item, string def="");
	int getInt(string section, string item, string def="");
	void setString(string section, string item, string valor);
	void setInt(string section, string item, int valor);

public:
	void save(void);
	void sync();

	string PuertoEscucha(string puerto="NoPuerto");
	string TiempoSesion(string segundos="NoSegundos");
	string ServerURL();

	string PathToIniRam(string path="NoPath");
	string PathToIniFlash(string path="NoPath");
	string PathToRCSH(string path="NoPath");
	string PathToPreconf(string path="NoPath");
	string PathToVersiones();
	int FtpGenTimeout() {return atoi(getString(strSection, strItemFtpGenTimeout,"5").c_str());}
	int FtpSendTimeout(){return atoi(getString(strSection, strItemFtpSendTimeout,"6000").c_str());}
	int HttpGenTimeout(){return atoi(getString(strSection, strItemHttpGenTimeout,"5").c_str());}
	int ClearResourcesOnBdt(){return atoi(getString(strSection, strItemClearResourcesOnBdt,"1").c_str());}

	string Log();
	string Login();
	int ConfigTsup();

    string NucleoProcName();
    string SnmpProcName();
    string RecordProcName();
    string NetworkInterfaceActiva();
	string ConfigFile();

	/** */
	string LastRouteDest(string ip="GetIp");
	string LastRouteVia(string ip="GetIp");
	string LastRouteSource(string ip="GetIp");

	/** SECCION ULISES */
	bool ModoUlises() {
		int md = getInt(strUlises, strItemUlisesModo, "0");
		return md==1 ? true : false;
	}

	/** */
	static string onram(string filename);
	static string onflash(string filename);
	static string onswrep(string filename);
	static string snmpModule()	{return LocalConfig::cfg.getString(strModulos, strItemModuloSnmp,"./ug5ksnmp-config.ini");} 
	static string recModule()	{return LocalConfig::cfg.getString(strModulos, strItemModuloGrabador, "./ug5krec-config.ini");} 
	/** */
	static string snmpExe()	{return LocalConfig::cfg.getString(strModulos, strItemExeSnmp,"/home/snmp/ug5ksnmp");} 
	static string recExe()	{return LocalConfig::cfg.getString(strModulos, strItemExeGrabador, "/home/rec/UG5KEd137b4Service");} 

	static int SupervisedFileUnlocktime() {
		return LocalConfig::cfg.getInt(strFilesSupervidor, strSupervisedFileUnlockTime, "10");
	}

	/** */
	INISection getSection(string section); 
	void deleteSection(string section);

private:
	/** */
	void LoadStrings();
	/** */
	string KeyToIdent(string key);
	string IdentToKey(string ident);
	/** */
	void GetKeyConfigLocal(INISection &config);
	void SetKeyConfigLocal(string key, string data);

#ifdef _WIN32
public:
	string ipWindows() { return GetIniSetting(ini, strWindowsTest, strItemWindowsTestIp, "192.168.1.129");}
	bool winSyncFtp() { return GetIniSetting(ini, strWindowsTest, strItemWindowsTestSyncFtp, "0") == "0" ? false : true;}
	bool winStdSnmp() { return GetIniSetting(ini, strWindowsTest, strItemWindowsTestSnmpStd, "0") == "0" ? false : true;}
	bool winSyncSer() { return GetIniSetting(ini, strWindowsTest, strItemWindowsTestServidor, "0") == "0" ? false : true;}
#endif
};

#endif
