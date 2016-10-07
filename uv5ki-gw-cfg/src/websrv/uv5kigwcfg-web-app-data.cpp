#include "..\..\include\websrv\uv5kigwcfg-web-app-data.h"

/** */
webData_tses::webData_tses(void)
{
	// TODO. Enlazar con la configuracion...
	std = 1;
	idc = "Datos Config";
	tim = "Time Config";
}

/** */
string webData_tses::JSerialize()
{
	Writer<StringBuffer> writer(s);

	writer.StartObject(); 

	writer.Key("lconfig"); writer.StartObject(); 
	writer.Key("std"); writer.Uint(std);
	writer.Key("idc"); writer.String(idc.c_str());
	writer.Key("tim"); writer.String(tim.c_str());
	writer.EndObject();

	writer.EndObject();

	return s.GetString();
}


