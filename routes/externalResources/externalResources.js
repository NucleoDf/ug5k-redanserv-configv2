/**
 * Created by vjmolina on 13/9/17.
 */
var express = require('express');
var logging = require('../../lib/loggingDate.js');

var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });
// app.use();        // to support URL-encoded bodies
var myLibExtResources = require('../../lib/externalResources.js');

router.route('/:extType')	// The root path is relative the path where it's mounted in app.js (app.use('/accessControl',controlAccess'))
	.get(function(req, res) {
		myLibExtResources.getExternalResources(req.params.extType, req, res);
	})
	.post(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibExtResources.postExternalResource(req.body,function(data){
			res.json(data);
		});
	})
	.put(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		//myLibTable.putTableBss(req.body,function(data){
		//	res.json(data);
		//});
	});

router.route('/getResource/:idExtResource')
	.get(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibExtResources.getExternalResource(req.params.idExtResource,function(data){
			res.json(data);
		});
	})
	.delete(function(req,res){
		logging.LoggingDate(req.method + ': ' + req.baseUrl + req.url);
		myLibExtResources.deleteExternalResource(req.params.idExtResource,function(data){
			res.json(data);
		});
	});

module.exports = router;