var async=require('async');
var logging = require('./loggingDate.js');

/** AGL */
var gcfg = require('../configUlises.json');
var ug5kdb = require('./ug5kdb.js');

/************************************/
/*	FUNCTION: getExternalResources 	*/
/*  PARAMS: req (IN),				*/
/*			res(OUT)				*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.getExternalResources = function getExternalResources(req, res){

	var query='SELECT idrecursos_externos, uri, tipo, alias ' +
				'FROM recursos_externos ' +
				'ORDER BY alias';
	ug5kdb.Query(query, null, function(err, rows){
		var resultado = {
			error: err ? err.message : null,
			lista_uris: err == null && rows != null && rows.length > 0 ? rows : null
		};
		res.json(resultado);
	});
};

/************************************/
/*	FUNCTION: getExternalResource 	*/
/*  PARAMS: idExtResource (IN),		*/
/*			f(OUT)					*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.getExternalResource = function(idExtResource,f){
	var query='SELECT idrecursos_externos, uri, tipo, alias ' +
		'FROM recursos_externos WHERE idrecursos_externos=?';
 	var param = idExtResource;
 	ug5kdb.Query(query, param, function(err, rows) {
 		var resultado = {
 			error: err ? err.message : null,
 			lista_uris: err == null && rows != null && rows.length > 0 ? rows : null
 		};
 	if (f) f(resultado);
 	});
 };

/************************************/
/*	FUNCTION: getExternalResource 	*/
/*  PARAMS: idExtResource (IN),		*/
/*			f(OUT)					*/
/*  REV 1.0.2 VMG					*/
/************************************/
exports.postExternalResource = function(extResource,f){
	var query = '';
	var param = [];
	if (extResource.id_recurso==-1){
		query = 'INSERT INTO recursos_externos (uri,tipo,alias) VALUES (?,?,?)';
		param = [extResource.uri,extResource.tipo,extResource.alias];
	}
	else {
		query = 'UPDATE recursos_externos SET uri=?,tipo=?,alias=? ' +
			'WHERE idrecursos_externos=?';
		param = [extResource.uri,extResource.tipo,
			extResource.alias,extResource.id_recurso];
	}
	ug5kdb.Query(query, param, function(err, rows) {
		var resultado = {
			error: err ? err.message : null,
			lista_uris: err == null && rows != null && rows.length > 0 ? rows : null
		};
		if (f) f(resultado);
	});
};

/****************************************/
/*	FUNCTION: deleteExternalResource	*/
/*  PARAMS: idExtResource (IN),			*/
/*			f(OUT)						*/
/*  REV 1.0.2 VMG						*/
/****************************************/
exports.deleteExternalResource = function (idExtResource,f){
	var query = 'DELETE FROM recursos_externos WHERE idrecursos_externos=?';
	var param = idExtResource;
	
	ug5kdb.Query(query, param, function(err, rows) {
		var resultado = {
			error: err ? err : (rows.affectedRows > 0) ? null : "CANT_DELETE",
			ResourceName: "Entrada de Recurso",
			tables:  null
		};
		if (f) f(resultado);
	});
};