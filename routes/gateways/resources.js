var express = require('express');
var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });

var myLibResources = require('../../lib/resources.js');

var gatewaysRouter = express.Router({mergeParams: true});

gatewaysRouter.route('/')
    .get(function (req, res) {
    	myLibResources.GetResources(req, res);
  		// res.status(200)
    //         .send('list overall resources from gateway: ' + req.params.gatewayId);
    });

gatewaysRouter.route('/:resourceId')
	.get(function(req,res){
		myLibResources.GetResource(req,res);
	});

module.exports = gatewaysRouter;