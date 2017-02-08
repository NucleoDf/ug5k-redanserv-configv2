/** */
var ug5kApp = angular.module('Ug5kweb', ['ngRoute', 'ui.bootstrap', 'smart-table', 'pascalprecht.translate']);

/** */
ug5kApp.config(function ($translateProvider) {
    // Our translations will go in here
    $translateProvider.useStaticFilesLoader({
        prefix: './languages/',
        suffix: '.json'
    });
    var userLang = navigator.languages[0];

    if (userLang.indexOf("en") == 0)
        $translateProvider.use('en_US');
    else if (userLang.indexOf("fr") == 0)
        $translateProvider.use('fr_FR');
    else
        $translateProvider.use('es_ES');
});

/** */
ug5kApp.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;
            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);

/** */
 ug5kApp.directive('bsPopover', function () {
     return function (scope, element, attrs) {
         element.popover({ placement: 'top', html: 'true' });
     };
 });

/** Variables Globales */
var pollingTime = 5000;
var maxPreconf = 8;
var InciPoll = 10;
var profiles_multiples = true;

/** Perfiles */
var PCFG_PROFILE  = 0x1000;
var ADMIN_PROFILE = 0x0040;
var ING_PROFILE   = 0x0020;
var GEST_PROFILE  = 0x0010;
var ALM1_PROFILE  = 0x0008;
var ALM2_PROFILE  = 0x0004;
var CRTL_PROFILE  = 0x0002;
var VIS_PROFILE   = 0x0001;
var PUERTA_ATRAS = (PCFG_PROFILE | ADMIN_PROFILE | CRTL_PROFILE | VIS_PROFILE); // 0x1043;

/** */
var carga_upload_config = false;
var carga_upload_config_timer = 0;              // Temporizador Aleatorio en Segundos...
var carga_upload_config_timer_max = 60;         // M�ximo del Temporizador.
var carga_upload_config_timer_min = 20;         // Minimo del Temporizador.

var Simulate = false;
var Desarrollando = false;
var session_supervision = true;

/** */
var sesion_sup = 10;

/** */
var rest_url_logout = '/logout';
var rest_url_tses = '/tses';
var rest_url_config = '/config';
var rest_url_upconfig = '/uploadcfg';
var rest_url_preconfig = '/preconf';
var rest_url_impexp = '/impexp';
var rest_url_mnt_std = '/mant/std';
var rest_url_mnt_reset = '/mant/reset';
var rest_url_mnt_bite = "/mant/bite";
var rest_url_mnt_versiones = '/mant/lver';
var rest_url_mnt_version = '/mant/ver';
var rest_url_mnt_filelogs = '/mant/logs';
var rest_url_dev_hist = '/dev/hist';
var routeForUnauthorizedAccess = '/noaut';
var routeForLogin = '/login.html';

/** */
var jamp_no_sip = 1;
/** */
var max_id_length = 32;

/** Validadores. */
var regx_ipval = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
var regx_trpval = /^[1-2]+,(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/[0-9]{2,5}$/;
var regx_atsrango = /^[0-9]{6}-[0-9]{6}$/;
var regx_atsnumber = /^[0-9]{6}$/;
var regx_urlval = /^(http(?:s)?\:\/\/[a-zA-Z0-9]+(?:(?:\.|\-)[a-zA-Z0-9]+)+(?:\:\d+)?(?:\/[\w\-]+)*(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$/;
var regx_ipportval = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_urival = /^sip:([^:]+)@(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_urival_nosip = /^([^:]+)@(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_fid = /^(1|2|3)[0-9]{2}\.[0-9]{2}(0|5)$/;
var regx_urirtspval = /^rtsp:(.+)@(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_idval = /^[a-zA-Z0-9\-_\.]{1,32}$/;
