// logger.js
angular
	.module('Ug5kweb')
	.factory('logger', logger);

function logger() {
	var retorno = 
	{
		error: function (msg) {
			console.log('Error: ', msg);
		},
		info: function (msg) {
			console.log('Info: ', msg);
		}
	};
	return retorno;
}