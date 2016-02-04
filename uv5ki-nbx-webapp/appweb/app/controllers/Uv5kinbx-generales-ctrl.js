/** */
angular.module("Uv5kinbx")
.controller("uv5kiGeneralesCtrl", function ($scope, $interval, $serv) {
    /** Inicializacion */
    var ctrl = this;
    var stdcodes = { Error: 0, Esclavo: 1, Maestro: 2 }

    ctrl.pagina = 0;

    /** Estados.. */
    ctrl.std = {}
    load_std();

    /** Lista de Preconfiguraciones */
    ctrl.preconf = [];
    load_preconf();

    /** Servicios del Controlador */
    /** Servicios Pagina de Estado*/
    /** */
    ctrl.txtEstado = function (std) {
        return std == stdcodes.Error ? "Error" :
            std == stdcodes.Esclavo ? "Esclavo" :
            std == stdcodes.Maestro ? "Maestro" : "Estado Erroneo";
    }
    /** */
    ctrl.colorEstado = function (std) {
        return std == stdcodes.Error ? "danger" :
            std == stdcodes.Esclavo ? "info" :
            std == stdcodes.Maestro ? "success" : "danger";
    }

    /** Servicios Pagina de Preconfiguraciones*/
    /** */
    ctrl.eliminar_pre = function (pre) {
        var pregunta = "¿Quiere eliminar la Preconfiguracion " + pre.nombre + "?";
        if (confirm(pregunta)) {
            $("body").css("cursor", "progress");
            $serv.preconf_delete(pre.nombre)
            .then(
            function (response) {
                $("body").css("cursor", "default");
                load_preconf();
            }
            , function (response) {
                $("body").css("cursor", "default");
            });
        }
    }
    /** */
    ctrl.activar_pre = function (pre) {
        var pregunta = "¿Quiere activar la Preconfiguracion " + pre.nombre + "?";
        if (confirm(pregunta)) {
            $("body").css("cursor", "progress");
            $serv.preconf_activate(pre.fecha, pre.nombre)
            .then(
            function (response) {

                $("body").css("cursor", "default");
            }
            , function (response) {

                $("body").css("cursor", "default");
            });
        }
    }
    /** */
    ctrl.salvar_como = function () {

        if (ctrl.preconf.length >= maxPreconf) {
            alert("Se ha alcanzado el número máximo de preconfiguraciones (" + maxPreconf + ") que se pueden almacenar. Elimine alguna antes de generar una nueva.");
            return;
        }

        var name = prompt("Please enter a name", "");
        if (name == null)
            return;

        for (var i = 0; i < ctrl.preconf.length; i++) {
            if (name == ctrl.preconf[i].nombre) {
                alert("Ya existe una preconfiguración con el nombre: " + ctrl.preconf[i].nombre + ". Debe introducir un nombre no utilizado.");
                return;
            }
        }

        if (confirm("¿Quiere salvar la configuracion actual como " + name + " ?") == false)
            return;

        $serv.preconf_saveas("", name).then(
            function (response) {
                alert("Preconfiguración "  + name + " guardada correctamente.");
                load_preconf();
            }
            , function (response) {
                console.log(response);
            });

    }

    /** */
    function load_std() {
        /* Obtener el estado del servidor... */
        $serv.stdgen_get().then(function (response) {
            ctrl.std = response.data;
        }
        , function (response) {
            console.log(response);
        });
    }

    /** */
    function load_preconf() {
        /* Obtener el estado del servidor... */
        $serv.preconf_list().then(function (response) {
            ctrl.preconf = response.data;
            console.log(ctrl.preconf);
        }
        , function (response) {
            console.log(response);
        });
    }

    /** Funcion Periodica del controlador */
    var timer = $interval(function () {
        
        load_std();

    }, pollingTime);

    /** Salida del Controlador. Borrado de Variables */
    $scope.$on("$destroy", function () {
        $interval.cancel(timer);
    });

});


