var express = require('express');
var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });

var myLibConfigurations = require('../../lib/configurations.js');
var myLibGateways = require('../../lib/gateways.js');
var myLibServicesGateways = require('../../lib/services.js');
var myLibHardwareGateways = require('../../lib/hardware.js');
var myLibUsuarios = require('../../lib/users.js');

var logging = require('../../lib/loggingDate.js');

// Nesting routers by attaching them as middleware:
var gatewaysRouter=express.Router({mergeParams:true});

function generatesRandomName(name)
{
	var myDate = new Date();
	var hashArray = ['A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
		'1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T',
		'U','V','W','X','Y','Z','0'];
	
	var monthNumber = myDate.getMonth()+1;
	var dayNumber = myDate.getDay()+1;
	var hourNumber = myDate.getHours()+1;
	var minNumber = myDate.getMinutes()+1;
	var secNumber = myDate.getSeconds()+1;
	
	return(name+'#'+hashArray[monthNumber]+hashArray[dayNumber]+hashArray[hourNumber]+
	hashArray[minNumber]+hashArray[secNumber]);
}

router.use('/:configuration/gateways',gatewaysRouter);

router.route('/')	// The root path is relative the path where it's mounted in app.js (app.use('/configurations',configurations'))
	.get(function(req, res) {
  		logging.LoggingDate("GET configurations");
  		myLibConfigurations.getConfigurations(req, res);
	});

router.route('/export/:gateway/:cfg')
	.put(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		// Obtener IPv
		//myLibGateways.getIpv(req.params.gateway,function(result){
			var ipv = req.body.ipGtw;
			var idCgw = req.params.gateway;
		//	if (ipv != -1 && ipv != -2 && ipv != null){
				// Datos de la configuracion activa
		//		myLibGateways.getTestConfig(ipv,function(data){
					// Usuarios
					myLibUsuarios.getUsers(req,res,idCgw, function(users){
						// General
						myLibGateways.getGateway(req,res,null,idCgw,function(gtw){
							// Servicios
							myLibServicesGateways.getServices(idCgw,null,function(servicios){
								// Hardware y recursos
								myLibHardwareGateways.getSlaves(ipv,idCgw,function(hardware){
									var cfg = 	{
												idConf: req.params.cfg,
												fechaHora: new Date(),
												users:users.users,
												general: gtw,
												servicios: servicios.services,
												hardware: hardware.hardware,
												recursos: hardware.resources
									};
									res.status(200).json(cfg);

									//myLibGateways.sinchroGateways(idCgw);
									logging.LoggingDate(JSON.stringify(cfg,null,'\t'));
									//res.json(cfg);
								});
							});
						});
					});
				//});
			//}
			//else
			//	res.status(200).json({});
		});
	//})


router.route('/active')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
  		myLibConfigurations.getActiveConfiguration(req, res, function(name){
  			res.json(name);
  		});
	});

router.route('/SP_cfg/:cfg')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
  		myLibConfigurations.SP_cfg(req.params.cfg, function(data){
  			res.json(data);
  		});
	});

router.route('/listOfGateways')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
  		myLibConfigurations.getListOfGateways(function(name){
  			res.json(name);
  		});
  	})
	.put(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var gtw = req.body;
  		myLibConfigurations.putListOfGateways(gtw, function(name){
  			res.json(name);
  		});
  	});

router.route('/:configuration')
	.post(function(req,res){
  		logging.LoggingDate("POST configurations/:configuration");
	  	var newConfiguration = req.body;
	  	myLibConfigurations.postConfiguration(req, res, newConfiguration,function(result){
	  		res.json(result);
	  	});
	})
	.get(function(req, res) {
  		logging.LoggingDate("GET configurations/:configuration");
		if (req.params.configuration != null)
			myLibConfigurations.getConfiguration(req,res,req.params.configuration);
	})
	.delete(function(req, res){
		var cfg = req.params.configuration;
		logging.LoggingDate("DELETE configuration/:configuration");
		myLibConfigurations.delConfiguration(req, res, cfg, function(result){
			res.json(result);
		});
	})
	.put(function(req, res){
		var cfg = req.body;
		var oldIdCfg = req.params.configuration;
		logging.LoggingDate("PUT configuration/:configuration");
		myLibConfigurations.putConfiguration(oldIdCfg, cfg, function(result){
			res.json(result);
		});
	});

router.route('/:configuration/copy')
	.post(function(req,res){
		logging.LoggingDate('Copying cfg ' + req.params.configuration + ' like ' + req.body.name);
		if (req.params.configuration != null && req.body.name != null){
			myLibConfigurations.copyConfiguration(req.params.configuration, req.body, function(result){
				res.json(result);
			});
		}
		});

router.route('/:configuration/activate/:listOfGateways')
	.get(function(req, res) {
  		logging.LoggingDate("GET configurations/:configuration/activate/:listOfGateways");
		if (req.params.configuration != null && req.params.listOfGateways.length > 0)
			myLibConfigurations.activateGateways(req.params.configuration,req.params.listOfGateways.split(','),function(result){
				res.json(result);
			});
		});

router.route('/:configuration/activate')
	.get(function(req, res) {
  		logging.LoggingDate("GET configurations/:configuration/activate");
		if (req.params.configuration != null)
			myLibConfigurations.activateConfiguration(req.params.configuration,function(result){
				res.json(result);
			});
		});

router.route('/:configuration/free')
	.get(function(req,res){
		myLibConfigurations.getFreeGateways(req.params.configuration, function(result){
				res.json(result);
			});
		});
/*
// Obtiene todas las pasarelas de cualquier emplazamiento
// que pertenezca a la configuración :configuration
router.route('/:configuration/site/gateways')
	.get(function(req,res){
		myLibConfigurations.getAllGateways(req.params.configuration, function(result){
				res.json(result);
			});
		});
*/
router.route('/:configuration/siteName/:siteName')
	.get(function(req,res){
		myLibConfigurations.getSiteName(req.params.configuration,req.params.siteName,function(result){
			res.json(result);
		});
	});

gatewaysRouter.route('/')	// The root path is relative the path where it's mounted in router.use('/:configuration/gateways',gatewaysRouter')
	.get(function (req, res) {
		logging.LoggingDate("GET configurations/:configuration/gateways");
		if (req.params.configuration != null)
			myLibGateways.getGateways(req,res,req.params.configuration);
    	});

gatewaysRouter.route('/:gateway')
    .get(function (req, res) {
		logging.LoggingDate("GET configurations/:configuration/gateways/:gateway");
		if (req.params.gateway != null)
            myLibGateways.getGateway(req,res,req.params.configuration, req.params.gateway, function(result){
            	res.json(result);
            });
    	})
    .delete(function(req, res){
    	logging.LoggingDate("DELETE configurations/:configuration/gateways/:gateway");
    	if (req.params.gateway != null){
    		myLibGateways.freeGatewayFromConfiguration({"CFG_idCFG" : req.params.configuration, "CGW_idCGW": req.params.gateway}, function(result){
    			res.json(result);
    		});
    	}
    	})
    .post(function(req, res){
    	logging.LoggingDate("POST configurations/:configuration/gateways/:gateway");
		if (req.params.gateway != null){
    		myLibGateways.assignGatewayToConfiguration({"CFG_idCFG" : req.params.configuration, "CGW_idCGW": req.params.gateway}, function(result){
    			res.json(result);
    		});
    	}   
    	});

// Proporciona la configuración completa de :gateway (general, servicios, hardware, recursos)
gatewaysRouter.route('/:gateway/all')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		// Obtener IPv
		myLibGateways.getIpv(req.params.gateway,function(result){
			var ipv = result.ipv;
			var idCgw = result.idCGW;
			if (ipv != -1 && ipv != -2 && ipv != null){
				// Datos de la configuracion activa
				myLibGateways.getTestConfig(ipv,function(data){
					// Usuarios
					myLibUsuarios.getUsers(req,res,idCgw, function(users){
						// General
						myLibGateways.getGateway(req,res,null,idCgw,function(gtw){
							// Servicios
							myLibServicesGateways.getServices(idCgw,null,function(servicios){
								// Hardware y recursos
								myLibHardwareGateways.getSlaves(ipv,idCgw,function(hardware){
									var cfg = 	{
												idConf: data.idConf,
												fechaHora: data.fechaHora,
												users:users.users,
												general: gtw,
												servicios: servicios.services,
												hardware: hardware.hardware,
												recursos: hardware.resources
									};
									res.status(200).json(cfg);

									myLibGateways.sinchroGateways(idCgw);
									//logging.LoggingDate(JSON.stringify(cfg,null,'\t'));
									//res.json(cfg);
								});
							});
						});
					});
				});
			}
			else
				res.status(200).json({});
		});
	})
	// Generado por la actualización desde la configuracion local de la gateway
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		logging.LoggingDate((JSON.stringify(req.body,null,'\t')),"LastConfig-" + req.params.gateway);
		var general = req.body.general;
		var servicios = req.body.servicios;
		var hardware = req.body.hardware;
		var recursos = req.body.recursos;

		// Solo se admiten configuraciones provenientes de una pasarela si !existe configuración activa 
		// (base de datos vacía, por ejemplo) o la pasarela pertenece a la configuración activa
		// 
		myLibConfigurations.getActiveConfiguration(req,res,function(result){
			if (result == null){	// No existe configuración activa
				if (req.body.general.emplazamiento==""){
					res.status(422).json({error:null, ipv: ipv});	//	emplazamiento vacio
					logging.loggingError('(422). Gateway ' + req.params.gateway + ' has no site.');
					return;
				}
				// Responder antes de que el cliente cierre la conexión por time-out
				res.status(200).json({idConf:'-2', fechaHora:''});

				//
				// Crear configuracion de la pasarela
				// 
				myLibConfigurations.postConfigurationFromGateway(req, res, general, servicios, hardware, function(result){
					if (result.error)	{
						logging.loggingError('Error adding gateway configuration from gateway ' + req.params.gateway);
					}
					else{
						myLibHardwareGateways.setResources(result.slaves,recursos,function(result){
							
							if (req.body.fechaHora != ''){
								var dia=(req.body.fechaHora).split("/")[0];
								var mes=(req.body.fechaHora).split("/")[1];
								var anio=(req.body.fechaHora).split("/")[2].split(" ")[0];
								var hora=(req.body.fechaHora).split("/")[2].split(" ")[1];
								var nuevaFecha=anio + '/'+ mes + '/' + dia + ' ' + hora;
								
								myLibGateways.setLastUpdateToGateway(req.body.idConf, nuevaFecha, req.params.gateway, function(result){
									if (result)	
										logging.LoggingSuccess('Gateway ' + req.params.gateway + ' updated.');
									else
										logging.loggingError('Configuration ' + req.body.idConf + ' is not in data base.');
								});
							}
							else
								logging.loggingError('fechaHora field empty.');
						});
					}
				});
			}
			else{
				myLibGateways.getIpv(req.params.gateway,function(result){
					
					var ipv = result.ipv;
					if (ipv != -1 && ipv != -2){
						myLibGateways.getTestConfig(ipv,function(data){
							if (data.idConf == '-1' || data.idConf == '-2'){	// La pasarela no pertenece a la configuración activa
								res.status(422).json({error:null, ipv: ipv});	//	Unprocessable Entity
								logging.loggingError('(422). Gateway ' + req.params.gateway + ' is not in active configuration.');
								return;
							}
							else{

								if (req.body.general.emplazamiento==""){
									res.status(422).json({error:null, ipv: ipv});	//	emplazamiento vacio
									logging.loggingError('(422). Gateway ' + req.params.gateway + ' has no site.');
									return;
								}

								res.status(200).json(data);

								//
								// Crear configuracion de la pasarela
								// 
								myLibConfigurations.postConfigurationFromGateway(req, res, general, servicios, hardware, function(result){
									if (result.error)	{
										logging.loggingError('Error adding gateway configuration from gateway ' + req.params.gateway);
									}
									else{
										myLibHardwareGateways.setResources(result.slaves,recursos,function(result){
											
											if (req.body.fechaHora != ''){
												var dia=(req.body.fechaHora).split("/")[0];
												var mes=(req.body.fechaHora).split("/")[1];
												var anio=(req.body.fechaHora).split("/")[2].split(" ")[0];
												var hora=(req.body.fechaHora).split("/")[2].split(" ")[1];
												var nuevaFecha=anio + '/'+ mes + '/' + dia + ' ' + hora;
												
												myLibGateways.setLastUpdateToGateway(req.body.idConf, nuevaFecha, req.params.gateway, function(result){
													if (result)	
														logging.LoggingSuccess('Gateway ' + req.params.gateway + ' updated.');
													else
														logging.loggingError('Configuration ' + req.body.idConf + ' is not in data base.');
												});
											}
											else
												logging.loggingError('fechaHora field empty.');
										});
									}
								});
							}
						});
					}
					else{
						//
						// Crear configuracion de la pasarela
						//
						var randName=generatesRandomName(req.body.general.name);
						if(req.body.general.emplazamiento=='') {
							var randEmp='EMP'+req.body.general.name;
							req.body.general.emplazamiento=randEmp;
						}
							
						req.body.general.name = randName;
						myLibConfigurations.postConfigurationFromGateway(req, res, general, servicios, hardware, function(result){
							if (result.error)	{
								logging.loggingError('Error adding gateway configuration from gateway ' + req.params.gateway);
							}
							else{
								myLibHardwareGateways.setResources(result.slaves,recursos,function(result){
									
									if (req.body.fechaHora != ''){
										var dia=(req.body.fechaHora).split("/")[0];
										var mes=(req.body.fechaHora).split("/")[1];
										var anio=(req.body.fechaHora).split("/")[2].split(" ")[0];
										var hora=(req.body.fechaHora).split("/")[2].split(" ")[1];
										var nuevaFecha=anio + '/'+ mes + '/' + dia + ' ' + hora;
										
										myLibGateways.setLastUpdateToGateway(req.body.idConf, nuevaFecha, req.params.gateway, function(result){
											if (result)
												logging.LoggingSuccess('Gateway ' + req.params.gateway + ' updated.');
											else
												logging.loggingError('Configuration ' + req.body.idConf + ' is not in data base.');
										});
									}
									else
										logging.loggingError('fechaHora field empty.');
								});
							}
						});
					}
				});
			}
		});
	});

gatewaysRouter.route('/:gateway/general')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibGateways.getGateway(req,res,null,req.params.gateway,function(gtw){
			res.json({general: gtw});
		});
	});

gatewaysRouter.route('/:gateway/servicios')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibServicesGateways.getServices(req.params.gateway,null,function(data){
			res.json({servicios: data.services});
		});
	});

gatewaysRouter.route('/:gateway/hardware')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibHardwareGateways.getSlaves(req.params.gateway,null,function(data){
			res.json({hardware: data.hardware});
		});
	});

gatewaysRouter.route('/:gateway/recursos')
	.get(function(req,res){
			res.redirect('/gateways/' + req.params.gateway + '/resources');
		//logging.LoggingDate('Not implemented yet.')
		//res.status(501).json('Not implemented yet.');
	});

module.exports = router;
