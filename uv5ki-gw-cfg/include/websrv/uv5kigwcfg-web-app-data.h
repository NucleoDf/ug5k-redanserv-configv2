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
	jData(){}
	virtual ~jData(){}

public:
	string JSerialize() 
	{
		StringBuffer s;
		Writer<StringBuffer> writer(s);
		writer.StartObject(); 
		jwrite(writer);
		writer.EndObject();		
		return s.GetString();
	}
	void JDeserialize(string data_in)
	{
		Document json;
		if (!validate(data_in))
			throw Exception("JSON-No Valido");
		if (json.IsObject()) 
		{
			json.RemoveAllMembers();
			json.GetAllocator().Clear();
		}
		json.Parse(data_in.c_str());
		jread(json);
	}
	virtual void jwrite(Writer<StringBuffer> &writer)=0;
	virtual void jread(Value &base)=0;
	string Error() {
		return error;
	}

protected:
	void SetError(string Error) {
		if (Error != "") {
			PLOG_ERROR(Error.c_str());
			error = Error;
		}
	}
	bool validate(string data_in) {return true;}	// TODO...
	/** */
	void write_key/*_object*/(Writer<StringBuffer> &writer, string key, jData &obj)
	{
		writer.Key(key.c_str());
		writer.StartObject();
		obj.jwrite(writer);
		writer.EndObject();
	}
	void write_key/*_string*/(Writer<StringBuffer> &writer, string key, string val)
	{
		writer.Key(key.c_str());writer.String(val.c_str());
	}
	void write_key/*_int*/(Writer<StringBuffer> &writer, string key, int val)
	{
		writer.Key(key.c_str());writer.Int(val);
	}
	void write_array(Writer<StringBuffer> &writer, string key, vector<string> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		vector<string>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
			writer.String((*it).c_str());
		writer.EndArray();
	}
	void write_array(Writer<StringBuffer> &writer, string key, vector<int> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		vector<int>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
			writer.Int((*it));
		writer.EndArray();
	}
	template <typename T> void write_array(Writer<StringBuffer> &writer, string key, vector<T *> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		typename vector<T *>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
		{
			writer.StartObject();
			(*it)->jwrite(writer);
			writer.EndObject();
		}
		writer.EndArray();
	}

	/** */
	bool has_member(Value &base, const char *indice)
	{
		if (base.IsNull()==false) {
			if (base.IsArray()==false) {
				if (base.HasMember(indice)==true)
					return true;
				SetError("No existe el Indice: (" + string(indice) + ")");
				return false;
			}
			SetError("Valor Base Es Array: (" + string(indice) + ")");
			return false;
		}
		SetError("Valor Base Nulo: (" + string(indice) + ")");
		return false;
	}
	bool is_null(Value &base, const char *indice) {
		if (has_member(base, indice)==true && base[indice].IsNull()==false)
			return false;
		if (error=="") SetError("Tipo NULO: (" + string(indice) + ").");
		return true;
	}
	bool is_int(Value &base, const char *indice) {
		if (has_member(base, indice)==true && base[indice].IsInt()==true)
			return true;
		if (error=="") SetError("Tipo incorrecto: (" + string(indice) + "). Se esperaba Entero");
		return false;
	}
	bool is_string(Value &base, const char *indice) {
		if (has_member(base, indice)==true && base[indice].IsString()==true)
			return true;
		if (error=="") SetError("Tipo incorrecto: (" + string(indice) + "). Se esperaba String");
		return false;
	}
	bool is_array(Value &base, const char *indice) {
		if (has_member(base, indice)==true && base[indice].IsArray()==true)
			return true;
		if (error=="") SetError("Tipo incorrecto: (" + string(indice) + "). Se esperaba Array");
		return false;
	}
	/** */
	int to_int(Value &base, const char *indice)
	{
		error = "";
		return is_null(base, indice) ? -1 :
			   is_int(base, indice) ? base[indice].GetInt() : 			   
			   is_string(base, indice) ? atoi(base[indice].GetString()) : -2;
	}	
	/** */
	string to_string(Value &base, const char *indice)
	{
		error="";
		return has_member(base, indice)==false ? "Indice Desconocido" :
			   is_string(base,indice) ? base[indice].GetString() :
			   is_null(base,indice) ? "NULL" : "Error de Tipo";
	}
	void to_obj(Value &base, const char *indice, jData &obj) {
		error="";
		if (has_member(base, indice)==true) {
			obj.jread(base[indice]);
		}
	}
	/** */
	void to_array(Value &base, const char *indice, vector<string> &arr)
	{
		error="";
		arr.clear();
		if (is_array(base,indice)==true)
		{
			Value &varr = base[indice];
			Value::ValueIterator itr;
			for (itr=varr.Begin(); itr!=varr.End(); itr++)
			{
				if ((*itr).IsString())
					arr.push_back((*itr).GetString());
			}
		}
	}
	void to_array(Value &base, const char *indice, vector<int> &arr)
	{
		error="";
		arr.clear();
		if (is_array(base,indice)==true)
		{
			Value &varr = base[indice];
			Value::ValueIterator itr;
			for (itr=varr.Begin(); itr!=varr.End(); itr++)
			{
				if ((*itr).IsInt())
					arr.push_back((*itr).GetInt());
			}
		}
	}
	template <typename T> void to_array(Value &base, const char *indice, vector<T *> &arr)
	{
		error="";
		arr.clear();
		if (is_array(base,indice)==true)
		{
			Value &varr = base[indice];
			Value::ValueIterator itr;
			for (itr=varr.Begin(); itr!=varr.End(); itr++)
			{
				T *obj = new T();
				obj->jread((*itr));
				arr.push_back(obj);
			}
		}
	}
	template <typename T> void clear_array(vector<T *> &arr) {
		if (arr.size() > 0) {
			typename vector<T *>::iterator it;
			for (it=arr.begin(); it!=arr.end(); it++)
				delete (*it);
			arr.clear();
		}
	}
private:
	string error;
};

/** */
class webData_line : public jData
{
public:
	webData_line(string msg="OK") {line=msg;}

public:
	virtual void jwrite(Writer<StringBuffer> &writer)
	{
		write_key/*_string*/(writer, "res", line);
	}
	virtual void jread(Value &base){}

protected:
	string line;
};


/** */
class webData_tses : public jData
{
public:
	webData_tses(int parStd=0, string parIdc="IDC_IDC", string parTim="TIM_TIM");
	~webData_tses(void){}
public:
	virtual void jread(Value &base)
	{
#if LOCAL_TEST
		std = to_int(base, "std");
		idc = to_string(base, "idc");
		tim = to_string(base, "tim");
#endif
	}
	virtual void jwrite(Writer<StringBuffer> &writer);

private:
	int std;
	string idc;
	string tim;
#if LOCAL_TEST
	webData_line msg;
	vector<string> val_prueba1;
	vector<int> val_prueba2;
	vector<webData_line *> val_prueba3;
#endif
};

/** */
class webData_config : public jData
{
public:
	webData_config(){}
	~webData_config(){}

public:
	virtual void jread(Value &base){}
	virtual void jwrite(Writer<StringBuffer> &writer){}
};

/** */
class webData_preconf_id : public jData
{
public:
	webData_preconf_id(string Name="", string Fecha="") {
		name=Name;
		fecha=Fecha;
	}
	~webData_preconf_id(){}

public:
	virtual void jread(Value &base){
		name = to_string(base, "name");
		fecha= to_string(base, "fecha");
	}
	virtual void jwrite(Writer<StringBuffer> &writer){
		write_key(writer, "name", name);
		write_key(writer, "fecha", fecha);
	}
	
private:
	string name;
	string fecha;
};

/** */
class webData_preconfs : public jData
{
public:
	webData_preconfs();
	~webData_preconfs();
public:
	virtual void jread(Value &base){
	}
	virtual void jwrite(Writer<StringBuffer> &writer){
		write_array(writer, "preconfs", preconfs);
	}

private:
	vector<webData_preconf_id *> preconfs;
};

#endif


