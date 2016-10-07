#ifndef _UV5KIGWCFG_WEB_DATA_H_
#define _UV5KIGWCFG_WEB_DATA_H_

#include "../base/code-base.h"
#include "../rapidjson/document.h"
#include "../rapidjson/writer.h"
#include "../rapidjson/stringbuffer.h"

using namespace rapidjson;

/** */
class jData : public CodeBase
{
public:
	virtual string JSerialize()=0;
	virtual void JDeserialize(string jdata)=0;

protected:
	bool validate(string data_in) {return true;}
	/** */
	void read(string data_in) 
	{
		if (!validate(data_in))
			throw Exception("JSON-No Valido");
		if (json.IsObject()) 
		{
			json.RemoveAllMembers();
			json.GetAllocator().Clear();
		}
		json.Parse(data_in.c_str());
	}
	/** */
	bool has_member(Value &base, const char *indice)
	{
		return base.IsNull() ? false : base.IsArray() ? false : base.HasMember(indice);
	}
	/** */
	int to_int(Value &base, const char *indice)
	{
		return has_member(base,indice)== false ? -1 :
			   base[indice].IsInt() ? base[indice].GetInt() :
			   base[indice].IsNull() ? -1 :
			   base[indice].IsString() ? atoi(base[indice].GetString()) : -1;
	}	
	/** */
	string to_string(Value &base, const char *indice)
	{
		return has_member(base, indice)==false ? "Indice Desconocido" :
			   base[indice].IsString() ? base[indice].GetString() :
			   base[indice].IsNull() ? "NULL" : "Error de Tipo";
	}

protected:
	StringBuffer s;
	Document json;
};

/** */
class webData_msg : public jData
{
public:
	webData_msg(string msg) {mensaje=msg;}

public:
	string JSerialize()
	{
		Writer<StringBuffer> writer(s);

		writer.StartObject(); 
		writer.Key("res"); writer.String(mensaje.c_str());
		writer.EndObject();

		return s.GetString();
	}
	void JDeserialize(string data_in){}

protected:
	string mensaje;

};

/** */
class webData_tses : public jData
{
public:
	webData_tses(void);
	~webData_tses(void){}
public:
	string JSerialize();
	void JDeserialize(string data_in)
	{
#if LOCAL_TEST
		read(data_in);
		if (has_member(json,"lconfig"))
		{
			Value &lconfig = json["lconfig"];

			std = to_int(lconfig, "std");
			idc = to_string(lconfig, "idc");
			tim = to_string(lconfig, "tim");
			return;
		}
		throw Exception("webData_tses error de formato");
#endif
	}

private:
	int std;
	string idc;
	string tim;
};

#endif


