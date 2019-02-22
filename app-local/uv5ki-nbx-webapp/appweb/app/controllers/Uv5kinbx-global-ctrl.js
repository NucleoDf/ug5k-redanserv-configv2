/** */
angular.module("Uv5kinbx")
.controller("uv5kiGlobalCtrl", function ($scope, $interval, $location) {
    /** Inicializacion */
    var ctrl = this;
    ctrl.pagina = 0;


    ctrl.user="agl1";
    ctrl.date = (new Date()).toLocaleDateString();
    ctrl.hora = (new Date()).toLocaleTimeString();
    $location.path("/");

    /** Funciones o servicios */


    /** Funcion Periodica del controlador */
	var timer = $interval(function() {
		ctrl.date=(new Date()).toLocaleDateString();
		ctrl.hora = (new Date()).toLocaleTimeString();
	}, 1000);

    /** Salida del Controlador. Borrado de Variables */
	$scope.$on("$destroy", function () {
	    $interval.cancel(timer);
	});
	
});


