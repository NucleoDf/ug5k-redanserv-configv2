var async=require('async');
var logging = require('./loggingDate.js');

/** AGL */
var gcfg = require('../configUlises.json');

/********************************/
/*	FUNCTION: getTablesBss 		*/
/*  PARAMS: req (IN),			*/
/*			res(OUT)			*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.getTablesBss = function getTablesBss(req, res){
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
		
			var consulta='SELECT idtabla_bss, nombre as name, descripcion as description, fecha_creacion as FechaCreacion,' +
				'valor0, valor1, valor2, valor3, valor4, valor5 FROM tablas_bss';

			var query = connection.query(consulta, function(err, rows) {
				logging.LoggingDate(query.sql);
				connection.end();	

			    if (err == null && rows != null && rows.length > 0){
		    		logging.LoggingDate(JSON.stringify(rows));
					res.json({error:null,tables: rows});
			    }
			    else if (err == null){
					res.json({error:null,tables: null});
			    }
			    else{
			    	logging.loggingError(err.code);
			    	res.json({error:err.message,tables: null});
			    }
			});
		}
	});
};

/********************************/
/*	FUNCTION: getTableBss 		*/
/*  PARAMS: idTable (IN),		*/
/*			res(OUT)			*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.getTableBss = function(idTable,f){
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
		
			var query = connection.query('SELECT idtabla_bss, nombre as name, descripcion as description, ' +
										'fecha_creacion as FechaCreacion,' +
										'valor0, valor1, valor2, valor3, valor4, valor5 FROM tablas_bss ' +
										'WHERE idtabla_bss=?',idTable,
				function(err, rows) {
				logging.LoggingDate(query.sql);
				connection.end();	

			    if (err == null && rows != null && rows.length > 0){
		    		logging.LoggingDate(JSON.stringify(rows));
		    		if (f != null)
						f({error:null,tables: rows});
			    }
			    else if (err == null){
					f({error:null,tables: null});
			    }
			    else{
			    	logging.loggingError(err.code);
			    	f({error:err,tables: null});
			    }
			});
		}
	});
};

/********************************/
/*	FUNCTION: postTableBss 		*/
/*  PARAMS: table (IN),			*/
/*			f(OUT)				*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.postTableBss = function(table,f){
	var mySql = require('mySql');
	var connection = mySql.createConnection({
	  host     : gcfg.Ulises.dbhost,
	  user     : gcfg.Ulises.dbuser,
	  password : gcfg.Ulises.dbpassword,
	  database : gcfg.Ulises.dbdatabase 
	});

	connection.connect(function(err) {
		if (err) {
			logging.LoggingDate("Error connention to 'U5K-G' database.");
		}
		else {
			logging.LoggingDate("Successful connection to 'U5K-G' database!");
			var query = connection.query('INSERT INTO tablas_bss (nombre, descripcion, valor0, valor1, ' +
				'valor2, valor3, valor4, valor5) VALUES (?,?,?,?,?,?,?,?)',[table.name,table.description,
				table.TableValues[0],table.TableValues[1],table.TableValues[2],table.TableValues[3],
				table.TableValues[4],table.TableValues[5]],
				function (err, result) {
					logging.LoggingDate(query.sql);
					connection.end();
					if (err)
						return f({error: err.message});
					else
						return f({data: 'OK'});
			});
		}
	});
};

/********************************/
/*	FUNCTION: postTableBss 		*/
/*  PARAMS: idTable (IN),		*/
/*			f(OUT)				*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.putTableBss = function(table,f){
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
		
			var tableValues = table.TableValues;
			
			var query = connection.query('UPDATE tablas_bss SET nombre=?, descripcion=?, valor0=?, valor1=?, ' +
				'valor2=?, valor3=?, valor4=?, valor5=? WHERE idtabla_bss=?',[table.name,table.description,
					table.TableValues[0],table.TableValues[1],table.TableValues[2],table.TableValues[3],
					table.TableValues[4],table.TableValues[5],table.idtabla_bss],
				function (err, result) {
				logging.LoggingDate(query.sql);
				connection.end();
				
				if (err)
					f({error:err.message,idTable: null});
			    
			    else{
			    	f({data:'OK',idTable: null});
			    }
			});
		}
	});
};

/********************************/
/*	FUNCTION: postTableBss 		*/
/*  PARAMS: idTable (IN),		*/
/*			f(OUT)				*/
/*  REV 1.0.2 VMG				*/
/********************************/
exports.deleteTableBss = function (idTable,f){
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
		
			var query = connection.query('SELECT rr.tabla_bss_id, rr.nombre '+
										'FROM recursos_radio rr '+
										'WHERE rr.tabla_bss_id=?',idTable, function(err, rows) {
				logging.LoggingDate(query.sql);

			    if (err == null && rows != null && rows.length > 0){
					connection.end();	
		    		logging.LoggingDate(JSON.stringify(rows));
					f({error:'CANT_DELETE',ResourceName:rows[0].nombre});
			    }
			    else if (err == null){
			    	query=connection.query('DELETE FROM tablas_bss WHERE idtabla_bss=?',idTable,function(err){
						connection.end();	
						f({error:err,tables: null});
			    	});
			    }
			    else{
					connection.end();	
			    	logging.loggingError(err.code);
			    	f({error:err,tables: null});
			    }
			});
		}
	});
};