var express = require('express');
var router = express.Router();
var config = require('../configUlises.json');
var myLibAuth = require('../lib/authentication.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index',{
  	LoginTimeout: config.Ulises.LoginTimeOut,
  	Region: config.Ulises.Region,
  	BackupServiceDomain: config.Ulises.BackupServiceDomain,
	Version: config.Ulises.Version});

 });

router.get('/ajax', function(req, res) {
	myLibAuth.setAuthentication(req, res);
});

module.exports = router;
