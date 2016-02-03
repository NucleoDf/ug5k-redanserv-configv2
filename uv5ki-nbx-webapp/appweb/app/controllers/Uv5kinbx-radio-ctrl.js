angular.module("Uv5kinbx")
.controller("uv5kiRadioCtrl", function ($scope, $interval, $serv, $lserv) {
    /** Inicializacion */
    var ctrl = this;
    var session_stdcodes = { Desconectado: 0, Conectado: 1, Deshabilitado: 2 }
    var session_types = { RX: 0, TX: 1, RXTX: 2 };
    var equ_types = {Main: 0, Reserva: 1};

    ctrl.pagina = 0;
    ctrl.sessions = [];
    ctrl.gestormn = [];


    rdSessionsGet();
    rdGestormnGet();

    /** Servicios Pagina de Sesiones*/
    /** */
    ctrl.txtEstado = function (std) {
        return std == session_stdcodes.Desconectado ? "Desconectado" : 
            std == session_stdcodes.Conectado ? "Conectado" : "Estado Erroneo";
    }
    /** */
    ctrl.colorEstado = function (std) {
            return std == session_stdcodes.Desconectado ? "danger" :
                std == session_stdcodes.Conectado ? "Info" :
                std == session_stdcodes.Deshabilitado ? "warning" : "danger";
    }
    /** */
    ctrl.txtTipo = function(type) {
        return type == session_types.RX ? "Solo RX" :
            type == session_types.TX ? "Solo TX" :
            type == session_types.RXTX ? "TX y RX" : "Tipo Desconocido";
    }

    /** Servicios Pagina del Gestor */
    ctrl.txtTipoEquipo = function (type) {
        return type == equ_types.Main ? "MAIN" :
            type == equ_types.Reserva ? "RSVA" : "ERROR";
    }

    ctrl.txtHabilitar = function (equ) {
        return equ.std == 2 ? "Enable" : "Disable";
    }

    /** */
    ctrl.EnableDisable = function (item) {
    }

    /** Rutinas Generales */
    /** Datos desde el Servidor */
    function rdSessionsGet() {
        $serv.radio_sessions_get().then(function (response) {
            ctrl.sessions = response.data;
        }
    , function (response) {
        console.log(response);
    });
    }

    function rdGestormnGet() {
        $serv.radio_gestormn_get().then(function (response) {
            ctrl.gestormn = response.data;
        }
    , function (response) {
        console.log(response);
    });
    }

    /** Funcion Periodica del controlador */
    var timer = $interval(function () {
        if (ctrl.pagina == 0)
            rdSessionsGet();
        else {
            rdGestormnGet();
        }
    }, pollingTime);

    /** Salida del Controlador. Borrado de Variables */
    $scope.$on("$destroy", function () {
        $interval.cancel(timer);
    });

});
