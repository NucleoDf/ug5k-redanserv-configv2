/** */
var Uv5kinbx = angular.module('Uv5kinbx', ['ngRoute', 'ui.bootstrap']);

Uv5kinbx.directive('fileModel', ['$parse', function ($parse) {
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

// 
// We already have a limitTo filter built-in to angular,
// let's make a startFrom filter
Uv5kinbx.filter('startFrom', function () {
    return function (input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});


/** Variables Globales */
var Simulate = true;
var pollingTime = 3000;
var maxPreconf = 8;

/** Rutas de Aplicacion */
var routeDefault = "/";
var routeConfig = "/config";
var routeRadio = "/radio";

/** Peticiones REST */
var rest_url_std = "/std";
var rest_url_preconf = "/preconf";
var rest_url_local_config = "/lconfig";
var rest_url_radio_sessions = "/rdsessions";
var rest_url_radio_gestormn = "/gestormn";
var rest_url_radio_gestormn_habilita = "/gestormn/enable";
var rest_url_radio_gestormn_asigna = "/gestormn/assign";

/** */
var roles = {
	ADMIN_PROFILE: 64,
	ING_PROFILE: 32,
	GEST_POFILE: 16,
	CRTL_PROFILE: 8,
	ALM1_PROFILE: 4,
	ALM2_PROLIFLE: 2,
	VIS_PROFILE: 1
};
/** */
var routeForUnauthorizedAccess = '/noaut';

/** Validadores. */
var regx_ipval = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
var regx_trpval = /^[1-2]+,(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/[0-9]{2,5}$/;
var regx_atsrango = /^[0-9]{6}-[0-9]{6}$/;
var regx_atsnumber = /^[0-9]{6}$/;
var regx_urlval = /^(http(?:s)?\:\/\/[a-zA-Z0-9]+(?:(?:\.|\-)[a-zA-Z0-9]+)+(?:\:\d+)?(?:\/[\w\-]+)*(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$/;
var regx_ipportval = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_urival = /^sip:(.+)@(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[\d]{1,5})?$/;
var regx_fid = /^(1|2|3)[0-9]{2}\.[0-9]{2}(0|5)$/;
var regx_fid_vhf = /^(1)(1|2|3)([0-9]{1})\.([0-9]{1})(0|5)$/;   /** 118.00 137.00 */
var regx_fid_uhf = /^(2|3|4)([0-9]{2})\.([0-9]{1})(0|5)$/;      /** 225.00 400.00 */
