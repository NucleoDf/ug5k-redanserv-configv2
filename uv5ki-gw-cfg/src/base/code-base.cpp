#include "..\..\include\base\code-base.h"

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
#ifndef _WIN32
#ifndef _PPC82xx_
			pthread_setname_np(m_hThread, id.c_str());
#endif // !_PPC82xx_
#endif // !_WIN32
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
void CodeBase::_Log(plog::Severity level, const char *fmt, va_list args)
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

	std::pair<plog::Severity, string> evento(level, textString);
	util::MutexLock lock(plog_mutex);
	plog_queue.push(evento);
}

/** */
void CodeBase::_FormatLog(plog::Severity level, const char *file, int line, const char *fmt, va_list args )
{
	try
	{
		std::stringstream ss;
		ss << file << " (L:" << line << "): " << fmt;
		_Log(level, ss.str().c_str(), args);
	}
	catch(...)
	{
		_Log(fatal, "Error en _FormatLog", args);
		return;
	}
}

/** */
pthread_t CodeBase::plog_thread_id;
std::queue<std::pair<plog::Severity, string> > CodeBase::plog_queue;
util::Mutex CodeBase::plog_mutex;
void *CodeBase::plog_thread_routine(void *arg) 
{
	while (_plog_iniciado == true)
	{
		if (!plog_queue.empty())
		{
			util::MutexLock lock(plog_mutex);
			std::pair<plog::Severity, string> evento = plog_queue.front();
			plog_queue.pop();

			if (plog::pLogProfiles[(int)evento.first].toFile)
				LOG_(plogFile, evento.first) << evento.second;
			if (plog::pLogProfiles[(int)evento.first].toConsole)
				LOG_(plogConsole, evento.first) << evento.second;
			if (plog::pLogProfiles[(int)evento.first].toNetwork)
				LOG_(plogNetwork, evento.first) << evento.second;
		}
	}
	return NULL;
}



