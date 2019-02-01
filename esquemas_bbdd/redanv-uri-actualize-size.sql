USE `ug5kv2`;
--
-- 
--
ALTER TABLE `ug5kv2`.`lista_uris`   
  CHANGE `uri` `uri` VARCHAR(64) CHARSET latin1 COLLATE latin1_spanish_ci NOT NULL  COMMENT 'Valor de la dirección ip. Puede ser usuario@ip:puerto';
--
-- 
--
ALTER TABLE `ug5kv2`.`recursos_externos`   
  CHANGE `uri` `uri` VARCHAR(64) CHARSET latin1 COLLATE latin1_spanish_ci NOT NULL  COMMENT 'Uri introducida por el usuario para ser seleccionada';

--
--
--
ALTER TABLE `ug5kv2`.`recursos_telefono`   
  CHANGE `uri_telefonica` `uri_telefonica` VARCHAR(64) CHARSET latin1 COLLATE latin1_spanish_ci NULL  COMMENT 'Uri para el recurso telefónico.';
