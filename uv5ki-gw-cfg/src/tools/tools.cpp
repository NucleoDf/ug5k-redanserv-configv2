#include "../../include/tools/tools.h"

/**
*/
bool Tools::EsIgual(const char * str1, const char * str2)
{
	return strcmp(str1,str2)==0 ? true : false;
}

/**
*/
bool Tools::FileExist(const char *filename)
{
	// ifstream file(string(filename), ifstream::in);
	ifstream file(filename, ios_base::in);
	bool ret = file.good();
	file.close();
	return ret;
}


/**
*/
static char _fecha[40]={0};
char * Tools::Hoy(void)
{
	
	time_t now;	
	struct tm * timeinfo;	

	time(&now);
	timeinfo = localtime (&now);
	strftime (_fecha, sizeof(_fecha), " %d/%m/%Y", timeinfo);
	return _fecha;
}

/**
*/
string Tools::HttpDecodeSpecialChars(string &stry)
{
	stry = Tools::replace(stry, "%2F", "/");
	stry = Tools::replace(stry, "%3A", ":");
	stry = Tools::replace(stry, "+", " ");
	stry = Tools::replace(stry, "%20", " ");
	stry = Tools::replace(stry, "%40", "@");

	return stry;
}

/**
*/
bool Tools::HttpQuerySplit(const char *qry, string &prop, string &value)
{
	/** Analizo los caracteres especiales. */
	string stry = qry;
	stry = Tools::HttpDecodeSpecialChars(stry);

	/** Obtengo los campos.. */
	size_t pos = stry.find("=");
	if (pos != string::npos)
	{
		prop = stry.substr(0,pos);
		value = stry.substr(pos+1,stry.length()-1);
		return true;
	}

	return false;
}

/**
*/
string & Tools::replace(string & subj, string old, string neu)
{
	size_t uiui = subj.find(old);
	while (uiui != string::npos)    
	{    
		subj.erase(uiui, old.size());        
		subj.insert(uiui, neu);        
		uiui = subj.find(old,uiui);
	}    
	return subj;    
}

/**
 * Wed, 09 Jun 2021 10:18:14 GMT
 * Wed Feb 13 15:46:11 2013
 * */
string Tools::DateCookie(int seconds)
{
	time_t now;
	struct tm * timeinfo;

	time(&now);
	now += seconds;
	timeinfo = gmtime (&now);
	strftime (_fecha, sizeof(_fecha), "%a,  %d %b %Y %H:%M:%S GMT", timeinfo);
	return _fecha;

}

/**
*/
string Tools::itoa(int i)
{
	std::stringstream out;
	out << i;
	return out.str();
}

/**
*/
int Tools::atoi(string str)
{
	int ret;
	int ok = sscanf(str.c_str(), "%i", &ret);
	return ok==1 ? ret : 0;
}

/** */
bool Tools::ValidateIpAddress(const string &ipAddress)
{
	int p1,p2,p3,p4;
	int conv = sscanf(ipAddress.c_str(),"%u.%u.%u.%u",&p1,&p2,&p3,&p4);
	if (conv != 4) return false;
	if (p1<0 || p1>255) return false;
	if (p2<0 || p2>255) return false;
	if (p3<0 || p3>255) return false;
	if (p4<0 || p4>255) return false;
	return true;
}


/**
*/
void Tools::DelFile(string path, string file)
{
	string name = path + file;
	if( remove( (name).c_str() ) != 0 )  
	{  
        std::cout << "No Puedo Eliminar el fichero: " << (name).c_str() << endl;
	}
}

////////////////////////////////////////////
/** */
template< typename T > std::string Tools::hexify(T i, bool prefijo)
{
    std::stringbuf buf;
    std::ostream os(&buf);

    os << (prefijo ? "0x" : "") << std::setfill('0') << std::setw(sizeof(T) * 2) << std::hex << i;

    return buf.str().c_str();
}

/** */
void Tools::split(std::vector<std::string> &tokens, const std::string &text, char sep) {
    unsigned int start = 0, end = 0;

    while ((end = text.find(sep, start)) != std::string::npos) {
        tokens.push_back(text.substr(start, end - start));
        start = end + 1;
    }

    tokens.push_back(text.substr(start));
}

/** */
bool Tools::StrContains(std::string texto, std::string valor) {
    if (texto.find(valor) != std::string::npos)
        return true;
    return false;
}

/** */
std::string Tools::StrFormat(const char *fmt, ...) {
    char textString[1024] = {'\0'}; // todo. Revisar este limite...

    // -- empty the buffer properly to ensure no leaks.
    memset(textString, '\0', sizeof (textString));

    va_list args;
    va_start(args, fmt);
#ifdef _WIN32
    vsnprintf_s(textString, 1024, fmt, args); // todo. Tambien esta aqui el limite...
#else
    vsnprintf(textString, 1024, fmt, args); // todo. Tambien esta aqui el limite...
#endif
    va_end(args);
    std::string retStr = textString;
    return retStr;
}

/** */
std::string Tools::Ahora() {
    struct tm * timeinfo;
    char buffer [80];

    std::time_t result = std::time(NULL);
    timeinfo = localtime(&result);

    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S.000Z", timeinfo);

    return std::string(buffer);
}

/** */
std::string Tools::Ahora_Servidor() {
    struct tm * timeinfo;
    char buffer [80];

    std::time_t result = std::time(NULL);
//    timeinfo = localtime(&result);
    timeinfo = gmtime(&result);
    strftime(buffer, 80, "%d/%m/%Y %H:%M:%S UTC", timeinfo);

    return std::string(buffer);
}

/** */
std::string Tools::Buff2String(int len, const char *data) {
    std::string str(data, len);
    return str;
}

/** */
std::string Tools::Int2String(int val)
{
	char buf[8];
	sprintf(buf,"%d",val);
	return std::string(buf);
}

/** */
bool Tools::DateString2time(std::string str, struct tm &stime)
{
// #ifdef _WIN32
	sscanf(str.c_str(),"%d/%d/%d %d:%d:%d", &stime.tm_mday, &stime.tm_mon, &stime.tm_year, &stime.tm_hour, &stime.tm_min, &stime.tm_sec);
	stime.tm_year -= 1900;
	stime.tm_mon -= 1;
	stime.tm_isdst = -1;
// #else
// 	strptime(str.c_str(), "%d/%m/%Y %H:%M:%s", &stime);
// #endif

	return true;
}

/** Numero de Segundos desde 1-1-2010 */
std::string Tools::ProgramUniqueId()
{
	struct tm stref;
	Tools::DateString2time("1/1/2010 00:00:00", stref);

	time_t tref = mktime(&stref);
	time_t tnow = time(NULL);
	
	long dif = (long )difftime(tnow,tref);
//	std::string id = Tools::hexify< long >(dif, false);
	std::string id = Tools::hexify(dif, false);

	return id;
}

/** */
std::string Tools::FileUniqueName(std::string fname)
{
	std::string ufname;
	std::string uid = Tools::ProgramUniqueId();

	size_t i = fname.rfind('.', fname.length());
	if (i != std::string::npos) 
	{
		ufname = fname.substr(0,i) + "_" + uid + fname.substr(i,fname.length()-i);
	}
	else
	{
		ufname = fname + "_" + uid;
	}

	return ufname;
}

/** */
std::string Tools::CookieTime(char *buffer, struct tm stime)
{
	const std::string dayName[] = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
	const std::string monName[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

	sprintf(buffer,"%s, %d %s %d %02d:%02d:%02d GMT", dayName[stime.tm_wday].c_str(), stime.tm_mday, monName[stime.tm_mon].c_str(),
		1900 + stime.tm_year, stime.tm_hour, stime.tm_min, stime.tm_sec);

	return std::string(buffer);
}

/** */
bool Tools::IsNoAscii(char c)
{
	return ((int)c >= 32 && (int)c<128) ? false : true;
}
