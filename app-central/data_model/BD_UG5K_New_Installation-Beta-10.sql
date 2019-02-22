CREATE DATABASE  IF NOT EXISTS `ug5k` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ug5k`;
-- MySQL dump 10.13  Distrib 5.6.26, for Win64 (x86_64)
--
-- Host: localhost    Database: ug5k
-- ------------------------------------------------------
-- Server version	5.6.26-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `alarmas_view`
--

DROP TABLE IF EXISTS `alarmas_view`;
/*!50001 DROP VIEW IF EXISTS `alarmas_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `alarmas_view` AS SELECT 
 1 AS `idHistoricoIncidencias`,
 1 AS `FechaHora`,
 1 AS `idEmplaz`,
 1 AS `IdHw`,
 1 AS `TipoHw`,
 1 AS `descripcion`,
 1 AS `Nivel`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `alivegateways_view`
--

DROP TABLE IF EXISTS `alivegateways_view`;
/*!50001 DROP VIEW IF EXISTS `alivegateways_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `alivegateways_view` AS SELECT 
 1 AS `idCGW`,
 1 AS `EMPLAZAMIENTO_idEMPLAZAMIENTO`,
 1 AS `REGIONES_idREGIONES`,
 1 AS `servicio`,
 1 AS `name`,
 1 AS `dualidad`,
 1 AS `ipv`,
 1 AS `ips`,
 1 AS `nivelconsola`,
 1 AS `puertoconsola`,
 1 AS `nivelIncidencias`,
 1 AS `idEMPLAZAMIENTO`,
 1 AS `site`,
 1 AS `CFG_idCFG`,
 1 AS `Activa`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cfg`
--

DROP TABLE IF EXISTS `cfg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cfg` (
  `idCFG` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `description` text,
  `activa` tinyint(1) DEFAULT NULL,
  `ts_activa` datetime DEFAULT NULL,
  PRIMARY KEY (`idCFG`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `cgw`
--

DROP TABLE IF EXISTS `cgw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cgw` (
  `idCGW` int(11) NOT NULL AUTO_INCREMENT,
  `EMPLAZAMIENTO_idEMPLAZAMIENTO` int(11) NOT NULL,
  `REGIONES_idREGIONES` int(11) NOT NULL DEFAULT '1',
  `servicio` int(11) DEFAULT NULL,
  `name` text,
  `dualidad` tinyint(1) DEFAULT NULL,
  `ipv` text,
  `ips` text,
  `nivelconsola` int(11) DEFAULT '65535',
  `puertoconsola` int(11) DEFAULT '19710',
  `nivelIncidencias` int(11) DEFAULT '3',
  PRIMARY KEY (`idCGW`,`EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  KEY `servicios_idx` (`servicio`),
  KEY `fk_CGW_REGIONES1_idx` (`REGIONES_idREGIONES`),
  KEY `fk_CGW_EMPLAZAMIENTO1_idx` (`EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  CONSTRAINT `fk_CGW_EMPLAZAMIENTO1` FOREIGN KEY (`EMPLAZAMIENTO_idEMPLAZAMIENTO`) REFERENCES `emplazamiento` (`idEMPLAZAMIENTO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_CGW_REGIONES1` FOREIGN KEY (`REGIONES_idREGIONES`) REFERENCES `regiones` (`idREGIONES`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `servicios` FOREIGN KEY (`servicio`) REFERENCES `servicios` (`idSERVICIOS`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ug5k`.`cgw_BEFORE_DELETE`
BEFORE DELETE ON `ug5k`.`cgw`
FOR EACH ROW
BEGIN
	DELETE FROM slaves WHERE slaves.idSLAVES IN (SELECT SLAVES_idSLAVES FROM hardware WHERE CGW_idCGW=old.idCGW);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cgw_cfg`
--

DROP TABLE IF EXISTS `cgw_cfg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cgw_cfg` (
  `idCGW_CFG` int(11) NOT NULL AUTO_INCREMENT,
  `CFG_idCFG` int(11) NOT NULL,
  `CGW_idCGW` int(11) NOT NULL,
  `Activa` tinyint(1) DEFAULT '0',
  `LastUpdate` datetime DEFAULT NULL,
  `Sincro` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idCGW_CFG`),
  KEY `fk_CGW_CFG_CFG1_idx` (`CFG_idCFG`),
  KEY `fk_CGW_CFG_CGW1_idx` (`CGW_idCGW`),
  CONSTRAINT `fk_CGW_CFG_CFG1` FOREIGN KEY (`CFG_idCFG`) REFERENCES `cfg` (`idCFG`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_CGW_CFG_CGW1` FOREIGN KEY (`CGW_idCGW`) REFERENCES `cgw` (`idCGW`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `cgw_estado`
--

DROP TABLE IF EXISTS `cgw_estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cgw_estado` (
  `cgw_idCGW` int(11) NOT NULL,
  `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO` int(11) NOT NULL,
  `viva` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`cgw_idCGW`,`cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  CONSTRAINT `fk_cgw_estado_cgw1` FOREIGN KEY (`cgw_idCGW`, `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`) REFERENCES `cgw` (`idCGW`, `EMPLAZAMIENTO_idEMPLAZAMIENTO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `cgw_fisica`
--

DROP TABLE IF EXISTS `cgw_fisica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cgw_fisica` (
  `idcgw_fisica` int(11) NOT NULL AUTO_INCREMENT,
  `cgw_idCGW` int(11) NOT NULL,
  `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO` int(11) NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idcgw_fisica`,`cgw_idCGW`,`cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  KEY `fk_cgw_fisica_cgw1_idx` (`cgw_idCGW`,`cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  CONSTRAINT `fk_cgw_fisica_cgw1` FOREIGN KEY (`cgw_idCGW`, `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`) REFERENCES `cgw` (`idCGW`, `EMPLAZAMIENTO_idEMPLAZAMIENTO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colateral`
--

DROP TABLE IF EXISTS `colateral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colateral` (
  `idCOLATERAL` int(11) NOT NULL AUTO_INCREMENT,
  `DESTINOS_idDESTINOS` int(11) NOT NULL,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  PRIMARY KEY (`idCOLATERAL`),
  KEY `fk_COLATERAL_RECURSO1_idx` (`RECURSO_idRECURSO`),
  KEY `fk_COLATERAL_DESTINOS1_idx` (`DESTINOS_idDESTINOS`),
  CONSTRAINT `fk_COLATERAL_DESTINOS1` FOREIGN KEY (`DESTINOS_idDESTINOS`) REFERENCES `destinos` (`idDESTINOS`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_COLATERAL_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `cpu`
--

DROP TABLE IF EXISTS `cpu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cpu` (
  `idCPU` int(11) NOT NULL AUTO_INCREMENT,
  `CGW_idCGW` int(11) DEFAULT NULL,
  `num` int(11) DEFAULT '1',
  `tlan` tinyint(1) DEFAULT NULL,
  `ip0` text,
  `ms0` text,
  `ip1` text,
  `ms1` text,
  `ipb` text,
  `msb` text,
  `ipg` text,
  PRIMARY KEY (`idCPU`),
  KEY `cgw_idx` (`CGW_idCGW`),
  CONSTRAINT `cgw` FOREIGN KEY (`CGW_idCGW`) REFERENCES `cgw` (`idCGW`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `destinos`
--

DROP TABLE IF EXISTS `destinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `destinos` (
  `idDESTINOS` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `tipoConmutacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`idDESTINOS`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `emplazamiento`
--

DROP TABLE IF EXISTS `emplazamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emplazamiento` (
  `idEMPLAZAMIENTO` int(11) NOT NULL AUTO_INCREMENT,
  `cfg_idCFG` int(11) NOT NULL,
  `name` text,
  PRIMARY KEY (`idEMPLAZAMIENTO`,`cfg_idCFG`),
  KEY `fk_emplazamiento_cfg1_idx` (`cfg_idCFG`),
  CONSTRAINT `fk_emplazamiento_cfg1` FOREIGN KEY (`cfg_idCFG`) REFERENCES `cfg` (`idCFG`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emplazamientos`
--

DROP TABLE IF EXISTS `emplazamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emplazamientos` (
  `idEMPLAZAMIENTOS` int(11) NOT NULL AUTO_INCREMENT,
  `uriTxA` text,
  `uriTxB` text,
  `uriRxA` text,
  `uriRxB` text,
  `activoTx` text,
  `activoRx` text,
  PRIMARY KEY (`idEMPLAZAMIENTOS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estadisticas`
--

DROP TABLE IF EXISTS `estadisticas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estadisticas` (
  `idESTADISTICAS` int(11) NOT NULL AUTO_INCREMENT,
  `IdEvento` int(10) unsigned NOT NULL,
  `Objeto` varchar(45) NOT NULL,
  `TimeStamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `TiempoEnFallo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idESTADISTICAS`),
  KEY `fk_ESTADISTICAS_INCIDENCIAS1_idx` (`IdEvento`),
  CONSTRAINT `fk_ESTADISTICAS_INCIDENCIAS1` FOREIGN KEY (`IdEvento`) REFERENCES `incidencias` (`IdIncidencia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grab`
--

DROP TABLE IF EXISTS `grab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grab` (
  `idGRAB` int(11) NOT NULL AUTO_INCREMENT,
  `sport` int(11) DEFAULT '65001',
  `rtsp_port` int(11) DEFAULT '11554',
  `rtsp_uri` text,
  `rtsp_ip` text,
  `rtsp_rtp` int(11) DEFAULT '1',
  `rtp_pl` int(11) DEFAULT '8',
  `rtp_sr` int(11) DEFAULT '8000',
  PRIMARY KEY (`idGRAB`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `hardware`
--

DROP TABLE IF EXISTS `hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hardware` (
  `idHARDWARE` int(11) NOT NULL AUTO_INCREMENT,
  `CGW_idCGW` int(11) NOT NULL,
  `SLAVES_idSLAVES` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  PRIMARY KEY (`idHARDWARE`),
  KEY `fk_HARDWARE_CGW1_idx` (`CGW_idCGW`),
  KEY `fk_HARDWARE_SLAVES1_idx` (`SLAVES_idSLAVES`),
  CONSTRAINT `fk_HARDWARE_CGW1` FOREIGN KEY (`CGW_idCGW`) REFERENCES `cgw` (`idCGW`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_HARDWARE_SLAVES1` FOREIGN KEY (`SLAVES_idSLAVES`) REFERENCES `slaves` (`idSLAVES`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=408 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `historicoincidencias`
--

DROP TABLE IF EXISTS `historicoincidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historicoincidencias` (
  `idHistoricoIncidencias` int(11) NOT NULL AUTO_INCREMENT,
  `IdEmplaz` varchar(32) DEFAULT NULL,
  `IdHw` varchar(32) NOT NULL,
  `TipoHw` varchar(20) NOT NULL,
  `IdIncidencia` int(10) unsigned NOT NULL,
  `FechaHora` datetime NOT NULL,
  `Reconocida` datetime DEFAULT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `Usuario` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`idHistoricoIncidencias`,`IdHw`),
  KEY `HistoricoIncidencias_FKIndex1` (`IdIncidencia`),
  KEY `HistoricoIncidenciasIndex` (`IdHw`,`TipoHw`,`IdIncidencia`,`FechaHora`),
  CONSTRAINT `historicoincidencias_ibfk_1` FOREIGN KEY (`IdIncidencia`) REFERENCES `incidencias` (`IdIncidencia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=530 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incidencias`
--

DROP TABLE IF EXISTS `incidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incidencias` (
  `IdIncidencia` int(10) unsigned NOT NULL,
  `Incidencia` varchar(180) NOT NULL,
  `Descripcion` varchar(180) NOT NULL,
  `LineaEventos` tinyint(1) NOT NULL,
  `Grupo` varchar(20) NOT NULL,
  `Error` tinyint(1) NOT NULL DEFAULT '0',
  `Nivel` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IdIncidencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencias`
--

LOCK TABLES `incidencias` WRITE;
/*!40000 ALTER TABLE `incidencias` DISABLE KEYS */;
INSERT INTO `incidencias` VALUES (47,'Inicio sesión RCS2010 UG5KR','Inicio sesión RCS2010 UG5KR  del usuario {0}',0,'SEGURIDAD',0,0),(48,'Recahazada sesión RCS2010 UG5KR','Recahazada sesión RCS2010 UG5KR  al usuario {0}',0,'SEGURIDAD',0,0),(49,'Fin sesion RCS2010 UG5KR','Fin sesion RCS2010 UG5KR  del usuario {0}',0,'SEGURIDAD',0,0),(50,'Inicio sesión Configuración Centralizada','Inicio sesión Configuración Centralizada  del usuario',0,'SEGURIDAD',0,0),(51,'Rechazada sesión Configuración Centralizada','Rechazada sesión Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(52,'Alta Usuario','Alta Usuario',0,'SEGURIDAD',0,0),(53,'Borrado Usuario','Borrado Usuario ',0,'SEGURIDAD',0,0),(54,'Modificado Usuario','Modificado Usuario',0,'SEGURIDAD',0,0),(55,'Fin sesion  Configuración Centralizada ','Fin sesion  Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(105,'Carga de Configuración Remota','Carga desde configuración remota',0,'CONF-R',0,0),(106,'Error Carga Configuración Remota','Error carga desde configuración remota [Cfg-Gtw]:',0,'CONF-R',0,0),(107,'Alta de Pasarela','Alta de Pasarela',0,'CONF-R',0,0),(108,'Baja de Pasarela','Baja de Pasarela',0,'CONF-R',0,0),(109,'Modificación de Parámetros Generales de Pasarela','Modificación de Parámetros Generales de Pasarela',0,'CONF-R',0,0),(110,'Modificación Rutas ATS','Modificación Rutas ATS',0,'CONF-R',0,0),(113,'Alta de Recurso','Alta de Recurso',0,'CONF-R',0,0),(114,'Baja de Recurso','Baja de Recurso',0,'CONF-R',0,0),(115,'Modificación de Parámetros de Recurso','Modificación de Parámetros de Recurso',0,'CONF-R',0,0),(116,'Modificación de Parámetros Lógicos de  Recurso','Modificación de Parámetros Lógicos de  Recurso',0,'CONF-R',0,0),(150,'Modificación de Parámetros Generales de Pasarela.','Modificación Parámetro en {0}. {1}',0,'CONF-L',0,0),(152,'Modificación de Parámetros de Recurso','Modificación HW en Recurso {0}. {1}',0,'CONF-L',0,0),(153,'Modificación de Parámetros Lógico de Recurso','Modificación SW en Recurso {0} . {1}',0,'CONF-L',0,0),(154,'Generación de Configuración por Defecto.','Generación de Configuración por Defecto {0} . {1}',0,'CONF-L',0,0),(155,'Activación de Configuración por Defecto.','Activación de Configuración por Defecto {0}  . {1}',0,'CONF-L',0,0),(156,'Borrado de Configuración por Defecto','Borrado de Configuración por Defecto {0}  . {1}',0,'CONF-L',0,0),(157,'Alta Recurso Radio','Recurso Radio {0} Añadido',0,'CONF-L',0,0),(158,'Baja Recurso Radio','Recurso Radio {0} Eliminado',0,'CONF-L',0,0),(159,'Alta Recurso Telefonía','Recurso Telefónico {0} Añadido',0,'CONF-L',0,0),(160,'Baja Recurso Telefonía','Recurso Telefónico {0} Eliminado',0,'CONF-L',0,0),(161,'Conflicto de configuraciones','Conflicto de Configuración en GW {0}',0,'CONF-L',0,0),(180,'Carga de Versión SW','Carga de Versión SW: {0}',0,'MAN-L',0,0),(181,'Activación de Versión SW','Activación de Versión SW: {0}',0,'MAN-L',0,0),(182,'Reset Remoto','Reset Remoto {0}',0,'MAN-L',0,0),(183,'Selección Bucle Prueba','Selección Bucle {0}  {1}  en {2}.',0,'MAN-L',0,0),(184,'Comando Bite','Selección  BITE {0}',0,'MAN-L',0,0),(185,'Conmutacion P/R','Selección Conmutación P/R {0}',0,'MAN-L',0,0),(186,'Selección Modo','Selección Modo :{0}',0,'MAN-L',0,0),(187,'Resultado Comando Bite','Resultado  BITE {0} {1}',0,'MAN-L',0,0),(193,'Resultado  bucle prueba','Resultado Bucle {0} en {1} : {2}',0,'MAN-L',0,0),(195,'Resultado Conmutacion P/R','Resultado  Conmutación P/R {0}, {1}',0,'MAN-L',0,0),(196,'Resultado  Modo','Resultado  Modo :{0}',0,'MAN-L',0,0),(201,'Arranque APP RCS2010','Arranque APP RCS2010 UG5KR en puesto {0}',0,'SP-GEN',0,0),(202,'Cierre Aplicacion APP RCS2010','Cierre Aplicacion APP RCS2010 UG5KR  en puesto {0}',0,'SP-GEN',1,0),(203,'Servidor NTP Conectado','Servidor NTP Conectado',0,'SP-GEN',0,0),(204,'Servidor NTP Desconectado','Servidor NTP Desconectado',0,'SP-GEN',1,0),(2000,'Cambio estado Pasarela','Cambio estado pasarela: {0}',1,'SP-PASARELA',0,2),(2003,'Cambio Estado LAN','Cambio Estado LANs. CGW {0}, LAN1 {1}, LAN2 {2}',1,'SP-PASARELA',0,2),(2005,'Cambio Estado CPU','Cambio Estado CPUs. CGW {0}, CPU Local {1}, CPU Dual {2}',1,'SP-PASARELA',0,2),(2007,'Conexión Recurso Radio','Conexión Recurso Radio {0}',1,'SP-PASARELA',0,0),(2008,'Desconexión Recurso Radio','Desconexión Recurso Radio {0}',1,'SP-PASARELA',1,0),(2009,'Conexión Recurso Telefonía','Conexión Recurso Telefonía  {0}',1,'SP-PASARELA',0,0),(2010,'Desconexión Recurso Telefonía','Desconexión Recurso Telefonía {0}',1,'SP-PASARELA',1,0),(2011,'Conexión Tarjeta Interfaz (esclava-tipo)','Conexión Tarjeta Interfaz. Número {0}; Tipo: {1}',1,'SP-PASARELA',0,0),(2012,'Desconexión Tarjeta Interfaz (esclava-tipo)','Desconexión Tarjeta Interfaz. Número {0}; Tipo: {1}',1,'SP-PASARELA',1,0),(2013,'Conexión Recurso R2','Conexión Recurso R2 {0}',1,'SP-PASARELA',0,0),(2014,'Desconexión Recurso R2.','Desconexión Recurso R2 {0}',1,'SP-PASARELA',1,0),(2015,'Conexión Recurso N5','Conexión Recurso N5 {0}',1,'SP-PASARELA',0,0),(2016,'Desconexión Recurso N5','Desconexión Recurso N5 {0}',1,'SP-PASARELA',1,0),(2017,'Conexión Recurso QSIG','Conexión Recurso QSIG {0}',1,'SP-PASARELA',0,0),(2018,'Desconexión Recurso  QSIG','Desconexión Recurso  QSIG {0}',1,'SP-PASARELA',1,0),(2019,'Conexión Recurso LCEN','Conexión Recurso LCEN {0}',1,'SP-PASARELA',0,0),(2020,'Desconexión Recurso  LCEN','Desconexión Recurso  LCEN {0}',1,'SP-PASARELA',1,0),(2021,'Servicio NTP Conectado','Servicio NTP Conectado',1,'SP-PASARELA',0,0),(2022,'Servicio NTP Desconectado','Servicio NTP Desconectado',1,'SP-PASARELA',1,0),(2023,'SIP-PROXY Presente','SIP-PROXY Presente',1,'SP-PASARELA',0,0),(2024,'SIP-PROXY Desconectado','SIP-PROXY Desconectado',1,'SP-PASARELA',1,0),(2025,'Conexión Recurso Tunneling','Conexión Recurso Tunneling {0}',1,'SP-PASARELA',0,0),(2026,'Desconexión Recurso Tunneling','Desconexión Recurso Tunneling {0}',1,'SP-PASARELA',1,0),(2027,'Cambio estado Sincro BD.','Cambio estado Sincro BD {0}',1,'SP-PASARELA',0,0),(2100,'Conmutación Principal/Reserva','Comando Conmutación P/R: Frecuencia{0}, Emplazamiento {1}, Equipo {2}',0,'SP-RADIO',0,0),(2101,'Caída/establecimiento sesión SIP','Cambio estado sesión SIP. Recurso: {0}; Estado:  {1}',0,'SP-RADIO',0,0),(2102,'Cambio PTT','Cambio estado PTT. Recurso: {0}; Estado: {1}',0,'SP-RADIO',0,0),(2103,'Cambio SQU','Cambio estado SQU. Recurso: {0}; Estado: {1}',0,'SP-RADIO',0,0),(2104,'Recurso Registrado en Proxy','Recurso {0} Registrado en Proxy {1}',0,'SP-RADIO',0,0),(2105,'Error Registro Recurso en Proxy','Error Registro Recurso {0} en Proxy {1}',0,'SP-RADIO',1,0),(2200,'Error Protocolo LCEN','Error Protocolo LCEN. Recurso  {0}, Error.',1,'SP-TELEFONIA',1,0),(2201,'Fallo línea LCEN (caída tono línea 2280 HZ)','Fallo línea LCEN. Recurso {0}',1,'SP-TELEFONIA',1,0),(2202,'Fallo test LCEN VoIP (mensaje Options)','Fallo test LCEN VoIP. Recurso {0}',1,'SP-TELEFONIA',1,0),(2203,'Error Protocolo R2','Error Protocolo R2. Recurso:  {0}.',1,'SP-TELEFONIA',1,0),(2204,'Fallo llamada de test R2 SCV','Fallo llamada de test R2 SCV. Recurso {0}',1,'SP-TELEFONIA',1,0),(2205,'Fallo llamada de test R2 VoIP (mensaje Options)','Fallo llamada de test R2 VoIP. Recurso  {0}',1,'SP-TELEFONIA',1,0),(2206,'Error Protocolo N5','Error Protocolo N5. Recurso:  {0}.',1,'SP-TELEFONIA',1,0),(2207,'Fallo llamada de test N5 SCV','Fallo llamada de test N5 SCV. Recurso {0}',1,'SP-TELEFONIA',1,0),(2208,'Fallo llamada de test N5 VoIP (mensaje Options)','Fallo llamada de test N5 VoIP. Recurso {0}',1,'SP-TELEFONIA',1,0),(2209,'Recurso Registrado en PROXY (+ IP PROXY)','Recurso  {0} Registrado en Proxy   {1}',0,'SP-TELEFONIA',0,0),(2210,'Error Registro Recurso en Proxy (Error + IP PROXY)','Error Registro Recurso {0} en Proxy {1}',1,'SP-TELEFONIA',1,0);
/*!40000 ALTER TABLE `incidencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `info_cgw`
--

DROP TABLE IF EXISTS `info_cgw`;
/*!50001 DROP VIEW IF EXISTS `info_cgw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `info_cgw` AS SELECT 
 1 AS `name`,
 1 AS `dual_cpu`,
 1 AS `emplazamiento`,
 1 AS `num_cpu`,
 1 AS `virtual_ip`,
 1 AS `dual_lan`,
 1 AS `ip_eth0`,
 1 AS `ip_eth1`,
 1 AS `bound_ip`,
 1 AS `gateway_ip`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `jitter`
--

DROP TABLE IF EXISTS `jitter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jitter` (
  `idJITTER` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `min` int(11) DEFAULT '0',
  `max` int(11) DEFAULT '0',
  PRIMARY KEY (`idJITTER`),
  KEY `fk_JITTER_RECURSO1_idx` (`RECURSO_idRECURSO`),
  CONSTRAINT `fk_JITTER_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listablanca`
--

DROP TABLE IF EXISTS `listablanca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listablanca` (
  `idLISTABLANCA` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `URILISTAS_idURILISTAS` int(11) NOT NULL,
  PRIMARY KEY (`idLISTABLANCA`,`URILISTAS_idURILISTAS`,`RECURSO_idRECURSO`),
  KEY `fk_LISTABLANCA_RECURSO1_idx` (`RECURSO_idRECURSO`),
  KEY `fk_LISTABLANCA_URILISTAS1_idx` (`URILISTAS_idURILISTAS`),
  CONSTRAINT `fk_LISTABLANCA_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_LISTABLANCA_URILISTAS1` FOREIGN KEY (`URILISTAS_idURILISTAS`) REFERENCES `urilistas` (`idURILISTAS`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `listanegra`
--

DROP TABLE IF EXISTS `listanegra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listanegra` (
  `idLISTANEGRA` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `URILISTAS_idURILISTAS` int(11) NOT NULL,
  PRIMARY KEY (`idLISTANEGRA`,`URILISTAS_idURILISTAS`,`RECURSO_idRECURSO`),
  KEY `fk_LISTANEGRA_RECURSO1_idx` (`RECURSO_idRECURSO`),
  KEY `fk_LISTANEGRA_URILISTAS1_idx` (`URILISTAS_idURILISTAS`),
  CONSTRAINT `fk_LISTANEGRA_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_LISTANEGRA_URILISTAS1` FOREIGN KEY (`URILISTAS_idURILISTAS`) REFERENCES `urilistas` (`idURILISTAS`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `listofgateways`
--

DROP TABLE IF EXISTS `listofgateways`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listofgateways` (
  `Gateway` varchar(35) NOT NULL,
  PRIMARY KEY (`Gateway`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `op_gtw`
--

DROP TABLE IF EXISTS `op_gtw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_gtw` (
  `idop_gtw` int(11) NOT NULL AUTO_INCREMENT,
  `cgw_idCGW` int(11) NOT NULL,
  `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO` int(11) NOT NULL,
  `operadores_idOPERADORES` int(11) NOT NULL,
  PRIMARY KEY (`idop_gtw`),
  KEY `fk_op_gtw_cgw1_idx` (`cgw_idCGW`,`cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`),
  KEY `fk_op_gtw_operadores1_idx` (`operadores_idOPERADORES`),
  CONSTRAINT `fk_op_gtw_cgw1` FOREIGN KEY (`cgw_idCGW`, `cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`) REFERENCES `cgw` (`idCGW`, `EMPLAZAMIENTO_idEMPLAZAMIENTO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_op_gtw_operadores1` FOREIGN KEY (`operadores_idOPERADORES`) REFERENCES `operadores` (`idOPERADORES`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operadores`
--

DROP TABLE IF EXISTS `operadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operadores` (
  `idOPERADORES` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `clave` text,
  `perfil` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`idOPERADORES`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `paramhw`
--

DROP TABLE IF EXISTS `paramhw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paramhw` (
  `idPARAMHW` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `AD_AGC` int(11) DEFAULT '0',
  `AD_Gain` decimal(6,3) DEFAULT '10.000',
  `DA_AGC` int(11) DEFAULT '0',
  `DA_Gain` decimal(6,3) DEFAULT '-10.000',
  PRIMARY KEY (`idPARAMHW`),
  KEY `fk_PARAMHW_RECURSO1_idx` (`RECURSO_idRECURSO`),
  CONSTRAINT `fk_PARAMHW_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paramradio`
--

DROP TABLE IF EXISTS `paramradio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paramradio` (
  `idPARAMRADIO` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `tipo` int(11) DEFAULT '0',
  `sq` int(11) DEFAULT '0',
  `ptt` int(11) DEFAULT '0',
  `bss` int(11) DEFAULT '0',
  `modoConfPtt` int(11) DEFAULT '0',
  `repSqBss` int(11) DEFAULT '1',
  `desactivacionSq` int(11) DEFAULT '1',
  `timeoutPtt` int(11) DEFAULT '200',
  `metodoBss` int(11) DEFAULT '0',
  `umbralVad` int(11) DEFAULT '-33',
  `numFlujosAudio` int(11) DEFAULT '1',
  `tiempoPtt` int(11) DEFAULT '0',
  `tmVentanaRx` int(11) DEFAULT '100',
  `climaxDelay` tinyint(1) DEFAULT '1',
  `tmRetardoFijo` int(11) DEFAULT '100',
  `bssRtp` int(11) DEFAULT '0',
  `retrasoSqOff` int(11) DEFAULT '50',
  `evtPTT` int(11) DEFAULT '0',
  `tjbd` int(11) DEFAULT '20',
  `tGRSid` int(11) DEFAULT '10',
  `iEnableGI` tinyint(1) DEFAULT '0',
  `iPttPrio` tinyint(1) DEFAULT '0',
  `iSesionPrio` tinyint(1) DEFAULT '0',
  `iPrecisionAudio` int(11) DEFAULT '1',
  PRIMARY KEY (`idPARAMRADIO`),
  KEY `fk_PARAMRADIO_RECURSO1_idx` (`RECURSO_idRECURSO`),
  CONSTRAINT `fk_PARAMRADIO_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `paramtelef`
--

DROP TABLE IF EXISTS `paramtelef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paramtelef` (
  `idPARAMTELEF` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `tipo` int(11) DEFAULT '0',
  `lado` int(11) DEFAULT '1',
  `t_eym` int(11) DEFAULT '0',
  `h2h4` int(11) DEFAULT '0',
  `ladoeym` int(11) DEFAULT '0',
  `modo` int(11) DEFAULT '0',
  `r_automatica` tinyint(1) DEFAULT '1',
  `no_test_local` text,
  `no_test_remoto` text,
  `it_release` int(11) DEFAULT '5',
  `uri_remota` text,
  `detect_vox` int(11) DEFAULT '0',
  `umbral_vox` int(11) DEFAULT '-15',
  `tm_inactividad` int(11) DEFAULT '2',
  `superv_options` int(11) DEFAULT '1',
  `tm_superv_options` int(11) DEFAULT '2',
  `colateral_scv` int(11) DEFAULT '0',
  `iT_Int_Warning` int(11) DEFAULT '1',
  PRIMARY KEY (`idPARAMTELEF`),
  KEY `fk_PARAMTELEF_RECURSO1_idx` (`RECURSO_idRECURSO`),
  CONSTRAINT `fk_PARAMTELEF_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `pos`
--

DROP TABLE IF EXISTS `pos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pos` (
  `idPOS` int(11) NOT NULL AUTO_INCREMENT,
  `SLAVES_idSLAVES` int(11) NOT NULL,
  `rank` int(11) DEFAULT NULL,
  `cfg` int(11) DEFAULT '1',
  PRIMARY KEY (`idPOS`),
  KEY `fk_POS_SLAVES1_idx` (`SLAVES_idSLAVES`),
  CONSTRAINT `fk_POS_SLAVES1` FOREIGN KEY (`SLAVES_idSLAVES`) REFERENCES `slaves` (`idSLAVES`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxys`
--

DROP TABLE IF EXISTS `proxys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proxys` (
  `idPROXYS` int(11) NOT NULL AUTO_INCREMENT,
  `SIP_idSIP` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `selected` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idPROXYS`),
  KEY `fk_PROXYS_SIP1_idx` (`SIP_idSIP`),
  CONSTRAINT `fk_PROXYS_SIP1` FOREIGN KEY (`SIP_idSIP`) REFERENCES `sip` (`idSIP`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `rangos`
--

DROP TABLE IF EXISTS `rangos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rangos` (
  `idRANGOS` int(11) NOT NULL AUTO_INCREMENT,
  `PARAMTELEF_idPARAMTELEF` int(11) NOT NULL,
  `origen` tinyint(1) DEFAULT NULL,
  `inicial` text,
  `final` text,
  PRIMARY KEY (`idRANGOS`,`PARAMTELEF_idPARAMTELEF`),
  KEY `fk_RANGOS_PARAMTELEF1_idx` (`PARAMTELEF_idPARAMTELEF`),
  CONSTRAINT `fk_RANGOS_PARAMTELEF1` FOREIGN KEY (`PARAMTELEF_idPARAMTELEF`) REFERENCES `paramtelef` (`idPARAMTELEF`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recurso`
--

DROP TABLE IF EXISTS `recurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recurso` (
  `idRECURSO` int(11) NOT NULL AUTO_INCREMENT,
  `POS_idPOS` int(11) NOT NULL,
  `name` text NOT NULL,
  `tamRTP` int(11) DEFAULT '20',
  `codec` int(11) DEFAULT '0',
  `tipo` int(11) DEFAULT NULL,
  `enableRegistro` int(11) DEFAULT '1',
  `restriccion` int(11) DEFAULT '0',
  `szClave` text,
  `LlamadaAutomatica` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idRECURSO`),
  KEY `fk_RECURSO_POS1_idx` (`POS_idPOS`),
  CONSTRAINT `fk_RECURSO_POS1` FOREIGN KEY (`POS_idPOS`) REFERENCES `pos` (`idPOS`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regiones`
--

DROP TABLE IF EXISTS `regiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regiones` (
  `idREGIONES` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idREGIONES`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regiones`
--

LOCK TABLES `regiones` WRITE;
/*!40000 ALTER TABLE `regiones` DISABLE KEYS */;
INSERT INTO `regiones` VALUES (1,'NUCLEODF');
/*!40000 ALTER TABLE `regiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrars`
--

DROP TABLE IF EXISTS `registrars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registrars` (
  `idREGISTRARS` int(11) NOT NULL AUTO_INCREMENT,
  `SIP_idSIP` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `selected` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idREGISTRARS`),
  KEY `fk_REGISTRARS_SIP1_idx` (`SIP_idSIP`),
  CONSTRAINT `fk_REGISTRARS_SIP1` FOREIGN KEY (`SIP_idSIP`) REFERENCES `sip` (`idSIP`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicios` (
  `idSERVICIOS` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `SIP_idSIP` int(11) DEFAULT NULL,
  `WEB_idWEB` int(11) DEFAULT NULL,
  `SNMP_idSNMP` int(11) DEFAULT NULL,
  `GRAB_idGRAB` int(11) DEFAULT NULL,
  `SINCR_idSINCR` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSERVICIOS`),
  KEY `fk_SERVICIOS_SIP1_idx` (`SIP_idSIP`),
  KEY `fk_SERVICIOS_WEB1_idx` (`WEB_idWEB`),
  KEY `fk_SERVICIOS_SNMP1_idx` (`SNMP_idSNMP`),
  KEY `fk_SERVICIOS_GRAB1_idx` (`GRAB_idGRAB`),
  KEY `fk_SERVICIOS_SINCR1_idx` (`SINCR_idSINCR`),
  CONSTRAINT `fk_SERVICIOS_GRAB1` FOREIGN KEY (`GRAB_idGRAB`) REFERENCES `grab` (`idGRAB`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_SERVICIOS_SINCR1` FOREIGN KEY (`SINCR_idSINCR`) REFERENCES `sincr` (`idSINCR`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_SERVICIOS_SIP1` FOREIGN KEY (`SIP_idSIP`) REFERENCES `sip` (`idSIP`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_SERVICIOS_SNMP1` FOREIGN KEY (`SNMP_idSNMP`) REFERENCES `snmp` (`idSNMP`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_SERVICIOS_WEB1` FOREIGN KEY (`WEB_idWEB`) REFERENCES `web` (`idWEB`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `servidoresntp`
--

DROP TABLE IF EXISTS `servidoresntp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servidoresntp` (
  `idServidorNtp` int(11) NOT NULL AUTO_INCREMENT,
  `SINCR_idSINCR` int(11) NOT NULL,
  `ip` text NOT NULL,
  `selected` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idServidorNtp`),
  KEY `fk_SERVIDORESNTP_SINCR1_idx` (`SINCR_idSINCR`),
  CONSTRAINT `fk_SERVIDORESNTP_SINCR1` FOREIGN KEY (`SINCR_idSINCR`) REFERENCES `sincr` (`idSINCR`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `sincr`
--

DROP TABLE IF EXISTS `sincr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sincr` (
  `idSINCR` int(11) NOT NULL AUTO_INCREMENT,
  `ntp` int(11) DEFAULT '2',
  PRIMARY KEY (`idSINCR`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sip`
--

DROP TABLE IF EXISTS `sip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip` (
  `idSIP` int(11) NOT NULL AUTO_INCREMENT,
  `PuertoLocalSIP` int(11) DEFAULT '5060',
  `KeepAlivePeriod` int(11) DEFAULT '200',
  `KeepAliveMultiplier` int(11) DEFAULT '10',
  `SupresionSilencio` int(11) DEFAULT '0',
  `PeriodoSupervisionSIP` int(11) DEFAULT '5',
  PRIMARY KEY (`idSIP`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `slaves`
--

DROP TABLE IF EXISTS `slaves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slaves` (
  `idSLAVES` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `tp` int(11) DEFAULT NULL,
  PRIMARY KEY (`idSLAVES`)
) ENGINE=InnoDB AUTO_INCREMENT=410 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `snmp`
--

DROP TABLE IF EXISTS `snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmp` (
  `idSNMP` int(11) NOT NULL AUTO_INCREMENT,
  `agcomm` text,
  `agcont` text,
  `agloc` text,
  `agname` text,
  `agv2` int(11) DEFAULT '1',
  `sport` int(11) DEFAULT '65000',
  `snmpp` int(11) DEFAULT '161',
  PRIMARY KEY (`idSNMP`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `spvs_cgw`
--

DROP TABLE IF EXISTS `spvs_cgw`;
/*!50001 DROP VIEW IF EXISTS `spvs_cgw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `spvs_cgw` AS SELECT 
 1 AS `name`,
 1 AS `resource`,
 1 AS `slave_rank`,
 1 AS `slave_type`,
 1 AS `resource_type`,
 1 AS `resource_rank`,
 1 AS `frecuencia`,
 1 AS `resource_subtype`,
 1 AS `remoto`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `spvs_site`
--

DROP TABLE IF EXISTS `spvs_site`;
/*!50001 DROP VIEW IF EXISTS `spvs_site`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `spvs_site` AS SELECT 
 1 AS `idEMPLAZAMIENTO`,
 1 AS `name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tabla_bss`
--

DROP TABLE IF EXISTS `tabla_bss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tabla_bss` (
  `idtabla_bss` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `UsuarioCreacion` varchar(32) DEFAULT NULL,
  `FechaCreacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `UsuarioModificacion` varchar(32) DEFAULT NULL,
  `FechaModificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idtabla_bss`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `tabla_bss_recurso`
--

DROP TABLE IF EXISTS `tabla_bss_recurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tabla_bss_recurso` (
  `idtabla_bss_recurso` int(11) NOT NULL AUTO_INCREMENT,
  `recurso_idRECURSO` int(11) NOT NULL,
  `tabla_bss_idtabla_bss` int(11) NOT NULL,
  PRIMARY KEY (`idtabla_bss_recurso`,`recurso_idRECURSO`,`tabla_bss_idtabla_bss`),
  KEY `fk_tabla_bss_recurso_recurso1_idx` (`recurso_idRECURSO`),
  KEY `fk_tabla_bss_recurso_tabla_bss1_idx` (`tabla_bss_idtabla_bss`),
  CONSTRAINT `fk_tabla_bss_recurso_recurso1` FOREIGN KEY (`recurso_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tabla_bss_recurso_tabla_bss1` FOREIGN KEY (`tabla_bss_idtabla_bss`) REFERENCES `tabla_bss` (`idtabla_bss`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `traps`
--

DROP TABLE IF EXISTS `traps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `traps` (
  `idTRAPS` int(11) NOT NULL AUTO_INCREMENT,
  `SNMP_idSNMP` int(11) NOT NULL,
  `ip` text,
  PRIMARY KEY (`idTRAPS`),
  KEY `fk_TRAPS_SNMP1_idx` (`SNMP_idSNMP`),
  CONSTRAINT `fk_TRAPS_SNMP1` FOREIGN KEY (`SNMP_idSNMP`) REFERENCES `snmp` (`idSNMP`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ubicaciones`
--

DROP TABLE IF EXISTS `ubicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ubicaciones` (
  `idUBICACIONES` int(11) NOT NULL AUTO_INCREMENT,
  `RECURSO_idRECURSO` int(11) NOT NULL,
  `uriTxA` text,
  `uriTxB` text,
  `uriRxA` text,
  `uriRxB` text,
  `activoTx` int(11) DEFAULT NULL,
  `activoRx` int(11) DEFAULT NULL,
  PRIMARY KEY (`idUBICACIONES`),
  KEY `fk_ubicaciones_recurso1_idx` (`RECURSO_idRECURSO`),
  CONSTRAINT `fk_UBICACIONES_RECURSO1` FOREIGN KEY (`RECURSO_idRECURSO`) REFERENCES `recurso` (`idRECURSO`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `urilistas`
--

DROP TABLE IF EXISTS `urilistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `urilistas` (
  `idURILISTAS` int(11) NOT NULL AUTO_INCREMENT,
  `ip` text,
  PRIMARY KEY (`idURILISTAS`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `web`
--

DROP TABLE IF EXISTS `web`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `web` (
  `idWEB` int(11) NOT NULL AUTO_INCREMENT,
  `wport` int(11) DEFAULT '8080',
  `stime` int(11) DEFAULT '0',
  PRIMARY KEY (`idWEB`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'ug5k'
--

--
-- Dumping routines for database 'ug5k'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_ReportCfg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ReportCfg`(in cfg_id int)
BEGIN
	select cfg.name as cfg_name, cgw.name as cgw_name, h.rank as slave,s.rank as posicion,r.name as resource_name,r.Tipo as resource_tipo,d.name as destination_name,rg.*,ub.*,pt.tipo as tipo_tel,pt.uri_remota,pr.tipo as tipo_rad
	 from cfg
		inner join cgw_cfg cc on cc.CFG_idCFG=cfg.idCFG
		inner join cgw cgw on cgw.idCGW=cc.CGW_idCGW
		inner join hardware h on h.CGW_idCGW=cc.CGW_idCGW
		inner join pos s on s.SLAVES_idSLAVES=h.SLAVES_idSLAVES
		inner join recurso r on r.POS_idPOS=s.idPOS
		left join colateral c on c.RECURSO_idRECURSO=r.idRECURSO
		left join destinos d on d.idDESTINOS=c.DESTINOS_idDESTINOS
		left join paramradio pr on pr.RECURSO_idRECURSO = r.idRECURSO
		left join paramtelef pt on pt.RECURSO_idRECURSO = r.idRECURSO
		left join rangos rg on rg.PARAMTELEF_idPARAMTELEF = pt.idPARAMTELEF
		left join ubicaciones ub on ub.RECURSO_idRECURSO = r.idRECURSO
	WHERE cfg.idCFG=cfg_id
	ORDER BY cgw.name,slave,posicion;  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `alarmas_view`
--

/*!50001 DROP VIEW IF EXISTS `alarmas_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `alarmas_view` AS select `a`.`idHistoricoIncidencias` AS `idHistoricoIncidencias`,`a`.`FechaHora` AS `FechaHora`,`a`.`IdEmplaz` AS `idEmplaz`,`a`.`IdHw` AS `IdHw`,`a`.`TipoHw` AS `TipoHw`,`a`.`Descripcion` AS `descripcion`,`b`.`Nivel` AS `Nivel` from (`historicoincidencias` `a` join `incidencias` `b`) where ((`a`.`IdIncidencia` = `b`.`IdIncidencia`) and (`b`.`LineaEventos` = 1) and isnull(`a`.`Reconocida`)) order by `b`.`Nivel` desc limit 200 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `alivegateways_view`
--

/*!50001 DROP VIEW IF EXISTS `alivegateways_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `alivegateways_view` AS select `c`.`idCGW` AS `idCGW`,`c`.`EMPLAZAMIENTO_idEMPLAZAMIENTO` AS `EMPLAZAMIENTO_idEMPLAZAMIENTO`,`c`.`REGIONES_idREGIONES` AS `REGIONES_idREGIONES`,`c`.`servicio` AS `servicio`,`c`.`name` AS `name`,`c`.`dualidad` AS `dualidad`,`c`.`ipv` AS `ipv`,`c`.`ips` AS `ips`,`c`.`nivelconsola` AS `nivelconsola`,`c`.`puertoconsola` AS `puertoconsola`,`c`.`nivelIncidencias` AS `nivelIncidencias`,`e`.`idEMPLAZAMIENTO` AS `idEMPLAZAMIENTO`,`e`.`name` AS `site`,`cc`.`CFG_idCFG` AS `CFG_idCFG`,`cc`.`Activa` AS `Activa` from (((`cgw` `c` join `cgw_estado` `ce` on((`ce`.`cgw_idCGW` = `c`.`idCGW`))) join `cgw_cfg` `cc` on((`cc`.`CGW_idCGW` = `c`.`idCGW`))) join `emplazamiento` `e` on((`e`.`idEMPLAZAMIENTO` = `ce`.`cgw_EMPLAZAMIENTO_idEMPLAZAMIENTO`))) where ((`ce`.`viva` = 1) and (`cc`.`Activa` or (not(`c`.`ipv` in (select `c2`.`ipv` from (`cgw_cfg` `cc` join `cgw` `c2` on((`c2`.`idCGW` = `cc`.`CGW_idCGW`))) where `cc`.`Activa`))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `info_cgw`
--

/*!50001 DROP VIEW IF EXISTS `info_cgw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `info_cgw` AS select `cgw`.`name` AS `name`,`cgw`.`dualidad` AS `dual_cpu`,`e`.`name` AS `emplazamiento`,`cpu`.`num` AS `num_cpu`,`cgw`.`ipv` AS `virtual_ip`,`cpu`.`tlan` AS `dual_lan`,`cpu`.`ip0` AS `ip_eth0`,`cpu`.`ip1` AS `ip_eth1`,`cpu`.`ipb` AS `bound_ip`,`cpu`.`ipg` AS `gateway_ip` from (((`cgw` join `cpu` on((`cgw`.`idCGW` = `cpu`.`CGW_idCGW`))) join `cgw_cfg` `cc` on(((`cc`.`CGW_idCGW` = `cgw`.`idCGW`) and (`cc`.`Activa` = 1)))) left join `emplazamiento` `e` on((`cgw`.`EMPLAZAMIENTO_idEMPLAZAMIENTO` = `e`.`idEMPLAZAMIENTO`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `spvs_cgw`
--

/*!50001 DROP VIEW IF EXISTS `spvs_cgw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `spvs_cgw` AS select `cgw`.`name` AS `name`,`r`.`name` AS `resource`,`h`.`rank` AS `slave_rank`,`s`.`tp` AS `slave_type`,`r`.`tipo` AS `resource_type`,`p`.`rank` AS `resource_rank`,`dst`.`name` AS `frecuencia`,`param`.`tipo` AS `resource_subtype`,(case when (`param`.`tipo` > 3) then 'True' else 'False' end) AS `remoto` from ((((((((`recurso` `r` join `pos` `p` on((`p`.`idPOS` = `r`.`POS_idPOS`))) join `slaves` `s` on((`s`.`idSLAVES` = `p`.`SLAVES_idSLAVES`))) join `hardware` `h` on((`h`.`SLAVES_idSLAVES` = `s`.`idSLAVES`))) join `cgw` on((`cgw`.`idCGW` = `h`.`CGW_idCGW`))) join `cgw_cfg` `cc` on(((`cc`.`CGW_idCGW` = `cgw`.`idCGW`) and (`cc`.`Activa` = 1)))) left join `paramradio` `param` on((`param`.`RECURSO_idRECURSO` = `r`.`idRECURSO`))) left join `colateral` `col` on((`col`.`RECURSO_idRECURSO` = `r`.`idRECURSO`))) left join `destinos` `dst` on((`dst`.`idDESTINOS` = `col`.`DESTINOS_idDESTINOS`))) order by `cgw`.`name`,`h`.`rank`,`p`.`rank` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `spvs_site`
--

/*!50001 DROP VIEW IF EXISTS `spvs_site`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `spvs_site` AS select `e`.`idEMPLAZAMIENTO` AS `idEMPLAZAMIENTO`,`e`.`name` AS `name` from (`emplazamiento` `e` join `cfg` `c` on((`c`.`idCFG` = `e`.`cfg_idCFG`))) where (`c`.`activa` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-24  9:02:09
