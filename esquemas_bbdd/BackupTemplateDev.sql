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
) ENGINE=InnoDB AUTO_INCREMENT=970 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
INSERT INTO `historicoincidencias` VALUES (758,NULL,'CFG','SEGURIDAD',50,'2017-06-26 09:17:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(759,NULL,'CFG','SEGURIDAD',50,'2017-06-26 11:06:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(760,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:04:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(761,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:57:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(762,NULL,'CFG','SEGURIDAD',50,'2017-06-26 12:58:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(763,NULL,'CFG','SEGURIDAD',50,'2017-06-26 13:02:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(764,NULL,'CFG','SEGURIDAD',50,'2017-06-26 15:52:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(765,NULL,'CFG','SEGURIDAD',50,'2017-06-26 15:59:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(766,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:03:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(767,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:05:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(768,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:06:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(769,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:07:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(770,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:08:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(771,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:13:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(772,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:15:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(773,NULL,'CFG','SEGURIDAD',50,'2017-06-26 16:55:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(774,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:06:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(775,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:08:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(776,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:10:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(777,NULL,'CFG','SEGURIDAD',50,'2017-06-26 17:11:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(778,NULL,'CFG','SEGURIDAD',50,'2017-06-27 09:27:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(779,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:39:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(780,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:42:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(781,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:49:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(782,NULL,'CFG','SEGURIDAD',50,'2017-06-27 10:54:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(783,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:11:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(784,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:16:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(785,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:20:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(786,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:24:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(787,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:25:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(788,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:27:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(789,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:29:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(790,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:34:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(791,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:36:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(792,NULL,'CFG','SEGURIDAD',50,'2017-06-27 11:39:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(793,NULL,'CFG','SEGURIDAD',50,'2017-06-27 12:25:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(794,NULL,'CFG','SEGURIDAD',50,'2017-06-27 12:30:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(795,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:24:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(796,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:27:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(797,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:31:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(798,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:33:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(799,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:37:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(800,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:38:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(801,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:41:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(802,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:43:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(803,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:45:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(804,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:49:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(805,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:51:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(806,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:54:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(807,NULL,'CFG','SEGURIDAD',50,'2017-06-27 13:56:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(808,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:01:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(809,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:03:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(810,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:10:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(811,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:11:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(812,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:12:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(813,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:14:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(814,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:20:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(815,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:22:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(816,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:23:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(817,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:25:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(818,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:28:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(819,NULL,'CFG','SEGURIDAD',50,'2017-06-27 14:29:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(820,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:33:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(821,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:36:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(822,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:39:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(823,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:50:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(824,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:52:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(825,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:53:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(826,NULL,'CFG','SEGURIDAD',50,'2017-06-27 16:55:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(827,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:03:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(828,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:04:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(829,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:05:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(830,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:06:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(831,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:07:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(832,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:08:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(833,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:09:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(834,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:11:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(835,NULL,'CFG','SEGURIDAD',50,'2017-06-27 17:17:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(836,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:33:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(837,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:57:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(838,NULL,'CFG','SEGURIDAD',50,'2017-06-28 10:59:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(839,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:08:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(840,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:11:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(841,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:14:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(842,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:15:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(843,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:17:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(844,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:19:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(845,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:23:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(846,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:25:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(847,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:25:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(848,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:27:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(849,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:28:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(850,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:31:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(851,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:36:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(852,NULL,'CFG','SEGURIDAD',50,'2017-06-28 11:39:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(853,NULL,'CFG','SEGURIDAD',50,'2017-06-28 13:44:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(854,NULL,'CFG','SEGURIDAD',50,'2017-06-28 14:58:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(855,NULL,'CFG','SEGURIDAD',50,'2017-06-28 14:59:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(856,NULL,'CFG','SEGURIDAD',50,'2017-06-28 15:05:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(857,NULL,'CFG','SEGURIDAD',51,'2017-06-28 16:25:18',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(858,NULL,'CFG','SEGURIDAD',50,'2017-06-28 16:37:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(859,NULL,'CFG','SEGURIDAD',50,'2017-06-28 16:51:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(860,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:02:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(861,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:07:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(862,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:10:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(863,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:17:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(864,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:21:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(865,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:25:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(866,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:31:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(867,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:38:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(868,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:53:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(869,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:56:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(870,NULL,'CFG','SEGURIDAD',50,'2017-06-28 17:58:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(871,NULL,'CFG','SEGURIDAD',50,'2017-06-28 18:00:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(872,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:03:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(873,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:06:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(874,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:12:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(875,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:13:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(876,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:47:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(877,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:53:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(878,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:56:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(879,NULL,'CFG','SEGURIDAD',50,'2017-06-29 10:58:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(880,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:10:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(881,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:13:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(882,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:16:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(883,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:19:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(884,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:20:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(885,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:26:43',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(886,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:28:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(887,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:30:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(888,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:33:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(889,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:38:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(890,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:39:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(891,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:42:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(892,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:43:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(893,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:47:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(894,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:49:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(895,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:52:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(896,NULL,'CFG','SEGURIDAD',50,'2017-06-29 11:56:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(897,NULL,'CFG','SEGURIDAD',50,'2017-06-29 12:00:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(898,NULL,'CFG','SEGURIDAD',50,'2017-06-29 12:04:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(899,NULL,'CFG','SEGURIDAD',50,'2017-06-29 15:36:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(900,NULL,'CFG','SEGURIDAD',50,'2017-06-29 15:39:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(901,NULL,'CFG','SEGURIDAD',50,'2017-06-30 10:57:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(902,NULL,'CFG','SEGURIDAD',50,'2017-06-30 10:59:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(903,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:00:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(904,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:03:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(905,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:05:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(906,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:05:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(907,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:07:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(908,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:09:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(909,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:43:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(910,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:44:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(911,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:45:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(912,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:47:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(913,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:57:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(914,NULL,'CFG','SEGURIDAD',50,'2017-06-30 11:59:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(915,NULL,'CFG','SEGURIDAD',50,'2017-06-30 12:00:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(916,NULL,'CFG','SEGURIDAD',50,'2017-06-30 12:05:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(917,NULL,'CFG','SEGURIDAD',50,'2017-06-30 12:50:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(918,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:38:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(919,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:40:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(920,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:43:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(921,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:50:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(922,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:52:24',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(923,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:53:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(924,NULL,'CFG','SEGURIDAD',50,'2017-06-30 13:58:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(925,NULL,'CFG','SEGURIDAD',50,'2017-06-30 14:00:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(926,NULL,'CFG','SEGURIDAD',50,'2017-06-30 14:02:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(927,NULL,'CFG','SEGURIDAD',50,'2017-06-30 14:05:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(928,NULL,'CFG','SEGURIDAD',50,'2017-07-03 19:23:32',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(929,NULL,'CFG','SEGURIDAD',50,'2017-07-04 07:50:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(930,NULL,'CFG','SEGURIDAD',50,'2017-07-04 08:16:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(931,NULL,'CFG','SEGURIDAD',50,'2017-07-04 08:18:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(932,NULL,'CFG','SEGURIDAD',50,'2017-07-04 08:23:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(933,NULL,'CFG','SEGURIDAD',50,'2017-07-04 08:24:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(934,NULL,'CFG','SEGURIDAD',50,'2017-07-04 09:19:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(935,NULL,'CFG','SEGURIDAD',50,'2017-07-04 09:20:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(936,NULL,'CFG','SEGURIDAD',50,'2017-07-04 15:46:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(937,NULL,'CFG','SEGURIDAD',50,'2017-07-04 16:15:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(938,NULL,'CFG','SEGURIDAD',50,'2017-07-09 19:01:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(939,NULL,'CFG','SEGURIDAD',50,'2017-07-10 20:55:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(940,NULL,'CFG','SEGURIDAD',50,'2017-07-10 20:58:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(941,NULL,'CFG','SEGURIDAD',50,'2017-07-10 21:04:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(942,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:35:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(943,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:38:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(944,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:39:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(945,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:41:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(946,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:43:25',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(947,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:44:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(948,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:45:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(949,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:48:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(950,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:50:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(951,NULL,'CFG','SEGURIDAD',50,'2017-07-24 09:53:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(952,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:06:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(953,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:06:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(954,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:08:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(955,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:10:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(956,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:12:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(957,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:13:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(958,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:47:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(959,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:48:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(960,NULL,'CFG','SEGURIDAD',50,'2017-07-24 10:55:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(961,NULL,'CFG','SEGURIDAD',50,'2017-07-24 12:12:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(962,NULL,'CFG','SEGURIDAD',50,'2017-07-24 14:52:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(963,NULL,'CFG','SEGURIDAD',50,'2017-07-24 17:23:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(964,NULL,'CFG','SEGURIDAD',50,'2017-07-25 08:42:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(965,NULL,'CFG','SEGURIDAD',50,'2017-07-25 09:46:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(966,NULL,'CFG','SEGURIDAD',50,'2017-07-25 09:50:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(967,NULL,'CFG','SEGURIDAD',50,'2017-07-25 09:53:27',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(968,NULL,'CFG','SEGURIDAD',50,'2017-07-25 09:55:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(969,NULL,'CFG','SEGURIDAD',50,'2017-07-25 09:58:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1');
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
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
INSERT INTO `lista_ips` VALUES (109,11,'2.2.2.4','PRX',0),(110,11,'2.2.2.41','PRX',0),(111,11,'2.2.2.43','REG',0),(112,11,'2.2.2.44','REG',0),(113,11,'2.2.2.46','NTP',0),(114,11,'2,2.2.2.46/162','TRPV2',0),(115,11,'2,2.2.2.47/162','TRPV2',0),(116,12,'3.3.3.2','PRX',0),(117,12,'3.3.3.21','PRX',0),(118,12,'3.3.3.23','REG',0),(119,12,'3.3.3.24','NTP',0),(120,12,'2,3.3.3.25/162','TRPV2',0),(121,12,'1,3.3.3.26/1','TRPV1',0),(122,13,'4.4.4.2','PRX',0),(123,13,'4.4.4.2','REG',0),(124,13,'4.4.4.2','NTP',0),(125,13,'2,4.4.4.2/162','TRPV2',0),(171,10,'1.1.1.31','PRX',0),(172,10,'1.1.1.33','REG',0),(173,10,'1.1.1.34','REG',0),(174,10,'1.1.1.35','NTP',0),(175,10,'1,1.1.1.36/161','TRPV1',0),(176,10,'2,1.1.1.37/162','TRPV2',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_uris`
--

LOCK TABLES `lista_uris` WRITE;
/*!40000 ALTER TABLE `lista_uris` DISABLE KEYS */;
INSERT INTO `lista_uris` VALUES (1,8,'sip1@1.2.3.4:80','TXA',1),(2,8,'sip2@5.6.7.8:81','RXA',1),(3,7,'sip@127.0.0.1','TXA',1),(4,6,'sip1@1.2.3.4:802','TXA',2),(5,6,'ip1@1.2.3.4:803','RXA',2),(81,6,'vv@1.2.3.4','LSN',0),(82,6,'mm@12.12.12.12','LSB',0);
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
INSERT INTO `pasarelas` VALUES (10,13,'PASARELA1','1.1.1.1','2017-06-20 09:22:46','1.1.1.2','1.1.1.2','1.1.1.2','1.1.1.3','1.1.1.3','1.1.1.3',5060,90,65000,161,0,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'',''),(11,13,'PASARELA2','2.2.2.2','2017-06-20 09:22:46','2.2.2.3','2.2.2.3','2.2.2.3','2.2.2.4','2.2.2.4','2.2.2.4',5060,90,65000,161,0,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'2.2.2.48','2.2.2.49'),(12,14,'PASARELA3','3.3.3.3','2017-06-20 09:22:46','3.3.3.1','3.3.3.1','3.3.3.1','3.3.3.2','3.3.3.2','3.3.3.2',5060,90,65000,161,0,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'3.3.3.27',''),(13,15,'PASARELA4','4.4.4.4','2017-06-20 09:22:46','4.4.4.1','4.4.4.1','4.4.4.1','4.4.4.2','4.4.4.2','4.4.4.2',5060,90,65000,161,0,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,555,'4.4.4.21','4.4.4.22'),(14,17,'PASARELA5','5.5.5.5','2017-06-20 09:22:46','5.5.5.1','5.5.5.1','5.5.5.1','5.5.5.2','5.5.5.2','5.5.5.2',5060,90,65000,161,0,'public','ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',8080,0,554,'','5.5.5.2');
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_radio`
--

LOCK TABLES `recursos_radio` WRITE;
/*!40000 ALTER TABLE `recursos_radio` DISABLE KEYS */;
INSERT INTO `recursos_radio` VALUES (6,10,0,0,'Radio80',0,'1233',30.025,NULL,0.00,0,5,1,0,0,1,0,1,0,0,0,NULL,0,0,-20.0,0,500,1,100,500,30,1,2),(7,10,1,0,'Radio2',0,NULL,136.000,0.00,0.00,0,3,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(8,14,0,0,'Radio_Test',0,NULL,135.000,0.00,0.00,0,0,0,0,0,0,0,0,0,0,0,NULL,0,0,-20.0,0,500,0,100,500,30,0,0),(41,11,0,0,'123',0,NULL,0.000,NULL,0.00,0,0,1,0,0,1,0,1,0,0,0,1,0,0,-20.0,0,500,0,100,500,30,0,0);
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
  `tiempo_supervision` int(2) NOT NULL DEFAULT '5' COMMENT 'Tiempo de supervisión en segundos. Rango min: 1, max: 10',
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
INSERT INTO `recursos_telefono` VALUES (11,10,2,0,'Telefono12',0,'1234',0,0,1,3,0,-16,4,0,10,0,'200000','200001',0,5,10,'res@1.2.3.4'),(12,14,1,0,'Telefonico_Test',0,NULL,0,0,1,0,1,-15,0,0,0,0,'','',0,5,5,'sip:');
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

-- Dump completed on 2017-07-25 10:51:48
