/**
 * Created by vjmolina on 2/3/17.
 */
var express = require('express');

var router = express.Router();

var bodyParser = require('body-parser');
var parseUrlEncoded = bodyParser.urlencoded({ extended: false });

var myLibVersion = require('../../lib/version.js');

router.route('/')	// The root path is relative the path where it's mounted in app.js (app.use('/accessControl',controlAccess'))
	.get(function(req, res) {
		//logging.LoggingDate("GET users.");
		myLibVersion.getVersion(req, res);
	});

module.exports = router;