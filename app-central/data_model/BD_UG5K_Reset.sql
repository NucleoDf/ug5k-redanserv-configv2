/********************************************/
/*	 SCRIPT PARA DEJAR CONFIGURACIÓN REDAN 	*/
/*	CON LOS DATOS MÍNIMOS Y PARTIR DE UNA	*/
/*			CONFIGURACIÓN VACÍA				*/
/********************************************/
/*		Ver 1.1								*/
/********************************************/
/*	CAMBIOS CON RESPECTO A VERSION 1.0:		*/
/*	- Incluir tabla_bss y tabla_bss_recurso	*/
/********************************************/

DELETE FROM `ug5k`.`cfg`;
DELETE FROM `ug5k`.`colateral`;
DELETE FROM `ug5k`.`destinos`;
DELETE FROM `ug5k`.`emplazamiento`;
DELETE FROM `ug5k`.`emplazamientos`;
DELETE FROM `ug5k`.`estadisticas`;
DELETE FROM `ug5k`.`servicios`;
DELETE FROM `ug5k`.`grab`;
DELETE FROM `ug5k`.`sip`;
DELETE FROM `ug5k`.`sincr`;
DELETE FROM `ug5k`.`jitter`;
DELETE FROM `ug5k`.`snmp`;
DELETE FROM `ug5k`.`web`;
DELETE FROM `ug5k`.`tabla_bss`;

DELETE FROM `ug5k`.`historicoincidencias`;

DELETE FROM `ug5k`.`slaves`;
DELETE FROM `ug5k`.`recurso`;
DELETE FROM `ug5k`.`urilistas`;

DELETE FROM `ug5k`.`listofgateways`;
DELETE FROM `ug5k`.`operadores`;

