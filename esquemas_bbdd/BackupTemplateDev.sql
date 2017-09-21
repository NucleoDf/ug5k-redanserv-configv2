CREATE DATABASE  IF NOT EXISTS `ug5kv2` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci */;
USE `ug5kv2`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: ug5kv2
-- ------------------------------------------------------
-- Server version	5.7.17

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES (8,'MADRID-CENTRO','Zona Madrid Centro',NULL,1,'2017-09-07 10:33:03'),(10,'asdasdad','',NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emplazamientos`
--

LOCK TABLES `emplazamientos` WRITE;
/*!40000 ALTER TABLE `emplazamientos` DISABLE KEYS */;
INSERT INTO `emplazamientos` VALUES (21,'ACC',8),(22,'TWR-N',8),(23,'ALCOLEA',8),(27,'ACC',10),(28,'TWR-N',10),(29,'ALCOLEA',10);
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
) ENGINE=InnoDB AUTO_INCREMENT=388 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
INSERT INTO `historicoincidencias` VALUES (1,NULL,'CFG','SEGURIDAD',50,'2017-09-06 14:11:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(2,NULL,'CFG','SEGURIDAD',55,'2017-09-06 14:11:57',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(3,NULL,'CFG','SEGURIDAD',50,'2017-09-06 14:13:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(4,NULL,'CFG','CONF-R',118,'2017-09-06 14:14:34',NULL,'Alta de Tabla de Calificación de Audio TbDef.','1 (a)'),(5,NULL,'CFG','CONF-R',107,'2017-09-06 14:18:27',NULL,'Alta de Pasarela ACC-GW-01.','1 (a)'),(6,NULL,'CFG','CONF-R',107,'2017-09-06 14:20:15',NULL,'Alta de Pasarela ACC-GW-02.','1 (a)'),(7,NULL,'CFG','CONF-R',109,'2017-09-06 14:20:32',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-02.','1 (a)'),(8,NULL,'CFG','CONF-R',109,'2017-09-06 14:23:47',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(9,NULL,'CFG','CONF-R',109,'2017-09-06 14:24:17',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-02.','1 (a)'),(10,NULL,'CFG','CONF-R',107,'2017-09-06 14:26:06',NULL,'Alta de Pasarela TWRN-GW-01.','1 (a)'),(11,NULL,'CFG','CONF-R',107,'2017-09-06 14:27:01',NULL,'Alta de Pasarela TWRN-GW-02.','1 (a)'),(12,NULL,'CFG','CONF-R',107,'2017-09-06 14:28:03',NULL,'Alta de Pasarela ALC-GW-01.','1 (a)'),(13,NULL,'CFG','CONF-R',113,'2017-09-06 14:30:08',NULL,'Alta de Recurso FS001.','1 (a)'),(14,NULL,'CFG','CONF-R',113,'2017-09-06 14:31:18',NULL,'Alta de Recurso FS002.','1 (a)'),(15,NULL,'CFG','CONF-R',113,'2017-09-06 14:32:00',NULL,'Alta de Recurso FS003.','1 (a)'),(16,NULL,'CFG','CONF-R',113,'2017-09-06 14:32:46',NULL,'Alta de Recurso FS004.','1 (a)'),(17,NULL,'CFG','CONF-R',116,'2017-09-06 14:33:08',NULL,'Modificación de Parámetros Lógicos de  Recurso TR001.','1 (a)'),(18,NULL,'CFG','CONF-R',116,'2017-09-06 14:33:19',NULL,'Modificación de Parámetros Lógicos de  Recurso TR002.','1 (a)'),(19,NULL,'CFG','CONF-R',116,'2017-09-06 14:33:26',NULL,'Modificación de Parámetros Lógicos de  Recurso TR003.','1 (a)'),(20,NULL,'CFG','CONF-R',116,'2017-09-06 14:33:33',NULL,'Modificación de Parámetros Lógicos de  Recurso TR004.','1 (a)'),(21,NULL,'CFG','CONF-R',116,'2017-09-06 14:34:08',NULL,'Modificación de Parámetros Lógicos de  Recurso TR002.','1 (a)'),(22,NULL,'CFG','CONF-R',116,'2017-09-06 14:34:16',NULL,'Modificación de Parámetros Lógicos de  Recurso TR003.','1 (a)'),(23,NULL,'CFG','CONF-R',116,'2017-09-06 14:34:24',NULL,'Modificación de Parámetros Lógicos de  Recurso TR004.','1 (a)'),(24,NULL,'CFG','CONF-R',113,'2017-09-06 14:34:59',NULL,'Alta de Recurso RR001.','1 (a)'),(25,NULL,'CFG','CONF-R',113,'2017-09-06 14:35:37',NULL,'Alta de Recurso RR002.','1 (a)'),(26,NULL,'CFG','CONF-R',113,'2017-09-06 14:36:09',NULL,'Alta de Recurso RR003.','1 (a)'),(27,NULL,'CFG','CONF-R',113,'2017-09-06 14:36:56',NULL,'Alta de Recurso RR004.','1 (a)'),(28,NULL,'CFG','CONF-R',113,'2017-09-06 14:37:24',NULL,'Alta de Recurso TT001.','1 (a)'),(29,NULL,'CFG','CONF-R',113,'2017-09-06 14:37:45',NULL,'Alta de Recurso TT002.','1 (a)'),(30,NULL,'CFG','CONF-R',113,'2017-09-06 14:38:16',NULL,'Alta de Recurso TT003.','1 (a)'),(31,NULL,'CFG','CONF-R',113,'2017-09-06 14:38:36',NULL,'Alta de Recurso TT004.','1 (a)'),(32,NULL,'CFG','CONF-R',109,'2017-09-06 14:38:38',NULL,'Modificación de Parámetros Generales de Pasarela ALC-GW-01.','1 (a)'),(33,NULL,'CFG','CONF-R',113,'2017-09-06 14:40:26',NULL,'Alta de Recurso F001.','1 (a)'),(34,NULL,'CFG','CONF-R',116,'2017-09-06 14:43:20',NULL,'Modificación de Parámetros Lógicos de  Recurso F001.','1 (a)'),(35,NULL,'CFG','SEGURIDAD',50,'2017-09-06 14:45:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(36,NULL,'CFG','CONF-R',116,'2017-09-06 14:45:44',NULL,'Modificación de Parámetros Lógicos de  Recurso F001.','1 (a)'),(37,NULL,'CFG','CONF-R',116,'2017-09-06 14:46:41',NULL,'Modificación de Parámetros Lógicos de  Recurso F002.','1 (a)'),(38,NULL,'CFG','CONF-R',116,'2017-09-06 14:48:20',NULL,'Modificación de Parámetros Lógicos de  Recurso F004.','1 (a)'),(39,NULL,'CFG','SEGURIDAD',55,'2017-09-06 14:49:46',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(40,NULL,'CFG','SEGURIDAD',50,'2017-09-06 14:57:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(41,NULL,'CFG','CONF-R',116,'2017-09-06 15:00:59',NULL,'Modificación de Parámetros Lógicos de  Recurso F006.','1 (a)'),(42,NULL,'CFG','CONF-R',116,'2017-09-06 15:25:08',NULL,'Modificación de Parámetros Lógicos de  Recurso F005.','1 (a)'),(43,NULL,'CFG','SEGURIDAD',51,'2017-09-06 17:03:29',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(44,NULL,'CFG','SEGURIDAD',51,'2017-09-06 17:03:53',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(45,NULL,'CFG','SEGURIDAD',50,'2017-09-06 17:04:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(46,NULL,'CFG','SEGURIDAD',55,'2017-09-06 17:05:50',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(47,NULL,'CFG','SEGURIDAD',50,'2017-09-06 17:05:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(48,NULL,'CFG','CONF-R',113,'2017-09-06 17:06:47',NULL,'Alta de Recurso BL01.','1 (a)'),(49,NULL,'CFG','CONF-R',113,'2017-09-06 17:07:09',NULL,'Alta de Recurso BC01.','1 (a)'),(50,NULL,'CFG','CONF-R',113,'2017-09-06 17:07:28',NULL,'Alta de Recurso AB01.','1 (a)'),(51,NULL,'CFG','CONF-R',113,'2017-09-06 17:07:48',NULL,'Alta de Recurso LC01.','1 (a)'),(52,NULL,'CFG','CONF-R',113,'2017-09-06 17:10:01',NULL,'Alta de Recurso R201.','1 (a)'),(53,NULL,'CFG','CONF-R',113,'2017-09-06 17:10:18',NULL,'Alta de Recurso N501.','1 (a)'),(54,NULL,'CFG','CONF-R',113,'2017-09-06 17:10:36',NULL,'Alta de Recurso QS01.','1 (a)'),(55,NULL,'CFG','SEGURIDAD',50,'2017-09-06 17:32:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(56,NULL,'CFG','CONF-R',113,'2017-09-06 17:32:52',NULL,'Alta de Recurso FL0001.','1 (a)'),(57,NULL,'CFG','CONF-R',116,'2017-09-06 17:33:07',NULL,'Modificación de Parámetros Lógicos de  Recurso FL0001.','1 (a)'),(58,NULL,'CFG','CONF-R',116,'2017-09-06 17:33:16',NULL,'Modificación de Parámetros Lógicos de  Recurso FL0001.','1 (a)'),(59,NULL,'CFG','CONF-R',114,'2017-09-06 17:33:22',NULL,'Baja de Recurso FL0001.','1 (a)'),(60,NULL,'CFG','CONF-R',114,'2017-09-06 17:34:03',NULL,'Baja de Recurso FL001.','1 (a)'),(61,NULL,'CFG','SEGURIDAD',55,'2017-09-06 17:39:27',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(62,NULL,'CFG','SEGURIDAD',50,'2017-09-07 10:14:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(63,NULL,'CFG','CONF-R',114,'2017-09-07 10:15:24',NULL,'Baja de Recurso FL001.','1 (a)'),(64,NULL,'CFG','CONF-R',113,'2017-09-07 10:16:01',NULL,'Alta de Recurso FL001.','1 (a)'),(65,NULL,'CFG','SEGURIDAD',50,'2017-09-07 11:35:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(66,NULL,'CFG','CONF-R',105,'2017-09-07 11:37:03',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(67,NULL,'CFG','CONF-R',105,'2017-09-07 11:37:38',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(68,NULL,'CFG','CONF-R',116,'2017-09-07 11:39:27',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','1 (a)'),(69,NULL,'CFG','CONF-R',109,'2017-09-07 11:39:34',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(70,NULL,'CFG','CONF-R',105,'2017-09-07 11:39:45',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(71,NULL,'CFG','CONF-R',109,'2017-09-07 11:40:20',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(72,NULL,'CFG','CONF-R',105,'2017-09-07 11:40:30',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(73,NULL,'CFG','CONF-R',116,'2017-09-07 11:41:14',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','1 (a)'),(74,NULL,'CFG','CONF-R',116,'2017-09-07 11:41:29',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','1 (a)'),(75,NULL,'CFG','CONF-R',116,'2017-09-07 11:43:58',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','1 (a)'),(76,NULL,'CFG','CONF-R',109,'2017-09-07 11:44:03',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(77,NULL,'CFG','CONF-R',105,'2017-09-07 11:44:14',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(78,NULL,'CFG','CONF-R',116,'2017-09-07 11:45:31',NULL,'Modificación de Parámetros Lógicos de  Recurso F007.','1 (a)'),(79,NULL,'CFG','CONF-R',109,'2017-09-07 11:45:33',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(80,NULL,'CFG','CONF-R',105,'2017-09-07 11:45:39',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(81,NULL,'CFG','CONF-R',109,'2017-09-07 11:47:03',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(82,NULL,'CFG','CONF-R',105,'2017-09-07 11:47:10',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(83,NULL,'CFG','CONF-R',109,'2017-09-07 11:47:32',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(84,NULL,'CFG','CONF-R',105,'2017-09-07 11:47:47',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(85,NULL,'CFG','CONF-R',109,'2017-09-07 11:49:47',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(86,NULL,'CFG','CONF-R',105,'2017-09-07 11:49:53',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(87,NULL,'CFG','CONF-R',109,'2017-09-07 11:51:09',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(88,NULL,'CFG','CONF-R',105,'2017-09-07 11:51:27',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(89,NULL,'CFG','CONF-R',109,'2017-09-07 11:52:13',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(90,NULL,'CFG','CONF-R',105,'2017-09-07 11:54:43',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(91,NULL,'CFG','SEGURIDAD',50,'2017-09-07 11:56:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(92,NULL,'CFG','CONF-R',109,'2017-09-07 11:56:29',NULL,'Modificación de Parámetros Generales de Pasarela ACC-GW-01.','1 (a)'),(93,NULL,'CFG','CONF-R',105,'2017-09-07 11:56:42',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(94,NULL,'CFG','SEGURIDAD',50,'2017-09-07 12:00:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(95,NULL,'CFG','CONF-R',107,'2017-09-07 12:02:51',NULL,'Alta de Pasarela ALC-GW-02.','1 (a)'),(96,NULL,'CFG','CONF-R',108,'2017-09-07 12:19:29',NULL,'Baja de Pasarela ALC-GW-02.','1 (a)'),(97,NULL,'CFG','CONF-R',108,'2017-09-07 12:22:10',NULL,'Baja de Pasarela ALC-GW-02.','1 (a)'),(98,NULL,'CFG','CONF-R',108,'2017-09-07 12:23:52',NULL,'Baja de Pasarela ALC-GW-02.','1 (a)'),(99,NULL,'CFG','CONF-R',105,'2017-09-07 12:27:09',NULL,'Carga de Configuración Remota MADRID-CENTRO-BKP.','1 (a)'),(100,NULL,'CFG','CONF-R',105,'2017-09-07 12:27:24',NULL,'Carga de Configuración Remota MADRID-CENTRO-BKP.','1 (a)'),(101,NULL,'CFG','SEGURIDAD',55,'2017-09-07 12:28:56',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(102,NULL,'CFG','SEGURIDAD',50,'2017-09-07 12:29:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(103,NULL,'CFG','CONF-R',105,'2017-09-07 12:33:03',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(104,NULL,'CFG','CONF-R',108,'2017-09-07 12:36:19',NULL,'Baja de Pasarela ALC-GW-02.','1 (a)'),(105,NULL,'CFG','CONF-R',116,'2017-09-07 12:44:38',NULL,'Modificación de Parámetros Lógicos de  Recurso BL01.','1 (a)'),(106,NULL,'CFG','CONF-R',105,'2017-09-07 12:44:46',NULL,'Carga de Configuración Remota MADRID-CENTRO.','1 (a)'),(107,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:09:14',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(108,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:09:24',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(109,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:09:37',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(110,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:11:36',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(111,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:12:54',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(112,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:14:24',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(113,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:15:29',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(114,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:17:51',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(115,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:18:31',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(116,NULL,'CFG','SEGURIDAD',55,'2017-09-07 14:18:40',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(117,NULL,'CFG','SEGURIDAD',50,'2017-09-07 14:19:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(118,NULL,'CFG','SEGURIDAD',55,'2017-09-07 14:21:48',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(119,NULL,'CFG','SEGURIDAD',50,'2017-09-07 14:22:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(120,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:22:47',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(121,NULL,'CFG','SEGURIDAD',51,'2017-09-07 14:23:11',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(122,NULL,'CFG','SEGURIDAD',50,'2017-09-07 14:24:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(123,NULL,'CFG','SEGURIDAD',50,'2017-09-07 14:26:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(124,NULL,'CFG','SEGURIDAD',55,'2017-09-07 14:31:12',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(125,NULL,'CFG','SEGURIDAD',50,'2017-09-07 15:09:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(126,NULL,'CFG','SEGURIDAD',50,'2017-09-08 08:36:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(127,NULL,'CFG','SEGURIDAD',50,'2017-09-11 16:53:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(128,NULL,'CFG','CONF-R',113,'2017-09-11 16:54:49',NULL,'Alta de Recurso RxTx.','1 (a)'),(129,NULL,'CFG','CONF-R',113,'2017-09-11 16:56:05',NULL,'Alta de Recurso Test.','1 (a)'),(130,NULL,'CFG','SEGURIDAD',50,'2017-09-11 16:58:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(131,NULL,'CFG','CONF-R',113,'2017-09-13 09:45:49',NULL,'Alta de Recurso ttt.','1 (a)'),(132,NULL,'CFG','CONF-R',116,'2017-09-13 09:46:10',NULL,'Modificación de Parámetros Lógicos de  Recurso ttt.','1 (a)'),(133,NULL,'CFG','SEGURIDAD',50,'2017-09-13 09:48:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(134,NULL,'CFG','CONF-R',116,'2017-09-13 09:55:07',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(135,NULL,'CFG','SEGURIDAD',55,'2017-09-13 10:48:48',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(136,NULL,'CFG','SEGURIDAD',50,'2017-09-13 11:16:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(137,NULL,'CFG','SEGURIDAD',50,'2017-09-13 11:23:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(138,NULL,'CFG','SEGURIDAD',50,'2017-09-13 11:23:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(139,NULL,'CFG','SEGURIDAD',55,'2017-09-13 12:24:01',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(140,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:43:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(141,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:53:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(142,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:53:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(143,NULL,'CFG','SEGURIDAD',51,'2017-09-13 12:53:54',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(144,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:54:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(145,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:55:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(146,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:58:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(147,NULL,'CFG','SEGURIDAD',50,'2017-09-13 12:59:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(148,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:01:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(149,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:05:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(150,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:09:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(151,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:11:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(152,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:11:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(153,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:18:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(154,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:32:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(155,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:34:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(156,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:36:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(157,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:39:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(158,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:40:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(159,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:41:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(160,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:45:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(161,NULL,'CFG','SEGURIDAD',50,'2017-09-13 13:46:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(162,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:02:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(163,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:03:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(164,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:05:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(165,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:36:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(166,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:36:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(167,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:37:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(168,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:52:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(169,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:53:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(170,NULL,'CFG','SEGURIDAD',50,'2017-09-13 14:56:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(171,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:04:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(172,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:06:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(173,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:08:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(174,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:11:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(175,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:13:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(176,NULL,'CFG','CONF-R',116,'2017-09-13 15:13:42',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(177,NULL,'CFG','CONF-R',116,'2017-09-13 15:14:56',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(178,NULL,'CFG','CONF-R',113,'2017-09-13 15:15:41',NULL,'Alta de Recurso asasa.','1 (a)'),(179,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:33:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(180,NULL,'CFG','SEGURIDAD',51,'2017-09-13 15:33:31',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(181,NULL,'CFG','SEGURIDAD',50,'2017-09-13 15:33:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(182,NULL,'CFG','CONF-R',116,'2017-09-13 16:09:17',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(183,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:09:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(184,NULL,'CFG','CONF-R',116,'2017-09-13 16:10:28',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(185,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:12:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(186,NULL,'CFG','CONF-R',116,'2017-09-13 16:13:07',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(187,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:13:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(188,NULL,'CFG','SEGURIDAD',51,'2017-09-13 16:13:45',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(189,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:14:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(190,NULL,'CFG','CONF-R',116,'2017-09-13 16:15:00',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(191,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:15:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(192,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:17:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(193,NULL,'CFG','CONF-R',116,'2017-09-13 16:18:05',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(194,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:24:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(195,NULL,'CFG','SEGURIDAD',51,'2017-09-13 16:50:40',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(196,NULL,'CFG','SEGURIDAD',51,'2017-09-13 16:50:49',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(197,NULL,'CFG','SEGURIDAD',51,'2017-09-13 16:50:58',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(198,NULL,'CFG','SEGURIDAD',50,'2017-09-13 16:51:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(199,NULL,'CFG','SEGURIDAD',51,'2017-09-13 16:57:17',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(200,NULL,'CFG','SEGURIDAD',51,'2017-09-13 17:11:17',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(201,NULL,'CFG','SEGURIDAD',51,'2017-09-13 17:11:29',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(202,NULL,'CFG','SEGURIDAD',50,'2017-09-13 17:11:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(203,NULL,'CFG','SEGURIDAD',50,'2017-09-13 17:13:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(204,NULL,'CFG','SEGURIDAD',50,'2017-09-15 09:10:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(205,NULL,'CFG','SEGURIDAD',50,'2017-09-15 09:15:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(206,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:00:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(207,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:09:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(208,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:11:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(209,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:11:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(210,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:14:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(211,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:17:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(212,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:18:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(213,NULL,'CFG','CONF-R',116,'2017-09-15 10:18:32',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(214,NULL,'CFG','SEGURIDAD',50,'2017-09-15 10:18:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(215,NULL,'CFG','CONF-R',116,'2017-09-15 10:19:18',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(216,NULL,'CFG','CONF-R',116,'2017-09-15 10:19:34',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(217,NULL,'CFG','CONF-R',116,'2017-09-15 10:19:48',NULL,'Modificación de Parámetros Lógicos de  Recurso Test.','1 (a)'),(218,NULL,'CFG','SEGURIDAD',50,'2017-09-20 09:51:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(219,NULL,'CFG','SEGURIDAD',50,'2017-09-20 09:53:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(220,NULL,'CFG','SEGURIDAD',50,'2017-09-20 10:24:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(221,NULL,'CFG','SEGURIDAD',50,'2017-09-20 10:56:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(222,NULL,'CFG','SEGURIDAD',55,'2017-09-20 11:09:44',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(223,NULL,'CFG','SEGURIDAD',51,'2017-09-20 11:09:47',NULL,'Rechazada sesión Configuración Centralizada  del usuario  No existe el usuario.','4'),(224,NULL,'CFG','SEGURIDAD',51,'2017-09-20 11:09:50',NULL,'Rechazada sesión Configuración Centralizada  del usuario  No existe el usuario.','3'),(225,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:09:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(226,NULL,'CFG','SEGURIDAD',52,'2017-09-20 11:10:07',NULL,'Alta Usuario 4.','1 (a)'),(227,NULL,'CFG','SEGURIDAD',55,'2017-09-20 11:10:10',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(228,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:10:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','4'),(229,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:14:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(230,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:14:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(231,NULL,'CFG','SEGURIDAD',55,'2017-09-20 11:15:28',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(232,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:15:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','4'),(233,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:16:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(234,NULL,'CFG','SEGURIDAD',55,'2017-09-20 11:16:34',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(235,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:16:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','4'),(236,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:20:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(237,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:21:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(238,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:27:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(239,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:27:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(240,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:28:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(241,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:32:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(242,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:36:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(243,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:36:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(244,NULL,'CFG','SEGURIDAD',51,'2017-09-20 11:36:32',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(245,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:36:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(246,NULL,'CFG','CONF-R',114,'2017-09-20 11:38:31',NULL,'Baja de Recurso asasa.','1 (a)'),(247,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:39:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(248,NULL,'CFG','CONF-R',113,'2017-09-20 11:39:40',NULL,'Alta de Recurso 111.','1 (a)'),(249,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:41:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(250,NULL,'CFG','CONF-R',114,'2017-09-20 11:41:48',NULL,'Baja de Recurso 111.','1 (a)'),(251,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:42:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(252,NULL,'CFG','CONF-R',113,'2017-09-20 11:42:58',NULL,'Alta de Recurso asdas.','1 (a)'),(253,NULL,'CFG','CONF-R',114,'2017-09-20 11:43:10',NULL,'Baja de Recurso Test.','1 (a)'),(254,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:44:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(255,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:44:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(256,NULL,'CFG','CONF-R',113,'2017-09-20 11:44:50',NULL,'Alta de Recurso asdasd.','1 (a)'),(257,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:45:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(258,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:49:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(259,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:52:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(260,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:53:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(261,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:53:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(262,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:54:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(263,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:55:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(264,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:57:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(265,NULL,'CFG','SEGURIDAD',50,'2017-09-20 11:58:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(266,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:00:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(267,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:01:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(268,NULL,'CFG','CONF-R',118,'2017-09-20 12:03:23',NULL,'Alta de Tabla de Calificación de Audio asdasd.','1 (a)'),(269,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:05:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(270,NULL,'CFG','CONF-R',118,'2017-09-20 12:05:47',NULL,'Alta de Tabla de Calificación de Audio asda.','1 (a)'),(271,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:07:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(272,NULL,'CFG','CONF-R',118,'2017-09-20 12:07:20',NULL,'Alta de Tabla de Calificación de Audio 12es.','1 (a)'),(273,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:10:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(274,NULL,'CFG','SEGURIDAD',51,'2017-09-20 12:10:01',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(275,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:10:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(276,NULL,'CFG','CONF-R',118,'2017-09-20 12:10:35',NULL,'Alta de Tabla de Calificación de Audio asd2.','1 (a)'),(277,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:11:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(278,NULL,'CFG','CONF-R',118,'2017-09-20 12:11:12',NULL,'Alta de Tabla de Calificación de Audio asdasd123.','1 (a)'),(279,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:14:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(280,NULL,'CFG','CONF-R',118,'2017-09-20 12:14:35',NULL,'Alta de Tabla de Calificación de Audio aasdasd.','1 (a)'),(281,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:15:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(282,NULL,'CFG','SEGURIDAD',51,'2017-09-20 12:15:23',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(283,NULL,'CFG','SEGURIDAD',51,'2017-09-20 12:15:23',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(284,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:15:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(285,NULL,'CFG','CONF-R',118,'2017-09-20 12:15:51',NULL,'Alta de Tabla de Calificación de Audio a3eed.','1 (a)'),(286,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:16:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(287,NULL,'CFG','CONF-R',117,'2017-09-20 12:17:09',NULL,'Baja de Tabla de Calificación de Audio 12es.','1 (a)'),(288,NULL,'CFG','CONF-R',117,'2017-09-20 12:17:12',NULL,'Baja de Tabla de Calificación de Audio a3eed.','1 (a)'),(289,NULL,'CFG','CONF-R',117,'2017-09-20 12:17:15',NULL,'Baja de Tabla de Calificación de Audio asdasd123.','1 (a)'),(290,NULL,'CFG','CONF-R',117,'2017-09-20 12:17:18',NULL,'Baja de Tabla de Calificación de Audio aasdasd.','1 (a)'),(291,NULL,'CFG','CONF-R',117,'2017-09-20 12:17:20',NULL,'Baja de Tabla de Calificación de Audio asd2.','1 (a)'),(292,NULL,'CFG','CONF-R',118,'2017-09-20 12:17:26',NULL,'Alta de Tabla de Calificación de Audio 12asda.','1 (a)'),(293,NULL,'CFG','SEGURIDAD',50,'2017-09-20 12:18:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(294,NULL,'CFG','CONF-R',118,'2017-09-20 12:18:15',NULL,'Alta de Tabla de Calificación de Audio 1345vvv.','1 (a)'),(295,NULL,'CFG','CONF-R',118,'2017-09-20 12:18:32',NULL,'Alta de Tabla de Calificación de Audio asdw213.','1 (a)'),(296,NULL,'CFG','SEGURIDAD',55,'2017-09-20 13:18:06',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(297,NULL,'CFG','SEGURIDAD',50,'2017-09-20 13:51:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(298,NULL,'CFG','CONF-R',113,'2017-09-20 14:14:02',NULL,'Alta de Recurso 1.','1 (a)'),(299,NULL,'CFG','SEGURIDAD',55,'2017-09-20 14:51:51',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(300,NULL,'CFG','SEGURIDAD',50,'2017-09-20 15:03:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(301,NULL,'CFG','SEGURIDAD',50,'2017-09-20 15:52:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(302,NULL,'CFG','CONF-R',113,'2017-09-20 15:53:06',NULL,'Alta de Recurso ascsda.','1 (a)'),(303,NULL,'CFG','SEGURIDAD',50,'2017-09-20 15:54:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(304,NULL,'CFG','CONF-R',113,'2017-09-20 15:55:16',NULL,'Alta de Recurso shgf.','1 (a)'),(305,NULL,'CFG','SEGURIDAD',51,'2017-09-20 16:08:49',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(306,NULL,'CFG','SEGURIDAD',50,'2017-09-20 16:12:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(307,NULL,'CFG','SEGURIDAD',50,'2017-09-20 16:18:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(308,NULL,'CFG','SEGURIDAD',50,'2017-09-20 16:19:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(309,NULL,'CFG','CONF-R',113,'2017-09-20 16:19:34',NULL,'Alta de Recurso asdasd.','1 (a)'),(310,NULL,'CFG','CONF-R',116,'2017-09-20 16:19:42',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(311,NULL,'CFG','CONF-R',116,'2017-09-20 16:19:58',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(312,NULL,'CFG','CONF-R',116,'2017-09-20 16:20:06',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(313,NULL,'CFG','CONF-R',116,'2017-09-20 16:20:20',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(314,NULL,'CFG','CONF-R',116,'2017-09-20 16:20:43',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(315,NULL,'CFG','CONF-R',116,'2017-09-20 16:21:17',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(316,NULL,'CFG','CONF-R',116,'2017-09-20 16:21:24',NULL,'Modificación de Parámetros Lógicos de  Recurso asdasd.','1 (a)'),(317,NULL,'CFG','CONF-R',113,'2017-09-20 16:22:43',NULL,'Alta de Recurso sdasd.','1 (a)'),(318,NULL,'CFG','CONF-R',116,'2017-09-20 16:22:51',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(319,NULL,'CFG','SEGURIDAD',50,'2017-09-20 16:32:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(320,NULL,'CFG','CONF-R',113,'2017-09-20 16:35:49',NULL,'Alta de Recurso asdas.','1 (a)'),(321,NULL,'CFG','CONF-R',114,'2017-09-20 16:35:58',NULL,'Baja de Recurso asdas.','1 (a)'),(322,NULL,'CFG','CONF-R',116,'2017-09-20 17:10:23',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(323,NULL,'CFG','CONF-R',116,'2017-09-20 17:11:16',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(324,NULL,'CFG','CONF-R',116,'2017-09-20 17:11:57',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(325,NULL,'CFG','CONF-R',116,'2017-09-20 17:12:28',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(326,NULL,'CFG','CONF-R',116,'2017-09-20 17:12:53',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(327,NULL,'CFG','CONF-R',116,'2017-09-20 17:13:49',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(328,NULL,'CFG','CONF-R',116,'2017-09-20 17:15:06',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(329,NULL,'CFG','SEGURIDAD',50,'2017-09-20 17:20:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(330,NULL,'CFG','SEGURIDAD',50,'2017-09-20 17:22:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(331,NULL,'CFG','CONF-R',116,'2017-09-20 17:22:34',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(332,NULL,'CFG','CONF-R',116,'2017-09-20 17:25:40',NULL,'Modificación de Parámetros Lógicos de  Recurso sdasd.','1 (a)'),(333,NULL,'CFG','SEGURIDAD',50,'2017-09-21 08:58:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(334,NULL,'CFG','SEGURIDAD',50,'2017-09-21 09:03:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(335,NULL,'CFG','SEGURIDAD',50,'2017-09-21 09:08:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(336,NULL,'CFG','SEGURIDAD',50,'2017-09-21 09:10:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(337,NULL,'CFG','SEGURIDAD',55,'2017-09-21 10:10:04',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(338,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:10:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(339,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:14:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(340,NULL,'CFG','CONF-R',116,'2017-09-21 10:14:58',NULL,'Modificación de Parámetros Lógicos de  Recurso asdas.','1 (a)'),(341,NULL,'CFG','CONF-R',113,'2017-09-21 10:15:44',NULL,'Alta de Recurso asd23.','1 (a)'),(342,NULL,'CFG','CONF-R',113,'2017-09-21 10:16:53',NULL,'Alta de Recurso 113assda.','1 (a)'),(343,NULL,'CFG','CONF-R',116,'2017-09-21 10:17:56',NULL,'Modificación de Parámetros Lógicos de  Recurso 113assda.','1 (a)'),(344,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:29:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(345,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:34:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(346,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:35:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(347,NULL,'CFG','SEGURIDAD',51,'2017-09-21 10:35:13',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(348,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:35:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(349,NULL,'CFG','CONF-R',113,'2017-09-21 10:35:59',NULL,'Alta de Recurso 132xz.','1 (a)'),(350,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:36:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(351,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:37:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(352,NULL,'CFG','CONF-R',116,'2017-09-21 10:37:46',NULL,'Modificación de Parámetros Lógicos de  Recurso 132xz.','1 (a)'),(353,NULL,'CFG','CONF-R',116,'2017-09-21 10:38:01',NULL,'Modificación de Parámetros Lógicos de  Recurso 132xz.','1 (a)'),(354,NULL,'CFG','CONF-R',116,'2017-09-21 10:38:09',NULL,'Modificación de Parámetros Lógicos de  Recurso 132xz.','1 (a)'),(355,NULL,'CFG','CONF-R',113,'2017-09-21 10:38:24',NULL,'Alta de Recurso 121gew.','1 (a)'),(356,NULL,'CFG','CONF-R',113,'2017-09-21 10:38:36',NULL,'Alta de Recurso asda1223.','1 (a)'),(357,NULL,'CFG','CONF-R',114,'2017-09-21 10:38:40',NULL,'Baja de Recurso 121gew.','1 (a)'),(358,NULL,'CFG','CONF-R',114,'2017-09-21 10:38:44',NULL,'Baja de Recurso 132xz.','1 (a)'),(359,NULL,'CFG','CONF-R',114,'2017-09-21 10:38:48',NULL,'Baja de Recurso asda1223.','1 (a)'),(360,NULL,'CFG','CONF-R',114,'2017-09-21 10:38:52',NULL,'Baja de Recurso shgf.','1 (a)'),(361,NULL,'CFG','SEGURIDAD',50,'2017-09-21 10:53:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(362,NULL,'CFG','CONF-R',113,'2017-09-21 10:54:13',NULL,'Alta de Recurso 21dasa.','1 (a)'),(363,NULL,'CFG','CONF-R',113,'2017-09-21 10:55:34',NULL,'Alta de Recurso asd5567.','1 (a)'),(364,NULL,'CFG','CONF-R',116,'2017-09-21 10:55:46',NULL,'Modificación de Parámetros Lógicos de  Recurso asd5567.','1 (a)'),(365,NULL,'CFG','CONF-R',113,'2017-09-21 10:56:11',NULL,'Alta de Recurso asd674345.','1 (a)'),(366,NULL,'CFG','SEGURIDAD',50,'2017-09-21 11:00:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(367,NULL,'CFG','SEGURIDAD',55,'2017-09-21 11:00:15',NULL,'Fin sesion  Configuración Centralizada  del usuario  .','1'),(368,NULL,'CFG','SEGURIDAD',50,'2017-09-21 11:00:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','4'),(369,NULL,'CFG','SEGURIDAD',50,'2017-09-21 11:01:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(370,NULL,'CFG','CONF-R',116,'2017-09-21 11:14:38',NULL,'Modificación de Parámetros Lógicos de  Recurso asd674345.','1 (a)'),(371,NULL,'CFG','SEGURIDAD',55,'2017-09-21 12:01:07',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(372,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:02:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(373,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:23',NULL,'Baja de Recurso asd674345.','1 (a)'),(374,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:26',NULL,'Baja de Recurso asd5567.','1 (a)'),(375,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:31',NULL,'Baja de Recurso asdas.','1 (a)'),(376,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:34',NULL,'Baja de Recurso asdasd.','1 (a)'),(377,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:37',NULL,'Baja de Recurso ascsda.','1 (a)'),(378,NULL,'CFG','CONF-R',116,'2017-09-21 12:06:41',NULL,'Modificación de Parámetros Lógicos de  Recurso ttt.','1 (a)'),(379,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:44',NULL,'Baja de Recurso ttt.','1 (a)'),(380,NULL,'CFG','CONF-R',114,'2017-09-21 12:06:50',NULL,'Baja de Recurso sda3.','1 (a)'),(381,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:10:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(382,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:13:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(383,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:18:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(384,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:19:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(385,NULL,'CFG','SEGURIDAD',50,'2017-09-21 12:21:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(386,NULL,'CFG','CONF-R',113,'2017-09-21 12:21:59',NULL,'Alta de Recurso asdas23.','1 (a)'),(387,NULL,'CFG','CONF-R',113,'2017-09-21 12:23:51',NULL,'Alta de Recurso asda.','1 (a)');
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
INSERT INTO `incidencias` VALUES (47,'Inicio sesión RCS2010 UG5KR','Inicio sesión RCS2010 UG5KR  del usuario: {0}',0,'SEGURIDAD',0,0),(48,'Recahazada sesión RCS2010 UG5KR','Rechazada sesión RCS2010 UG5KR  al usuario: {0}',0,'SEGURIDAD',0,0),(49,'Fin sesion RCS2010 UG5KR','Fin sesion RCS2010 UG5KR  del usuario: {0}',0,'SEGURIDAD',0,0),(50,'Inicio sesión Configuración Centralizada','Inicio sesión Configuración Centralizada  del usuario',0,'SEGURIDAD',0,0),(51,'Rechazado  sesión Configuración Centralizada','Rechazada sesión Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(52,'Alta Usuario','Alta Usuario',0,'SEGURIDAD',0,0),(53,'Borrado Usuario','Borrado Usuario ',0,'SEGURIDAD',0,0),(54,'Modificado Usuario','Modificado Usuario',0,'SEGURIDAD',0,0),(55,'Fin sesion  Configuración Centralizada ','Fin sesion  Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(105,'Carga de Configuración Remota','Carga de Configuración Remota',0,'CONF-R',0,0),(106,'Error Carga Configuración Remota','Error Carga Configuración Remota',0,'CONF-R',0,0),(107,'Alta de Pasarela','Alta de Pasarela',0,'CONF-R',0,0),(108,'Baja de Pasarela','Baja de Pasarela',0,'CONF-R',0,0),(109,'Modificación de Parámetros Generales de Pasarela','Modificación de Parámetros Generales de Pasarela',0,'CONF-R',0,0),(110,'Modificación Rutas ATS','Modificación Rutas ATS',0,'CONF-R',0,0),(113,'Alta de Recurso','Alta de Recurso',0,'CONF-R',0,0),(114,'Baja de Recurso','Baja de Recurso',0,'CONF-R',0,0),(115,'Modificación de Parámetros de Recurso','Modificación de Parámetros de Recurso',0,'CONF-R',0,0),(116,'Modificación de Parámetros Lógicos de  Recurso','Modificación de Parámetros Lógicos de  Recurso',0,'CONF-R',0,0),(117,'Baja de Tabla de Calificación de Audio','Baja de Tabla de Calificación de Audio',0,'CONF-R',0,0),(118,'Alta de Tabla de Calificación de Audio','Alta de Tabla de Calificación de Audio',0,'CONF-R',0,0),(150,'Modificación de Parámetros Generales de Pasarela.','Modificación Parámetro en: {0}. {1}',0,'CONF-L',0,0),(153,'Modificación de Parámetros Lógico de Recurso','Modificación SW en Recurso: {0}. {1}. {2}',0,'CONF-L',0,0),(154,'Generación de Configuración por Defecto.','Generación de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(155,'Activación de Configuración por Defecto.','Activación de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(156,'Borrado de Configuración por Defecto','Borrado de Configuración por Defecto: {0}. {1}',0,'CONF-L',0,0),(157,'Alta Recurso Radio','Recurso Radio  Añadido: {0}. {1}. {2}',0,'CONF-L',0,0),(158,'Baja Recurso Radio','Recurso Radio Eliminado: {0}. {1}. {2}',0,'CONF-L',0,0),(159,'Alta Recurso Telefonía','Recurso Telefónico Añadido: {0}. {1}. {2}',0,'CONF-L',0,0),(160,'Baja Recurso Telefonía','Recurso Telefónico  Eliminado: {0} . {1} . {2}',0,'CONF-L',0,0),(161,'Conflicto de configuraciones','Conflicto de Configuración en GW: {0}. {1}. {2}',0,'CONF-L',0,0),(180,'Carga versión Software Pasarela','Carga de Versión Software Pasarela: {0} {1}',0,'MAN-L',0,0),(182,'Reset Remoto','Reset Remoto: {0}',0,'MAN-L',0,0),(183,'Selección Bucle Prueba','Selección Bucle: {0} {1}  en {2}.',0,'MAN-L',0,0),(184,'Comando Bite','Selección  BITE: {0}',0,'MAN-L',0,0),(185,'Conmutacion P/R','Selección Conmutación P/R: {0}',0,'MAN-L',0,0),(186,'Selección Modo','Selección Modo: {0}',0,'MAN-L',0,0),(187,'Resultado Comando Bite','Resultado  BITE: {0} : {1}',0,'MAN-L',0,0),(193,'Resultado  bucle prueba','Resultado Bucle: {0} en {1} : {2}',0,'MAN-L',0,0),(195,'Resultado Conmutacion P/R','Resultado  Conmutación P/R: {0} {1}',0,'MAN-L',0,0),(196,'Resultado  Modo','Resultado  Modo: {0}',0,'MAN-L',0,0),(201,'Arranque APP RCS2010','Arranque APP RCS2010 UG5KR en puesto: {0}',1,'SP-GEN',0,2),(202,'Cierre Aplicacion APP RCS2010','Cierre Aplicacion APP RCS2010 UG5KR  en puesto: {0}',1,'SP-GEN',0,2),(2000,'Cambio estado Pasarela','Cambio estado pasarela: {0}',1,'SP-PASARELA',0,2),(2003,'Cambio Estado LAN','Cambio Estado LANs. CGW: {0} : LAN1 {1}  : LAN2 {2}',1,'SP-PASARELA',0,1),(2005,'Cambio Estado CPU','Cambio Estado CPUs. CGW: {0} : CPU Local {1}  : CPU Dual {2}',1,'SP-PASARELA',0,2),(2007,'Conexión Recurso Radio','Conexión Recurso Radio: {0}',1,'SP-PASARELA',0,0),(2008,'Desconexión Recurso Radio','Desconexión Recurso Radio: {0}',1,'SP-PASARELA',1,0),(2009,'Conexión Recurso Telefonía','Conexión Recurso Telefonía: {0}',1,'SP-PASARELA',0,0),(2010,'Desconexión Recurso Telefonía','Desconexión Recurso Telefonía: {0}',1,'SP-PASARELA',1,0),(2011,'Conexión Tarjeta Interfaz (esclava-tipo)','Conexión Tarjeta Interfaz. Número: {0}: Tipo: {1}',1,'SP-PASARELA',0,0),(2012,'Desconexión Tarjeta Interfaz (esclava-tipo)','Desconexión Tarjeta Interfaz. Número: {0}: Tipo: {1}',1,'SP-PASARELA',1,0),(2013,'Conexión Recurso R2','Conexión Recurso R2: {0}',1,'SP-PASARELA',0,0),(2014,'Desconexión Recurso R2.','Desconexión Recurso R2: {0}',1,'SP-PASARELA',1,0),(2015,'Conexión Recurso N5','Conexión Recurso N5: {0}',1,'SP-PASARELA',0,0),(2016,'Desconexión Recurso N5','Desconexión Recurso N5: {0}',1,'SP-PASARELA',1,0),(2017,'Conexión Recurso QSIG','Conexión Recurso QSIG: {0}',1,'SP-PASARELA',0,0),(2018,'Desconexión Recurso  QSIG','Desconexión Recurso QSIG: {0}',1,'SP-PASARELA',1,0),(2019,'Conexión Recurso LCEN','Conexión Recurso LCEN: {0}',1,'SP-PASARELA',0,0),(2020,'Desconexión Recurso  LCEN','Desconexión Recurso  LCEN: {0}',1,'SP-PASARELA',1,0),(2021,'Servicio NTP Conectado','Servicio NTP Conectado',1,'SP-PASARELA',0,0),(2022,'Servicio NTP Desconectado','Servicio NTP Desconectado',1,'SP-PASARELA',1,0),(2027,'Cambio estado Sincro BD.','Cambio estado Sincro BD: {0}',1,'SP-PASARELA',0,0),(2101,'Caída/establecimiento sesión SIP','Cambio sesión SIP. Recurso: {0} Sesión:  {1} {2} {3} ',1,'SP-RADIO',0,0),(2102,'Cambio PTT','Cambio estado PTT. Recurso: {0} Estado: {1}',0,'SP-RADIO',0,0),(2103,'Cambio SQU','Cambio estado SQU. Recurso: {0} Estado: {1}',0,'SP-RADIO',0,0),(2200,'Error Protocolo LCEN','Error Protocolo LCEN. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2202,'Fallo test LCEN VoIP (mensaje Options)','Fallo test LCEN VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2203,'Error Protocolo R2','Error Protocolo R2. Recurso: {0}.',1,'SP-TELEFONIA',1,0),(2204,'Fallo llamada de test R2 SCV','Fallo llamada de test R2 SCV. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2205,'Fallo llamada de test R2 VoIP (mensaje Options)','Fallo llamada de test R2 VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2206,'Error Protocolo N5','Error Protocolo N5. Recurso: {0}.',1,'SP-TELEFONIA',1,0),(2207,'Fallo llamada de test N5 SCV','Fallo llamada de test N5 SCV. Recurso: {0}',1,'SP-TELEFONIA',1,0),(2208,'Fallo llamada de test N5 VoIP (mensaje Options)','Fallo llamada de test N5 VoIP. Recurso: {0}',1,'SP-TELEFONIA',1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=774 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
INSERT INTO `lista_ips` VALUES (669,16,'10.1.1.100','PRX',0),(670,16,'10.1.1.200','NTP',0),(671,16,'2,10.1.1.200/162','TRPV2',0),(672,17,'10.1.1.100','PRX',0),(673,17,'10.1.1.200','NTP',0),(674,17,'2,10.1.1.200/162','TRPV2',0),(675,18,'10.1.1.100','PRX',0),(676,18,'10.1.1.200','NTP',0),(677,18,'2,10.1.1.200/162','TRPV2',0),(681,19,'10.1.1.100','PRX',0),(682,19,'10.1.1.200','NTP',0),(683,19,'2,10.1.1.200/162','TRPV2',0),(711,15,'10.1.1.100','PRX',0),(712,15,'10.1.1.200','NTP',0),(713,15,'2,10.1.1.200/162','TRPV2',0),(723,24,'10.1.1.100','PRX',0),(724,24,'10.1.1.200','NTP',0),(725,24,'2,10.1.1.200/162','TRPV2',0),(746,32,'10.1.1.100','PRX',0),(747,32,'10.1.1.200','NTP',0),(748,33,'10.1.1.100','PRX',0),(749,33,'10.1.1.200','NTP',0),(750,33,'2,10.1.1.200/162','TRPV2',0),(751,34,'10.1.1.100','PRX',0),(752,34,'10.1.1.200','NTP',0),(753,34,'2,10.1.1.200/162','TRPV2',0),(754,35,'10.1.1.100','PRX',0),(755,35,'10.1.1.200','NTP',0),(756,35,'2,10.1.1.200/162','TRPV2',0),(757,41,'10.1.1.100','PRX',0),(758,41,'10.1.1.200','NTP',0),(759,41,'2,10.1.1.200/162','TRPV2',0),(760,36,'10.1.1.100','PRX',0),(761,36,'10.1.1.200','NTP',0),(762,36,'2,10.1.1.200/162','TRPV2',0),(763,37,'10.1.1.100','PRX',0),(764,37,'10.1.1.200','NTP',0),(765,37,'2,10.1.1.200/162','TRPV2',0),(766,38,'10.1.1.100','PRX',0),(767,38,'10.1.1.200','NTP',0),(768,38,'2,10.1.1.200/162','TRPV2',0),(769,39,'10.1.1.100','PRX',0),(770,39,'10.1.1.200','NTP',0),(771,39,'2,10.1.1.200/162','TRPV2',0),(772,40,'10.1.1.100','PRX',0),(773,40,'10.1.1.200','NTP',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_uris`
--

LOCK TABLES `lista_uris` WRITE;
/*!40000 ALTER TABLE `lista_uris` DISABLE KEYS */;
INSERT INTO `lista_uris` VALUES (117,108,'sip:negra1@1.1.1.1:4040','LSN',0),(118,108,'sip:negra2@1.1.1.1:4040','LSN',0),(123,110,'sip:negra1@1.1.1.1:4040','LSN',0),(124,110,'sip:negra2@1.1.1.1:4040','LSN',0),(125,111,'sip:aaa@1.1.1.1:4040','TXA',1),(126,111,'sip:bbb@2.2.2.2:3030','RXA',1),(127,112,'sip:negra1@1.1.1.1:4040','LSN',0),(128,112,'sip:negra2@1.1.1.1:4040','LSN',0),(129,113,'sip:aaa@1.1.1.1:4040','TXA',1),(130,113,'sip:bbb@2.2.2.2:3030','RXA',1),(131,114,'sip:negra1@1.1.1.1:4040','LSN',0),(132,114,'sip:negra2@1.1.1.1:4040','LSN',0),(133,115,'sip:aaa@1.1.1.1:4040','TXA',1),(134,115,'sip:bbb@2.2.2.2:3030','RXA',1),(154,124,'sip:negra@1.1.1.1','LSN',0),(155,124,'sip:blanca@1.1.1.1','LSB',0);
/*!40000 ALTER TABLE `lista_uris` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ug5kv2`.`lista_uris_BEFORE_INSERT` BEFORE INSERT ON `lista_uris` FOR EACH ROW
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operadores`
--

LOCK TABLES `operadores` WRITE;
/*!40000 ALTER TABLE `operadores` DISABLE KEYS */;
INSERT INTO `operadores` VALUES (1,'root','MQ==',64),(2,'1','MQ==',64),(3,'4','MQ==',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasarelas`
--

LOCK TABLES `pasarelas` WRITE;
/*!40000 ALTER TABLE `pasarelas` DISABLE KEYS */;
INSERT INTO `pasarelas` VALUES (15,21,'ACC-GW-01','10.1.1.0','2017-09-07 10:44:46','10.1.1.1','10.1.1.100','255.255.255.0','10.1.1.3','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(16,21,'ACC-GW-02','10.1.1.4','2017-09-07 09:37:37','10.1.1.5','10.1.1.100','255.255.255.0','10.1.1.7','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(17,22,'TWRN-GW-01','10.2.1.0','2017-09-07 09:37:37','10.2.1.1','10.2.1.100','255.255.255.0','10.2.1.3','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(18,22,'TWRN-GW-02','10.2.1.4','2017-09-06 14:27:00','10.2.1.5','10.2.1.100','255.255.255.0','10.2.1.7','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(19,23,'ALC-GW-01','10.3.1.0','2017-09-07 09:37:37','10.3.1.1','10.3.1.100','255.255.255.0','10.3.1.3','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(24,23,'ALC-GW-03','10.3.1.8','2017-09-07 12:25:18','10.3.1.11','10.3.1.100','255.255.255.0','10.3.1.13','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(32,23,'ALC-GW-02','10.3.1.4','2017-09-07 12:37:37','10.3.1.5','10.3.1.100','255.255.255.0','10.3.1.6','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(33,21,'asdasdas','10.1.1.2','2017-09-13 09:55:44','10.1.1.21','10.1.1.100','255.255.255.0','10.1.1.22','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',1),(34,27,'ACC-GW-01','10.1.1.0','2017-09-13 09:59:08','10.1.1.1','10.1.1.100','255.255.255.0','10.1.1.3','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(35,27,'ACC-GW-02','10.1.1.4','2017-09-13 09:59:08','10.1.1.5','10.1.1.100','255.255.255.0','10.1.1.7','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(36,28,'TWRN-GW-01','10.2.1.0','2017-09-13 09:59:08','10.2.1.1','10.2.1.100','255.255.255.0','10.2.1.3','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(37,28,'TWRN-GW-02','10.2.1.4','2017-09-13 09:59:08','10.2.1.5','10.2.1.100','255.255.255.0','10.2.1.7','10.2.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(38,29,'ALC-GW-01','10.3.1.0','2017-09-13 09:59:08','10.3.1.1','10.3.1.100','255.255.255.0','10.3.1.3','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(39,29,'ALC-GW-03','10.3.1.8','2017-09-13 09:59:08','10.3.1.11','10.3.1.100','255.255.255.0','10.3.1.13','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(40,29,'ALC-GW-02','10.3.1.4','2017-09-13 09:59:08','10.3.1.5','10.3.1.100','255.255.255.0','10.3.1.6','10.3.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DFLABS','NUCLEO-DFDT.MADRID.SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0),(41,27,'asdasdas','10.1.1.2','2017-09-13 09:59:08','10.1.1.21','10.1.1.100','255.255.255.0','10.1.1.22','10.1.1.100','255.255.255.0',5060,90,65000,161,1,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'10.1.1.120','10.1.1.121',0);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rangos_ats`
--

LOCK TABLES `rangos_ats` WRITE;
/*!40000 ALTER TABLE `rangos_ats` DISABLE KEYS */;
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
  `tipo` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT '1 para Radio y 2 para telefonía',
  `alias` varchar(45) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Alias de la uri',
  PRIMARY KEY (`idrecursos_externos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_externos`
--

LOCK TABLES `recursos_externos` WRITE;
/*!40000 ALTER TABLE `recursos_externos` DISABLE KEYS */;
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
  `frecuencia` float(6,3) NOT NULL COMMENT 'Frecuencia en MHz (UHF/VHF). desde 30.000 a 300.000 y pico',
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
  `umbral_vad` float(3,1) NOT NULL DEFAULT '-27.0' COMMENT 'Umbral Vad. Rango min: -35.0, max: -15.0.',
  `tiempo_max_ptt` int(4) NOT NULL DEFAULT '0' COMMENT 'Tiempo máximo PTT. Rango de min: 0, max: 1000',
  `ventana_bss` int(4) NOT NULL DEFAULT '500' COMMENT 'Ventana BSS. Rango min: 10, max: 5000.',
  `tipo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Tipo de climax.1(ASAP), 2(TIEMPO FIJO).',
  `retardo_fijo_climax` int(3) NOT NULL DEFAULT '100' COMMENT 'Retardo fijo climax. Rango min: 0, max: 250',
  `cola_bss_sqh` int(4) NOT NULL DEFAULT '500' COMMENT 'Cola BSS SQH. Rango min: 10, max: 5000.',
  `retardo_jitter` int(3) NOT NULL DEFAULT '30' COMMENT 'Retardo jitter. Rango min: 0, max: 100.',
  `metodo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Método climax. Valores 0 (Relativo), 1 (Absoluto).',
  `restriccion_entrantes` int(1) DEFAULT '0' COMMENT 'Restricción entrantes. Valores: 0 (Ninguna), 1 (Lista Negra), 2 (Lista Blanca)',
  PRIMARY KEY (`idrecurso_radio`),
  KEY `fk_pasarela_radio_idx` (`pasarela_id`),
  KEY `fk_radio_tabla_bss_idx` (`tabla_bss_id`),
  CONSTRAINT `fk_pasarela_radio` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_radio`
--

LOCK TABLES `recursos_radio` WRITE;
/*!40000 ALTER TABLE `recursos_radio` DISABLE KEYS */;
INSERT INTO `recursos_radio` VALUES (108,15,0,0,'RxTx',0,NULL,135.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,1),(110,33,0,0,'RxTx',0,'null',135.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,1),(111,33,0,1,'Test',0,'null',135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,0),(112,34,0,0,'RxTx',0,'null',135.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,1),(113,34,0,1,'Test',0,'null',135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,0),(114,41,0,0,'RxTx',0,'null',135.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,1),(115,41,0,1,'Test',0,'null',135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,0,100,500,30,0,0),(123,17,0,0,'asdasd',0,NULL,135.000,0.00,0.00,0,3,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,1,100,500,30,0,0),(124,17,0,1,'sdasd',0,NULL,135.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,0,0,0,-20.0,0,500,1,100,500,30,0,2),(125,15,2,0,'asd23',0,NULL,135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-27.0,0,500,1,100,500,30,0,0),(126,15,2,1,'113assda',0,NULL,135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-27.0,0,500,1,100,500,30,0,0),(129,15,3,0,'21dasa',0,NULL,135.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,0,0,0,-27.0,0,500,1,100,500,30,0,0);
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
  `ajuste_ad` int(10) DEFAULT NULL COMMENT 'Ajuste cero digital en A/D',
  `ajuste_da` int(10) DEFAULT NULL COMMENT 'Ajuste cero digital en D/A',
  `precision_audio` int(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Precisión de Audio: (0) Estricto o (1) Normal. Por ahora no lo utilizamos',
  `tipo_interfaz_tel` int(1) NOT NULL COMMENT 'Tipo de interfaz telefónico. 0 (BL), 1(BC), 2(AB), 3(R2), 4(N5), 5(LCEN), 6 (QSIG)',
  `deteccion_vox` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Detección Vox. (1) Si, (0) No.',
  `umbral_vox` int(10) NOT NULL DEFAULT '-27' COMMENT 'Valor del umbral Vox en dB.',
  `cola_vox` int(10) NOT NULL DEFAULT '5' COMMENT 'Valor para la cola Vox en segundos.',
  `respuesta_automatica` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Respuesta automática. (1) Si, (0) No.',
  `periodo_tonos` int(2) NOT NULL DEFAULT '5' COMMENT 'Periodo tonos respuesta estado en segundos. Rango min: 1, max: 10',
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_telefono`
--

LOCK TABLES `recursos_telefono` WRITE;
/*!40000 ALTER TABLE `recursos_telefono` DISABLE KEYS */;
INSERT INTO `recursos_telefono` VALUES (28,33,1,0,'ttt',0,'null',0,0,1,0,1,-15,0,0,0,0,'','',0,5,5,'sip:pepe@1.1.1.1:5050'),(29,34,1,0,'ttt',0,'null',0,0,1,0,1,-15,0,0,0,0,'','',0,5,5,'sip:pepe@1.1.1.1:5050'),(30,41,1,0,'ttt',0,'null',0,0,1,0,1,-15,0,0,0,0,'','',0,5,5,'sip:pepe@1.1.1.1:5050'),(31,15,0,2,'1',0,NULL,0,0,1,0,1,-15,0,0,0,0,'','',0,5,5,''),(33,15,0,1,'asdas23',0,NULL,0,0,1,0,1,-27,5,0,5,0,'','',0,5,5,''),(34,15,1,2,'asda',0,NULL,0,0,1,0,1,-27,5,0,5,0,'','',0,5,5,'');
/*!40000 ALTER TABLE `recursos_telefono` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ug5kv2`.`recurso_telefono_BEFORE_INSERT` BEFORE INSERT ON `recursos_telefono` FOR EACH ROW
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
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ug5kv2`.`recursos_telefono_BEFORE_UPDATE` BEFORE UPDATE ON `recursos_telefono` FOR EACH ROW
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablas_bss`
--

LOCK TABLES `tablas_bss` WRITE;
/*!40000 ALTER TABLE `tablas_bss` DISABLE KEYS */;
INSERT INTO `tablas_bss` VALUES (1,'TbDef','Tabla por defecto','2017-09-06 12:14:34',0,3,8,11,13,15),(2,'asdasd','as','2017-09-20 10:03:22',0,0,0,0,0,0),(3,'asda','asd','2017-09-20 10:05:46',0,0,0,0,0,0),(10,'12asda','','2017-09-20 10:17:25',0,0,0,0,0,0),(11,'1345vvv','','2017-09-20 10:18:14',0,0,0,0,0,0),(12,'asdw213','','2017-09-20 10:18:32',0,0,0,0,0,0);
/*!40000 ALTER TABLE `tablas_bss` ENABLE KEYS */;
UNLOCK TABLES;

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
/*!50001 VIEW `info_cgw` AS select `p`.`nombre` AS `name`,1 AS `dual_cpu`,`e`.`nombre` AS `emplazamiento`,1 AS `num_cpu`,`p`.`ip_virtual` AS `virtual_ip`,1 AS `dual_lan`,'' AS `ip_eth0`,'' AS `ip_eth1`,`p`.`ip_cpu0` AS `bound_ip`,`p`.`ip_gtw0` AS `gateway_ip` from ((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) where (`c`.`activa` = 1) union select `p`.`nombre` AS `name`,1 AS `dual_cpu`,`e`.`nombre` AS `emplazamiento`,2 AS `num_cpu`,`p`.`ip_virtual` AS `virtual_ip`,1 AS `dual_lan`,'' AS `ip_eth0`,'' AS `ip_eth1`,`p`.`ip_cpu1` AS `bound_ip`,`p`.`ip_gtw1` AS `gateway_ip` from ((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) where (`c`.`activa` = 1) order by `emplazamiento`,`name`,`num_cpu` desc */;
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

-- Dump completed on 2017-09-21 12:24:32
