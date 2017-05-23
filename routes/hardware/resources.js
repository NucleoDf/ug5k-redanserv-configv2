var express = require('express');
var logging = require('../../lib/loggingDate.js');

var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });

var myLibResources = require('../../lib/resources.js');

router.route('/')	// The root path is relative the path where it's mounted in app.js (app.use('/resources', resources);)
	.get(function(req, res) {
  		logging.LoggingDate("GET resources");
  		myLibResources.getResources(function(rsc){
	  		res.json(rsc);
  		});
	});

router.route('/free')
	.get(function(req, res) {
  		logging.LoggingDate("GET resources/free");
  		myLibResources.getFreeResources(function(rsc){
	  		res.json(rsc);
  		});
	});

router.route('/lists')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibResources.getUriList(function(data){
			res.json(data);
		});
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var uri = req.body;
		myLibResources.postUriList(uri,function(data){
			res.json(data);
		});
	})
	.delete(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var uri = req.body;
		myLibResources.deleteUriList(uri,function(data){
			res.json(data);
		});
	});

router.route('/remote/:cfg/:site/:gtw')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibResources.getRemoteRadioResources(req.params.cfg,req.params.site,req.params.gtw,function(data){
			res.json(data);
		});
	});

router.route('/tel/:cfg/:site/:gtw')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibResources.getTelephonicResources(req.params.cfg,req.params.site,req.params.gtw,function(data){
			res.json(data);
		});
	});

router.route('/assignedlists/:resource/:tipolista')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var resource = req.params.resource;
		var tipolista = req.params.tipolista;
		myLibResources.getAssignedUriList(resource,tipolista,function(data){
			res.json(data);
		});
	});

router.route('/:resource')
	.get(function(req, res) {
  		logging.LoggingDate("GET resources/:resource");
		var resource = req.params.resource;
		myLibResources.getResource(resource,function(rsc){
			res.json(rsc);
		});
	})
	.delete(function(req, res){
		var resource = req.params.resource;
		logging.LoggingDate("DELETE resources/:idPos");
		myLibResources.delResource(resource,function(rsc){
			res.json(rsc);
		});
	})
	.post(function(req,res){
		var resource=req.body;
		logging.LoggingDate("POST resources/:resource");
		myLibResources.postResource(resource,function(rsc){
			res.json(rsc);
		});
	})
	.put(function(req, res){
		var resource = req.body;
		logging.LoggingDate("PUT resources/:resource");
		myLibResources.putResource(resource, function(rsc){
			res.status(201).json(rsc);
		});
	});

router.route('/:resource/radioParameters')
	.get(function(req, res) {
  		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var resource = req.params.resource;
		myLibResources.getRadioParameters(resource,function(param){
			res.json(param);
		});
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var resource = req.params.resource;
		var params = req.body;
		myLibResources.postRadioParameters(resource,params,function(param){
			res.json(param);
		});
	});

router.route('/:resource/phoneParameters')
	.get(function(req, res) {
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var resource = req.params.resource;
		 myLibResources.getTelephoneParameters(resource,function(rsc){
		 	res.json(rsc);
		});
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var resource = req.params.resource;
		var params = req.body;
		myLibResources.postTelephoneParameters(resource,params,function(param){
			res.json(param);
		});
	});

router.route('/:resource/phoneParameters/range')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		myLibResources.getRangeAts(rsc,function(ranks){
			res.json(ranks);
		});
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		var range = req.body;
		myLibResources.postRangeAts(rsc,range,function(data){
			res.json(data);
		});
	})
	.put(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var range = req.body;
		myLibResources.putRangeAts(range,function(data){
			res.json(data);
		});
	});

router.route('/:resource/phoneParameters/range/:range')
	.delete(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var range = req.params.range;
		myLibResources.deleteRangeAts(range,function(data){
			res.json(data);
		});
	});

router.route('/:resource/lists')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		myLibResources.getListsFromResource(rsc,function(data){
			res.json(data);
		});
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		var uri = req.body;
		myLibResources.postUriToResource(rsc,uri,function(data){
			res.json(data);
		});
	})
	.delete(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		var uri = req.body;
		myLibResources.deleteUriToResource(rsc,uri,function(data){
			res.json(data);
		});
	});

router.route('/:resource/uris/:uri')
	.delete(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		var rsc = req.params.resource;
		var uri = req.params.uri;
		myLibResources.deleteResourceUri(rsc,uri,function(data){
			res.json(data);
		});
	});

router.route('/:resource/uris')
	.get(function(req, res) {
	  	logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibResources.getResourceUris(req.params.resource, function(data){
			res.json(data);
		});
	})
	.post(function(req, res) {
	  	logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
	  	var uri=req.body;
		myLibResources.postResourceUris(uri, function(data){
			res.json(data);
		});
	})
	.put(function(req, res) {
	  	logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
	  	var uri=req.body;
		myLibResources.putResourceUris(uri, function(data){
			res.json(data);
		});
	});

module.exports = router;