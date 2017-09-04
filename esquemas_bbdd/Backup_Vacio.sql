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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historicoincidencias`
--

LOCK TABLES `historicoincidencias` WRITE;
/*!40000 ALTER TABLE `historicoincidencias` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=657 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lista_ips`
--

LOCK TABLES `lista_ips` WRITE;
/*!40000 ALTER TABLE `lista_ips` DISABLE KEYS */;
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
  `pendiente_actualizar` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indica si está pendiente de aplicar cambios (1) o no (0) para poder actualizar la fecha ultima_actualizacion que se manda a la pasarela física',
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

-- Dump completed on 2017-09-04 10:27:14
