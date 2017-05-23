var langs = ['en', 'es'];
var langCode = '';
var langJS = null;


var translate = function (jsdata)
{	
	$("[tkey]").each (function (index)
	{
		var strTr = jsdata [$(this).attr ('tkey')];
	    $(this).html (strTr);
	});
}

var translateWord = function (key,translate){
	var strTr = '';
	var lang = navigator.languages[0].substr (0, 2);
	if (langs.indexOf(lang)>=0){
		$.getJSON('lang/'+lang+'.json', function(result){
		    translate(result[key]);
		});
	}
}

var translateForm = function (){
	//langCode = navigator.language.substr (0, 2);
	langCode = navigator.languages[0].substr (0, 2);

	if (langs.indexOf(langCode)>=0)
		$.getJSON('lang/'+langCode+'.json', translate);
	else
		$.getJSON('lang/en.json', translate);
}
