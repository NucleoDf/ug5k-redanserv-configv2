#ifndef _UV5KIGWCFG_WEB_DATA_H_
#define _UV5KIGWCFG_WEB_DATA_H_

#include "../base/code-base.h"
#include "../base/sistema.h"
#include "../tools/tools.h"
#include "../rapidjson/document.h"
#include "../rapidjson/writer.h"
#include "../rapidjson/stringbuffer.h"
#include "../config/local-config.h"

#define __POR_REFERENCIA__		1	

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
	virtual bool test() {
		return true;
	}
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
	bool validate(string data_in) {
		Document valid;
		valid.Parse<kParseValidateEncodingFlag>(data_in.c_str());
		return !valid.HasParseError();
	}
	/** */
	void write_key/*_object*/(Writer<StringBuffer> &writer, string key, jData &obj)
	{
		writer.Key(key.c_str());
		writer.StartObject();
		obj.jwrite(writer);
		writer.EndObject();
	}
	void write_key/*_string*/(Writer<StringBuffer> &writer, string key, bool val)
	{
		writer.Key(key.c_str());writer.Bool(val);
	}
	void write_key/*_string*/(Writer<StringBuffer> &writer, string key, string val)
	{
		writer.Key(key.c_str());writer.String(val.c_str());
	}
	void write_key/*_int*/(Writer<StringBuffer> &writer, string key, int val)
	{
		writer.Key(key.c_str());writer.Int(val);
	}
	void write_key(Writer<StringBuffer> &writer, string key, vector<string> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		vector<string>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
			writer.String((*it).c_str());
		writer.EndArray();
	}
	void write_key(Writer<StringBuffer> &writer, string key, vector<int> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		vector<int>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
			writer.Int((*it));
		writer.EndArray();
	}
#if __POR_REFERENCIA__
	template <typename T> void write_key(Writer<StringBuffer> &writer, string key, vector<T> &val) 
	{
		writer.Key(key.c_str());
		writer.StartArray();
		typename vector<T>::iterator it;
		for (it=val.begin(); it!=val.end();it++)
		{
			writer.StartObject();
			(*it).jwrite(writer);
			writer.EndObject();
		}
		writer.EndArray();
	}
#else
	template <typename T> void write_key(Writer<StringBuffer> &writer, string key, vector<T *> &val) 
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
#endif

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
	bool is_bool(Value &base, const char *indice) {
		if (has_member(base, indice)==true && base[indice].IsBool()==true)
			return true;
		if (error=="") SetError("Tipo incorrecto: (" + string(indice) + "). Se esperaba Boolean");
		return false;
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
	void read_key(Value &base, const char *indice, bool &val) {
		error = "";
		val = is_null(base, indice) ? false :
			   is_bool(base, indice) ? base[indice].GetBool() : false; 			   
	}
	void read_key(Value &base, const char *indice, int &val) {
		error = "";
		val = is_null(base, indice) ? -1 :
			   is_int(base, indice) ? base[indice].GetInt() : 			   
			   is_string(base, indice) ? atoi(base[indice].GetString()) : -2;
	}
	void read_key(Value &base, const char *indice, string &val) {
		error = "";
		val = has_member(base, indice)==false ? "Indice Desconocido" :
			   is_string(base,indice) ? base[indice].GetString() :
			   is_null(base,indice) ? "NULL" : "Error de Tipo";
	}
	void read_key(Value &base, const char *indice, jData &obj) {
		error="";
		if (has_member(base, indice)==true) {
			obj.jread(base[indice]);
		}
	}
	/** */
	void read_key(Value &base, const char *indice, vector<string> &arr)
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
	void read_key(Value &base, const char *indice, vector<int> &arr)
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
#if __POR_REFERENCIA__
	template <typename T> void read_key(Value &base, const char *indice, vector<T> &arr)
	{
		error="";
		arr.clear();
		if (is_array(base,indice)==true)
		{
			Value &varr = base[indice];
			Value::ValueIterator itr;
			for (itr=varr.Begin(); itr!=varr.End(); itr++)
			{
				T obj;
				obj.jread((*itr));
				arr.push_back(obj);
			}
		}
	}
	template <typename T> void clear_array(vector<T> &arr) {
		if (arr.size() > 0) {
			arr.clear();
		}
	}
#else
	template <typename T> void read_key(Value &base, const char *indice, vector<T *> &arr)
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
#endif
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
	webData_tses(int parStd=0, string parIdc="IDC_IDC", string parTim="TIM_TIM", string parModo="rd", string version="0.0");
	webData_tses(string jData) {
		JDeserialize(jData);
	}
	~webData_tses(void){}
public:
	virtual void jread(Value &base)
	{
#if LOCAL_TEST
		read_key(base, "std", std);
		read_key(base, "idc", idc);
		read_key(base, "tim", tim);
		read_key(base, "ver", ver);
		read_key(base, "modo", modo);
#endif
	}
	virtual void jwrite(Writer<StringBuffer> &writer);

private:
	int std;
	string idc;
	string tim;
	string ver;
	string modo;
	string modo_redan;
	int ntpsync;
	string localdate;
	string timr;
#if LOCAL_TEST_1
	webData_line msg;
	vector<string> val_prueba1;
	vector<int> val_prueba2;
	vector<webData_line> val_prueba3;
#endif
};


/** */
class webData_VersionNucleo : public jData
{
public:
	webData_VersionNucleo() {
		string strpath = onfs(LocalConfig::p_cfg->get(strSection, strItemPath2Versiones));	// .PathToVersiones();
		const char *filename = strpath.c_str();
		ifstream infile(filename);
		stringstream buffer;
		string line;
		
		buffer << infile.rdbuf();
		while (std::getline(buffer, line))
		{
			if (line=="") continue;
			if (line.find("Ultima Actualizacion") == 0) continue;
			line.erase(std::remove_if(line.begin(), line.end(), &Tools::IsNoAscii), line.end());
			if (line.find(":") == line.length()-1) 
			{
				string line1;
				if (std::getline(buffer, line1))
				{
					line1.erase(std::remove_if(line1.begin(), line1.end(), &Tools::IsNoAscii), line1.end());
					line = line + " " + line1;
				}
			}
			lines.push_back(webData_line(line));
		}

		version = VersionGlobal();
		cfgsver = VersionConfiguracion();
		snmpver = VersionSnmp();
		recsver = VersionGrabador();

	}
	~webData_VersionNucleo(){}
public:
	virtual void jread(Value &base){}
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "version", version);
		write_key(writer, "cfgsver", cfgsver);
		write_key(writer, "snmpver", snmpver);
		write_key(writer, "recsver", recsver);
		write_key(writer, "lines", lines);
	}
private:
	string version;
	string cfgsver;
	string snmpver;
	string recsver;
	vector<webData_line> lines;
};

/** */
class webData_LogsList : public jData
{
public:
	webData_LogsList() {
		/** Obtener el PATH de los LOGS.. */
		string path = ON_WORKING_DIR("appweb/logs");

		/** Hacer una lista de los ficheros en ese PATH */
		vector<string> dir;
		Tools::Dir(dir, path, "");
		for (size_t i=0; i<dir.size(); i++)	{
			lst.push_back(webData_line(dir[i]));
		}
	}
public:
	virtual void jread(Value &base){}
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "lst", lst);
	}
public:
	vector<webData_line> lst;
};

/** */
class webData_VersionNucleoNew : public jData {
public:
	/** */
	class Component : public jData {
	public:
		/** */
		class File : public jData {
		public:
			File() {
			}
		public:
			virtual void jread(Value &base){
				read_key(base, "Path", Path);
				//read_key(base, "Date", Date);
				//read_key(base, "Size", Size);
				sistema::fileattr(onfs(Path), Date, Size);
			}
			virtual void jwrite(Writer<StringBuffer> &writer) {
				write_key(writer, "Path", Path);
				write_key(writer, "Date", Date);
				write_key(writer, "Size", Size);
			}
		public:
			string Path;
			string Date;
			string Size;
		};

	public:
		Component() {
		}
	public:
		virtual void jread(Value &base){
			read_key(base, "Name", Name);
			read_key(base, "Id", Id);
			read_key(base, "Files", Files);
		}
		virtual void jwrite(Writer<StringBuffer> &writer) {
			write_key(writer, "Name", Name);
			write_key(writer, "Id", Id);
			write_key(writer, "Files", Files);
		}
	public:
		string Name;
		string Id;
		vector <File> Files;
	};

public:
	webData_VersionNucleoNew() {
	}
public:
	virtual void jread(Value &base){
		read_key(base, "Version", Version);
		read_key(base, "Components", Components);
	}
	virtual void jwrite(Writer<StringBuffer> &writer) {
		write_key(writer, "Version", Version);
		write_key(writer, "Components", Components);
	}
	void loadfrom(string filename) {
		try {
			ifstream f(filename.c_str(), ios_base::in);
			string data,linea;
			while (std::getline(f, linea))
				data += linea;
			JDeserialize(data);
		}
		catch(Exception x) {
		}
	}
public:
	string Version;
	vector<Component> Components;
};

#endif
