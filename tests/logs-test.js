var logger = require('../lib/nu-log.js');

var obj = {name:'pp', valor: 23};
var arr = [{name:'pp', valor: 23},{apellido:'gggg', edad: 23},9,"texto"];
function test1(){
	logger.Error('Mensaje de Error', obj, arr);
	logger.Info('Mensaje de Informacion', obj, arr);
	logger.Trace('Mesnaje de Traza...', obj, arr);
}

test1();
