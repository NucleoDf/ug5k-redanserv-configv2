-- MySQL dump 10.13  Distrib 5.6.23, for Win32 (x86)
--
-- Host: localhost    Database: ug5kv2
-- ------------------------------------------------------
-- Server version	5.6.11

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
-- Table structure for table `configuraciones`
--

DROP TABLE IF EXISTS `configuraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuraciones` (
  `idconfiguracion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria de la tabla. Tabla para almacenar las distintas configuraciones que se pueden crear en l esquema.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre que se le da a la configuración. Tiene que ser único en la BBDD.',
  `descripcion` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Información adicional de la configuración.',
  `region` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Región a la que pertenece la configuración.',
  `activa` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Estado activo (1) o Inactivo (0). Sólo puede haber una activa a la vez.',
  `fecha_activacion` datetime DEFAULT NULL COMMENT 'Fecha en la que se ha activado la configuración.',
  PRIMARY KEY (`idconfiguracion`),
  UNIQUE KEY `name_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES (8,'MADRID-CENTRO','Zona Madrid Centro',NULL,0,'2017-09-07 10:33:03'),(10,'MADRID-CENTRO-BKP','Copia de la configuracion activa',NULL,1,'2017-11-21 15:14:48'),(11,'OtraCopia','',NULL,0,NULL);
/*!40000 ALTER TABLE `configuraciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ug5kv2`.`configuraciones_BEFORE_DELETE` BEFORE DELETE ON `configuraciones` FOR EACH ROW
BEGIN
DECLARE specialty CONDITION FOR SQLSTATE '45001';
	IF old.activa=1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Active config cannot be deleted', MYSQL_ERRNO = 1001;
      END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `emplazamiento`
--

DROP TABLE IF EXISTS `emplazamiento`;
/*!50001 DROP VIEW IF EXISTS `emplazamiento`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `emplazamiento` AS SELECT 
 1 AS `idEMPLAZAMIENTO`,
 1 AS `cfg_idCFG`,
 1 AS `name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `emplazamientos`
--

DROP TABLE IF EXISTS `emplazamientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emplazamientos` (
  `idemplazamiento` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria de la tabla. Tabla que representa los emplazamientos en los que se pueden situar pasarelas.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre que se le da al emplazamiento. Tiene que ser único en la configuración.',
  `configuracion_id` int(11) NOT NULL COMMENT 'Cave externa a tabla gateway',
  PRIMARY KEY (`idemplazamiento`),
  KEY `fk_gateway_id_idx` (`configuracion_id`),
  CONSTRAINT `fk_config_emp` FOREIGN KEY (`configuracion_id`) REFERENCES `configuraciones` (`idconfiguracion`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emplazamientos`
--

LOCK TABLES `emplazamientos` WRITE;
/*!40000 ALTER TABLE `emplazamientos` DISABLE KEYS */;
INSERT INTO `emplazamientos` VALUES (21,'ACC',8),(22,'TWR-N',8),(23,'ALCOLEA',8),(27,'ACC',10),(28,'TWR-N',10),(29,'ALCOLEA',10),(30,'ACC1',11),(31,'TWR-N',11),(32,'ALCOLEA',11);
/*!40000 ALTER TABLE `emplazamientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historicoincidencias`
--

DROP TABLE IF EXISTS `historicoincidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historicoincidencias` (
  `idHistoricoIncidencias` int(11) NOT NULL AUTO_INCREMENT,
  `IdEmplaz` varchar(32) COLLATE latin1_spanish_ci DEFAULT NULL,
  `IdHw` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `TipoHw` varchar(20) COLLATE latin1_spanish_ci NOT NULL,
  `IdIncidencia` int(10) unsigned NOT NULL,
  `FechaHora` datetime NOT NULL,
  `Reconocida` datetime DEFAULT NULL,
  `Descripcion` varchar(300) COLLATE latin1_spanish_ci DEFAULT NULL,
  `Usuario` varchar(64) COLLATE latin1_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`idHistoricoIncidencias`,`IdHw`),
  KEY `HistoricoIncidencias_FKIndex1` (`IdIncidencia`),
  KEY `HistoricoIncidenciasIndex` (`IdHw`,`TipoHw`,`IdIncidencia`,`FechaHora`),
  CONSTRAINT `historicoincidencias_ibfk_1` FOREIGN KEY (`IdIncidencia`) REFERENCES `incidencias` (`IdIncidencia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=660 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
INSERT INTO `historicoincidencias` VALUES (579,NULL,'CFG','SEGURIDAD',50,'2017-11-14 08:50:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(580,NULL,'CFG','CONF-R',116,'2017-11-14 08:51:16',NULL,'Modificación de Parámetros Lógicos de  Recurso F004.','admin (a)'),(581,NULL,'CFG','CONF-R',116,'2017-11-14 08:51:30',NULL,'Modificación de Parámetros Lógicos de  Recurso F004.','admin (a)'),(582,NULL,'CFG','CONF-R',116,'2017-11-14 08:53:38',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','admin (a)'),(583,NULL,'CFG','CONF-R',116,'2017-11-14 08:57:13',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','admin (a)'),(584,NULL,'CFG','SEGURIDAD',55,'2017-11-14 08:59:07',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(585,NULL,'CFG','SEGURIDAD',50,'2017-11-14 08:59:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(586,NULL,'CFG','CONF-R',116,'2017-11-14 08:59:44',NULL,'Modificación de Parámetros Lógicos de  Recurso LC01.','admin (a)'),(587,NULL,'CFG','SEGURIDAD',55,'2017-11-14 09:00:11',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(588,NULL,'CFG','SEGURIDAD',50,'2017-11-14 10:43:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(589,NULL,'CFG','CONF-R',116,'2017-11-14 10:44:07',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','admin (a)'),(590,NULL,'CFG','SEGURIDAD',55,'2017-11-14 12:43:26',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','admin'),(591,NULL,'CFG','SEGURIDAD',50,'2017-11-14 14:22:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(592,NULL,'CFG','SEGURIDAD',55,'2017-11-14 14:35:51',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(593,NULL,'CFG','SEGURIDAD',50,'2017-11-14 14:38:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(594,NULL,'CFG','SEGURIDAD',55,'2017-11-14 14:39:41',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(595,NULL,'CFG','SEGURIDAD',50,'2017-11-14 14:55:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(596,NULL,'CFG','CONF-R',116,'2017-11-14 14:56:55',NULL,'Modificación de Parámetros Lógicos de  Recurso TR001.','admin (a)'),(597,NULL,'CFG','CONF-R',116,'2017-11-14 14:57:24',NULL,'Modificación de Parámetros Lógicos de  Recurso TR002.','admin (a)'),(598,NULL,'CFG','CONF-R',116,'2017-11-14 14:57:33',NULL,'Modificación de Parámetros Lógicos de  Recurso TR003.','admin (a)'),(599,NULL,'CFG','CONF-R',116,'2017-11-14 14:57:43',NULL,'Modificación de Parámetros Lógicos de  Recurso TR004.','admin (a)'),(600,NULL,'CFG','CONF-R',116,'2017-11-14 14:58:10',NULL,'Modificación de Parámetros Lógicos de  Recurso RR001.','admin (a)'),(601,NULL,'CFG','CONF-R',116,'2017-11-14 14:58:19',NULL,'Modificación de Parámetros Lógicos de  Recurso RR002.','admin (a)'),(602,NULL,'CFG','CONF-R',116,'2017-11-14 14:58:26',NULL,'Modificación de Parámetros Lógicos de  Recurso RR003.','admin (a)'),(603,NULL,'CFG','CONF-R',116,'2017-11-14 14:58:33',NULL,'Modificación de Parámetros Lógicos de  Recurso RR004.','admin (a)'),(604,NULL,'CFG','CONF-R',105,'2017-11-14 14:58:39',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(605,NULL,'CFG','CONF-R',116,'2017-11-14 15:02:57',NULL,'Modificación de Parámetros Lógicos de  Recurso RR001.','admin (a)'),(606,NULL,'CFG','CONF-R',105,'2017-11-14 15:03:27',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(607,NULL,'CFG','CONF-R',109,'2017-11-14 15:03:50',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-01.','admin (a)'),(608,NULL,'CFG','CONF-R',105,'2017-11-14 15:04:02',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(609,NULL,'CFG','CONF-R',116,'2017-11-14 15:04:42',NULL,'Modificación de Parámetros Lógicos de  Recurso TR001.','admin (a)'),(610,NULL,'CFG','CONF-R',105,'2017-11-14 15:04:49',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(611,NULL,'CFG','SEGURIDAD',50,'2017-11-15 10:00:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(612,NULL,'CFG','CONF-R',116,'2017-11-15 10:00:32',NULL,'Modificación de Parámetros Lógicos de  Recurso TR001.','admin (a)'),(613,NULL,'CFG','CONF-R',105,'2017-11-15 10:00:51',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(614,NULL,'CFG','SEGURIDAD',50,'2017-11-15 13:59:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(615,NULL,'CFG','SEGURIDAD',55,'2017-11-15 14:00:16',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(616,NULL,'CFG','SEGURIDAD',51,'2017-11-15 14:00:19',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Password incorrecta..','2'),(617,NULL,'CFG','SEGURIDAD',51,'2017-11-15 14:00:26',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Password incorrecta..','2'),(618,NULL,'CFG','SEGURIDAD',50,'2017-11-15 14:00:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','2'),(619,NULL,'CFG','SEGURIDAD',50,'2017-11-16 10:45:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(620,NULL,'CFG','SEGURIDAD',54,'2017-11-16 11:02:24',NULL,'Modificado Usuario 2.','admin (a)'),(621,NULL,'CFG','SEGURIDAD',54,'2017-11-16 11:02:31',NULL,'Modificado Usuario 2.','admin (a)'),(622,NULL,'CFG','SEGURIDAD',55,'2017-11-16 11:02:36',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(623,NULL,'CFG','SEGURIDAD',50,'2017-11-16 11:02:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','2'),(624,NULL,'CFG','SEGURIDAD',55,'2017-11-16 11:03:14',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','2'),(625,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:20:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(626,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:23:57',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(627,NULL,'CFG','SEGURIDAD',51,'2017-11-16 14:24:00',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Password incorrecta..','2'),(628,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:24:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','2'),(629,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:24:13',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','2'),(630,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:24:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(631,NULL,'CFG','SEGURIDAD',52,'2017-11-16 14:26:48',NULL,'Alta Usuario vis.','admin (a)'),(632,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:26:51',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(633,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:26:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','vis'),(634,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:27:18',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','vis'),(635,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:27:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(636,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:28:05',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(637,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:30:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(638,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:38:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(639,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:40:46',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(640,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:43:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(641,NULL,'CFG','SEGURIDAD',55,'2017-11-16 14:51:42',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(642,NULL,'CFG','SEGURIDAD',50,'2017-11-16 14:56:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(643,NULL,'CFG','CONF-R',109,'2017-11-16 14:58:07',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-02.','admin (a)'),(644,NULL,'CFG','CONF-R',105,'2017-11-16 14:58:14',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(645,NULL,'CFG','CONF-R',109,'2017-11-16 14:58:57',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-02.','admin (a)'),(646,NULL,'CFG','CONF-R',109,'2017-11-16 14:59:20',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-02.','admin (a)'),(647,NULL,'CFG','CONF-R',105,'2017-11-16 14:59:27',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(648,NULL,'CFG','CONF-R',109,'2017-11-16 15:00:34',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-02.','admin (a)'),(649,NULL,'CFG','CONF-R',105,'2017-11-16 15:00:40',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(650,NULL,'CFG','CONF-R',109,'2017-11-16 15:01:04',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-02.','admin (a)'),(651,NULL,'CFG','CONF-R',105,'2017-11-16 15:01:10',NULL,'Carga de Configuración Remota MADRID-CENTRO.','admin (a)'),(652,NULL,'CFG','SEGURIDAD',55,'2017-11-16 15:05:52',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','admin'),(653,NULL,'CFG','SEGURIDAD',50,'2017-11-17 08:45:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','admin'),(654,NULL,'CFG','SEGURIDAD',50,'2017-11-21 15:08:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(655,NULL,'CFG','SEGURIDAD',55,'2017-11-21 16:08:48',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(656,NULL,'CFG','SEGURIDAD',50,'2017-11-21 16:10:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(657,NULL,'CFG','CONF-R',105,'2017-11-21 16:14:48',NULL,'Carga de Configuración Remota MADRID-CENTRO-BKP.','1 (a)'),(658,NULL,'CFG','CONF-R',105,'2017-11-21 16:14:48',NULL,'Carga de Configuración Remota undefined.','1 (a)'),(659,NULL,'CFG','SEGURIDAD',50,'2017-11-21 16:31:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1');
/*!40000 ALTER TABLE `historicoincidencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencias`
--

DROP TABLE IF EXISTS `incidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incidencias` (
  `IdIncidencia` int(10) unsigned NOT NULL,
  `Incidencia` varchar(180) COLLATE latin1_spanish_ci NOT NULL,
  `Descripcion` varchar(180) COLLATE latin1_spanish_ci NOT NULL,
  `LineaEventos` tinyint(1) NOT NULL,
  `Grupo` varchar(20) COLLATE latin1_spanish_ci NOT NULL,
  `Error` tinyint(1) NOT NULL DEFAULT '0',
  `Nivel` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IdIncidencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencias`
--

LOCK TABLES `incidencias` WRITE;
/*!40000 ALTER TABLE `incidencias` DISABLE KEYS */;
INSERT INTO `incidencias` VALUES (47,'Inicio sesión RCS2010 UG5KR','Inicio sesión RCS2010 UG5KR  del usuario: {0}',0,'SEGURIDAD',0,0),(48,'Recahazada sesión RCS2010 UG5KR','Rechazada sesión RCS2010 UG5KR  al usuario: {0}',0,'SEGURIDAD',0,0),(49,'Fin sesion RCS2010 UG5KR','Fin sesion RCS2010 UG5KR  del usuario: {0}',0,'SEGURIDAD',0,0),(50,'Inicio sesión Configuración Centralizada','Inicio sesión Configuración Centralizada  del usuario',1,'SEGURIDAD',0,0),(51,'Rechazado  sesión Configuración Centralizada','Rechazada sesión Configuración Centralizada  del usuario ',1,'SEGURIDAD',0,2),(52,'Alta Usuario','Alta Usuario',0,'SEGURIDAD',0,0),(53,'Borrado Usuario','Borrado Usuario ',0,'SEGURIDAD',0,0),(54,'Modificado Usuario','Modificado Usuario',0,'SEGURIDAD',0,0),(55,'Fin sesion  Configuración Centralizada ','Fin sesion  Configuración Centralizada  del usuario ',1,'SEGURIDAD',0,1),(105,'Carga de Configuración Remota','Carga de Configuración Remota',0,'CONF-R',0,0),(106,'Error Carga Configuración Remota','Error Carga Configuración Remota',0,'CONF-R',0,0),(107,'Alta de Pasarela','Alta de Pasarela',0,'CONF-R',0,0),(108,'Baja de Pasarela','Baja de Pasarela',0,'CONF-R',0,0),(109,'Modificación de Parámetros Generales de Pasarela','Modificación de Parámetros Generales de Pasarela',0,'CONF-R',0,0),(113,'Alta de Recurso','Alta de Recurso',0,'CONF-R',0,0),(114,'Baja de Recurso','Baja de Recurso',0,'CONF-R',0,0),(116,'Modificación de Parámetros Lógicos de  Recurso','Modificación de Parámetros Lógicos de  Recurso',0,'CONF-R',0,0),(117,'Baja de Tabla de Calificación de Audio','Baja de Tabla de Calificación de Audio',0,'CONF-R',0,0),(118,'Alta de Tabla de Calificación de Audio','Alta de Tabla de Calificación de Audio',0,'CONF-R',0,0),(150,'Modificación de Parámetros Generales de Pasarela.','Modificación Parámetro en: {0}. {1}',0,'CONF-L',0,0),(153,'Modificación de Parámetros Lógico de Recurso','Modificación SW en Recurso: {0}. {1}. {2}',0,'CONF-L',0,0),(154,'Generación de Configuración por Defecto.','Generación de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(155,'Activación de Configuración por Defecto.','Activación de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(156,'Borrado de Configuración por Defecto','Borrado de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(157,'Alta Recurso Radio','Recurso Radio  Añadido: {0}. {1}. {2}',0,'CONF-L',0,0),(158,'Baja Recurso Radio','Recurso Radio Eliminado: {0}. {1}. {2}',0,'CONF-L',0,0),(159,'Alta Recurso Telefonía','Recurso Telefónico Añadido: {0}. {1}. {2}',0,'CONF-L',0,0),(160,'Baja Recurso Telefonía','Recurso Telefónico  Eliminado: {0} . {1} . {2}',0,'CONF-L',0,0),(161,'Conflicto de configuraciones','Conflicto de Configuración en GW: {0}. {1}. {2}',0,'CONF-L',0,0),(180,'Carga versión Software Pasarela','Carga de Versión Software Pasarela: {0} {1}',0,'MAN-L',0,0),(182,'Reset Remoto','Reset Remoto: {0}',0,'MAN-L',0,0),(183,'Selección Bucle Prueba','Selección Bucle: {0} {1}  en {2}.',0,'MAN-L',0,0),(184,'Comando Bite','Selección  BITE: {0}',0,'MAN-L',0,0),(185,'Conmutacion P/R','Selección Conmutación P/R: {0}',0,'MAN-L',0,0),(186,'Selección Modo','Selección Modo: {0}',0,'MAN-L',0,0),(187,'Resultado Comando Bite','Resultado  BITE: {0} : {1}',0,'MAN-L',0,0),(193,'Resultado  bucle prueba','Resultado Bucle: {0} en {1} : {2}',0,'MAN-L',0,0),(195,'Resultado Conmutacion P/R','Resultado  Conmutación P/R: {0} {1}',0,'MAN-L',0,0),(196,'Resultado  Modo','Resultado  Modo: {0}',0,'MAN-L',0,0),(201,'Arranque APP RCS2010','Arranque APP RCS2010 UG5KR en puesto: {0}',1,'SP-GEN',0,2),(202,'Cierre Aplicacion APP RCS2010','Cierre Aplicacion APP RCS2010 UG5KR  en puesto: {0}',1,'SP-GEN',0,2),(2000,'Cambio estado Pasarela','Cambio estado pasarela: {0}',1,'SP-PASARELA',0,2),(2003,'Cambio Estado LAN','Cambio Estado LANs. CGW: {0} : LAN1 {1}  : LAN2 {2}',1,'SP-PASARELA',0,1),(2005,'Cambio Estado CPU','Cambio Estado CPUs. CGW: {0} : CPU Local {1}  : CPU Dual {2}',1,'SP-PASARELA',0,2),(2007,'Conexión Recurso Radio','Conexión Recurso Radio: {0}',1,'SP-PASARELA',0,0),(2008,'Desconexión Recurso Radio','Desconexión Recurso Radio: {0}',1,'SP-PASARELA',1,0),(2009,'Conexión Recurso Telefonía','Conexión Recurso Telefonía: {0}',1,'SP-PASARELA',0,0),(2010,'Desconexión Recurso Telefonía','Desconexión Recurso Telefonía: {0}',1,'SP-PASARELA',1,0),(2011,'Conexión Tarjeta Interfaz (esclava-tipo)','Conexión Tarjeta Interfaz. Número: {0}: Tipo: {1}',1,'SP-PASARELA',0,0),(2012,'Desconexión Tarjeta Interfaz (esclava-tipo)','Desconexión Tarjeta Interfaz. Número: {0}: Tipo: {1}',1,'SP-PASARELA',1,0),(2013,'Conexión Recurso R2','Conexión Recurso R2: {0}',1,'SP-PASARELA',0,0),(2014,'Desconexión Recurso R2.','Desconexión Recurso R2: {0}',1,'SP-PASARELA',1,0),(2015,'Conexión Recurso N5','Conexión Recurso N5: {0}',1,'SP-PASARELA',0,0),(2016,'Desconexión Recurso N5','Desconexión Recurso N5: {0}',1,'SP-PASARELA',1,0),(2017,'Conexión Recurso QSIG','Conexión Recurso QSIG: {0}',1,'SP-PASARELA',0,0),(2018,'Desconexión Recurso  QSIG','Desconexión Recurso QSIG: {0}',1,'SP-PASARELA',1,0),(2019,'Conexión Recurso LCEN','Conexión Recurso LCEN: {0}',1,'SP-PASARELA',0,0),(2020,'Desconexión Recurso  LCEN','Desconexión Recurso  LCEN: {0}',1,'SP-PASARELA',1,0),(2021,'Servicio NTP Conectado','Servicio NTP Conectado',1,'SP-PASARELA',0,0),(2022,'Servicio NTP Desconectado','Servicio NTP Desconectado',1,'SP-PASARELA',1,0),(2027,'Cambio estado Sincro BD.','Cambio estado Sincro BD: {0}',1,'SP-PASARELA',0,0),(2101,'Caída/establecimiento sesión SIP','Cambio sesión SIP. Recurso: {0} Sesión:  {1} {2} {3} ',1,'SP-RADIO',0,0),(2102,'Cambio PTT','Cambio estado PTT. Recurso: {0} Estado: {1}',0,'SP-RADIO',0,0),(2103,'Cambio SQU','Cambio estado SQU. Recurso: {0} Estado: {1}',0,'SP-RADIO',0,0),(2200,'Error Protocolo LCEN','Error Protocolo LCEN. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2202,'Fallo test LCEN VoIP (mensaje Options)','Fallo test LCEN VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2203,'Error Protocolo R2','Error Protocolo R2. Recurso: {0}.',1,'SP-TELEFONIA',1,0),(2204,'Fallo llamada de test R2 SCV','Fallo llamada de test R2 SCV. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2205,'Fallo llamada de test R2 VoIP (mensaje Options)','Fallo llamada de test R2 VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2206,'Error Protocolo N5','Error Protocolo N5. Recurso: {0}.',1,'SP-TELEFONIA',1,0),(2207,'Fallo llamada de test N5 SCV','Fallo llamada de test N5 SCV. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2208,'Fallo llamada de test N5 VoIP (mensaje Options)','Fallo llamada de test N5 VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0);
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
-- Table structure for table `lista_ips`
--

DROP TABLE IF EXISTS `lista_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lista_ips` (
  `idlista_ips` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Campo Clave. Representa una lista de ips que se introducen como diversos parámetros para pasarelas, servicios, etc.',
  `pasarela_id` int(11) NOT NULL COMMENT 'Clave externa a pasarela',
  `ip` varchar(25) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor de la dirección ip. En el caso de los Traps se almacena la versión seguido de una coma, la ip, una barra y el puerto.',
  `tipo` varchar(5) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Tipo de IP: PROXY: PROXY, RGTRS: REGISTRAR, NTP: SERVIDOR NTP, TRPV1: IP PARA TRAPS V1, TRPV2: IP PARA TRAPS V2',
  `selected` tinyint(1) DEFAULT '0' COMMENT 'Indica si se encuentra seleccionado ese valor',
  PRIMARY KEY (`idlista_ips`),
  KEY `fk_pasarela_lista_ips_idx` (`pasarela_id`),
  CONSTRAINT `fk_pasarela_lista_ips` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=856 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
INSERT INTO `lista_ips` VALUES (669,16,'10.1.1.100','PRX',0),(670,16,'10.1.1.200','NTP',0),(671,16,'2,10.1.1.200/162','TRPV2',0),(672,17,'10.1.1.100','PRX',0),(673,17,'10.1.1.200','NTP',0),(674,17,'2,10.1.1.200/162','TRPV2',0),(675,18,'10.1.1.100','PRX',0),(676,18,'10.1.1.200','NTP',0),(677,18,'2,10.1.1.200/162','TRPV2',0),(723,24,'10.1.1.100','PRX',0),(724,24,'10.1.1.200','NTP',0),(725,24,'2,10.1.1.200/162','TRPV2',0),(751,34,'10.1.1.100','PRX',0),(752,34,'10.1.1.200','NTP',0),(753,34,'2,10.1.1.200/162','TRPV2',0),(754,35,'10.1.1.100','PRX',0),(755,35,'10.1.1.200','NTP',0),(756,35,'2,10.1.1.200/162','TRPV2',0),(757,36,'10.1.1.100','PRX',0),(758,36,'10.1.1.200','NTP',0),(759,36,'2,10.1.1.200/162','TRPV2',0),(760,37,'10.1.1.100','PRX',0),(761,37,'10.1.1.200','NTP',0),(762,37,'2,10.1.1.200/162','TRPV2',0),(778,45,'10.1.1.100','PRX',0),(779,45,'10.1.1.200','NTP',0),(780,46,'10.1.1.100','PRX',0),(781,46,'10.1.1.200','NTP',0),(782,46,'2,10.1.1.200/162','TRPV2',0),(783,47,'10.1.1.100','PRX',0),(784,47,'10.1.1.200','NTP',0),(785,47,'2,10.1.1.200/162','TRPV2',0),(786,48,'10.1.1.100','PRX',0),(787,48,'10.1.1.200','NTP',0),(788,48,'2,10.1.1.200/162','TRPV2',0),(789,49,'10.1.1.100','PRX',0),(790,49,'10.1.1.200','NTP',0),(791,49,'2,10.1.1.200/162','TRPV2',0),(792,50,'10.1.1.100','PRX',0),(793,50,'10.1.1.200','NTP',0),(794,50,'2,10.1.1.200/162','TRPV2',0),(798,52,'10.1.1.100','PRX',0),(799,52,'10.1.1.200','NTP',0),(800,33,'10.1.1.100','PRX',0),(801,33,'10.1.1.200','NTP',0),(802,33,'2,10.1.1.200/162','TRPV2',0),(803,53,'10.1.1.100','PRX',0),(804,53,'10.1.1.200','NTP',0),(840,15,'10.1.1.100','PRX',0),(841,15,'10.1.1.200','NTP',0),(842,15,'2,10.1.1.200/162','TRPV2',0),(843,19,'10.1.1.100','PRX',0),(844,19,'10.1.1.200','NTP',0),(845,19,'2,10.1.1.200/162','TRPV2',0),(852,39,'10.1.1.100','PRX',0),(853,39,'10.1.1.200','NTP',0),(854,32,'10.1.1.100','PRX',0),(855,32,'10.1.1.200','NTP',0);
/*!40000 ALTER TABLE `lista_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lista_uris`
--

DROP TABLE IF EXISTS `lista_uris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lista_uris` (
  `idlista_uris` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave Primaria. Representa una lista de uris que se introducen como diversos parámetros para pasarelas, servicios, etc. Solo para recursos radio.',
  `recurso_radio_id` int(11) NOT NULL COMMENT 'Clave externa a recurso.',
  `uri` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor de la dirección ip. Puede ser usuario@ip:puerto',
  `tipo` varchar(3) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Tipo de URI: TXA: TRANSMISION A, TXB: TRANSMISION B, RXA: RECEPCION A, RXB: RECEPCION B, LSB: LISTA BLANCA, LSN: LISTA NEGRA, TEL: TELEFONIA.',
  `nivel_colateral` int(1) NOT NULL DEFAULT '0' COMMENT 'Es el nivel de relación que va a existir entre las uris. Va desde 1 a 6. \n1: Emplazamiento1 TXA - RXA\n2: Emplazamiento1 TXB - RXB\n3: Emplazamiento2 TXA - RXA\n4: Emplazamiento2 TXB - RXB\n5: Emplazamiento3 TXA - RXA\n6: Emplazamiento3 TXB - RXB',
  PRIMARY KEY (`idlista_uris`),
  KEY `fk_recurso_radio_uri` (`recurso_radio_id`),
  CONSTRAINT `fk_recurso_radio_uri` FOREIGN KEY (`recurso_radio_id`) REFERENCES `recursos_radio` (`idrecurso_radio`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_uris`
--

LOCK TABLES `lista_uris` WRITE;
/*!40000 ALTER TABLE `lista_uris` DISABLE KEYS */;
INSERT INTO `lista_uris` VALUES (83,54,'sip:TR001@10.3.1.0:5060','TXA',1),(84,54,'sip:TR001@10.3.1.0:5060','RXA',1),(86,55,'sip:TR002@10.3.1.0:5060','TXA',1),(87,55,'sip:TR002@10.3.1.0:5060','RXA',1),(93,58,'sip:TT003@10.3.1.0:5060','TXA',1),(94,58,'sip:RR003@10.3.1.0:5060','RXA',1),(99,64,'sip:TT001@10.3.1.0:5060','TXA',1),(100,64,'sip:RR001@10.3.1.0:5060','RXA',1),(101,59,'sip:TR001@10.3.1.0:5060','TXA',1),(102,59,'sip:TR001@10.3.1.0:5060','RXA',1),(117,108,'sip:TT001@10.3.1.0:5060','TXA',1),(118,108,'sip:RR001@10.3.1.0:5060','RXA',1),(119,109,'sip:TT003@10.3.1.0:5060','TXA',1),(120,109,'sip:RR003@10.3.1.0:5060','RXA',1),(121,110,'sip:TR001@10.3.1.0:5060','TXA',1),(122,110,'sip:TR001@10.3.1.0:5060','RXA',1),(123,111,'sip:RR001@10.3.1.0:5060','TXA',1),(124,111,'sip:TT001@10.3.1.0:5060','RXA',1),(125,112,'sip:TR001@10.3.1.0:5060','TXA',1),(126,112,'sip:TR001@10.3.1.0:5060','RXA',1),(127,113,'sip:TR002@10.3.1.0:5060','TXA',1),(128,113,'sip:TR002@10.3.1.0:5060','RXA',1),(129,114,'sip:TT001@10.3.1.0:5060','TXA',1),(130,114,'sip:RR001@10.3.1.0:5060','RXA',1),(131,211,'sip:TT001@10.3.1.0:5060','TXA',1),(132,211,'sip:RR001@10.3.1.0:5060','RXA',1),(133,212,'sip:TT003@10.3.1.0:5060','TXA',1),(134,212,'sip:RR003@10.3.1.0:5060','RXA',1),(135,213,'sip:TR001@10.3.1.0:5060','TXA',1),(136,213,'sip:TR001@10.3.1.0:5060','RXA',1),(137,214,'sip:RR001@10.3.1.0:5060','TXA',1),(138,214,'sip:TT001@10.3.1.0:5060','RXA',1),(139,215,'sip:TR001@10.3.1.0:5060','TXA',1),(140,215,'sip:TR001@10.3.1.0:5060','RXA',1),(141,216,'sip:TR002@10.3.1.0:5060','TXA',1),(142,216,'sip:TR002@10.3.1.0:5060','RXA',1),(143,217,'sip:TT001@10.3.1.0:5060','TXA',1),(144,217,'sip:RR001@10.3.1.0:5060','RXA',1),(155,60,'sip:RR001@10.3.1.0:5060','TXA',1),(156,60,'sip:TT001@10.3.1.0:5060','RXA',1),(157,53,'sip:pedro@1.1.1.1','LSN',0),(166,50,'sip:negra@1.1.1.1','LSN',0),(167,50,'sip:blanca@1.1.1.1','LSB',0),(172,57,'sip:rtx1@2.2.2.2','TXA',1),(173,57,'sip:rtx1@2.2.2.2','RXA',1),(176,43,'sip:negra@1.1.1.1','LSN',0),(177,43,'sip:blanca@1.1.1.1','LSB',0),(178,44,'sip:negra@1.1.1.1','LSN',0),(179,44,'sip:blanca@1.1.1.1','LSB',0),(180,45,'sip:negra@1.1.1.1','LSN',0),(181,45,'sip:blanca@1.1.1.1','LSB',0),(184,47,'sip:negra@1.1.1.1','LSN',0),(185,47,'sip:blanca@1.1.1.1','LSB',0),(186,48,'sip:negra@1.1.1.1','LSN',0),(187,48,'sip:blanca@1.1.1.1','LSB',0),(188,49,'sip:negra@1.1.1.1','LSN',0),(189,49,'sip:blanca@1.1.1.1','LSB',0),(190,46,'sip:negra@1.1.1.1','LSN',0),(191,46,'sip:blanca@1.1.1.1','LSB',0);
/*!40000 ALTER TABLE `lista_uris` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `lista_uris_BINS` BEFORE INSERT ON lista_uris FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	IF (NEW.uri NOT LIKE 'sip:%') THEN
		set NEW.uri = CONCAT('sip:', NEW.uri);
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `operadores`
--

DROP TABLE IF EXISTS `operadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operadores` (
  `idOPERADORES` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave Primaria. Tabla que almacena los usuarios de la web así como los del resto de aplicaciones y de las pasarelas.',
  `name` varchar(32) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre de usuario.',
  `clave` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Password encriptado del usuario.',
  `perfil` int(1) unsigned NOT NULL COMMENT 'Máscara de bits para asignar los distintos roles de usuario.',
  PRIMARY KEY (`idOPERADORES`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operadores`
--

LOCK TABLES `operadores` WRITE;
/*!40000 ALTER TABLE `operadores` DISABLE KEYS */;
INSERT INTO `operadores` VALUES (1,'root','MQ==',320),(2,'1','MQ==',320),(3,'admin','MQ==',64),(4,'gw-vis','MQ==',128),(6,'mando','MQ==',3),(7,'2','MQ==',512),(9,'todo','MQ==',49115),(10,'soyelusuarionumero1','MQ==',320),(11,'vis','MQ==',1);
/*!40000 ALTER TABLE `operadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasarela_operadores`
--

DROP TABLE IF EXISTS `pasarela_operadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pasarela_operadores` (
  `idpasarela_operadores` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria. Relación entre pasarelas y operadores.',
  `pasarela_id` int(11) NOT NULL COMMENT 'Clave externa a pasarela.',
  `operadores_id` int(11) NOT NULL COMMENT 'Clave externa a operadores.',
  PRIMARY KEY (`idpasarela_operadores`),
  KEY `fk_pasarela_pasarela_operadores_idx` (`pasarela_id`),
  KEY `fk_operadores_pasarela_operadores_idx` (`operadores_id`),
  CONSTRAINT `fk_operadores_pasarela_operadores` FOREIGN KEY (`operadores_id`) REFERENCES `operadores` (`idOPERADORES`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_pasarela_pasarela_operadores` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasarela_operadores`
--

LOCK TABLES `pasarela_operadores` WRITE;
/*!40000 ALTER TABLE `pasarela_operadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `pasarela_operadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasarelas`
--

DROP TABLE IF EXISTS `pasarelas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pasarelas` (
  `idpasarela` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave Primaria. Representa la unidad fundamental de la pasarela. Lleva con atributos todos los datos a sus servicios así como referencias a recursos hardware asociados.',
  `emplazamiento_id` int(11) NOT NULL COMMENT 'Clave externa a la tabla emplazamiento.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre de la pasarela.',
  `ip_virtual` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Dirección ip virtual que se le asigna a la pasarela.',
  `ultima_actualizacion` datetime DEFAULT NULL COMMENT 'Fecha en la que se ha cargado la última actualización a la pasarela.',
  `ip_cpu0` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Dirección ip de la cpu 0.',
  `ip_gtw0` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Dirección ip de la puerta de enlace para la cpu0.',
  `mask_cpu0` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Máscara de red para la cpu0.',
  `ip_cpu1` varchar(15) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección ip de la cpu 1.',
  `ip_gtw1` varchar(15) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección ip de la puerta de enlace para la cpu1.',
  `mask_cpu1` varchar(15) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Máscara de red para la cpu0.',
  `puerto_sip` int(5) DEFAULT '5060' COMMENT 'Valor del puerto para el campo SIP',
  `periodo_supervision` int(6) NOT NULL DEFAULT '90' COMMENT 'Tiempo en segundos para el valor supervisión. Entre 90 y 1800.',
  `puerto_servicio_snmp` int(5) DEFAULT '65000' COMMENT 'Valor del puerto para el servicio snmp.',
  `puerto_snmp` int(5) DEFAULT '161' COMMENT 'Valor del puerto para el snmp.',
  `snmpv2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indica si usa snmp versión 2. (1) Verdadero, (0) Falso.',
  `comunidad_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'public' COMMENT 'Comunidad SNMP V2. Por defecto public',
  `nombre_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'ULISESG5000i' COMMENT 'Nombre del servicio snmp.',
  `localizacion_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF LABS' COMMENT 'Localización del servicio snmp.',
  `contacto_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF DT. MADRID. SPAIN' COMMENT 'Dirección de contacto del servicio snmp.',
  `puerto_servicio_web` int(5) DEFAULT NULL COMMENT 'Valor del puerto para el servicio web.',
  `tiempo_sesion` int(6) NOT NULL DEFAULT '0' COMMENT 'Tiempo en segundos de la sesión.',
  `puerto_rtsp` int(5) DEFAULT NULL COMMENT 'Valor para el puerto rtsp.',
  `servidor_rtsp` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección del servidor rtsp.',
  `servidor_rtspb` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección del servidor rtsp 2 o B',
  `pendiente_actualizar` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indica si está pendiente de aplicar cambios (1) o no (0) para poder actualizar la fecha ultima_actualizacion que se manda a la pasarela física',
  PRIMARY KEY (`idpasarela`),
  KEY `fk_emp_pasarela_idx` (`emplazamiento_id`),
  CONSTRAINT `fk_emp_pasarela` FOREIGN KEY (`emplazamiento_id`) REFERENCES `emplazamientos` (`idemplazamiento`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasarelas`
--

LOCK TABLES `pasarelas` WRITE;
/*!40000 ALTER TABLE `pasarelas` DISABLE KEYS */;
INSERT INTO `pasarelas` VALUES (15,21,'ACC-GW-01','10.1.1.0','2017-11-16 13:58:13','10.1.1.1','10.1.1.100','255.255.255.0','10.1.1.3','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(16,21,'ACC-GW-02','10.1.1.4','2017-11-16 13:58:13','10.1.1.5','10.1.1.100','255.255.255.0','10.1.1.7','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(17,22,'TWRN-GW-01','10.2.1.0','2017-11-16 13:58:13','10.2.1.1','10.2.1.100','255.255.255.0','10.2.1.3','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(18,22,'TWRN-GW-02','10.2.1.4','2017-11-16 13:58:13','10.2.1.5','10.2.1.100','255.255.255.0','10.2.1.7','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(19,23,'ALC-GW-01','10.3.1.0','2017-11-16 13:58:13','10.3.1.1','10.3.1.100','255.255.255.0','10.3.1.3','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(24,23,'ALC-GW-03','10.3.1.8','2017-11-16 13:58:13','10.3.1.11','10.3.1.100','255.255.255.0','10.3.1.13','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(32,23,'ALC-GW-02','10.3.1.4','2017-11-16 14:01:10','10.3.1.5','10.3.1.100','255.255.255.0','10.3.1.6','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(33,27,'ACC-GW-01','10.1.1.0','2017-11-21 15:14:48','10.1.1.1','10.1.1.100','255.255.255.0','10.1.1.3','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(34,27,'ACC-GW-02','10.1.1.4','2017-11-21 15:14:48','10.1.1.5','10.1.1.100','255.255.255.0','10.1.1.7','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(35,28,'TWRN-GW-01','10.2.1.0','2017-11-21 15:14:48','10.2.1.1','10.2.1.100','255.255.255.0','10.2.1.3','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(36,28,'TWRN-GW-02','10.2.1.4','2017-11-21 15:14:48','10.2.1.5','10.2.1.100','255.255.255.0','10.2.1.7','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(37,29,'ALC-GW-01','10.3.1.0','2017-11-21 15:14:48','10.3.1.1','10.3.1.100','255.255.255.0','10.3.1.3','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(39,29,'ALC-GW-02','10.3.1.4','2017-11-21 15:14:48','10.3.1.5','10.3.1.100','255.255.255.0','10.3.1.6','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(45,29,'ALC-GW-03','10.3.1.8','2017-11-21 15:14:48','10.3.1.11','10.3.1.100','255.255.255.0','10.3.1.13','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(46,30,'ACC-GW-01','10.1.1.0','2017-09-13 10:53:12','10.1.1.1','10.1.1.100','255.255.255.0','10.1.1.3','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(47,30,'ACC-GW-02','10.1.1.4','2017-09-13 10:53:12','10.1.1.5','10.1.1.100','255.255.255.0','10.1.1.7','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(48,31,'TWRN-GW-01','10.2.1.0','2017-09-12 15:43:19','10.2.1.1','10.2.1.100','255.255.255.0','10.2.1.3','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(49,31,'TWRN-GW-02','10.2.1.4','2017-09-12 15:43:19','10.2.1.5','10.2.1.100','255.255.255.0','10.2.1.7','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(50,32,'ALC-GW-01','10.3.1.0','2017-09-13 10:53:12','10.3.1.1','10.3.1.100','255.255.255.0','10.3.1.3','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(52,32,'ALC-GW-02','10.3.1.4','2017-09-12 15:43:19','10.3.1.5','10.3.1.100','255.255.255.0','10.3.1.6','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(53,32,'ALC-GW-03','10.3.1.8','2017-09-13 09:44:23','10.3.1.11','10.3.1.100','255.255.255.0','10.3.1.13','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0);
/*!40000 ALTER TABLE `pasarelas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rangos_ats`
--

DROP TABLE IF EXISTS `rangos_ats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rangos_ats` (
  `idrangos_ats` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave Primaria. Tabla para almacenar los distintos rangos tanto de destino como de origen.',
  `recurso_telefonico_id` int(11) NOT NULL COMMENT 'Clave al recurso de teléfono al que pertenece',
  `rango_ats_inicial` varchar(6) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor inicial para el rango ATS. STRING (ATS-USER). De "200000" a "399999”.',
  `rango_ats_final` varchar(6) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor final para el rango ATS. STRING (ATS-USER). De "200000" a "399999”.',
  `tipo` int(1) NOT NULL COMMENT 'Tipo de Rango: 0 origen y 1 destino',
  PRIMARY KEY (`idrangos_ats`),
  KEY `fk_recurso_telefono_rango_ats_idx` (`recurso_telefonico_id`),
  CONSTRAINT `fk_recurso_telefono_rango_ats` FOREIGN KEY (`recurso_telefonico_id`) REFERENCES `recursos_telefono` (`idrecurso_telefono`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rangos_ats`
--

LOCK TABLES `rangos_ats` WRITE;
/*!40000 ALTER TABLE `rangos_ats` DISABLE KEYS */;
INSERT INTO `rangos_ats` VALUES (1,17,'340100','340199',0);
/*!40000 ALTER TABLE `rangos_ats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recursos_externos`
--

DROP TABLE IF EXISTS `recursos_externos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recursos_externos` (
  `idrecursos_externos` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
  `uri` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Uri introducida por el usuario para ser seleccionada',
  `tipo` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT '1 para Radio y 2 para telefonia',
  `alias` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Alias de la uri',
  PRIMARY KEY (`idrecursos_externos`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_externos`
--

LOCK TABLES `recursos_externos` WRITE;
/*!40000 ALTER TABLE `recursos_externos` DISABLE KEYS */;
INSERT INTO `recursos_externos` VALUES (2,'rx1@1.1.1.1','2','rx1'),(3,'tx1@1.1.1.1','0','tx1'),(4,'rtx1@2.2.2.2','1','rtx1'),(5,'tlf1@3.3.3.3','3','tlf1'),(6,'pepe@1.1.1.1','0','prueba');
/*!40000 ALTER TABLE `recursos_externos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recursos_radio`
--

DROP TABLE IF EXISTS `recursos_radio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recursos_radio` (
  `idrecurso_radio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Campo Clave. Representa un recurso de tipo radio, asignado a una pasarela.',
  `pasarela_id` int(11) NOT NULL COMMENT 'Clave externa a pasarela.',
  `fila` int(1) NOT NULL COMMENT 'Posición dentro de la IA4 en la que se encuentra asignado el recurso radio. Puede tomar valores del 0 al 3.',
  `columna` int(1) NOT NULL COMMENT 'Elemento IA4 en la que se encuentra asignado el recurso radio. Puede tomar valores del 0 al 3.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre del recurso. Único dentro de la pasarela.',
  `codec` int(1) DEFAULT '0' COMMENT 'Codec de audio para el recurso radio. 0: G711-A',
  `clave_registro` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Valor para la clave del registro. Indica no habilitado con valor NULL.',
  `frecuencia` float(6,3) NOT NULL COMMENT 'Frecuencia en Mhz (UHF/VHF). desde 30.000 a 300.000 y pico',
  `ajuste_ad` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en A/D. Rango min: -13.5, max: 1.20. Si es NULL el ajuste es automático.',
  `ajuste_da` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en D/A. Rango min: -24.3, max: 1.10. Si es NULL el ajuste es automático.',
  `precision_audio` int(1) NOT NULL DEFAULT '0' COMMENT 'Precisión de Audio: (0) Estricto o (1) Normal.',
  `tipo_agente` int(1) NOT NULL COMMENT 'Tipo de agente de radio. 0 (LS), 1 (LPR), 2 (FDS), 3 (FDPR), 4 (RRT), 5(RTX), 6(RRX).',
  `indicacion_entrada_audio` int(1) NOT NULL COMMENT 'Indicación de entrada de audio. 0 (HW), 1 (VAD), 2 (FORZADO)',
  `indicacion_salida_audio` int(1) NOT NULL COMMENT 'Indicación de salida de audio. 0 (HW), 1 (TONO)',
  `metodo_bss` int(1) DEFAULT NULL COMMENT 'Método BSS disponible.\nEn RLOCALES: 0 (Ninguno), 1 (RSSI), 2 (RSSI y NUCLEO)\rEn REMOTOS: 0 (RSSI), 1 (NUCLEO).',
  `prioridad_ptt` int(1) DEFAULT '0' COMMENT 'Prioridad PTT. Rango: 0 (Normal), 1 (Prioritario), 2 (Emergencia)',
  `prioridad_sesion_sip` int(1) DEFAULT '0' COMMENT 'Prioridad sesión SIP. 0 (Normal), 1 ( Prioritaria)',
  `climax_bss` tinyint(1) DEFAULT '0' COMMENT 'Habilita BSS/CLIMAX. (1) Habilitado, (0) No Habilitado.',
  `retraso_interno_grs` int(3) NOT NULL DEFAULT '0' COMMENT 'Retraso interno GRS en mili segundos. Rango min: 0, max: 250.',
  `evento_ptt_squelch` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Evento PTT/Squelch. (1) Activado, (0) No Activado.',
  `habilita_grabacion` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Habilita grabación. (1) Si habilita, (0) No Habilita.',
  `tabla_bss_id` int(11) DEFAULT NULL COMMENT 'Clave ajena a la tabla bss de calificación de audio.',
  `max_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `min_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `umbral_vad` float(3,1) NOT NULL DEFAULT '-20.0' COMMENT 'Umbral Vad. Rango min: -35.0, max: -15.0.',
  `tiempo_max_ptt` int(4) NOT NULL DEFAULT '0' COMMENT 'Tiempo máximo PTT. Rango de min: 0, max: 1000',
  `ventana_bss` int(4) NOT NULL DEFAULT '500' COMMENT 'Ventana BSS. Rango min: 10, max: 5000.',
  `tipo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Tipo de climax. 0 (No), 1(ASAP), 2(TIEMPO FIJO).',
  `retardo_fijo_climax` int(3) NOT NULL DEFAULT '100' COMMENT 'Retardo fijo climax. Rango min: 0, max: 250',
  `cola_bss_sqh` int(4) NOT NULL DEFAULT '500' COMMENT 'Cola BSS SQH. Rango min: 10, max: 5000.',
  `retardo_jitter` int(3) NOT NULL DEFAULT '30' COMMENT 'Retardo jitter. Rango min: 0, max: 100.',
  `metodo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Método climax. Valores 0 (Relativo), 1 (Absoluto).',
  `restriccion_entrantes` int(1) DEFAULT '0' COMMENT 'Restricción entrantes. Valores: 0 (Ninguna), 1 (Lista Negra), 2 (Lista Blanca)',
  PRIMARY KEY (`idrecurso_radio`),
  KEY `fk_pasarela_radio_idx` (`pasarela_id`),
  KEY `fk_radio_tabla_bss_idx` (`tabla_bss_id`),
  CONSTRAINT `fk_pasarela_radio` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_radio`
--

LOCK TABLES `recursos_radio` WRITE;
/*!40000 ALTER TABLE `recursos_radio` DISABLE KEYS */;
INSERT INTO `recursos_radio` VALUES (42,19,0,0,'TR001',0,NULL,120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,1,100,500,30,0,1),(43,19,1,0,'TR002',0,NULL,120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,5,0,0,-20.0,0,500,1,100,500,30,0,0),(44,19,2,0,'TR003',0,NULL,120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,5,0,0,-20.0,0,500,1,100,500,30,0,0),(45,19,3,0,'TR004',0,NULL,120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,5,0,0,-20.0,0,500,1,100,500,30,0,0),(46,19,0,1,'RR001',0,NULL,121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,1,100,500,30,0,0),(47,19,1,1,'RR002',0,NULL,121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,5,0,0,-20.0,0,500,1,100,500,30,0,0),(48,19,2,1,'RR003',0,NULL,121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,5,0,0,-20.0,0,500,1,100,500,30,0,0),(49,19,3,1,'RR004',0,NULL,121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,6,0,0,-20.0,0,500,1,100,500,30,0,0),(50,19,0,2,'TT001',0,NULL,121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,1,100,500,30,0,2),(51,19,1,2,'TT002',0,NULL,121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(52,19,2,2,'TT003',0,NULL,121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(53,19,3,2,'TT004',0,NULL,121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,2,100,500,30,0,1),(54,17,0,0,'F001',0,NULL,120.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(55,17,1,0,'F002',0,NULL,120.005,0.00,0.00,0,0,0,0,2,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(57,15,0,0,'F004',0,NULL,120.000,0.30,-5.60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,2,250,500,30,0,0),(58,15,2,0,'F006',0,NULL,121.050,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(59,15,3,0,'F007',0,NULL,121.500,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(60,15,1,0,'F005',0,NULL,121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,2,100,500,30,0,0),(64,17,3,0,'FL001',0,NULL,121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(65,24,0,0,'TR001',0,'null',120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(66,24,1,0,'TR002',0,'null',120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(67,24,2,0,'TR003',0,'null',120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(68,24,3,0,'TR004',0,'null',120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(69,24,0,1,'RR001',0,'null',121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(70,24,1,1,'RR002',0,'null',121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(71,24,2,1,'RR003',0,'null',121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(72,24,3,1,'RR004',0,'null',121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(73,24,0,2,'TT001',0,'null',121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(74,24,1,2,'TT002',0,'null',121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(75,24,2,2,'TT003',0,'null',121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(76,24,3,2,'TT004',0,'null',121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(108,33,0,0,'F004',0,'null',120.000,0.00,0.00,0,0,0,0,2,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(109,33,2,0,'F006',0,'null',121.050,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(110,33,3,0,'F007',0,'null',121.500,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(111,33,1,0,'F005',0,'null',121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(112,35,0,0,'F001',0,'null',120.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(113,35,1,0,'F002',0,'null',120.005,0.00,0.00,0,0,0,0,2,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(114,35,3,0,'FL001',0,'null',121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(115,37,0,0,'TR001',0,'null',120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(116,37,1,0,'TR002',0,'null',120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(117,37,2,0,'TR003',0,'null',120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(118,37,3,0,'TR004',0,'null',120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(119,37,0,1,'RR001',0,'null',121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(120,37,1,1,'RR002',0,'null',121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(121,37,2,1,'RR003',0,'null',121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(122,37,3,1,'RR004',0,'null',121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(123,37,0,2,'TT001',0,'null',121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(124,37,1,2,'TT002',0,'null',121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(125,37,2,2,'TT003',0,'null',121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(126,37,3,2,'TT004',0,'null',121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(199,45,0,0,'TR001',0,'null',120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(200,45,1,0,'TR002',0,'null',120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(201,45,2,0,'TR003',0,'null',120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(202,45,3,0,'TR004',0,'null',120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(203,45,0,1,'RR001',0,'null',121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(204,45,1,1,'RR002',0,'null',121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(205,45,2,1,'RR003',0,'null',121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(206,45,3,1,'RR004',0,'null',121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(207,45,0,2,'TT001',0,'null',121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(208,45,1,2,'TT002',0,'null',121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(209,45,2,2,'TT003',0,'null',121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(210,45,3,2,'TT004',0,'null',121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(211,46,0,0,'F004',0,'null',120.000,0.00,0.00,0,0,0,0,2,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(212,46,2,0,'F006',0,'null',121.050,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(213,46,3,0,'F007',0,'null',121.500,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(214,46,1,0,'F005',0,'null',121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(215,48,0,0,'F001',0,'null',120.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(216,48,1,0,'F002',0,'null',120.005,0.00,0.00,0,0,0,0,2,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(217,48,3,0,'FL001',0,'null',121.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(218,50,0,2,'TR001',0,'null',120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(219,50,1,0,'TR002',0,'null',120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(220,50,2,0,'TR003',0,'null',120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(221,50,3,0,'TR004',0,'null',120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(222,50,1,3,'RR001',0,'null',121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(223,50,1,1,'RR002',0,'null',121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(224,50,2,1,'RR003',0,'null',121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(225,50,3,1,'RR004',0,'null',121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(226,50,0,0,'TT001',0,'null',121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(227,50,1,2,'TT002',0,'null',121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(228,50,2,2,'TT003',0,'null',121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(229,50,3,2,'TT004',0,'null',121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(230,53,0,0,'TR001',0,'null',120.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(231,53,1,0,'TR002',0,'null',120.005,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(232,53,2,0,'TR003',0,'null',120.050,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(233,53,3,0,'TR004',0,'null',120.500,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(234,53,0,1,'RR001',0,'null',121.000,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(235,53,1,1,'RR002',0,'null',121.005,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(236,53,2,1,'RR003',0,'null',121.050,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(237,53,3,1,'RR004',0,'null',121.500,0.00,0.00,0,6,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(238,53,0,2,'TT001',0,'null',121.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(239,53,1,2,'TT002',0,'null',121.005,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(240,53,2,2,'TT003',0,'null',121.050,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(241,53,3,2,'TT004',0,'null',121.500,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(242,50,3,3,'test',0,'clave',120.005,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0);
/*!40000 ALTER TABLE `recursos_radio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recursos_telefono`
--

DROP TABLE IF EXISTS `recursos_telefono`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recursos_telefono` (
  `idrecurso_telefono` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave Primaria. Representa un recurso de tipo telefónico, asignado a una pasarela.',
  `pasarela_id` int(11) NOT NULL COMMENT 'Clave externa a tabla pasarela.',
  `fila` int(1) NOT NULL COMMENT 'Posición dentro de la IA4 en la que se encuentra asignado el recurso telefónico. Puede tomar valores del 0 al 3.',
  `columna` int(1) NOT NULL COMMENT 'Elemento IA4 en la que se encuentra asignado el recurso telefónico. Puede tomar valores del 0 al 3.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre del recurso telefónico. Único dentro de la pasarela.',
  `codec` int(1) NOT NULL DEFAULT '0' COMMENT 'Codec de audio para el recurso radio. 0: G711-A',
  `clave_registro` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Valor para la clave del registro.',
  `ajuste_ad` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en A/D',
  `ajuste_da` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en D/A',
  `precision_audio` int(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Precisión de Audio: (0) Estricto o (1) Normal. Por ahora no lo utilizamos',
  `tipo_interfaz_tel` int(1) NOT NULL COMMENT 'Tipo de interfaz telefónico. 0 (BL), 1(BC), 2(AB), 3(R2), 4(N5), 5(LCEN), 6 (QSIG)',
  `deteccion_vox` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Detección Vox. (1) Si, (0) No.',
  `umbral_vox` int(10) DEFAULT NULL COMMENT 'Valor del umbral Vox en dB.',
  `cola_vox` int(10) DEFAULT NULL COMMENT 'Valor para la cola Vox en segundos.',
  `respuesta_automatica` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Respuesta automática. (1) Si, (0) No.',
  `periodo_tonos` int(2) DEFAULT NULL COMMENT 'Periodo tonos respuesta estado en segundos. Rango min: 1, max: 10',
  `lado` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Lado A (0) o lado B (1)',
  `origen_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Origen llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `destino_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Destino llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `supervisa_colateral` tinyint(1) DEFAULT NULL COMMENT 'Indica si supervisa colateral. (1) Supervisa, (0) No Supervisa.',
  `tiempo_supervision` int(2) NOT NULL DEFAULT '5' COMMENT 'Tiempo de supervisión en segundos. Rango min: 1, max: 10',
  `duracion_tono_interrup` int(2) NOT NULL DEFAULT '0' COMMENT 'Duración en segundos del tono de interrupción. Rango min: 5, max: 15.',
  `uri_telefonica` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Uri para el recurso telefónico.',
  PRIMARY KEY (`idrecurso_telefono`),
  KEY `fk_pasarela_tfno_idx` (`pasarela_id`),
  CONSTRAINT `fk_pasarela_tfno` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_telefono`
--

LOCK TABLES `recursos_telefono` WRITE;
/*!40000 ALTER TABLE `recursos_telefono` DISABLE KEYS */;
INSERT INTO `recursos_telefono` VALUES (13,15,0,2,'BL01',0,NULL,-3.60,0.30,1,0,1,-16,1,0,0,0,'','',0,5,5,'sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:s'),(14,15,1,2,'BC01',0,NULL,0.00,0.00,1,1,1,-15,0,0,0,0,'','',0,5,5,'sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:s'),(15,15,2,1,'AB01',0,NULL,0.00,0.00,1,2,1,-15,0,0,0,0,'','',0,5,5,'sip:tlf1@3.3.3.3'),(16,15,3,1,'LC01',0,NULL,0.00,-7.00,1,5,1,-15,0,1,5,0,'','',1,2,5,'sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:sip:s'),(17,15,0,3,'R201',0,NULL,0.00,0.00,1,3,1,-15,0,1,2,0,'340199','330199',1,2,5,'sip:R201@10.2.1.0'),(18,15,1,3,'N501',0,NULL,0.00,0.00,1,4,1,-15,0,1,0,0,'','',0,5,5,''),(19,15,2,3,'QS01',0,NULL,0.00,0.00,1,6,1,-15,0,1,0,0,'','',0,5,5,''),(27,33,0,2,'BL01',0,'null',0.00,0.00,1,3,1,-16,1,0,0,0,'','',0,5,5,'sip:BC01@10.1.1.0'),(28,33,1,2,'BC01',0,'null',0.00,0.00,1,1,1,-15,0,0,0,0,'','',0,5,5,''),(29,33,2,2,'AB01',0,'null',0.00,0.00,1,2,1,-15,0,0,0,0,'','',0,5,5,''),(30,33,3,2,'LC01',0,'null',0.00,0.00,1,5,1,-15,0,1,0,0,'','',0,5,5,''),(31,33,0,3,'R201',0,'null',0.00,0.00,1,3,1,-15,0,1,0,0,'','',0,5,5,''),(32,33,1,3,'N501',0,'null',0.00,0.00,1,4,1,-15,0,1,0,0,'','',0,5,5,''),(33,33,2,3,'QS01',0,'null',0.00,0.00,1,6,1,-15,0,1,0,0,'','',0,5,5,''),(34,46,0,2,'BL01',0,'null',0.00,0.00,1,3,1,-16,1,0,0,0,'','',0,5,5,'sip:BC01@10.1.1.0'),(35,46,1,2,'BC01',0,'null',0.00,0.00,1,1,1,-15,0,0,0,0,'','',0,5,5,''),(36,46,2,2,'AB01',0,'null',0.00,0.00,1,2,1,-15,0,0,0,0,'','',0,5,5,''),(37,46,3,2,'LC01',0,'null',0.00,0.00,1,5,1,-15,0,1,0,0,'','',0,5,5,''),(38,46,0,3,'R201',0,'null',0.00,0.00,1,3,1,-15,0,1,0,0,'','',0,5,5,''),(39,46,1,3,'N501',0,'null',0.00,0.00,1,4,1,-15,0,1,0,0,'','',0,5,5,''),(40,46,2,3,'QS01',0,'null',0.00,0.00,1,6,1,-15,0,1,0,0,'','',0,5,5,''),(41,17,3,3,'LCE01',0,NULL,0.00,0.00,1,5,1,-15,0,1,0,0,'','',0,5,5,'sip:LC01@10.1.1.0'),(42,17,2,3,'R201',0,NULL,0.00,0.00,1,3,1,-15,0,1,5,0,'333333','333334',1,2,5,'sip:R201@10.1.1.0'),(43,17,1,3,'N501',0,NULL,0.00,0.00,1,4,1,-15,0,1,5,0,'333333','333334',1,2,5,'sip:N501@10.1.1.0'),(44,15,3,3,'tel01',0,NULL,0.00,0.00,1,0,1,-27,5,0,5,0,'','',0,5,5,'sip:BL01@10.1.1.0');
/*!40000 ALTER TABLE `recursos_telefono` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `recursos_telefono_BINS` BEFORE INSERT ON recursos_telefono FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	IF (NEW.uri_telefonica NOT LIKE 'sip:%') THEN
		IF(NEW.uri_telefonica NOT LIKE '') THEN
			set NEW.uri_telefonica = CONCAT('sip:', NEW.uri_telefonica);
		END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `recursos_telefono_BUPD` BEFORE UPDATE ON recursos_telefono FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	IF(NEW.uri_telefonica NOT LIKE '') THEN
		set NEW.uri_telefonica = CONCAT('sip:', NEW.uri_telefonica);
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
-- Table structure for table `tablas_bss`
--

DROP TABLE IF EXISTS `tablas_bss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tablas_bss` (
  `idtabla_bss` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Clave primaria de la tabla. Esta tabla representa las tablas como los valores de calificación de audio que se le pueden asignar a los recursos.',
  `nombre` varchar(32) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre que se le da a la tabla. No se puede repetir.',
  `descripcion` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Información adicional de la tabla.',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación de la tabla.',
  `valor0` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 0 de la tabla. Rango: min: 0, max: 15.',
  `valor1` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 1 de la tabla. Rango: min: 0, max: 15.',
  `valor2` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 2 de la tabla. Rango: min: 0, max: 15.',
  `valor3` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 3 de la tabla. Rango: min: 0, max: 15.',
  `valor4` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 4 de la tabla. Rango: min: 0, max: 15.',
  `valor5` int(2) NOT NULL DEFAULT '0' COMMENT 'Valor 5 de la tabla. Rango: min: 0, max: 15.',
  PRIMARY KEY (`idtabla_bss`),
  UNIQUE KEY `name_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablas_bss`
--

LOCK TABLES `tablas_bss` WRITE;
/*!40000 ALTER TABLE `tablas_bss` DISABLE KEYS */;
INSERT INTO `tablas_bss` VALUES (5,'rhode-01','Para receptores RHODE','2017-09-21 13:04:41',0,3,4,5,10,15),(6,'jotron-01','Para receptores JOTRON','2017-09-21 13:30:30',0,8,10,12,14,15);
/*!40000 ALTER TABLE `tablas_bss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp`
--

DROP TABLE IF EXISTS `temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `valor1` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp`
--

LOCK TABLES `temp` WRITE;
/*!40000 ALTER TABLE `temp` DISABLE KEYS */;
INSERT INTO `temp` VALUES (1,20),(2,23),(3,24),(4,3);
/*!40000 ALTER TABLE `temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ug5kv2'
--

--
-- Dumping routines for database 'ug5kv2'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_CopyConfiguration` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CopyConfiguration`(in cfg_id int, in cfg_name VARCHAR(64), in cfg_description VARCHAR(100))
BEGIN
    DECLARE copy_config_id INT DEFAUlT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE v_nuevos INT(11);
    DECLARE v_antiguos INT(11);
    
    DECLARE emplazamiento_cursor CURSOR FOR
    SELECT e.idemplazamiento as nuevo, e1.idemplazamiento as viejo
    FROM emplazamientos e, emplazamientos e1
    WHERE e.configuracion_id = copy_config_id
    AND e1.configuracion_id = cfg_id
    AND e1.nombre = e.nombre;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;    
    
    INSERT INTO configuraciones (nombre, descripcion, region, activa)
    SELECT cfg_name, cfg_description, cfg.region, 0
    FROM configuraciones cfg
    WHERE cfg.idconfiguracion=cfg_id;
    
    SELECT LAST_INSERT_ID() INTO copy_config_id;
    
    INSERT INTO emplazamientos (nombre, configuracion_id)
    SELECT emp.nombre, copy_config_id
    FROM emplazamientos emp
    WHERE emp.configuracion_id=cfg_id;

    OPEN emplazamiento_cursor;
    get_emp: LOOP
    FETCH emplazamiento_cursor INTO v_nuevos, v_antiguos;
    IF done = 1 THEN
            LEAVE get_emp;
    END IF;
    INSERT INTO pasarelas (emplazamiento_id, nombre, ip_virtual, ultima_actualizacion, ip_cpu0, ip_gtw0, mask_cpu0, ip_cpu1, ip_gtw1, mask_cpu1, puerto_sip, periodo_supervision, puerto_servicio_snmp, puerto_snmp, snmpv2, comunidad_snmp, nombre_snmp, localizacion_snmp, contacto_snmp, puerto_servicio_web, tiempo_sesion, puerto_rtsp, servidor_rtsp, servidor_rtspb)
    SELECT v_nuevos, pas.nombre, pas.ip_virtual, pas.ultima_actualizacion, pas.ip_cpu0, pas.ip_gtw0, pas.mask_cpu0, pas.ip_cpu1, pas.ip_gtw1, pas.mask_cpu1, pas.puerto_sip, pas.periodo_supervision, pas.puerto_servicio_snmp, pas.puerto_snmp, pas.snmpv2, pas.comunidad_snmp, pas.nombre_snmp, pas.localizacion_snmp, pas.contacto_snmp, pas.puerto_servicio_web, pas.tiempo_sesion, pas.puerto_rtsp, pas.servidor_rtsp, pas.servidor_rtspb
    FROM pasarelas pas 
    WHERE pas.emplazamiento_id = v_antiguos;
    END LOOP get_emp;
    CLOSE emplazamiento_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Test`()
BEGIN
	DECLARE a_cursor CURSOR FOR
    SELECT *
    FROM PASARELAS 
    WHERE emplazamiento_id=3; 
    
    
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
-- Final view structure for view `emplazamiento`
--

/*!50001 DROP VIEW IF EXISTS `emplazamiento`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emplazamiento` AS select `e`.`idemplazamiento` AS `idEMPLAZAMIENTO`,`e`.`configuracion_id` AS `cfg_idCFG`,`e`.`nombre` AS `name` from `emplazamientos` `e` */;
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
/*!50001 VIEW `info_cgw` AS select `p`.`nombre` AS `name`,1 AS `dual_cpu`,`e`.`nombre` AS `emplazamiento`,1 AS `num_cpu`,`p`.`ip_virtual` AS `virtual_ip`,1 AS `dual_lan`,'' AS `ip_eth0`,'' AS `ip_eth1`,`p`.`ip_cpu0` AS `bound_ip`,`p`.`ip_gtw0` AS `gateway_ip` from ((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) where (`c`.`activa` = 1) union select `p`.`nombre` AS `name`,1 AS `dual_cpu`,`e`.`nombre` AS `emplazamiento`,2 AS `num_cpu`,`p`.`ip_virtual` AS `virtual_ip`,1 AS `dual_lan`,'' AS `ip_eth0`,'' AS `ip_eth1`,`p`.`ip_cpu1` AS `bound_ip`,`p`.`ip_gtw1` AS `gateway_ip` from ((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) where (`c`.`activa` = 1) */;
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
/*!50001 VIEW `spvs_cgw` AS select `p`.`nombre` AS `name`,`rr`.`nombre` AS `resource`,`rr`.`columna` AS `slave_rank`,0 AS `slave_type`,1 AS `resource_type`,`rr`.`fila` AS `resource_rank`,cast(`rr`.`frecuencia` as char(7) charset utf8) AS `frecuencia`,`rr`.`tipo_agente` AS `resource_subtype`,(case when (`rr`.`tipo_agente` > 3) then 'True' else 'False' end) AS `remoto` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_radio` `rr` on((`p`.`idpasarela` = `rr`.`pasarela_id`))) where ((`c`.`activa` = 1) and (`rr`.`nombre` is not null)) union select `p`.`nombre` AS `name`,`rt`.`nombre` AS `resource`,`rt`.`columna` AS `slave_rank`,0 AS `slave_type`,2 AS `resource_type`,`rt`.`fila` AS `resource_rank`,NULL AS `frecuencia`,`rt`.`tipo_interfaz_tel` AS `resource_subtype`,'False' AS `remoto` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_telefono` `rt` on((`p`.`idpasarela` = `rt`.`pasarela_id`))) where ((`c`.`activa` = 1) and (`rt`.`nombre` is not null)) */;
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
/*!50001 VIEW `spvs_site` AS select `e`.`idemplazamiento` AS `idEMPLAZAMIENTO`,`e`.`nombre` AS `name` from (`emplazamientos` `e` left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) where (`c`.`activa` = 1) */;
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

-- Dump completed on 2017-11-21 16:33:49
