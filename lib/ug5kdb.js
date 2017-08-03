var mySql = require('mySql');
var gcfg = require('../configUlises.json');
var logging = require('./loggingDate.js');
var log = true;		// TODO. Ponerlo en Configuracion... 

if (!global.QueryCount) global.QueryCount = 0;

function Query(query, param1, cbRes, nolog) {
	var QueryCount = (++global.QueryCount);
	var connection = mySql.createConnection({
		  host     : gcfg.Ulises.dbhost,
		  user     : gcfg.Ulises.dbuser,
		  password : gcfg.Ulises.dbpassword,
		  database : gcfg.Ulises.dbdatabase,
		  multipleStatements: true 
		});

	logging.LoggingDateCond(log, BuildStrQuery(QueryCount, query, param1));
	connection.connect(function(mysqlerr){
		if (mysqlerr){
			logging.LoggingDateCond(log, BuildStrResult(mysqlerr));
			cbRes(mysqlerr);
		}
		else {
			connection.query(query, param1, function(mysqlerr, rows, fields) {				
				connection.end();
				logging.LoggingDateCond(log && !nolog, BuildStrResult(QueryCount, mysqlerr, rows));				
				logging.LoggingDateCond(log &&  nolog, BuildStrResultCount(QueryCount, mysqlerr, rows));				
				cbRes(mysqlerr, rows, fields)
			});
		}
	});
}

function QueryWithPromise(query, param1, nolog) {
	return new Promise(function(resolve, rejects){
		Query(query, param1, function(err, rows, fields){
			if (err) {
				resolve({error: err});
			}
			else {
				resolve({error: null, data: rows});
			}		  
		}, nolog);
	});
}

async function QuerySync(query, param1, nolog) {
	var res = await QueryWithPromise(query, param1, nolog);
	return res;
}

//
async function QueryMultiInsertSync(query, par){
	var qrys = await QueryWithPromise(query, null, false);
	/* if (Array.isArray(qrys.data)) {
		var ret = [];
		qrys.data.forEach(function(item,index){
			ret.push(item.insertId);
		});
		return ret;	
	}*/
	return qrys;
}

//
function BuildStrQuery(QueryCount, query, param) {
	var res = "[UG5KDBV2] Query(" + QueryCount.toString() + "): ";
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

function BuildStrResult(QueryCount, err, result) {
	var res = "[UG5KDBV2] RES(" + QueryCount.toString() + "): ";
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

function BuildStrResultCount(QueryCount, err, result) {
	var res = "[UG5KDBV2] RES(" + QueryCount.toString() + "): ";
	if (err) {
		res += ("ERROR: " + err);
	}
	else {
		if (Array.isArray(result)) {
			res += (result.length.toString() + " Registros Leidos");
		}
	}
	return res;	
}

/**/
exports.Query = Query;
exports.QueryWithPromise = QueryWithPromise;
exports.QuerySync = QuerySync;
exports.QueryMultiInsertSync = QueryMultiInsertSync;

