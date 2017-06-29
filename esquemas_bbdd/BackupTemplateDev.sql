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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES (5,'CONFIGURACION1','Descripcion 1',NULL,1,'2017-06-20 09:22:46'),(6,'CONFIGURACION2','Descripcion 2',NULL,0,NULL),(7,'CONFIGURACION3','Descripcion 3',NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emplazamientos`
--

LOCK TABLES `emplazamientos` WRITE;
/*!40000 ALTER TABLE `emplazamientos` DISABLE KEYS */;
INSERT INTO `emplazamientos` VALUES (13,'EMPLAZAMIENTO1',5),(14,'EMPLAZAMIENTO2',5),(15,'EMPLAZAMIENTO3',5),(17,'EMPLAZAMIENTO5',6),(18,'EMPLAZAMIENTO7',7),(19,'EMPLAZAMIENTO4',5),(20,'EMPLAZAMIENTO6',6);
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
) ENGINE=InnoDB AUTO_INCREMENT=901 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
INSERT INTO `historicoincidencias` VALUES (125,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:27:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(126,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:28:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(127,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:30:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(128,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:10:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(129,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:39:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(130,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:42:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(131,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:44:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(132,NULL,'CFG','SEGURIDAD',50,'2017-05-31 11:11:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(133,NULL,'CFG','SEGURIDAD',50,'2017-05-31 11:13:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(134,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:12:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(135,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:14:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(136,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:25:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(137,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:28:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(138,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:33:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(139,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:34:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(140,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:38:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(141,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:46:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(142,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:58:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(143,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:00:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(144,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:03:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(145,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:07:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(146,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:11:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(147,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:15:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(148,NULL,'CFG','SEGURIDAD',50,'2017-05-31 16:50:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(149,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:00:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(150,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:09:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(151,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:15:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(152,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:22:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(153,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:24:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(154,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:28:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(155,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:30:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(156,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:32:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(157,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:35:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(158,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:39:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(159,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:40:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(160,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:42:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(161,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:45:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(162,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:05:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(163,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:07:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(164,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:09:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(165,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:13:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(166,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:14:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(167,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:16:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(168,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:17:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(169,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:20:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(170,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:01:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(171,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:08:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(172,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:11:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(173,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:13:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(174,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:15:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(175,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:17:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(176,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:20:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(177,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:25:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(178,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:32:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(179,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:39:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(180,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:19:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(181,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:32:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(182,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:35:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(183,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:42:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(184,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:44:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(185,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:45:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(186,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:52:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(187,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:56:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(188,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:58:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(189,NULL,'CFG','SEGURIDAD',50,'2017-06-01 10:59:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(190,NULL,'CFG','SEGURIDAD',50,'2017-06-01 11:02:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(191,NULL,'CFG','SEGURIDAD',50,'2017-06-01 11:05:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(192,NULL,'CFG','SEGURIDAD',50,'2017-06-01 11:07:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(193,NULL,'CFG','SEGURIDAD',50,'2017-06-05 09:27:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(194,NULL,'CFG','SEGURIDAD',50,'2017-06-05 09:55:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(195,NULL,'CFG','SEGURIDAD',50,'2017-06-05 10:08:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(196,NULL,'CFG','SEGURIDAD',50,'2017-06-05 10:15:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(197,NULL,'CFG','SEGURIDAD',50,'2017-06-05 10:29:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(198,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:21:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(199,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:24:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(200,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:26:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(201,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:27:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(202,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:56:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(203,NULL,'CFG','SEGURIDAD',50,'2017-06-05 11:58:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(204,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:23:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(205,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:26:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(206,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:46:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(207,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:52:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(208,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:53:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(209,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:57:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(210,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:58:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(211,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:58:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(212,NULL,'CFG','SEGURIDAD',50,'2017-06-05 12:59:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(213,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:04:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(214,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:07:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(215,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:08:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(216,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:10:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(217,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:45:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(218,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:46:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(219,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:48:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(220,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:49:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(221,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:52:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(222,NULL,'CFG','SEGURIDAD',50,'2017-06-05 13:56:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(223,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:39:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(224,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:48:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(225,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:49:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(226,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:51:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(227,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:52:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(228,NULL,'CFG','SEGURIDAD',50,'2017-06-05 14:53:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(229,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:07:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(230,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:16:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(231,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:18:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(232,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:19:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(233,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:19:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(234,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:20:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(235,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:29:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(236,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:30:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(237,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:31:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(238,NULL,'CFG','SEGURIDAD',51,'2017-06-05 15:31:19',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(239,NULL,'CFG','SEGURIDAD',50,'2017-06-05 15:31:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(240,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:28:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(241,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:29:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(242,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:29:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(243,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:31:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(244,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:32:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(245,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:41:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(246,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:42:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(247,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:43:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(248,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:45:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(249,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:55:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(250,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:56:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(251,NULL,'CFG','SEGURIDAD',50,'2017-06-05 16:59:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(252,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:00:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(253,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:02:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(254,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:03:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(255,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:17:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(256,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:20:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(257,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:27:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(258,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:31:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(259,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:44:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(260,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:49:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(261,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:51:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(262,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:52:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(263,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:53:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(264,NULL,'CFG','SEGURIDAD',50,'2017-06-05 17:56:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(265,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:00:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(266,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:01:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(267,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:08:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(268,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:09:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(269,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:10:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(270,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:11:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(271,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:14:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(272,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:16:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(273,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:22:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(274,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:25:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(275,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:25:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(276,NULL,'CFG','SEGURIDAD',50,'2017-06-05 18:27:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(277,NULL,'CFG','SEGURIDAD',50,'2017-06-06 08:53:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(278,NULL,'CFG','SEGURIDAD',50,'2017-06-06 09:45:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(279,NULL,'CFG','SEGURIDAD',50,'2017-06-06 09:46:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(280,NULL,'CFG','SEGURIDAD',50,'2017-06-06 09:53:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(281,NULL,'CFG','SEGURIDAD',50,'2017-06-06 09:57:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(282,NULL,'CFG','SEGURIDAD',50,'2017-06-06 10:00:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(283,NULL,'CFG','SEGURIDAD',50,'2017-06-06 10:04:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(284,NULL,'CFG','SEGURIDAD',50,'2017-06-06 10:09:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(285,NULL,'CFG','SEGURIDAD',50,'2017-06-06 10:10:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(286,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:21:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(287,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:27:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(288,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:34:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(289,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:49:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(290,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:52:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(291,NULL,'CFG','SEGURIDAD',50,'2017-06-06 11:58:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(292,NULL,'CFG','SEGURIDAD',50,'2017-06-06 12:02:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(293,NULL,'CFG','SEGURIDAD',50,'2017-06-06 12:17:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(294,NULL,'CFG','SEGURIDAD',50,'2017-06-06 12:28:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(295,NULL,'CFG','SEGURIDAD',50,'2017-06-06 12:32:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(296,NULL,'CFG','SEGURIDAD',50,'2017-06-06 12:40:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(297,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:08:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(298,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:13:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(299,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:15:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(300,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:17:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(301,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:19:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(302,NULL,'CFG','SEGURIDAD',50,'2017-06-06 13:21:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(303,NULL,'CFG','SEGURIDAD',50,'2017-06-06 15:19:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(304,NULL,'CFG','SEGURIDAD',50,'2017-06-06 15:49:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(305,NULL,'CFG','SEGURIDAD',50,'2017-06-06 15:52:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(306,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:03:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(307,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:16:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(308,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:17:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(309,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:18:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(310,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:19:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(311,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:22:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(312,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:32:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(313,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:33:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(314,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:33:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(315,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:36:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(316,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:36:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(317,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:45:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(318,NULL,'CFG','SEGURIDAD',50,'2017-06-06 16:48:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(319,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:00:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(320,NULL,'CFG','SEGURIDAD',51,'2017-06-06 17:00:40',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(321,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:00:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(322,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:04:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(323,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:04:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(324,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:06:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(325,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:08:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(326,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:09:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(327,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:10:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(328,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:13:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(329,NULL,'CFG','SEGURIDAD',50,'2017-06-06 17:14:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(330,NULL,'CFG','SEGURIDAD',50,'2017-06-07 08:43:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(331,NULL,'CFG','SEGURIDAD',50,'2017-06-07 09:07:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(332,NULL,'CFG','SEGURIDAD',50,'2017-06-07 09:40:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(333,NULL,'CFG','SEGURIDAD',50,'2017-06-07 10:25:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(334,NULL,'CFG','SEGURIDAD',50,'2017-06-07 10:45:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(335,NULL,'CFG','SEGURIDAD',50,'2017-06-07 10:50:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(336,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:18:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(337,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:18:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(338,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:20:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(339,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:27:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(340,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:42:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(341,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:47:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(342,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:48:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(343,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:50:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(344,NULL,'CFG','SEGURIDAD',50,'2017-06-07 11:59:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(345,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:00:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(346,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:05:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(347,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:14:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(348,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:19:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(349,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:24:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(350,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:30:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(351,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:31:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(352,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:34:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(353,NULL,'CFG','SEGURIDAD',50,'2017-06-07 12:35:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(354,NULL,'CFG','SEGURIDAD',50,'2017-06-08 09:19:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(355,NULL,'CFG','SEGURIDAD',50,'2017-06-08 09:45:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(356,NULL,'CFG','SEGURIDAD',50,'2017-06-08 09:46:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(357,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:25:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(358,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:43:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(359,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:48:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(360,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:53:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(361,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:54:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(362,NULL,'CFG','SEGURIDAD',50,'2017-06-08 10:55:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(363,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:01:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(364,NULL,'CFG','SEGURIDAD',51,'2017-06-08 11:01:33',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(365,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:07:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(366,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:13:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(367,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:18:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(368,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:21:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(369,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:33:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(370,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:37:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(371,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:47:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(372,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:56:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(373,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:57:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(374,NULL,'CFG','SEGURIDAD',50,'2017-06-08 11:58:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(375,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:05:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(376,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:11:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(377,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:16:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(378,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:41:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(379,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:43:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(380,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:44:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(381,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:45:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(382,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:48:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(383,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:49:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(384,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:50:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(385,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:53:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(386,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:55:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(387,NULL,'CFG','SEGURIDAD',50,'2017-06-08 12:58:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(388,NULL,'CFG','SEGURIDAD',50,'2017-06-08 13:06:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(389,NULL,'CFG','SEGURIDAD',50,'2017-06-08 13:22:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(390,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:30:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(391,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:36:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(392,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:37:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(393,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:41:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(394,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:43:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(395,NULL,'CFG','SEGURIDAD',50,'2017-06-08 15:55:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(396,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:03:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(397,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:03:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(398,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:06:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(399,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:08:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(400,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:12:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(401,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:13:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(402,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:17:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(403,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:18:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(404,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:24:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(405,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:27:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(406,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:33:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(407,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:35:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(408,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:37:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(409,NULL,'CFG','SEGURIDAD',50,'2017-06-08 16:44:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(410,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:09:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(411,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:16:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(412,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:18:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(413,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:20:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(414,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:24:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(415,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:25:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(416,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:26:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(417,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:32:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(418,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:32:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(419,NULL,'CFG','SEGURIDAD',50,'2017-06-08 17:34:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(420,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:01:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(421,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:08:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(422,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:11:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(423,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:13:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(424,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:15:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(425,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:16:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(426,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:28:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(427,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:31:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(428,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:41:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(429,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:43:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(430,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:44:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(431,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:46:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(432,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:48:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(433,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:51:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(434,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:57:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(435,NULL,'CFG','SEGURIDAD',50,'2017-06-08 18:57:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(436,NULL,'CFG','SEGURIDAD',50,'2017-06-08 19:00:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(437,NULL,'CFG','SEGURIDAD',51,'2017-06-08 19:00:16',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(438,NULL,'CFG','SEGURIDAD',50,'2017-06-09 08:47:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(439,NULL,'CFG','SEGURIDAD',50,'2017-06-09 09:46:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(440,NULL,'CFG','SEGURIDAD',50,'2017-06-09 10:57:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(441,NULL,'CFG','SEGURIDAD',50,'2017-06-09 10:58:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(442,NULL,'CFG','SEGURIDAD',50,'2017-06-09 11:00:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(443,NULL,'CFG','SEGURIDAD',50,'2017-06-09 11:03:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(444,NULL,'CFG','SEGURIDAD',50,'2017-06-09 11:04:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(445,NULL,'CFG','SEGURIDAD',50,'2017-06-09 11:05:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(446,NULL,'CFG','SEGURIDAD',50,'2017-06-09 11:29:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(447,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:15:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(448,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:41:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(449,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:51:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(450,NULL,'CFG','SEGURIDAD',51,'2017-06-12 09:51:05',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(451,NULL,'CFG','SEGURIDAD',51,'2017-06-12 09:51:34',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(452,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:51:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(453,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:55:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(454,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:57:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(455,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:58:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(456,NULL,'CFG','SEGURIDAD',50,'2017-06-12 09:59:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(457,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:00:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(458,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:05:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(459,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:12:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(460,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:13:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(461,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:17:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(462,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:19:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(463,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:20:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(464,NULL,'CFG','SEGURIDAD',50,'2017-06-12 10:27:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(465,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:09:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(466,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:09:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(467,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:10:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(468,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:12:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(469,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:13:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(470,NULL,'CFG','SEGURIDAD',50,'2017-06-12 11:25:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(471,NULL,'CFG','SEGURIDAD',50,'2017-06-12 12:19:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(472,NULL,'CFG','SEGURIDAD',50,'2017-06-12 12:20:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(473,NULL,'CFG','SEGURIDAD',50,'2017-06-16 12:27:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(474,NULL,'CFG','SEGURIDAD',50,'2017-06-16 12:29:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(475,NULL,'CFG','SEGURIDAD',50,'2017-06-16 12:31:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(476,NULL,'CFG','CONF-R',108,'2017-06-16 12:33:14',NULL,'Baja de Pasarela PASARELA1.','1'),(477,NULL,'CFG','CONF-R',108,'2017-06-16 12:33:18',NULL,'Baja de Pasarela PASARELA3.','1'),(478,NULL,'CFG','SEGURIDAD',50,'2017-06-19 08:58:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(479,NULL,'CFG','SEGURIDAD',50,'2017-06-19 09:42:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(480,NULL,'CFG','SEGURIDAD',50,'2017-06-19 09:45:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(481,NULL,'CFG','SEGURIDAD',50,'2017-06-19 09:47:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(482,NULL,'CFG','SEGURIDAD',50,'2017-06-19 09:53:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(483,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:00:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(484,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:04:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(485,NULL,'CFG','CONF-R',108,'2017-06-19 10:30:24',NULL,'Baja de Pasarela asdas1.','1'),(486,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:33:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(487,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:39:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(488,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:41:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(489,NULL,'CFG','CONF-R',108,'2017-06-19 10:43:42',NULL,'Baja de Pasarela asda.','1'),(490,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:55:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(491,NULL,'CFG','SEGURIDAD',50,'2017-06-19 10:57:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(492,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:01:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(493,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:19:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(494,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:20:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(495,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:23:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(496,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:25:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(497,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:26:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(498,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:26:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(499,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:28:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(500,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:29:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(501,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:31:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(502,NULL,'CFG','SEGURIDAD',50,'2017-06-19 11:32:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(503,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:05:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(504,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:08:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(505,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:09:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(506,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:16:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(507,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:20:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(508,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:21:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(509,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:29:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(510,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:43:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(511,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:46:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(512,NULL,'CFG','SEGURIDAD',50,'2017-06-19 12:52:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(513,NULL,'CFG','SEGURIDAD',50,'2017-06-19 13:05:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(514,NULL,'CFG','SEGURIDAD',50,'2017-06-19 13:31:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(515,NULL,'CFG','SEGURIDAD',50,'2017-06-19 13:50:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(516,NULL,'CFG','SEGURIDAD',50,'2017-06-19 14:35:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(517,NULL,'CFG','SEGURIDAD',50,'2017-06-19 15:09:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(518,NULL,'CFG','SEGURIDAD',50,'2017-06-19 15:44:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(519,NULL,'CFG','CONF-R',108,'2017-06-19 15:44:18',NULL,'Baja de Pasarela asdasdad.','1'),(520,NULL,'CFG','SEGURIDAD',50,'2017-06-19 17:46:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(521,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:10:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(522,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:15:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(523,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:17:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(524,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:20:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(525,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:46:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(526,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:50:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(527,NULL,'CFG','CONF-R',108,'2017-06-20 09:52:19',NULL,'Baja de Pasarela PASARELA1.','1'),(528,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:53:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(529,NULL,'CFG','SEGURIDAD',50,'2017-06-20 09:59:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(530,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:30:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(531,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:30:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(532,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:31:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(533,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:33:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(534,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:34:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(535,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:35:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(536,NULL,'CFG','SEGURIDAD',50,'2017-06-20 10:35:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(537,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:07:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(538,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:09:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(539,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:11:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(540,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:12:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(541,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:19:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(542,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:49:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(543,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:50:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(544,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:51:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(545,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:53:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(546,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:55:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(547,NULL,'CFG','SEGURIDAD',50,'2017-06-20 12:58:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(548,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:01:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(549,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:07:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(550,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:09:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(551,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:10:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(552,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:11:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(553,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:16:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(554,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:19:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(555,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:20:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(556,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:23:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(557,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:34:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(558,NULL,'CFG','SEGURIDAD',50,'2017-06-20 13:36:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(559,NULL,'CFG','SEGURIDAD',50,'2017-06-20 14:44:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(560,NULL,'CFG','SEGURIDAD',50,'2017-06-20 14:45:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(561,NULL,'CFG','SEGURIDAD',50,'2017-06-20 14:47:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(562,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:39:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(563,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:42:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(564,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:45:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(565,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:50:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(566,NULL,'CFG','SEGURIDAD',51,'2017-06-20 15:52:49',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(567,NULL,'CFG','SEGURIDAD',51,'2017-06-20 15:53:05',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(568,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:54:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(569,NULL,'CFG','SEGURIDAD',50,'2017-06-20 15:59:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(570,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:03:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(571,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:06:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(572,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:09:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(573,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:11:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(574,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:14:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(575,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:22:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(576,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:24:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(577,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:24:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(578,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:25:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(579,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:27:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(580,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:44:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(581,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:44:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(582,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:45:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(583,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:47:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(584,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:48:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(585,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:50:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(586,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:51:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(587,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:53:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(588,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:55:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(589,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:56:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(590,NULL,'CFG','SEGURIDAD',50,'2017-06-20 16:59:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(591,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:00:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(592,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:02:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(593,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:02:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(594,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:02:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(595,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:04:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(596,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:06:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(597,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:06:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(598,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:11:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(599,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:12:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(600,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:20:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(601,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:21:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(602,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:24:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(603,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:33:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(604,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:36:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(605,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:39:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(606,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:40:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(607,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:42:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(608,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:43:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(609,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:45:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(610,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:47:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(611,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:48:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(612,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:51:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(613,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:53:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(614,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:56:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(615,NULL,'CFG','SEGURIDAD',50,'2017-06-20 17:57:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(616,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:02:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(617,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:05:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(618,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:06:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(619,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:14:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(620,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:16:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(621,NULL,'CFG','SEGURIDAD',50,'2017-06-20 18:19:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(622,NULL,'CFG','SEGURIDAD',50,'2017-06-21 08:43:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(623,NULL,'CFG','SEGURIDAD',50,'2017-06-21 08:45:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(624,NULL,'CFG','SEGURIDAD',50,'2017-06-21 08:48:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(625,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:21:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(626,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:24:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(627,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:25:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(628,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:27:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(629,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:28:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(630,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:31:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(631,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:35:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(632,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:43:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(633,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:44:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(634,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:49:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(635,NULL,'CFG','SEGURIDAD',50,'2017-06-21 09:50:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(636,NULL,'CFG','SEGURIDAD',50,'2017-06-21 12:01:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(637,NULL,'CFG','SEGURIDAD',50,'2017-06-21 12:01:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(638,NULL,'CFG','SEGURIDAD',50,'2017-06-21 12:16:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(639,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:20:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(640,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:22:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(641,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:25:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(642,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:26:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(643,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:28:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(644,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:34:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(645,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:36:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(646,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:38:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(647,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:43:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(648,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:49:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(649,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:54:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(650,NULL,'CFG','SEGURIDAD',50,'2017-06-21 14:58:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(651,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:01:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(652,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:02:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(653,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:03:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(654,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:07:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(655,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:10:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(656,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:11:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(657,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:41:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(658,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:47:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(659,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:49:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(660,NULL,'CFG','SEGURIDAD',50,'2017-06-21 15:51:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(661,NULL,'CFG','SEGURIDAD',50,'2017-06-22 08:58:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(662,NULL,'CFG','SEGURIDAD',50,'2017-06-22 10:36:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(663,NULL,'CFG','SEGURIDAD',50,'2017-06-22 10:38:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(664,NULL,'CFG','SEGURIDAD',50,'2017-06-22 10:57:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(665,NULL,'CFG','SEGURIDAD',50,'2017-06-22 10:58:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(666,NULL,'CFG','SEGURIDAD',51,'2017-06-22 10:59:26',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(667,NULL,'CFG','SEGURIDAD',51,'2017-06-22 10:59:40',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(668,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:00:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(669,NULL,'CFG','SEGURIDAD',51,'2017-06-22 11:06:36',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(670,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:08:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(671,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:13:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(672,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:14:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(673,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:17:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(674,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:20:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(675,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:23:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(676,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:25:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(677,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:26:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(678,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:27:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(679,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:32:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(680,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:39:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(681,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:42:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(682,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:49:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(683,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:54:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(684,NULL,'CFG','SEGURIDAD',50,'2017-06-22 11:59:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(685,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:05:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(686,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:18:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(687,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:21:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(688,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:23:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(689,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:24:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(690,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:26:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(691,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:31:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(692,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:37:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(693,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:38:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(694,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:40:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(695,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:48:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(696,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:49:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(697,NULL,'CFG','SEGURIDAD',50,'2017-06-22 12:55:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(698,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:25:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(699,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:33:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(700,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:36:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(701,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:44:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(702,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:46:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(703,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:48:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(704,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:50:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(705,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:52:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(706,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:53:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(707,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:57:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(708,NULL,'CFG','SEGURIDAD',50,'2017-06-22 15:58:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(709,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:04:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(710,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:05:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(711,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:07:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(712,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:09:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(713,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:12:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(714,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:14:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(715,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:19:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(716,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:20:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(717,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:21:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(718,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:22:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(719,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:26:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(720,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:28:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(721,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:30:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(722,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:31:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(723,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:33:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(724,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:34:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(725,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:46:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(726,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:51:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(727,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:55:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(728,NULL,'CFG','SEGURIDAD',50,'2017-06-22 16:57:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(729,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:04:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(730,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:09:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(731,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:12:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(732,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:15:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(733,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:16:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(734,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:39:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(735,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:40:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(736,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:40:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(737,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:43:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(738,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:50:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(739,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:56:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(740,NULL,'CFG','SEGURIDAD',50,'2017-06-22 17:58:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(741,NULL,'CFG','SEGURIDAD',50,'2017-06-22 18:03:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(742,NULL,'CFG','SEGURIDAD',50,'2017-06-22 18:04:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(743,NULL,'CFG','SEGURIDAD',50,'2017-06-22 18:06:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(744,NULL,'CFG','SEGURIDAD',50,'2017-06-22 18:09:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(745,NULL,'CFG','SEGURIDAD',50,'2017-06-23 09:03:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(746,NULL,'CFG','SEGURIDAD',50,'2017-06-23 09:18:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(747,NULL,'CFG','SEGURIDAD',50,'2017-06-23 09:32:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(748,NULL,'CFG','SEGURIDAD',50,'2017-06-23 10:36:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(749,NULL,'CFG','SEGURIDAD',50,'2017-06-23 12:21:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(750,NULL,'CFG','SEGURIDAD',50,'2017-06-23 12:22:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(751,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:03:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(752,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:13:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(753,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:18:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(754,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:22:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(755,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:23:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(756,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:27:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(757,NULL,'CFG','SEGURIDAD',50,'2017-06-23 13:29:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(758,NULL,'CFG','SEGURIDAD',50,'2017-06-26 09:17:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(759,NULL,'CFG','SEGURIDAD',50,'2017-06-26 11:06:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(760,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:04:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(761,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:57:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(762,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:58:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(763,NULL,'CFG','SEGURIDAD',50,'2017-06-26 13:02:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(764,NULL,'CFG','SEGURIDAD',50,'2017-06-26 15:52:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(765,NULL,'CFG','SEGURIDAD',50,'2017-06-26 15:59:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(766,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:03:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(767,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:05:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(768,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:06:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(769,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:07:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(770,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:08:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(771,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:13:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(772,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:15:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(773,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:55:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(774,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:06:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(775,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:08:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(776,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:10:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(777,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:11:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(778,NULL,'CFG','SEGURIDAD',50,'2017-06-27 09:27:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(779,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:39:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(780,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:42:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(781,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:49:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(782,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:54:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(783,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:11:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(784,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:16:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(785,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:20:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(786,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:24:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(787,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:25:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(788,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:27:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(789,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:29:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(790,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:34:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(791,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:36:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(792,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:39:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(793,NULL,'CFG','SEGURIDAD',50,'2017-06-27 12:25:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(794,NULL,'CFG','SEGURIDAD',50,'2017-06-27 12:30:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(795,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:24:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(796,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:27:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(797,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:31:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(798,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:33:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(799,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:37:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(800,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:38:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(801,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:41:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(802,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:43:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(803,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:45:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(804,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:49:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(805,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:51:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(806,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:54:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(807,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:56:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(808,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:01:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(809,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:03:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(810,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:10:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(811,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:11:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(812,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:12:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(813,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:14:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(814,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:20:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(815,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:22:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(816,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:23:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(817,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:25:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(818,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:28:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(819,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:29:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(820,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:33:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(821,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:36:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(822,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:39:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(823,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:50:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(824,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:52:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(825,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:53:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(826,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:55:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(827,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:03:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(828,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:04:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(829,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:05:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(830,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:06:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(831,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:07:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(832,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:08:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(833,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:09:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(834,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:11:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(835,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:17:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(836,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:33:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(837,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:57:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(838,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:59:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(839,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:08:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(840,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:11:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(841,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:14:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(842,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:15:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(843,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:17:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(844,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:19:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(845,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:23:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(846,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:25:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(847,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:25:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(848,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:27:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(849,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:28:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(850,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:31:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(851,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:36:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(852,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:39:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(853,NULL,'CFG','SEGURIDAD',50,'2017-06-28 13:44:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(854,NULL,'CFG','SEGURIDAD',50,'2017-06-28 14:58:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(855,NULL,'CFG','SEGURIDAD',50,'2017-06-28 14:59:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(856,NULL,'CFG','SEGURIDAD',50,'2017-06-28 15:05:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(857,NULL,'CFG','SEGURIDAD',51,'2017-06-28 16:25:18',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(858,NULL,'CFG','SEGURIDAD',50,'2017-06-28 16:37:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(859,NULL,'CFG','SEGURIDAD',50,'2017-06-28 16:51:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(860,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:02:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(861,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:07:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(862,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:10:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(863,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:17:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(864,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:21:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(865,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:25:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(866,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:31:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(867,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:38:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(868,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:53:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(869,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:56:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(870,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:58:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(871,NULL,'CFG','SEGURIDAD',50,'2017-06-28 18:00:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(872,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:03:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(873,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:06:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(874,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:12:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(875,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:13:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(876,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:47:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(877,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:53:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(878,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:56:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(879,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:58:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(880,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:10:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(881,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:13:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(882,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:16:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(883,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:19:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(884,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:20:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(885,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:26:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(886,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:28:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(887,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:30:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(888,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:33:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(889,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:38:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(890,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:39:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(891,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:42:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(892,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:43:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(893,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:47:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(894,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:49:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(895,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:52:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(896,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:56:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(897,NULL,'CFG','SEGURIDAD',50,'2017-06-29 12:00:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(898,NULL,'CFG','SEGURIDAD',50,'2017-06-29 12:04:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(899,NULL,'CFG','SEGURIDAD',50,'2017-06-29 15:36:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(900,NULL,'CFG','SEGURIDAD',50,'2017-06-29 15:39:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1');
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
INSERT INTO `incidencias` VALUES (47,'Inicio sesión RCS2010 UG5KR','Inicio sesión RCS2010 UG5KR  del usuario {0}',0,'SEGURIDAD',0,0),(48,'Recahazada sesión RCS2010 UG5KR','Rechazada sesión RCS2010 UG5KR  al usuario {0}',0,'SEGURIDAD',0,0),(49,'Fin sesion RCS2010 UG5KR','Fin sesion RCS2010 UG5KR  del usuario {0}',0,'SEGURIDAD',0,0),(50,'Inicio sesión Configuración Centralizada','Inicio sesión Configuración Centralizada  del usuario',0,'SEGURIDAD',0,0),(51,'Rechazado  sesión Configuración Centralizada','Rechazada sesión Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(52,'Alta Usuario','Alta Usuario',0,'SEGURIDAD',0,0),(53,'Borrado Usuario','Borrado Usuario ',0,'SEGURIDAD',0,0),(54,'Modificado Usuario','Modificado Usuario',0,'SEGURIDAD',0,0),(55,'Fin sesion  Configuración Centralizada ','Fin sesion  Configuración Centralizada  del usuario ',0,'SEGURIDAD',0,0),(105,'Carga de Configuración Remota','Carga de Configuración Remota',0,'CONF-R',0,0),(106,'Error Carga Configuración Remota','Error Carga Configuración Remota',0,'CONF-R',0,0),(107,'Alta de Pasarela','Alta de Pasarela',0,'CONF-R',0,0),(108,'Baja de Pasarela','Baja de Pasarela',0,'CONF-R',0,0),(109,'Modificación de Parámetros Generales de Pasarela','Modificación de Parámetros Generales de Pasarela',0,'CONF-R',0,0),(110,'Modificación Rutas ATS','Modificación Rutas ATS',0,'CONF-R',0,0),(113,'Alta de Recurso','Alta de Recurso',0,'CONF-R',0,0),(114,'Baja de Recurso','Baja de Recurso',0,'CONF-R',0,0),(115,'Modificación de Parámetros de Recurso','Modificación de Parámetros de Recurso',0,'CONF-R',0,0),(116,'Modificación de Parámetros Lógicos de  Recurso','Modificación de Parámetros Lógicos de  Recurso',0,'CONF-R',0,0),(150,'Modificación de Parámetros Generales de Pasarela.','Modificación Parámetro en {0}. {1}',0,'CONF-L',0,0),(153,'Modificación de Parámetros Lógico de Recurso','Modificación SW en Recurso {0} . {1} . {2}',0,'CONF-L',0,0),(154,'Generación de Configuración por Defecto.','Generación de Configuración por Defecto {0} . {1}',0,'CONF-L',0,0),(155,'Activación de Configuración por Defecto.','Activación de Configuración por Defecto {0}  . {1}',0,'CONF-L',0,0),(156,'Borrado de Configuración por Defecto','Borrado de Configuración por Defecto {0}  . {1}',0,'CONF-L',0,0),(157,'Alta Recurso Radio','Recurso Radio  Añadido {0} . {1} . {2}',0,'CONF-L',0,0),(158,'Baja Recurso Radio','Recurso Radio Eliminado {0} . {1} . {2}',0,'CONF-L',0,0),(159,'Alta Recurso Telefonía','Recurso Telefónico Añadido {0} . {1} . {2}',0,'CONF-L',0,0),(160,'Baja Recurso Telefonía','Recurso Telefónico  Eliminado {0} . {1} . {2}',0,'CONF-L',0,0),(161,'Conflicto de configuraciones','Conflicto de Configuración en GW {0} . {1} . {2}',0,'CONF-L',0,0),(182,'Reset Remoto','Reset Remoto {0}',0,'MAN-L',0,0),(183,'Selección Bucle Prueba','Selección Bucle {0}  {1}  en {2}.',0,'MAN-L',0,0),(184,'Comando Bite','Selección  BITE {0}',0,'MAN-L',0,0),(185,'Conmutacion P/R','Selección Conmutación P/R {0}',0,'MAN-L',0,0),(186,'Selección Modo','Selección Modo :{0}',0,'MAN-L',0,0),(187,'Resultado Comando Bite','Resultado  BITE {0} {1}',0,'MAN-L',0,0),(193,'Resultado  bucle prueba','Resultado Bucle {0} en {1} : {2}',0,'MAN-L',0,0),(195,'Resultado Conmutacion P/R','Resultado  Conmutación P/R {0}, {1}',0,'MAN-L',0,0),(196,'Resultado  Modo','Resultado  Modo :{0}',0,'MAN-L',0,0),(201,'Arranque APP RCS2010','Arranque APP RCS2010 UG5KR en puesto {0}',0,'SP-GEN',0,0),(202,'Cierre Aplicacion APP RCS2010','Cierre Aplicacion APP RCS2010 UG5KR  en puesto {0}',0,'SP-GEN',1,0),(2000,'Cambio estado Pasarela','Cambio estado pasarela: {0}',1,'SP-PASARELA',0,2),(2003,'Cambio Estado LAN','Cambio Estado LANs. CGW {0}, LAN1 {1}, LAN2 {2}',1,'SP-PASARELA',0,2),(2005,'Cambio Estado CPU','Cambio Estado CPUs. CGW {0}, CPU Local {1}, CPU Dual {2}',1,'SP-PASARELA',0,2),(2007,'Conexión Recurso Radio','Conexión Recurso Radio {0}',1,'SP-PASARELA',0,0),(2008,'Desconexión Recurso Radio','Desconexión Recurso Radio {0}',1,'SP-PASARELA',1,0),(2009,'Conexión Recurso Telefonía','Conexión Recurso Telefonía  {0}',1,'SP-PASARELA',0,0),(2010,'Desconexión Recurso Telefonía','Desconexión Recurso Telefonía {0}',1,'SP-PASARELA',1,0),(2011,'Conexión Tarjeta Interfaz (esclava-tipo)','Conexión Tarjeta Interfaz. Número {0}; Tipo: {1}',1,'SP-PASARELA',0,0),(2012,'Desconexión Tarjeta Interfaz (esclava-tipo)','Desconexión Tarjeta Interfaz. Número {0}; Tipo: {1}',1,'SP-PASARELA',1,0),(2013,'Conexión Recurso R2','Conexión Recurso R2 {0}',1,'SP-PASARELA',0,0),(2014,'Desconexión Recurso R2.','Desconexión Recurso R2 {0}',1,'SP-PASARELA',1,0),(2015,'Conexión Recurso N5','Conexión Recurso N5 {0}',1,'SP-PASARELA',0,0),(2016,'Desconexión Recurso N5','Desconexión Recurso N5 {0}',1,'SP-PASARELA',1,0),(2017,'Conexión Recurso QSIG','Conexión Recurso QSIG {0}',1,'SP-PASARELA',0,0),(2018,'Desconexión Recurso  QSIG','Desconexión Recurso  QSIG {0}',1,'SP-PASARELA',1,0),(2019,'Conexión Recurso LCEN','Conexión Recurso LCEN {0}',1,'SP-PASARELA',0,0),(2020,'Desconexión Recurso  LCEN','Desconexión Recurso  LCEN {0}',1,'SP-PASARELA',1,0),(2021,'Servicio NTP Conectado','Servicio NTP Conectado',1,'SP-PASARELA',0,0),(2022,'Servicio NTP Desconectado','Servicio NTP Desconectado',1,'SP-PASARELA',1,0),(2027,'Cambio estado Sincro BD.','Cambio estado Sincro BD {0}',1,'SP-PASARELA',0,0),(2101,'Caída/establecimiento sesión SIP','Cambio estado sesión SIP. Recurso: {0}; Estado:  {1} , {2}, {3}',1,'SP-RADIO',0,0),(2102,'Cambio PTT','Cambio estado PTT. Recurso: {0}; Estado: {1}',0,'SP-RADIO',0,0),(2103,'Cambio SQU','Cambio estado SQU. Recurso: {0}; Estado: {1}',0,'SP-RADIO',0,0),(2200,'Error Protocolo LCEN','Error Protocolo LCEN. Recurso  {0}, Error.',1,'SP-TELEFONIA',1,0),(2202,'Fallo test LCEN VoIP (mensaje Options)','Fallo test LCEN VoIP. Recurso {0}',1,'SP-TELEFONIA',1,0),(2203,'Error Protocolo R2','Error Protocolo R2. Recurso:  {0}.',1,'SP-TELEFONIA',1,0),(2204,'Fallo llamada de test R2 SCV','Fallo llamada de test R2 SCV. Recurso {0}',1,'SP-TELEFONIA',1,0),(2205,'Fallo llamada de test R2 VoIP (mensaje Options)','Fallo llamada de test R2 VoIP. Recurso  {0}',1,'SP-TELEFONIA',1,0),(2206,'Error Protocolo N5','Error Protocolo N5. Recurso:  {0}.',1,'SP-TELEFONIA',1,0),(2207,'Fallo llamada de test N5 SCV','Fallo llamada de test N5 SCV. Recurso {0}',1,'SP-TELEFONIA',1,0),(2208,'Fallo llamada de test N5 VoIP (mensaje Options)','Fallo llamada de test N5 VoIP. Recurso {0}',1,'SP-TELEFONIA',1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
INSERT INTO `lista_ips` VALUES (109,11,'2.2.2.4','PRX',0),(110,11,'2.2.2.41','PRX',0),(111,11,'2.2.2.43','REG',0),(112,11,'2.2.2.44','REG',0),(113,11,'2.2.2.46','NTP',0),(114,11,'2,2.2.2.46/162','TRPV2',0),(115,11,'2,2.2.2.47/162','TRPV2',0),(116,12,'3.3.3.2','PRX',0),(117,12,'3.3.3.21','PRX',0),(118,12,'3.3.3.23','REG',0),(119,12,'3.3.3.24','NTP',0),(120,12,'2,3.3.3.25/162','TRPV2',0),(121,12,'1,3.3.3.26/1','TRPV1',0),(122,13,'4.4.4.2','PRX',0),(123,13,'4.4.4.2','REG',0),(124,13,'4.4.4.2','NTP',0),(125,13,'2,4.4.4.2/162','TRPV2',0),(147,10,'1.1.1.31','PRX',0),(148,10,'1.1.1.33','REG',0),(149,10,'1.1.1.34','REG',0),(150,10,'1.1.1.35','NTP',0),(151,10,'1,1.1.1.36/161','TRPV1',0),(152,10,'2,1.1.1.37/162','TRPV2',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_uris`
--

LOCK TABLES `lista_uris` WRITE;
/*!40000 ALTER TABLE `lista_uris` DISABLE KEYS */;
INSERT INTO `lista_uris` VALUES (1,6,'sip1@1.2.3.4:80','TXA',1),(2,6,'sip2@5.6.7.8:81','RXA',1),(3,7,'sip@127.0.0.1','TXA',1),(4,6,'sip1@1.2.3.4:802','TXA',2),(5,6,'ip1@1.2.3.4:803','RXA',2),(72,39,'v@1.1.1.11','LSN',0),(73,39,'vv@2.2.2.2','LSN',0),(74,39,'vvv@3.3.3.3','LSN',0),(78,40,'vvvv@1.1.1.1','LSN',0),(79,40,'mmm@2.2.2.22','LSB',0);
/*!40000 ALTER TABLE `lista_uris` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operadores`
--

LOCK TABLES `operadores` WRITE;
/*!40000 ALTER TABLE `operadores` DISABLE KEYS */;
INSERT INTO `operadores` VALUES (1,'root','MQ==',64),(2,'1','MQ==',64);
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
  `periodo_supervision` int(6) DEFAULT '0' COMMENT 'Tiempo en segundos para el valor supervisión.',
  `puerto_servicio_snmp` int(5) DEFAULT '65000' COMMENT 'Valor del puerto para el servicio snmp.',
  `puerto_snmp` int(5) DEFAULT '161' COMMENT 'Valor del puerto para el snmp.',
  `snmpv2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indica si usa snmp versión 2. (1) Verdadero, (0) Falso.',
  `comunidad_snmp` varchar(45) COLLATE latin1_spanish_ci DEFAULT 'public' COMMENT 'Comunidad SNMP V2. Por defecto public',
  `nombre_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'ULISESG5000i' COMMENT 'Nombre del servicio snmp.',
  `localizacion_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF LABS' COMMENT 'Localización del servicio snmp.',
  `contacto_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF DT. MADRID. SPAIN' COMMENT 'Dirección de contacto del servicio snmp.',
  `puerto_servicio_web` int(5) DEFAULT NULL COMMENT 'Valor del puerto para el servicio web.',
  `tiempo_sesion` int(6) NOT NULL DEFAULT '0' COMMENT 'Tiempo en segundos de la sesión.',
  `puerto_rtsp` int(5) DEFAULT NULL COMMENT 'Valor para el puerto rtsp.',
  `servidor_rtsp` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección del servidor rtsp.',
  `servidor_rtspb` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección del servidor rtsp 2 o B',
  PRIMARY KEY (`idpasarela`),
  KEY `fk_emp_pasarela_idx` (`emplazamiento_id`),
  CONSTRAINT `fk_emp_pasarela` FOREIGN KEY (`emplazamiento_id`) REFERENCES `emplazamientos` (`idemplazamiento`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasarelas`
--

LOCK TABLES `pasarelas` WRITE;
/*!40000 ALTER TABLE `pasarelas` DISABLE KEYS */;
INSERT INTO `pasarelas` VALUES (10,13,'PASARELA1','1.1.1.1',NULL,'1.1.1.2','1.1.1.2','1.1.1.2','1.1.1.3','1.1.1.3','1.1.1.3',5060,NULL,65000,161,0,NULL,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'',''),(11,13,'PASARELA2','2.2.2.2',NULL,'2.2.2.3','2.2.2.3','2.2.2.3','2.2.2.4','2.2.2.4','2.2.2.4',5060,NULL,65000,161,0,NULL,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'2.2.2.48','2.2.2.49'),(12,14,'PASARELA3','3.3.3.3',NULL,'3.3.3.1','3.3.3.1','3.3.3.1','3.3.3.2','3.3.3.2','3.3.3.2',5060,NULL,65000,161,0,NULL,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'3.3.3.27',''),(13,15,'PASARELA4','4.4.4.4',NULL,'4.4.4.1','4.4.4.1','4.4.4.1','4.4.4.2','4.4.4.2','4.4.4.2',5060,NULL,65000,161,0,NULL,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,555,'4.4.4.21','4.4.4.22'),(14,17,'PASARELA5','5.5.5.5',NULL,'5.5.5.1','5.5.5.1','5.5.5.1','5.5.5.2','5.5.5.2','5.5.5.2',5060,NULL,65000,161,0,NULL,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'','5.5.5.2');
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rangos_ats`
--

LOCK TABLES `rangos_ats` WRITE;
/*!40000 ALTER TABLE `rangos_ats` DISABLE KEYS */;
INSERT INTO `rangos_ats` VALUES (53,11,'222222','222222',0),(54,11,'333331','333332',0),(55,11,'232326','232325',0),(56,11,'333333','333333',1);
/*!40000 ALTER TABLE `rangos_ats` ENABLE KEYS */;
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
  `frecuencia` float(7,3) NOT NULL COMMENT 'Frecuencia en Mhz (UHF/VHF). desde 30.000 a 3000.000',
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
  `habilita_grabacion` tinyint(1) DEFAULT '1' COMMENT 'Habilita grabación. (1) Si habilita, (0) No Habilita.',
  `tabla_bss_id` int(11) DEFAULT NULL COMMENT 'Clave ajena a la tabla bss de calificación de audio.',
  `max_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `min_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `umbral_vad` float(3,1) DEFAULT NULL COMMENT 'Umbral Vad. Rango min: -35.0, max: -15.0.',
  `tiempo_max_ptt` int(4) DEFAULT NULL COMMENT 'Tiempo máximo PTT. Rango de min: 0, max: 1000',
  `ventana_bss` int(4) DEFAULT NULL COMMENT 'Ventana BSS. Rango min: 10, max: 5000.',
  `tipo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Tipo de climax. 0 (No), 1(ASAP), 2(TIEMPO FIJO).',
  `retardo_fijo_climax` int(3) DEFAULT NULL COMMENT 'Retardo fijo climax. Rango min: 0, max: 250',
  `cola_bss_sqh` int(4) DEFAULT NULL COMMENT 'Cola BSS SQH. Rango min: 10, max: 5000.',
  `retardo_jitter` int(3) DEFAULT NULL COMMENT 'Retardo jitter. Rango min: 0, max: 100.',
  `metodo_climax` int(1) NOT NULL DEFAULT '0' COMMENT 'Método climax. Valores 0 (Relativo), 1 (Absoluto).',
  `restriccion_entrantes` int(1) DEFAULT '0' COMMENT 'Restricción entrantes. Valores: 0 (Ninguna), 1 (Lista Negra), 2 (Lista Blanca)',
  PRIMARY KEY (`idrecurso_radio`),
  KEY `fk_pasarela_radio_idx` (`pasarela_id`),
  KEY `fk_radio_tabla_bss_idx` (`tabla_bss_id`),
  CONSTRAINT `fk_pasarela_radio` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_radio`
--

LOCK TABLES `recursos_radio` WRITE;
/*!40000 ALTER TABLE `recursos_radio` DISABLE KEYS */;
INSERT INTO `recursos_radio` VALUES (6,10,0,0,'Radio80',0,'1233',135.025,NULL,0.00,0,6,1,0,0,1,0,1,0,0,0,1,0,0,NULL,NULL,NULL,1,NULL,NULL,NULL,1,0),(7,10,1,0,'Radio2',0,NULL,136.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,0.0,NULL,NULL,0,NULL,NULL,NULL,0,0),(8,14,0,0,'Radio_Test',0,NULL,135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,0.0,NULL,NULL,0,NULL,NULL,NULL,0,0),(39,10,2,1,'asdasd',0,NULL,0.000,0.00,0.00,0,4,0,0,0,0,0,0,0,0,0,NULL,0,0,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1),(40,10,1,1,'asdada',0,NULL,0.000,0.00,0.00,0,5,0,0,0,0,0,0,0,0,0,NULL,0,0,NULL,NULL,NULL,0,NULL,NULL,NULL,0,2);
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
  `umbral_vox` int(10) DEFAULT NULL COMMENT 'Valor del umbral Vox en dB.',
  `cola_vox` int(10) DEFAULT NULL COMMENT 'Valor para la cola Vox en segundos.',
  `respuesta_automatica` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Respuesta automática. (1) Si, (0) No.',
  `periodo_tonos` int(2) DEFAULT NULL COMMENT 'Periodo tonos respuesta estado en segundos. Rango min: 1, max: 10',
  `lado` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Lado A (0) o lado B (1)',
  `origen_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Origen llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `destino_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Destino llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `supervisa_colateral` tinyint(1) DEFAULT NULL COMMENT 'Indica si supervisa colateral. (1) Supervisa, (0) No Supervisa.',
  `tiempo_supervision` int(2) DEFAULT NULL COMMENT 'Tiempo de supervisión en segundos. Rango min: 1, max: 10',
  `duracion_tono_interrup` int(2) NOT NULL DEFAULT '0' COMMENT 'Duración en segundos del tono de interrupción. Rango min: 5, max: 15.',
  `uri_telefonica` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Uri para el recurso telefónico.',
  PRIMARY KEY (`idrecurso_telefono`),
  KEY `fk_pasarela_tfno_idx` (`pasarela_id`),
  CONSTRAINT `fk_pasarela_tfno` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_telefono`
--

LOCK TABLES `recursos_telefono` WRITE;
/*!40000 ALTER TABLE `recursos_telefono` DISABLE KEYS */;
INSERT INTO `recursos_telefono` VALUES (11,10,2,0,'Telefono12',0,'1234',0,0,1,3,0,-16,4,0,10,0,'200000','200001',0,NULL,10,'res@1.2.3.4'),(12,14,1,0,'Telefonico_Test',0,NULL,0,0,1,0,1,-15,0,0,0,0,'','',0,NULL,5,'sip:');
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
	IF(NEW.uri_telefonica NOT LIKE '%sip%') THEN
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablas_bss`
--

LOCK TABLES `tablas_bss` WRITE;
/*!40000 ALTER TABLE `tablas_bss` DISABLE KEYS */;
INSERT INTO `tablas_bss` VALUES (1,'Tabla1','Desc tabla 1','2017-06-16 12:00:18',3,2,7,2,2,15),(2,'Tabla2','Desc de la tabla2','2017-06-16 12:01:02',2,6,10,7,13,14);
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
/*!50001 VIEW `spvs_cgw` AS select `p`.`nombre` AS `name`,`rr`.`nombre` AS `resource`,`rr`.`columna` AS `slave_rank`,0 AS `slave_type`,1 AS `resource_type`,`rr`.`fila` AS `resource_rank`,`rr`.`frecuencia` AS `frecuencia`,`rr`.`tipo_agente` AS `resource_subtype`,(case when (`rr`.`tipo_agente` > 3) then 'True' else 'False' end) AS `remoto` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_radio` `rr` on((`p`.`idpasarela` = `rr`.`pasarela_id`))) where (`c`.`activa` = 1) union select `p`.`nombre` AS `name`,`rt`.`nombre` AS `resource`,`rt`.`columna` AS `slave_rank`,0 AS `slave_type`,2 AS `resource_type`,`rt`.`fila` AS `resource_rank`,NULL AS `frecuencia`,`rt`.`tipo_interfaz_tel` AS `resource_subtype`,'False' AS `remoto` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_telefono` `rt` on((`p`.`idpasarela` = `rt`.`pasarela_id`))) where (`c`.`activa` = 1) */;
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

-- Dump completed on 2017-06-29 17:43:02
