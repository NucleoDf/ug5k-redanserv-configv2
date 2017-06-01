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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES (2,'CONFIGURACION1','Descripción 1','1',1,NULL),(3,'CONFIGURACION2','Descripción 2','1',0,NULL),(4,'CONFIGURACION3','Descripcion3','1',0,NULL);
/*!40000 ALTER TABLE `configuraciones` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emplazamientos`
--

LOCK TABLES `emplazamientos` WRITE;
/*!40000 ALTER TABLE `emplazamientos` DISABLE KEYS */;
INSERT INTO `emplazamientos` VALUES (3,'EMPLAZAMIENTO1',2),(4,'EMPLAZAMIENTO2',3),(5,'EMPLAZAMIENTO3',2),(6,'EMPLAZAMIENTO4',4);
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
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
INSERT INTO `historicoincidencias` VALUES (1,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:35:40',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(2,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:36:19',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(3,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:38:04',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(4,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:42:24',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(5,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:46:46',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(6,NULL,'CFG','SEGURIDAD',50,'2017-05-23 12:50:00',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(7,NULL,'CFG','SEGURIDAD',50,'2017-05-23 15:17:08',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(8,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:43:07',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(9,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:50:10',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(10,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:51:37',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(11,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:52:20',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(12,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:54:06',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(13,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:55:42',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(14,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:57:04',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(15,NULL,'CFG','SEGURIDAD',50,'2017-05-25 13:59:27',NULL,'Inicio sesión Configuración Centralizada  del usuario 1.','1'),(16,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:51:35',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(17,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:56:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(18,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(19,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(20,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:28',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(21,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(22,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(23,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(24,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(25,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:57:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(26,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:58:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(27,NULL,'CFG','SEGURIDAD',50,'2017-05-25 15:59:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(28,NULL,'CFG','SEGURIDAD',50,'2017-05-25 16:04:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(29,NULL,'CFG','SEGURIDAD',51,'2017-05-25 16:04:06',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(30,NULL,'CFG','SEGURIDAD',50,'2017-05-25 16:04:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(31,NULL,'CFG','SEGURIDAD',51,'2017-05-25 16:04:46',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(32,NULL,'CFG','SEGURIDAD',51,'2017-05-25 16:04:48',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(33,NULL,'CFG','SEGURIDAD',50,'2017-05-25 16:10:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(34,NULL,'CFG','SEGURIDAD',50,'2017-05-25 16:11:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(35,NULL,'CFG','SEGURIDAD',55,'2017-05-25 16:41:35',NULL,'Fin sesion  Configuración Centralizada  del usuario  La Session ha expirado.....','1'),(36,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:24:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(37,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:25:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(38,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:26:53',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(39,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:31:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(40,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:33:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(41,NULL,'CFG','SEGURIDAD',50,'2017-05-26 10:35:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(42,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:04:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(43,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:06:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(44,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:08:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(45,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:15:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(46,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:15:17',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(47,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:15:18',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(48,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:16:59',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(49,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:17:20',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(50,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:18:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(51,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:18:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(52,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:25:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(53,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:25:08',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(54,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:25:10',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(55,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:25:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(56,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:25:54',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(57,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:25:55',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(58,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:29:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(59,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:29:53',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(60,NULL,'CFG','SEGURIDAD',51,'2017-05-26 12:29:56',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(61,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:33:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(62,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:48:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(63,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:49:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(64,NULL,'CFG','SEGURIDAD',50,'2017-05-26 12:50:07',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(65,NULL,'CFG','SEGURIDAD',50,'2017-05-29 09:39:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(66,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:41:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(67,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:42:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(68,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:51:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(69,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:53:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(70,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:54:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(71,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:57:12',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(72,NULL,'CFG','SEGURIDAD',50,'2017-05-29 10:57:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(73,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:14:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(74,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:22:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(75,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:22:39',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(76,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:24:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(77,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:24:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(78,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:28:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(79,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:29:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(80,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:31:04',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(81,NULL,'CFG','SEGURIDAD',50,'2017-05-29 11:31:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(82,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:17:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(83,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:18:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(84,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:19:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(85,NULL,'CFG','SEGURIDAD',51,'2017-05-29 12:19:47',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(86,NULL,'CFG','SEGURIDAD',51,'2017-05-29 12:19:52',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(87,NULL,'CFG','SEGURIDAD',51,'2017-05-29 12:19:58',NULL,'Rechazada sesión Configuración Centralizada  del usuario  Existe una sesion activa..','1'),(88,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:20:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(89,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:22:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(90,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:26:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(91,NULL,'CFG','SEGURIDAD',50,'2017-05-29 12:33:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(92,NULL,'CFG','SEGURIDAD',50,'2017-05-29 13:05:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(93,NULL,'CFG','SEGURIDAD',50,'2017-05-29 13:10:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(94,NULL,'CFG','SEGURIDAD',50,'2017-05-29 14:18:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(95,NULL,'CFG','SEGURIDAD',50,'2017-05-29 14:21:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(96,NULL,'CFG','SEGURIDAD',50,'2017-05-29 14:28:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(97,NULL,'CFG','SEGURIDAD',50,'2017-05-29 14:29:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(98,NULL,'CFG','SEGURIDAD',50,'2017-05-29 14:30:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(99,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:02:54',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(100,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:04:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(101,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:04:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(102,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:08:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(103,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:12:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(104,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:18:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(105,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:35:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(106,NULL,'CFG','SEGURIDAD',50,'2017-05-29 15:54:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(107,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:06:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(108,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:07:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(109,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:39:57',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(110,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:42:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(111,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:43:15',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(112,NULL,'CFG','SEGURIDAD',50,'2017-05-29 16:44:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(113,NULL,'CFG','SEGURIDAD',50,'2017-05-30 09:55:21',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(114,NULL,'CFG','SEGURIDAD',50,'2017-05-30 10:03:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(115,NULL,'CFG','SEGURIDAD',50,'2017-05-30 10:04:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(116,NULL,'CFG','SEGURIDAD',50,'2017-05-30 10:05:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(117,NULL,'CFG','SEGURIDAD',50,'2017-05-30 10:11:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(118,NULL,'CFG','SEGURIDAD',50,'2017-05-30 11:17:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(119,NULL,'CFG','SEGURIDAD',50,'2017-05-30 11:18:58',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(120,NULL,'CFG','SEGURIDAD',50,'2017-05-30 11:22:50',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(121,NULL,'CFG','SEGURIDAD',50,'2017-05-30 11:29:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(122,NULL,'CFG','SEGURIDAD',50,'2017-05-30 12:02:36',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(123,NULL,'CFG','SEGURIDAD',50,'2017-05-30 12:14:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(124,NULL,'CFG','SEGURIDAD',50,'2017-05-30 12:19:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(125,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:27:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(126,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:28:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(127,NULL,'CFG','SEGURIDAD',50,'2017-05-30 17:30:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(128,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:10:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(129,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:39:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(130,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:42:01',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(131,NULL,'CFG','SEGURIDAD',50,'2017-05-31 10:44:17',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(132,NULL,'CFG','SEGURIDAD',50,'2017-05-31 11:11:49',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(133,NULL,'CFG','SEGURIDAD',50,'2017-05-31 11:13:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(134,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:12:41',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(135,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:14:46',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(136,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:25:30',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(137,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:28:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(138,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:33:23',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(139,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:34:29',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(140,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:38:09',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(141,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:46:16',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(142,NULL,'CFG','SEGURIDAD',50,'2017-05-31 12:58:45',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(143,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:00:10',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(144,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:03:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(145,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:07:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(146,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:11:08',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(147,NULL,'CFG','SEGURIDAD',50,'2017-05-31 13:15:48',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(148,NULL,'CFG','SEGURIDAD',50,'2017-05-31 16:50:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(149,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:00:11',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(150,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:09:44',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(151,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:15:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(152,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:22:22',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(153,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:24:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(154,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:28:59',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(155,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:30:33',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(156,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:32:13',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(157,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:35:56',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(158,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:39:06',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(159,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:40:18',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(160,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:42:03',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(161,NULL,'CFG','SEGURIDAD',50,'2017-05-31 17:45:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(162,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:05:37',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(163,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:07:05',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(164,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:09:51',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(165,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:13:00',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(166,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:14:14',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(167,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:16:42',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(168,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:17:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(169,NULL,'CFG','SEGURIDAD',50,'2017-05-31 18:20:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(170,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:01:40',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(171,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:08:34',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(172,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:11:38',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(173,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:13:19',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(174,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:15:26',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(175,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:17:47',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(176,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:20:55',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(177,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:25:02',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(178,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:32:31',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1'),(179,NULL,'CFG','SEGURIDAD',50,'2017-06-01 09:39:52',NULL,'Inicio sesión Configuración Centralizada  del usuario .','1');
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
  `ip` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor de la dirección ip.',
  `puerto` int(5) DEFAULT NULL COMMENT 'Valor del puerto si aplica.',
  `tipo` varchar(5) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Tipo de IP: PROXY: PROXY, RGTRS: REGISTRAR, NTP: SERVIDOR NTP, TRPV1: IP PARA TRAPS V1, TRPV2: IP PARA TRAPS V2',
  PRIMARY KEY (`idlista_ips`),
  KEY `fk_pasarela_lista_ips_idx` (`pasarela_id`),
  CONSTRAINT `fk_pasarela_lista_ips` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
INSERT INTO `lista_ips` VALUES (1,1,'1.2.3.4',NULL,'PRX'),(2,1,'1.3.4.5',2234,'REG'),(3,1,'2.3.4.5',NULL,'NTP'),(4,1,'1.1.1.1',3321,'TRPV1'),(5,1,'2.2.2.2',223,'TRPV2'),(6,2,'4.4.4.4',112,'TRPV1'),(7,1,'1.4.2.5',NULL,'PRX');
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
  `ip` varchar(15) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor de la dirección ip',
  `puerto` int(5) DEFAULT NULL COMMENT 'Valor del puerto si aplica',
  `usuario` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de usuario asignado a la URI.',
  `tipo` varchar(3) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Tipo de URI: TXA: TRANSMISION A, TXB: TRANSMISION B, RXA: RECEPCION A, RXB: RECEPCION B, LSB: LISTA BLANCA, LSN: LISTA NEGRA, TEL: TELEFONIA.',
  PRIMARY KEY (`idlista_uris`),
  KEY `fk_recurso_radio_uri` (`recurso_radio_id`),
  CONSTRAINT `fk_recurso_radio_uri` FOREIGN KEY (`recurso_radio_id`) REFERENCES `recursos_radio` (`idrecurso_radio`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_uris`
--

LOCK TABLES `lista_uris` WRITE;
/*!40000 ALTER TABLE `lista_uris` DISABLE KEYS */;
INSERT INTO `lista_uris` VALUES (1,1,'1',1,'1','1');
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
  `puerto_proxy` int(5) DEFAULT '5060' COMMENT 'Valor del puerto para el proxy.',
  `periodo_supervision` int(6) DEFAULT '0' COMMENT 'Tiempo en segundos para el valor supervisión.',
  `puerto_servicio_snmp` int(5) DEFAULT '65000' COMMENT 'Valor del puerto para el servicio snmp.',
  `puerto_snmp` int(5) DEFAULT '161' COMMENT 'Valor del puerto para el snmp.',
  `snmpv2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indica si usa snmp versión 2. (1) Verdadero, (0) Falso.',
  `nombre_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'ULISESG5000i' COMMENT 'Nombre del servicio snmp.',
  `localizacion_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF LABS' COMMENT 'Localización del servicio snmp.',
  `contacto_snmp` varchar(45) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'NUCLEO-DF DT. MADRID. SPAIN' COMMENT 'Dirección de contacto del servicio snmp.',
  `puerto_servicio_web` int(5) DEFAULT NULL COMMENT 'Valor del puerto para el servicio web.',
  `tiempo_sesion` int(6) DEFAULT '0' COMMENT 'Tiempo en segundos de la sesión.',
  `puerto_rtsp` int(5) DEFAULT NULL COMMENT 'Valor para el puerto rtsp.',
  `servidor_rtsp` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección del servidor rtsp.',
  `fichero` json DEFAULT NULL COMMENT 'Prueba fichero',
  PRIMARY KEY (`idpasarela`),
  KEY `fk_emp_pasarela_idx` (`emplazamiento_id`),
  CONSTRAINT `fk_emp_pasarela` FOREIGN KEY (`emplazamiento_id`) REFERENCES `emplazamientos` (`idemplazamiento`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasarelas`
--

LOCK TABLES `pasarelas` WRITE;
/*!40000 ALTER TABLE `pasarelas` DISABLE KEYS */;
INSERT INTO `pasarelas` VALUES (1,3,'PASARELA','1.1.1.1','2017-05-12 13:27:24','1.1.1.2','1.1.1.3','1.1.1.3','1.1.1.4','1.1.1.5','1.1.1.6',5060,0,65000,161,1,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',1234,22,12,'1.11.111.1','{\"tipo\": [0, 1], \"idConf\": [\"MADRID-REGION-5\", \"MADRID-REGION-5\"], \"general\": {\"ips\": [\"192.168.0.212:5050\", \"192.168.0.212:5050\"], \"ipv\": [\"192.168.0.51\", \"192.168.0.51\"], \"name\": [\"GW-01-01\", \"GW-01-01\"], \"dualidad\": [1, 1], \"nivelconsola\": -1, \"emplazamiento\": [\"EMPLAZAMIENTO-01\", \"EMPLAZAMIENTO-01\"], \"nivelconsola2\": -1}, \"fechaHora\": [\"19/05/2017 08:59:46 UTC\", \"19/05/2017 08:59:46 UTC\"]}'),(2,4,'PASARELA2','2.2.2.2','2017-05-13 13:27:24','2.2.2.2','2.2.2.3','2.2.2.4','2.2.2.5','2.2.2.6','2.2.2.7',5060,240,65001,162,0,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',234,21,13,'2.12.112.2',NULL),(3,3,'PASARELA3','33.33.33.33','2017-05-14 13:27:24','3.3.3.3','3.3.3.4','3.3.3.5','3.3.3.6','3.3.3.7','3.3.3.8',5060,234,65002,161,0,'ULISESG5000i','NUCLEO-DF LABS','NUCLEO-DF DT. MADRID. SPAIN',12,23,14,'3.13.113.3',NULL);
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
  `rango_ats_inicial` varchar(6) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor inicial para el rango ATS. STRING (ATS-USER).',
  `rango_ats_final` varchar(6) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Valor final para el rango ATS. STRING (ATS-USER).',
  `recurso_telefonico_id` int(11) DEFAULT NULL,
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
-- Table structure for table `recursos_radio`
--

DROP TABLE IF EXISTS `recursos_radio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recursos_radio` (
  `idrecurso_radio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Campo Clave. Representa un recurso de tipo radio, asignado a una pasarela.',
  `pasarela_id` int(11) NOT NULL COMMENT 'Clave externa a pasarela.',
  `numero_ia4` int(1) NOT NULL COMMENT 'Elemento IA4 en la que se encuentra asignado el recurso radio. Puede tomar valores del 0 al 3.',
  `posicion_ia4` int(1) NOT NULL COMMENT 'Posición dentro de la IA4 en la que se encuentra asignado el recurso radio. Puede tomar valores del 0 al 3.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre del recurso. Único dentro de la pasarela.',
  `codec` int(1) DEFAULT '0' COMMENT 'Codec de audio para el recurso radio. 0: G711-A',
  `clave_registro` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Valor para la clave del registro. Indica no habilitado con valor NULL.',
  `frecuencia` float(7,3) NOT NULL COMMENT 'Frecuencia en Mhz (UHF/VHF). desde 30.000 a 3000.000',
  `ajuste_ad` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en A/D. Rango min: -13.5, max: 1.20. Si es NULL el ajuste es automático.',
  `ajuste_da` float(4,2) DEFAULT NULL COMMENT 'Ajuste cero digital en D/A. Rango min: -24.3, max: 1.10. Si es NULL el ajuste es automático.',
  `precision_audio` int(1) NOT NULL COMMENT 'Precisión de Audio: (0) Normal o (1) Estricto.',
  `tipo_agente` int(1) NOT NULL COMMENT 'Tipo de agente de radio. 0 (LS), 1 (LPR), 2 (FDS), 3 (FDPR), 4 (RRT), 5(RTX), 6(RRX).',
  `indicacion_entrada_audio` int(1) NOT NULL COMMENT 'Indicación de entrada de audio. 0 (HW), 1 (VAD), 2 (FORZADO)',
  `indicacion_salida_audio` int(1) NOT NULL COMMENT 'Indicación de salida de audio. 0 (HW), 1 (TONO)',
  `metodo_bss` int(1) DEFAULT NULL COMMENT 'Método BSS disponible.\nEn RLOCALES: 0 (Ninguno), 1 (RSSI), 2 (RSSI y NUCLEO)\rEn REMOTOS: 0 (RSSI), 1 (NUCLEO).',
  `prioridad_ptt` int(1) DEFAULT '0' COMMENT 'Prioridad PTT. Rango: 0 (Normal), 1 (Prioritario), 2 (Emergencia)',
  `prioridad_sesion_sip` int(1) DEFAULT '0' COMMENT 'Prioridad sesión SIP. 0 (Normal), 1 ( Prioritaria)',
  `climax_bss` tinyint(1) DEFAULT '0' COMMENT 'Habilita BSS/CLIMAX. (1) Habilitado, (0) No Habilitado.',
  `retraso_interno_grs` int(3) DEFAULT NULL COMMENT 'Retraso interno GRS en mili segundos. Rango min: 0, max: 250.',
  `evento_ptt_squelch` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Evento PTT/Squelch. (1) Activado, (0) No Activado.',
  `habilita_grabacion` tinyint(1) DEFAULT '1' COMMENT 'Habilita grabación. (1) Si habilita, (0) No Habilita.',
  `tabla_bss_id` int(11) DEFAULT NULL COMMENT 'Clave ajena a la tabla bss de calificación de audio.',
  `max_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `min_jitter` int(3) DEFAULT '0' COMMENT 'Rango 0 < val < 200.',
  `umbral_vad` float(3,1) DEFAULT NULL COMMENT 'Umbral Vad. Rango min: -35.0, max: -15.0.',
  `tiempo_max_ptt` int(4) DEFAULT NULL COMMENT 'Tiempo máximo PTT. Rango de min: 0, max: 1000',
  `ventana_bss` int(4) DEFAULT NULL COMMENT 'Ventana BSS. Rango min: 10, max: 5000.',
  `tipo_climax` int(1) DEFAULT NULL COMMENT 'Tipo de climax. 0 (No), 1(ASAP), 2(TIEMPO FIJO).',
  `retardo_fijo_climax` int(3) DEFAULT NULL COMMENT 'Retardo fijo climax. Rango min: 0, max: 250',
  `cola_bss_sqh` int(4) DEFAULT NULL COMMENT 'Cola BSS SQH. Rango min: 10, max: 5000.',
  `retardo_jitter` int(3) DEFAULT NULL COMMENT 'Retardo jitter. Rango min: 0, max: 100.',
  `metodo_climax` int(1) DEFAULT '0' COMMENT 'Método climax. Valores 0 (Relativo), 1 (Absoluto).',
  `restriccion_entrantes` int(1) DEFAULT '0' COMMENT 'Restricción entrantes. Valores: 0 (Ninguna), 1 (Lista Negra), 2 (Lista Blanca)',
  PRIMARY KEY (`idrecurso_radio`),
  KEY `fk_pasarela_radio_idx` (`pasarela_id`),
  KEY `fk_radio_tabla_bss_idx` (`tabla_bss_id`),
  CONSTRAINT `fk_pasarela_radio` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_radio_tabla_bss` FOREIGN KEY (`tabla_bss_id`) REFERENCES `tablas_bss` (`idtabla_bss`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_radio`
--

LOCK TABLES `recursos_radio` WRITE;
/*!40000 ALTER TABLE `recursos_radio` DISABLE KEYS */;
INSERT INTO `recursos_radio` VALUES (1,1,3,3,'RecursoRadio',0,NULL,135.000,NULL,NULL,1,1,1,1,NULL,NULL,NULL,0,NULL,0,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0);
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
  `numero_ia4` int(1) NOT NULL COMMENT 'Elemento IA4 en la que se encuentra asignado el recurso telefónico. Puede tomar valores del 0 al 3.',
  `posicion_ia4` int(1) NOT NULL COMMENT 'Posición dentro de la IA4 en la que se encuentra asignado el recurso telefónico. Puede tomar valores del 0 al 3.',
  `nombre` varchar(64) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Nombre del recurso telefónico. Único dentro de la pasarela.',
  `codec` int(1) NOT NULL DEFAULT '0' COMMENT 'Codec de audio para el recurso radio. 0: G711-A',
  `clave_registro` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Valor para la clave del registro.',
  `ajuste_ad` int(10) DEFAULT NULL COMMENT 'Ajuste cero digital en A/D',
  `ajuste_da` int(10) DEFAULT NULL COMMENT 'Ajuste cero digital en D/A',
  `tipo_interfaz_tel` varchar(30) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Tipo de interfaz telefónico.',
  `deteccion_vox` tinyint(1) DEFAULT '1' COMMENT 'Detección Vox. (1) Si, (0) No.',
  `umbral_vox` int(10) DEFAULT NULL COMMENT 'Valor del umbral Vox en dB.',
  `cola_vox` int(10) DEFAULT NULL COMMENT 'Valor para la cola Vox en segundos.',
  `respuesta_automatica` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Respuesta automática. (1) Si, (0) No.',
  `periodo_tonos` int(2) DEFAULT NULL COMMENT 'Periodo tonos respuesta estado en segundos. Rango min: 1, max: 10',
  `lado` varchar(1) COLLATE latin1_spanish_ci NOT NULL COMMENT 'Lado A o lado B.',
  `origen_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Origen llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `destino_test` varchar(6) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Destino llamadas salientes de test. STRING (ATS-USER). De "200000" a "399999”',
  `supervisa_colateral` tinyint(1) DEFAULT NULL COMMENT 'Indica si supervisa colateral. (1) Supervisa, (0) No Supervisa.',
  `tiempo_supervision` int(2) DEFAULT NULL COMMENT 'Tiempo de supervisión en segundos. Rango min: 1, max: 10',
  `duracion_tono_interrup` int(2) NOT NULL DEFAULT '0' COMMENT 'Duración en segundos del tono de interrupción. Rango min: 5, max: 15.',
  `uri_telefonica` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Uri para el recurso telefónico.',
  PRIMARY KEY (`idrecurso_telefono`),
  KEY `fk_pasarela_tfno_idx` (`pasarela_id`),
  CONSTRAINT `fk_pasarela_tfno` FOREIGN KEY (`pasarela_id`) REFERENCES `pasarelas` (`idpasarela`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_telefono`
--

LOCK TABLES `recursos_telefono` WRITE;
/*!40000 ALTER TABLE `recursos_telefono` DISABLE KEYS */;
INSERT INTO `recursos_telefono` VALUES (1,1,1,2,'tfno1',0,NULL,NULL,NULL,'',1,NULL,NULL,1,NULL,'',NULL,NULL,NULL,NULL,0,NULL),(2,1,2,1,'tfno2',0,NULL,NULL,NULL,'',1,NULL,NULL,1,NULL,'',NULL,NULL,NULL,NULL,0,'sip:1'),(3,2,0,0,'tfno3',0,NULL,NULL,NULL,'',1,NULL,NULL,1,NULL,'',NULL,NULL,NULL,NULL,0,'sip: 1.1');
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
 1 AS `resource_type`,
 1 AS `frecuencia`,
 1 AS `resource_subtype`*/;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablas_bss`
--

LOCK TABLES `tablas_bss` WRITE;
/*!40000 ALTER TABLE `tablas_bss` DISABLE KEYS */;
/*!40000 ALTER TABLE `tablas_bss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ug5kv2'
--

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
/*!50001 VIEW `spvs_cgw` AS select `p`.`nombre` AS `name`,`rr`.`nombre` AS `resource`,1 AS `resource_type`,`rr`.`frecuencia` AS `frecuencia`,`rr`.`tipo_agente` AS `resource_subtype` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_radio` `rr` on((`p`.`idpasarela` = `rr`.`pasarela_id`))) where (`c`.`activa` = 1) union select `p`.`nombre` AS `name`,`rt`.`nombre` AS `resource`,2 AS `resource_type`,NULL AS `frecuencia`,`rt`.`tipo_interfaz_tel` AS `resource_subtype` from (((`pasarelas` `p` left join `emplazamientos` `e` on((`p`.`emplazamiento_id` = `e`.`idemplazamiento`))) left join `configuraciones` `c` on((`e`.`configuracion_id` = `c`.`idconfiguracion`))) left join `recursos_telefono` `rt` on((`p`.`idpasarela` = `rt`.`pasarela_id`))) where (`c`.`activa` = 1) */;
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

-- Dump completed on 2017-06-01  9:43:27
