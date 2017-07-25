var myLibGateways = require('./gateways.js');
var myLibServices = require('./services.js');
var myLibHardware = require('./hardware.js');
var async=require('async');

var logging = require('./loggingDate.js');

/** AGL */
var gcfg = require('../configUlises.json');

/************************************/
/*	FUNCTION: getConfigurations 	*/
/*  PARAMS: 						*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.getConfigurations = function getConfigurations(req, res){
	var cfgs=[];
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err, usrs){
		if (err){
			logging.LoggingDate("Error connention to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		
			var query = connection.query('SELECT idconfiguracion as idCFG, nombre as name, descripcion as description,' +
				'region, activa, fecha_activacion as ts_activa ' +
				'FROM configuraciones', function(err, rows, fields) {
				logging.LoggingDate(query.sql);
				if(err)
					res.json({error: err.message});
				else {
					cfgs = rows;
					logging.LoggingDate(JSON.stringify({result:cfgs},null,'\t'));
					res.json({result: cfgs});
				}
			});
			connection.end();	
		}
	});
};

/********************************/
/*	FUNCTION: getConfiguration 	*/
/*  PARAMS: res,				*/
/*			red,				*/
/*			configuration		*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.getConfiguration = function getConfiguration(req, res, cfg){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err) {
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else {
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		}
		var query = connection.query('SELECT c.idconfiguracion as idCFG, c.nombre as name, '+
									'c.descripcion as description, c.activa as activa, '+
									'DATE_FORMAT(c.activa, "%d/%m/%Y %H:%i:%s") as ts_activa, '+
									'e.nombre as nameSite, e.idemplazamiento as idEMPLAZAMIENTO '+
									'FROM configuraciones c '+
									'LEFT JOIN emplazamientos e ON c.idconfiguracion = e.configuracion_id '+
									'WHERE c.idconfiguracion = ?',cfg, function(err, rows, fields) {
			logging.LoggingDate(query.sql);
			if(err)
				res.json({error: err.message});
		    else {
				var c=rows;
				logging.LoggingDate(JSON.stringify({result:c},null,'\t'));
				res.json({result:c});
		    }
		});
	});
};

/************************************/
/*	FUNCTION: postConfiguration 	*/
/*  PARAMS: newGateway				*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.postConfiguration = function postConfiguration(req, res, newConfiguration, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		}

		var query = connection.query('INSERT INTO configuraciones (nombre, descripcion) '+
									'VALUES (?,?)', [newConfiguration.name,newConfiguration.description],
		function(err, result) {
			logging.LoggingDate(query.sql);
			connection.end();
			if (err){
				return f({error: err.message, data: newConfiguration});
			}
			else {
				newConfiguration.idCFG = result.insertId;
				return f({error: null, data: newConfiguration});
			}
		});
	});
};

/************************************/
/*	FUNCTION: putConfiguration 		*/
/*  PARAMS: oldIdConf,				*/
/*			cfg,					*/
/*          f  						*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.putConfiguration = function putConfiguration(oldIdConf, cfg, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
			return;
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		}

		var query = connection.query('UPDATE configuraciones SET nombre=?, descripcion=? ' +
									'WHERE idconfiguracion=?',[cfg.name, cfg.description, cfg.idCFG],
			function(err, result){
				logging.LoggingDate(query.sql);
				connection.end();
			if (err){
				return f({error: err.message, data: null});
			}
			else
				return f({error: null, data: cfg});
		});
	});
};

/********************************/
/*	FUNCTION: delConfiguration 	*/
/*  PARAMS: res,				*/
/*			req,				*/
/*			cfg,				*/
/*			f 					*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.delConfiguration = function delConfiguration(req, res, cfg, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
		host     : gcfg.Ulises.dbhost,
		user     : gcfg.Ulises.dbuser,
		password : gcfg.Ulises.dbpassword,
		database : gcfg.Ulises.dbdatabase,
		multipleStatements: true
	});
	
	connection.connect(function(err, usrs){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			
			var query = connection.query('DELETE FROM configuraciones WHERE idconfiguracion=?', [cfg],
				function(err, result) {
					logging.LoggingDate(query.sql);
					connection.end();
					if (err)
						f({error: err.message});
					else
						f({data: 'OK'});
				});
		}
	});
};

/*var query = connection.query('DELETE FROM CFG WHERE ??=?', ['name', cfg], function (err, result) {
 logging.LoggingDate(query.sql);
 f({error: null, data: cfg});
 
 connection.end();
 });*/
/************************************/
/*	FUNCTION: copyConfiguration 	*/
/*  PARAMS: sourceCfg,				*/
/*			targetCfg				*/
/* 	Llamada a Procedimiento MySQL	*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.copyConfiguration = function copyConfiguration(src, trgt, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			var query = connection.query('CALL SP_CopyConfiguration(?,?,?)',[src, trgt.name, trgt.description],
			function (err, rows, result) {
				logging.LoggingDate(query.sql);
				connection.end();
				if (err)
					f({error: err.message});
				else {
					f({data: 'COPY_OK'});
				}
			});
		}
	});
};

/********************************/
/*	FUNCTION: getFreeGateways 	*/
/*  PARAMS: 					*/
/********************************/
exports.getFreeGateways = function getFreeGateways(cfg, f){
	var gtws=[];
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err, usrs){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		
			var query = "";
			query=connection.query('SELECT b.*,a.Activa,e.name as nameSite, c.idCFG,c.name as nameCfg,c.description,c.activa,c.ts_activa FROM (SELECT * FROM CGW_CFG WHERE CFG_idCFG=?) a RIGHT JOIN' + 
										' CGW b ON a.CGW_idCGW = b.idCGW' +
										' INNER JOIN emplazamiento e ON b.EMPLAZAMIENTO_idEMPLAZAMIENTO=e.idEMPLAZAMIENTO ' +
										' INNER JOIN cfg c ON c.idCFG = e.CFG_idCFG ' +
										' WHERE a.CGW_idCGW IS NULL ORDER BY nameCfg,e.name,b.name', cfg, function(err, rows, fields) {
				logging.LoggingDate(query.sql);
				if (err){
					return f({error: err.code, result: null});
				}

			    if (rows.length > 0){
		    		gtws = rows;
		    		logging.LoggingDate(JSON.stringify({error: null, result: gtws},null,'\t'));
		    	}
				connection.end();	
				f({error: null, result: gtws});
			});
		}
	});
};

/****************************************/
/*	FUNCTION: activateConfiguration 	*/
/*  PARAMS: idCFG 						*/
/****************************************/
exports.activateConfiguration = function activateConfiguration(idCFG,f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
			return;
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");

			// Comprobar si tiene pasarealas. En caso contrario no se puede activar esta configuración
			var queryHasGateways = connection.query('SELECT COUNT(*) as cuantos FROM CGW a ' +
														'INNER JOIN emplazamiento e ON a.EMPLAZAMIENTO_idEMPLAZAMIENTO=e.idEMPLAZAMIENTO ' +
														'WHERE e.CFG_idCFG=?', idCFG, function(err, rows, fields) {
				if (!err && rows != null && rows.length > 0){
					if (rows[0].cuantos == 0){
						connection.end();
						return f({result:false, count:0});
					}
					else{
						// Desactivar la configuración activa
						var query = connection.query('UPDATE CFG SET activa=0 WHERE activa=1', function(err, result){
							logging.LoggingDate(query.sql);
							if (err){
								connection.end();
								return f({result:false, count:1});
							}

							var queryCgwCfg = connection.query('UPDATE CGW_CFG SET Activa=0,Sincro=0 WHERE Activa=1', function(err, result){
								logging.LoggingDate(queryCgwCfg.sql);
								if (err){
									connection.end();
									return f({result:false, count:1});
								}

								// Activar la configuración 
								var queryActive = connection.query('UPDATE CFG SET activa=1,ts_activa=UTC_TIMESTAMP() WHERE idCFG=?', idCFG, function(err, result){
									logging.LoggingDate(queryActive.sql);
									if (err){
										connection.end();
										return f({result:false, count:1});
									}

									var queryGw = connection.query('DELETE FROM CGW_CFG WHERE CFG_idCFG=? AND Activa=-1', idCFG, function(err, result){
										logging.LoggingDate(queryGw.sql);
										if (err){
											connection.end();
											return f({result:false, count:1});
										}

										queryCgwCfg = connection.query('UPDATE CGW_CFG SET Activa=1, Sincro=0, LastUpdate=UTC_TIMESTAMP() WHERE CFG_idCFG=?', idCFG, function(err, result){
											connection.end();
											logging.LoggingDate(queryCgwCfg.sql);
											if (err){
												return f({result:false, count:1});
											}
											
										f({result:true, count:1});
										});
									});
								});
							});
						});
					}
				}
				else{
					connection.end();
					return f({result:false, count:1});
				}
			});
		}
	});
};


/************************************************************************/
/*	FUNCTION: activateGateways		 									*/
/*  PARAMS: idCFG 														*/
/*          listOfGateways												*/
/*  DESC: Activa configuración en las gateways pasadas en arrayOfGtw 	*/
/************************************************************************/
exports.activateGateways = function activateGateways(idCfg,arrayOfGtw,f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
			return;
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");

			queryCgwCfg = connection.query('UPDATE CGW_CFG SET Sincro=0, LastUpdate=UTC_TIMESTAMP(), Activa=1 WHERE CFG_idCFG=? AND CGW_idCGW IN (?)', [idCfg,arrayOfGtw], function(err, result){
				connection.end();
				logging.LoggingDate(queryCgwCfg.sql);
				if (err){
					return f(false);
				}

				f(true);
			});
		}
	});
};

exports.postConfigurationFromGateway = function postConfigurationFromGateway(req, res, general, servicios, hardware, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		
			// Crear el servicio.
			if (servicios != null && servicios.name == null)
				servicios.name = general.name + '_SERVICE';


			var slaves=[];
			
			async.waterfall([
				function(callback){
					// Localizar la gateway a partir de la ip de la CPU pasada como parámetro en el POST
					myLibGateways.getIpv(req.params.gateway,function(result){
						if (result.error != null)
							return callback(result.error);

						//callback(null,result.idCGW);
						if (result.ipv == -1){	// result.data => ipv de la gateway
							if (servicios.idSERVICIOS == null){
								myLibServices.postService(servicios,function(result){
									servicios.idSERVICIOS = result.service.idServicios;
									// SI LA GATEWAY NO EXISTE EN LA CONFIGURACIÓN, SE INSERTA.
									myLibGateways.postGateway(req.body.idConf, false, true, general, servicios, function(result){
										//idCGW = result.data.idCGW;
										exports.assignGatewayToConfiguration({"CFG_idCFG" : result.idCfg, "CGW_idCGW": result.data.idCGW, Activa:1, Sincro:2}, function(result){
								    		callback(null,result.data.CGW_idCGW);
								    	});
										//callback(null, result.data.idCGW);
									});
								});
							}
							else{
								myLibGateways.postGateway(req.body.idConf, false, true, general, servicios, function(result){
									myLibGateways.assignGatewayToConfiguration({"CFG_idCFG" : result.idCfg, "CGW_idCGW": result.data.idCGW, Activa:1, Sincro:2}, function(result){
							    		callback(null,result.data.CGW_idCGW);
							    	});
									//callback(null, result.data.idCGW);
								});	
							}
						}
						else{
							// SI YA EXISTE, SE OBTIENE EL idCGW PARA ACTUALIZAR (ELIMINAR/INSERTAR) EL HARDWARE
							//myLibHardware.RemoveHardwareFromGateway({CGW_idCGW:rows[0].idCGW,SLAVES_idSLAVES:null},function(result){
								servicios.idSERVICIOS = result.servicio;
								general.idCGW = result.idCGW;
								
								// SE ACTUALIZAN LOS DATOS DE LA PASARELA Y SUS SERVICIOS ASIGNADOS
								myLibGateways.putGateway(req, res, general, servicios, function(gtw){
									callback(null, result.idCGW);
								});
							//})
						}
					});
				}],
				function(err, idCGW){
					var numSlave = 0;
					// INSERTAR CADA ESCLAVA RECIBIDA
					async.eachSeries(hardware.slv,
						function(s,callback){
							if (s.tp != -1){	// Configurada
								// Comprobar si la CGW <idCGW> tiene una esclava configurada en la posición <numSlave>
								var querySlave=connection.query('SELECT SLAVES_idSLAVES FROM hardware ' +
																	'WHERE CGW_idCGW=? AND rank=?', [idCGW,numSlave], function(err, rows, fields){
									logging.LoggingDate(querySlave.sql);

									s.rank = numSlave;

									if (err)	callback(err);
									else if (rows != null && rows.length > 0){
										var idSlave = rows[0].SLAVES_idSLAVES;

										//slaves[numSlave++]=idSlave;

										// Eliminar esta slave
										var updateSlave=connection.query('DELETE FROM slaves WHERE idSLAVES=?', idSlave, function(err, result){
											logging.LoggingDate(updateSlave.sql);
											if (err) return callback(err);

											//callback();	
										});
									}

									// Insertar la esclava con los nuevos datos recibidos
									var slave={};

									slave.name = general.name + "_" + s.rank;
									slave.tp = s.tp;

									// Eliminar una posible slave con este nombre
									//var queryDelSlave=connection.query('DELETE FROM slaves WHERE name=?',slave.name,function(err,result){
									//	logging.LoggingDate(queryDelSlave.sql);
										var queryInsertSlaves=connection.query('INSERT INTO slaves SET ?', slave, function(err, result){
											logging.LoggingDate(queryInsertSlaves.sql);
											if (err) callback(err);
											else{
												var hw={};
												hw.CGW_idCGW = idCGW;
												hw.SLAVES_idSLAVES= result.insertId;
												hw.rank = s.rank;

												slaves[numSlave++]=result.insertId;
								
												// INSERTAR EL REGISTRO HARDWARE ASOCIADO A LA ESCLAVA Y A LA PASARELA
												var queryInsertHw=connection.query('INSERT INTO hardware SET ?', hw, function(err,result){
													logging.LoggingDate(queryInsertHw.sql);
													if (err) return callback(err);

													callback();	
												});
											}
										});
									//})
								});
							}
							else{
								slaves[numSlave]=-1;

								// Slave no configurada
								myLibHardware.RemoveHardwareFromGateway({CGW_idCGW:rows[0].idCGW,SLAVES_idSLAVES:null,rank:numSlave},function(result){
									numSlave++;
									callback();
								});
							}
						},
						function(err){
							connection.end();

							f({error:err,slaves:slaves});
						}
					);	// End async.each
				}
			);
		}
	});
};

exports.getSiteName = function getSiteName(cfgId,siteName,f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connention to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		}

		//var query = connection.query('SELECT idCFG,name,description,activa,DATE_FORMAT(ts_activa, "%d/%m/%Y %H:%i:%s") as ts_activa FROM CFG WHERE ??=?',['name', cfg], function(err, rows, fields) {
		var query = connection.query('SELECT idEMPLAZAMIENTO ' + 
										'FROM  emplazamiento ' +
    									'WHERE name=? AND cfg_idCFG=?',[siteName,cfgId], function(err, rows, fields) {
			connection.end();
			logging.LoggingDate(query.sql);

		    if (err) throw err;
		    if (rows && rows.length > 0){
				logging.LoggingDate(JSON.stringify({result:rows},null,'\t'));
				f(rows[0]);
		    }
		    else
		    	f(null);
		});
	});
};

exports.getActiveConfiguration = function getActiveConfiguration(req, res, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
			return;
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");

			// Desactivar la configuración activa
			var query = connection.query('SELECT c.idCFG,c.name FROM cfg c ' +
											'INNER JOIN cgw_cfg cc ON cc.CFG_idCFG=c.idCFG ' +
    										'WHERE cc.activa', function(err, rows, fields){
				connection.end();
				logging.LoggingDate(query.sql);
				if (err || rows==null || rows.length == 0){
					return f(null);
				}

				return f({idCFG:rows[0].idCFG,name:rows[0].name});
			});
		}
	});
};

exports.resetGatewaysSynchroState = function resetGatewaysSynchroState(f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			
			var query = connection.query('UPDATE cgw_cfg SET Sincro = 3', function(err, result1) {
				if (err){
					logging.LoggingDate(query.sql);
					connection.end();	
					return f(err ? err : 'NO_DATA');
				}

				var query2=connection.query('REPLACE cgw_estado (SELECT idCGW,EMPLAZAMIENTO_idEMPLAZAMIENTO,0 FROM cgw)',function(err,result2){
					if (err){
							logging.LoggingDate(query2.sql);
							connection.end();	
							return f(err ? err : 'NO_DATA');
						}

					connection.end();	
					logging.LoggingDate(query2.sql);
					f({error: err, result: result1.affectedRows + result2.affectedRows});
				});
			});
		}
	});
};

exports.SP_cfg = function SP_cfg(cfg, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			
			var query = connection.query('CALL SP_ReportCfg(?)',cfg, function(err, rows) {
				connection.end();	
				if (err){
					logging.LoggingDate(query.sql);
					return f(err ? err : 'NO_DATA');
				}

				f({error: err, result: rows});
			});
		}
	});
};

exports.getListOfGateways = function getListOfGateways(f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			
			var query = connection.query('SELECT * FROM listOfGateways', function(err, rows) {
				connection.end();	
				if (err){
					logging.LoggingDate(query.sql);
					return f(err ? err : 'NO_DATA');
				}

				f({error: err, result: rows});
			});
		}
	});
};

/****************************************/
/*	FUNCTION: setUpdateGateway 			*/
/*  PARAMS: 							*/
/*  REV 1.0.2 VMG						*/
/****************************************/
exports.setUpdateGateway = function setUpdateGateway(gtw, f) {
	var mySql = require('mySql');
	var connection = mySql.createConnection({
		host: gcfg.Ulises.dbhost,
		user: gcfg.Ulises.dbuser,
		password: gcfg.Ulises.dbpassword,
		database: gcfg.Ulises.dbdatabase
	});
	
	connection.connect(function (err) {
		if (err) {
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else {
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			var query = connection.query('UPDATE pasarelas SET pendiente_actualizar=1 ' +
				'WHERE idpasarela=?',gtw.Gateway, function(err, rows) {
				connection.end();
				if (err) {
					logging.LoggingDate(query.sql);
					return f(err ? err : 'NO_DATA');
				}
				else
					return f({error: err, result: 'UPDATED'});
			});
		}
	});
}

exports.putListOfGateways = function putListOfGateways(gtw, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");

			var query;			
			if (gtw.Gateway != null){
				query = connection.query('INSERT INTO listOfGateways SET ?', gtw, function(err, result) {
					connection.end();	
					if (err){
						logging.LoggingDate(query.sql);
						return f(err ? err : 'NO_DATA');
					}

					f({error: err, result: result.insertId});
				});
			}
			else{
				query = connection.query('TRUNCATE TABLE listOfGateways', function(err, result) {
					connection.end();	
					if (err){
						logging.LoggingDate(query.sql);
						return f(err ? err : 'NO_DATA');
					}

					f({error: err, result: null});
				});
			}
		}
	});
};

exports.postConfigurationFromJsonFile = function(idcfg, idSite, config, f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err){
		if (err){
			logging.LoggingDate("Error connection to 'U5K-G' database.");
		}
		else{
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
		
			var slaves=[];
			var estadoPasarela=0;//-1: Error || 0: OK || 1: Nombre duplicado || 2: Ips duplicadas
			
			async.waterfall([
				function(callback){
					// Buscar config.general.ipv en la bd
					// Si existe no se genera la importación y mensaje de error o se borra la gtw
					// existente
					var query = connection.query('SELECT COUNT(name) as cuantos '+
						'FROM cgw '+
						'WHERE idCGW IN ( '+
						'SELECT CGW_idCGW '+
						'FROM cgw_cfg '+
						'WHERE CFG_idCFG = ?) '+
						'AND name LIKE ?',[idcfg,config.general.name],
					function(err,rows){
						if(err)
							callback(err,-1);
						else if (rows[0].cuantos != 0) {
							estadoPasarela = 1;//1: Nombre duplicado
							config.general.name = config.general.name + '(Copia)';
						}
						
						var query = connection.query(
							'SELECT c.ipb ' +
							'FROM cpu c ' +
							'LEFT JOIN cgw_cfg c2 ON c2.CGW_idCGW = c.CGW_idCGW ' +
							'LEFT JOIN cfg c3 ON c3.idCFG = c2.CFG_idCFG ' +
							'WHERE c3.idCFG = ?', idcfg,
						function(err,rows) {
							if (err)
								callback(err, -1);
							else if (rows != 0) {
								//CAMBIAR EL VALOR DE LAS IPS!!!!!
								for (var i=0;i<rows.length;i++) {
									for(var j=0;j<2;j++) {
										if (rows[i].ipb == config.general.cpus[j].ipb)
											config.general.cpus[j].ipb = generaIp4ImportJson(rows, config.general.cpus[j].ipb);
											estadoPasarela = 2; //2: Ip duplicada
									}
								}
							}
							
							// CREAR SELECT PARA OBTENER NOMBRE LA CONFIG A PARTIR DE idCfg
							//
							query = connection.query('SELECT name FROM cfg WHERE idCFG=?', idcfg, function (err, rows) {
								if (err == null) {
									config.idConf = rows[0].name;
									// CREAR SELECT PARA OBTENER NOMBRE DEL EMPLAZAMIENTO A PARTIR DE idSite
									//
									query = connection.query('SELECT name FROM emplazamiento WHERE idEMPLAZAMIENTO=?', idSite, function (err, rows) {
										if (err == null) {
											config.general.emplazamiento = rows[0].name;
											// Crear el servicio.
											//config.servicios.name=config.servicios.name + '_IMPORTED_SERVICE';
											myLibServices.postService(config.servicios, function (result) {
												config.servicios.idSERVICIOS = result.service.idSERVICIOS;
												// SI LA GATEWAY NO EXISTE EN LA CONFIGURACIÓN, SE INSERTA.
												myLibGateways.postGateway(config.idConf, false, true, config.general, config.servicios, function (result) {
													myLibGateways.assignGatewayToConfiguration({
														"CFG_idCFG": result.idCfg,
														"CGW_idCGW": result.data.idCGW,
														Activa: 1,
														Sincro: 2
													}, function (result) {
														callback(null, result.data.CGW_idCGW);
													});
												});
											});
										}
										else
											callback(err);
									});
								}
								else
									callback(err);
							});
						});
					});
				}],
				function(err, idCGW){
					if (err != null || idCGW == -1)
						f({error:err != null ? err : -1,slaves:null});

					var numSlave = 0;
					// INSERTAR CADA ESCLAVA RECIBIDA
					async.eachSeries(config.hardware.slv,
						function(s,callback){
							if (s.tp != -1){	// Configurada
								// Comprobar si la CGW <idCGW> tiene una esclava configurada en la posición <numSlave>
								var querySlave=connection.query('SELECT SLAVES_idSLAVES FROM hardware ' +
																	'WHERE CGW_idCGW=? AND rank=?', [idCGW,numSlave], function(err, rows, fields){
									logging.LoggingDate(querySlave.sql);

									s.rank = numSlave;

									if (err)	callback(err);
									else if (rows != null && rows.length > 0){
										var idSlave = rows[0].SLAVES_idSLAVES;

										//slaves[numSlave++]=idSlave;

										// Eliminar esta slave
										var updateSlave=connection.query('DELETE FROM slaves WHERE idSLAVES=?', idSlave, function(err, result){
											logging.LoggingDate(updateSlave.sql);
											if (err) return callback(err);

											//callback();	
										});
									}

									// Insertar la esclava con los nuevos datos recibidos
									var slave={};

									slave.name = config.general.name + "_" + s.rank;
									slave.tp = s.tp;

									// Eliminar una posible slave con este nombre
									//var queryDelSlave=connection.query('DELETE FROM slaves WHERE name=?',slave.name,function(err,result){
										//logging.LoggingDate(queryDelSlave.sql);
										var queryInsertSlaves=connection.query('INSERT INTO slaves SET ?', slave, function(err, result){
											logging.LoggingDate(queryInsertSlaves.sql);
											if (err) callback(err);
											else{
												var hw={};
												hw.CGW_idCGW = idCGW;
												hw.SLAVES_idSLAVES= result.insertId;
												hw.rank = s.rank;

												slaves[numSlave++]=result.insertId;
								
												// INSERTAR EL REGISTRO HARDWARE ASOCIADO A LA ESCLAVA Y A LA PASARELA
												var queryInsertHw=connection.query('INSERT INTO hardware SET ?', hw, function(err,result){
													logging.LoggingDate(queryInsertHw.sql);
													if (err) return callback(err);

													callback();	
												});
											}
										});
									//})
								});
							}
							else{
								slaves[numSlave]=-1;

								// Slave no configurada
								myLibHardware.RemoveHardwareFromGateway({CGW_idCGW:rows[0].idCGW,SLAVES_idSLAVES:null,rank:numSlave},function(result){
									numSlave++;
									callback();
								});
							}
						},
						function(err){
							connection.end();

							f({error:err,slaves:slaves});
						}
					);	// End async.each
				}
			);
		}
	});
};

function generaIp4ImportJson(ipList, originalIp) {
	var newIp='';
	var k=1;
	var incIpDigit=0;
	var newIp = originalIp.split(".");
	var noNewIpFound=false;
	do {
		if (parseInt(newIp[3]) < 255) {
			incIpDigit = parseInt(newIp[3]) + k;
			newIp = newIp[0] + '.' + newIp[1] + '.' + newIp[2] + '.' + incIpDigit.toString();
		}
		
		for(var i=0; i<ipList.length;i++) {
			if(newIp == ipList[i]) {
				noNewIpFound = false;
				break;
			}
			else
				noNewIpFound = true;
		}
	} while(!noNewIpFound)
	
	return newIp;
}
