var express = require('express');
var logging = require('../../lib/loggingDate.js');

var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });

var myLibServices = require('../../lib/services.js');

router.route('/')	// The root path is relative the path where it's mounted in app.js (app.use('/', services);)
	.get(function(req, res) {
  		logging.LoggingDate("GET services");
  		
  		myLibServices.getAllServices(function(services){
  			res.json(services);	
  		});
	});

router.route('/:service/gateways')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibServices.getGatewaysOfService(req.params.service,function(data){
			res.json(data);
		});
	});

router.route('/:service')
	.get(function(req, res) {
  		logging.LoggingDate("GET services/:service");
		var service = req.params.service;
		myLibServices.getService(service,function(data){
			res.json({general: null,
					 servicios: data.services});
		});
	})
	.post(function(req,res){
		logging.LoggingDate("POST services/:service");
		var service = req.body;
		myLibServices.postService(service,function(data){
			res.json(data);
		});
	})
    .copy(function(req, res){
		var targetService = req.body;
		logging.LoggingDate("COPY services/" + targetService.name);
    	myLibServices.postService(targetService,function(data){
    	 	res.status(201).json(data);
    	});
    })
    .delete(function(req,res){
    	var serviceId=req.params.service;
    	logging.LoggingDate("DELETE services/" + serviceId);
    	myLibServices.deleteService(serviceId,function(data){
    		res.json(data);
    	});
    });

module.exports = router;
