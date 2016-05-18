angular.module("Uv5kinbx")
.controller("uv5kiRadioCtrl", function ($scope, $interval, $serv, $lserv) {
    /** Inicializacion */
    var ctrl = this;
    var session_stdcodes = { Desconectado: 0, Conectado: 1, Deshabilitado: 2 }
    var session_types = { RX: 0, TX: 1, RXTX: 2 };
    var equ_types = { Main: 0, Reserva: 1 };
    var led_std = { Off: 0, On1: 1, On2: 2 };

    var cp_ps = 3;              // Control Paginado. Tamaño de la Pagina.

    ctrl.pagina = 0;
    ctrl.leds = led_std.Off;
    ctrl.sessions = [];
    ctrl.scp_current = 0;               // Current Page en Sesiones.
    
    ctrl.scp_nop = function () {        // Número de Paginas en Sesiones.
        return Math.ceil(ctrl.sessions.length / cp_ps);
    }

    ctrl.gestormn = [];

    /** */
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
    /* */
    ctrl.txtHabilitar = function (equ) {
        return equ.std == 2 ? "Enable" : "Disable";
    }
    /** */    
    ctrl.led = function () {
        return ctrl.leds == led_std.Off ? "" : ctrl.leds == led_std.On1 ? "led-green" : ctrl.leds == led_std.On2 ? "led-yellow" : "led-red";
    }
    /** */
    ctrl.EnableDisable = function (item) {
        var bDisable = item.std == 2;
        var strQuestion = bDisable ? "¿Desea Habilitar el Equipo " : "¿Desea Deshabilitar el Equipo ";
        strQuestion = strQuestion + item.equ + "?";
        if (confirm(strQuestion) == true) {
            $serv.radio_gestormn_enable(item).then(function () {
                alert("Operacion Efectuada");
                rdGestormnGet();
            }, function (response) {
                console.log(response);
            });
        }
    }
    /** */
    ctrl.Asignar = function (item) {
        // TODO.
        var bDisable = item.std == 2;
        if (bDisable == true) {
            alert("El equipo esta deshabilitado. Habilitalo antes para poder asignarlo");
            return;
        }
        var asignado = item.frec != "---.--";
        if (asignado == true) {
            var strQuestion = "¿ Desea Desasignar el equipo " + item.equ + "?";
            if (confirm(strQuestion) == true) {
                var cmd = { equ: item.eq, cmd: 0, frec: "---.--" };
                $serv.radio_gestormn_asigna(cmd).then(function (response) {
                    alert("Operacion Efectuada");
                }, function (response) {
                    console.log(response);
                });
            }
        }
        else {
            var frec = prompt("Intruduzca la frecuencia");
            if (frec != null) {
                var modo_val = item.grp == 0 ? 3 : 4;       // Rango de VHF (4) o de UHF (3)
                if ($lserv.validate(modo_val, frec) == true) {
                    var strQuestion = "¿ Desea Desasignar el equipo " + item.equ + "a la frecuencia " + frec + "?";
                    if (confirm(strQuestion) == true) {
                        var cmd = { equ: item.equ, cmd: 1, frec: frec };
                        $serv.radio_gestormn_asigna(cmd).then(function (response) {
                            alert("Operacion Efectuada");
                        }, function (response) {
                            console.log(response);
                        });
                    }
                }
                else
                    alert("Error en formato de frecuencia introducida");
            }
        }
    }
    /** */
    ctrl.ResetServicio = function () {
        if (confirm("¿Desea reiniciar el servicio de gestión radio?") == true) {
            $serv.radio_gestormn_reset().then(function () {
                alert("Operacion Efectuada");
            }, function (response) {
                console.log(response);
            });
        }
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
    /** */
    function rdGestormnGet() {
        $serv.radio_gestormn_get().then(function (response) {
            ctrl.gestormn = response.data;
            ctrl.leds = ctrl.leds == led_std.On2 ? led_std.On1 : led_std.On2;
        }
    , function (response) {
        console.log(response);
        ctrl.leds = led_std.Off;
    });
    }
    /** Funcion Periodica del controlador */
    var timer = $interval(function () {
        //if (ctrl.pagina == 0)
        //    rdSessionsGet();
        //else {
        //    rdGestormnGet();
        //}
    }, pollingTime);

    /** Salida del Controlador. Borrado de Variables */
    $scope.$on("$destroy", function () {
        $interval.cancel(timer);
    });

});
