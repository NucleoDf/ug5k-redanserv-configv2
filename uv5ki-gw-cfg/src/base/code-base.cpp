#include "../../include/base/code-base.h"
#include "../../include/base/sistema.h"
#include "../../include/tools/tools.h"

/** MACROS */
#define LOGCONF	ON_WORKING_DIR("plog.conf")

/** Variables Estaticas */
bool CodeBase::_plog_iniciado=false;
plog::LogConfig CodeBase::cfg;
plog::ConsoleAppender<plog::ConsoleFormatter> *CodeBase::p_consoleAppender;
plog::NetUdpAppender<plog::Log4viewFormatter> *CodeBase::p_log4viewAppender;

/** */
CodeBase::CodeBase(void)
{
}

/** */
CodeBase::~CodeBase(void)
{
}

/** */
void CodeBase::plogInit() 
{
	if (_plog_iniciado == true)
		return;

#ifdef _WIN32
	cfg.Configure("./wplog.conf");
#else
	cfg.Configure(LOGCONF);
#endif

	string id=cfg.UdpId();

	p_consoleAppender = new plog::ConsoleAppender<plog::ConsoleFormatter>();
	p_log4viewAppender = new plog::NetUdpAppender<plog::Log4viewFormatter>(cfg.IpUpd().c_str(), cfg.PortUdp(), id.c_str());

	plog::init<plogFile>(plog::verbose, cfg.FileName().c_str(), cfg.FileSize(), cfg.NumberOfFile());
	plog::init<plogConsole>("plog_con", plog::verbose, p_consoleAppender);
	plog::init<plogNetwork>("plog_net", plog::verbose, p_log4viewAppender);

	_plog_iniciado = true;
	pthread_create(&plog_thread_id, NULL, plog_thread_routine, NULL);
#if !defined(_WIN32) && !defined(__APPLE__) && !defined(_PPC82xx_)
	pthread_setname_np(plog_thread_id, id.c_str());
#endif 
}

/** */
void CodeBase::plogDispose() 
{
	if (_plog_iniciado==true)
	{
		_plog_iniciado = false;
		pthread_join(plog_thread_id, NULL);
		delete p_consoleAppender;
		delete p_log4viewAppender;
	}
}

/** */
void CodeBase::_Log(plog::Severity level, const char *from, int line, const char *fmt, va_list args)
{
	if (_plog_iniciado == false)
		plogInit();

	char textString[1024] = {'\0'};
	memset(textString, '\0', sizeof(textString));

#ifdef _WIN32
	vsnprintf_s ( textString, sizeof(textString), fmt, args );
#else
	vsnprintf ( textString, sizeof(textString), fmt, args );
#endif

	PLogEvent evento(level, from, line, textString);
	util::MutexLock lock(plog_mutex);
	plog_queue.push(evento);
}

/** */
void CodeBase::_FormatLog(plog::Severity level, const char *file, int line, const char *fmt, va_list args )
{
	try
	{
		//std::stringstream ss;
		//ss << file << " (L:" << line << "): " << fmt;
		//ss << file << " (L:" << line << ")";
		_Log(level, file, line, fmt, args);
	}
	catch(...)
	{
		_Log(fatal, "", 0, "Error en _FormatLog", args);
		return;
	}
}

/** */
pthread_t CodeBase::plog_thread_id;
std::queue<PLogEvent > CodeBase::plog_queue;
util::Mutex CodeBase::plog_mutex;
void *CodeBase::plog_thread_routine(void *arg) 
{
#if !defined(_WIN32)
	PLOG_INFO("PlogThread (%d) running...", (int )getpid());
#endif
	while (_plog_iniciado == true)
	{
		if (!plog_queue.empty())
		{
			util::MutexLock lock(plog_mutex);
			cfg.TestCfgChange(); 
			PLogEvent evento = plog_queue.front();
			plog_queue.pop();

			if (plog::pLogProfiles[(int)evento.sev].toFile)
				NDFLOG_(plogFile, evento.sev, evento.from.c_str(), evento.line) << evento.msg;
			if (plog::pLogProfiles[(int)evento.sev].toConsole)
				NDFLOG_(plogConsole, evento.sev, evento.from.c_str(), evento.line) << evento.msg;
			if (plog::pLogProfiles[(int)evento.sev].toNetwork)
				NDFLOG_(plogNetwork, evento.sev, evento.from.c_str(), evento.line) << evento.msg;
		}
		Sleep(10);
	}
	return NULL;
}

/** */
string CodeBase::VersionGlobal() 
{
	return Tools::read_txt_file(ON_WORKING_DIR("version.txt"));
}

/** */
extern char *acStrVersion();
string CodeBase::VersionConfiguracion()
{
	return (string )acStrVersion();
}
/** */
string CodeBase:: VersionSnmp() 
{
	return sistema::SnmpAgentVersion();
}

/** */
string CodeBase::VersionGrabador()
{
	return sistema::RecordServiceVersion();
}

