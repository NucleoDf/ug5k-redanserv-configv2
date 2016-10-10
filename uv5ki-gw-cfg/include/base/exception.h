#ifndef _DFN_EXCEPTION_
#define _DFN_EXCEPTION_

#ifdef _WIN32
#	include <windows.h>
#else
#	include <errno.h>
#endif

#include <stdexcept> 
#include <string> 
#include <cstring>
#include <iostream>
#include <sstream>

using namespace std;

class Exception : public runtime_error
{
public:
	Exception(const char *s="");
	~Exception(void) throw(){}
protected:
    virtual const char *Prefix()
    {
#ifdef _WIN32
        return "WIN32";
#else
		return "LINUX";
#endif
    }

private:
    unsigned long m_error;
    mutable string m_msg;
public:
	unsigned long Code(void);
	virtual const char *what();
};

#endif
