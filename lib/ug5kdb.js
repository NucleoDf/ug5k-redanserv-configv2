var mySql = require('mySql');
var gcfg = require('../configUlises.json');
var logging = require('./loggingDate.js');
var log = true;		// TODO. Ponerlo en Configuracion... 

exports.Query = function Query(query, param1, cbRes) {
	var connection = mySql.createConnection({
		  host     : gcfg.Ulises.dbhost,
		  user     : gcfg.Ulises.dbuser,
		  password : gcfg.Ulises.dbpassword,
		  database : gcfg.Ulises.dbdatabase 
		});

	logging.LoggingDateCond(log, BuildStrQuery(query, param1));
	connection.connect(function(mysqlerr){
		if (mysqlerr){
			logging.LoggingDateCond(log, BuildStrResult(mysqlerr));
			cbRes(mysqlerr);
		}
		else {
			connection.query(query, param1, function(mysqlerr, rows, fields) {				
				connection.end();
				logging.LoggingDateCond(log, BuildStrResult(mysqlerr, rows));				
				cbRes(mysqlerr, rows, fields)
			});
		}
	});
}
//
function BuildStrQuery(query, param) {
	var res = "[UG5KV2] Query: ";
	if (query) res += (query + " ");
	if (param) {
		res += "PAR: ";
		if (Array.isArray(param)) {
			param.forEach(function(item, index){
				res += (JSON.stringify(item) + ", ");
			});
		}
		else {
			res += (JSON.stringify(param) + ", ");
		}
	}
	res += "==>";
	return res;
}

function BuildStrResult(err, result) {
	var res = "[UG5KV2] RES: ";
	if (err) {
		res += ("ERROR: " + err);
	}
	else {
		if (!Array.isArray(result)) {
			res += JSON.stringify(result);
		}
		else {
			result.forEach(function(item, index){				
				res += (JSON.stringify(item) + '\r\n');
			});
		}
	}
	return res;
}

