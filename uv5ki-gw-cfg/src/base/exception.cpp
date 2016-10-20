#include "../../include/base/exception.h"

/** */
Exception::Exception(const char *s)
#ifdef _WIN32
	:runtime_error(s), m_error(GetLastError())
#else
	:runtime_error(s), m_error(errno)		// Obtener ultimo error en linux/mac
#endif
{
}

/** */
Exception::Exception(string s)
#ifdef _WIN32
	:runtime_error(s.c_str() ), m_error(GetLastError())
#else
	:runtime_error(s.c_str()), m_error(errno)		// Obtener ultimo error en linux/mac
#endif
{
}

/** */
unsigned long Exception::Code(void)
{
	return m_error;
}

/** */
#if defined _WIN32
const char *Exception::what()
#elif defined __APPLE__
const char *Exception::what() const _NOEXCEPT
#elif defined _PPC82xx_
const char *Exception::what()
#else
const char *Exception::what()
#endif
{
	try
	{
		if (m_msg.empty())
		{
#ifdef _WIN32
			std::ostringstream os;
			os << Prefix() << "(ERROR: " << m_error << "). " << runtime_error::what();
			//char buf[256];
			//if (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, m_error, 0, (LPSTR)buf, sizeof(buf), 0))
			//{
			//	os << ": " << buf;
			//}
			m_msg = os.str();
#else
			// 
			std::ostringstream os;
			os << Prefix() << "(ERROR: " << m_error << "). " << runtime_error::what();
			os << ": " << strerror(m_error);
			m_msg = os.str();
#endif
		}

		return m_msg.c_str();
	}
	catch (...)
	{
		return "error on error";
	}
}

