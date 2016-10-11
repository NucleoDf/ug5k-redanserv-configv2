#include "../../include/websrv/uv5kigwcfg-web-app-data.h"

/** */
webData_tses::webData_tses(int parStd, string parIdc, string parTim)
{	
	std = parStd;
	idc = parIdc;
	tim = parTim;

#if LOCAL_TEST
	val_prueba1.push_back("Valor-1");
	val_prueba1.push_back("Valor-2");

	val_prueba2.push_back(0);
	val_prueba2.push_back(2);
	val_prueba2.push_back(1000);
	val_prueba2.push_back(-23);

	val_prueba3.push_back(new webData_line());
	val_prueba3.push_back(new webData_line("hola"));
#endif
}

/** */
void webData_tses::jwrite(Writer<StringBuffer> &writer)
{
	write_key/*_uint*/(writer, "std", std);
	write_key/*_string*/(writer, "idc", idc);
	write_key/*_string*/(writer, "tim", tim);
#if LOCAL_TEST
	write_key/*_object*/(writer, "msg", msg);
	write_key(writer, "ArrayPrueba1", val_prueba1);
	write_key(writer, "ArrayPrueba2", val_prueba2);
	write_key(writer, "ArrayPrueba3", val_prueba3);
#endif
}

///**----------------------------------------------------------------------------------*/
///** */
//webData_preconfs::webData_preconfs()
//{
//	// TODO. Leer la lista de Preconfiguraciones
//	preconfs.push_back(new webData_preconf_id("preconf-01", "10/10/2015, 08:09:09"));
//	preconfs.push_back(new webData_preconf_id("preconf-02", "11/10/2015, 09:09:09"));
//	preconfs.push_back(new webData_preconf_id("preconf-03", "12/10/2015, 10:09:09"));
//}
//
///** */
//webData_preconfs::~webData_preconfs()
//{
//	vector<webData_preconf_id *>::iterator it;
//	for (it = preconfs.begin(); it != preconfs.end(); it++)
//		delete (*it);
//	preconfs.clear();
//}
//



