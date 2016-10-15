/** */
var ADMIN_PROFILE = 64;
var ING_PROFILE = 32;
var GEST_PROFILE = 16;
var ALM1_PROFILE = 8;
var ALM2_PROFILE = 4;
var CRTL_PROFILE = 2;
var VIS_PROFILE = 1;
/** */

var trpval = /^[1-2]+,(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/[0-9]{2,5}$/;

/** */
function ndfEnable(selector, enable)
{
	var nodeList = document.querySelectorAll(selector);
	for (var i = 0, length = nodeList.length; i < length; i++) 
	{
		nodeList[i].disabled = enable;
	}
}

/** */
function ndfLogout() {
	$.ajax({
		type : 'POST',
		url : '/logout',
		timeout : 200,
		success : function () {
			document.cookie = "ssid=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
			window.location.href = "/login.html";
		},
		error : function (jqXHR, exception) {
			ndfAjaxError(jqXHR, exception);
		}
	});
}
/** */
function ndfGetCookie(cname) {
    match = document.cookie.match(new RegExp(cname + '=([^;]+)'));
    if (match) return match[1];
}

/** */
function ndfUsuario() {
    console.log('document.cookie: ' + document.cookie);
    document.getElementById('_usuario').innerHTML = 'Usuario: ' + ndfGetCookie("ssid").split('|')[0];
}

/** */
function ndfProfile() {
	var profile =  parseInt(ndfGetCookie("ssid").split('|')[1]);
	return profile;
}

/** */
function ndf_change_inner(elementos, name){
	for (index = 0; index < elementos.length; ++index) {
		elementos[index].innerHTML=name;
	}
}

/** */
function ndf_show(elementos, modo){
	for (index = 0; index < elementos.length; ++index) {
		elementos[index].style.visibility=modo;
	}
}

/** */
function ValidateTrapDest(destino) {
	return trpval.test(destino);
}

/** */
function AccesoFuncion(profile) {
	var current = ndfProfile();
	if (current < profile)
		return false;
	return true;
}
/** */

function ndfAjaxError(jqXHR, exception) {
	if (jqXHR.status === 0) {
		alert('Not connect.\n Verify Network.');
	} else if (jqXHR.status == 404) {
		alert('Requested page not found. [404]');
	} else if (jqXHR.status == 500) {
		alert('Internal Server Error [500].');
	} else if (exception === 'parsererror') {
		alert('Requested JSON parse failed.');
	} else if (exception === 'timeout') {
		alert('Time out error.');
	} else if (exception === 'abort') {
		alert('Ajax request aborted.');
	} else {
		alert('Uncaught Error.\n' + jqXHR.responseText);
	}
}
function GetHora()
{
    function ponerCero(digito)
    {
        if ((digito >= 0) && (digito <= 9))
        {
            digito = '0' + digito;
        }
        return digito;
    }
    var hora = new Date();
    var hh = hora.getHours().toString();
    var mt = hora.getMinutes().toString();
    var ss = hora.getSeconds().toString();
    var solohora = ponerCero(hh) + ':' + ponerCero(mt) + ':' + ponerCero(ss);
    return solohora;
}

function ndrelojSystem()
{
    var solohora = setInterval(function () { document.getElementById("_hsolohora").innerHTML = GetHora(); }, 1000);
}
