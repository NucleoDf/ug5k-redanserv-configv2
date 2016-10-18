#include "../../include/config/soap-config.h"

/** */
remoteGetXdataFunc xml_data::remote_get_xdata_func;

/** */
soap_config::soap_config(remoteGetXdataFunc remoteFunc, string hwName)
{
	remote_get_xdata_func = remoteFunc;
	
	xdata_idConfig = remote_get_xdata_func("GetVersionConfiguracion","id_sistema=departamento","","");
	xdata_ParametrosGeneralesSistema = remote_get_xdata_func("GetParametrosGenerales","id_sistema=departamento","","");
	xdata_ParametrosMulticast = remote_get_xdata_func("GetParametrosMulticast","id_sistema=departamento","","");
	xdata_ArrayOfAsignacionRecursosGW = remote_get_xdata_func("GetPlanAsignacionRecursos","id_sistema=departamento","","");
	xdata_ArrayOfAsignacionUsuariosTV = remote_get_xdata_func("GetPlanAsignacionUsuarios","id_sistema=departamento","","");
	xdata_ArrayOfDireccionamientoIP = remote_get_xdata_func("GetPlanDireccionamientoIP","id_sistema=departamento","","");
	xdata_ArrayOfDireccionamientoSIP = remote_get_xdata_func("GetPlanDireccionamientoSIP","id_sistema=departamento","","");
	xdata_ArrayOfListaRedes = remote_get_xdata_func("GetPlanRedes","id_sistema=departamento","","");
	xdata_ArrayOfListaTroncales = remote_get_xdata_func("GetPlanTroncales","id_sistema=departamento","","");
	xdata_ArrayOfNumeracionATS = remote_get_xdata_func("GetPlanNumeracionATS","id_sistema=departamento","","");
	xdata_CfgPasarela = remote_get_xdata_func("GetCfgPasarela","id_sistema=departamento", "id_hw=" + hwName, "");

	XDeserialize(xdata_idConfig, "string");

}


soap_config::~soap_config(void)
{
}
