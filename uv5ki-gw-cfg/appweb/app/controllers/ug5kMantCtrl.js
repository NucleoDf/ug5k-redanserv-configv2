/** */
angular
	.module('Ug5kweb')
	.controller('ug5kMantCtrl', ug5kMantCtrl);

ug5kMantCtrl.$inject = ['$scope', '$q', '$interval', 'transerv', 'dataservice', 'authservice', 'MantService', 'CfgService'/*, 'ngDialog'*/];

function ug5kMantCtrl($scope, $q, $interval, transerv, dataservice, authservice, MantService, CfgService/*, ngDialog*/) {
    var vm = this;
    var simul = true;

    CfgService.opcion(6);

    /** Pagina */
    vm.pagina = 0;	

    /** */
    vm.mostrar_boton = function (boton) {
        switch (boton) {
            case 0:     // LOGS
                return authservice.ProfilePermission(true, [ADMIN_PROFILE]);
            case 1:     // BITE
            case 2:     // RESET
                return authservice.ProfilePermission(true, [ADMIN_PROFILE, CRTL_PROFILE]);
        }
        return false;
    }

    /** */
	vm.set_pagina = function (ind) {
	    vm.pagina = ind;
	}

    /** Pagina de Estado */
	vm.std = {};
	vm.service = MantService;

    /** */
	vm.BtnText = function (ver) {
	    return ver.std == 'Actual' ? /*'Nueva'*/transerv.translate('MCTRL_MSG_00') : /*'Anterior'*/transerv.translate('MCTRL_MSG_01');
	}

    /** */
	vm.show_cpu1 = function () {
	    return CfgService.dualidad();
	}

    /** Pagina de Control */
    /** */
	vm.reset = function () {
	    if (Confirma(/*"¿Desea Reinicializar la Unidad?"*/transerv.translate('MCTRL_MSG_02')) == false) return;

	    $("body").css("cursor", "progress");
	    dataservice.mnt_reset().then(
            function (respuesta) {
                $("body").css("cursor", "default");
                console.log("POST: ", respuesta);
            },
            function (error) {
                $("body").css("cursor", "default");
                alert("POST-ERROR: ", error);
        } );
	}

    /** */
	vm.bite = function () {
	    console.log("BITE!!!");
	    if (Confirma(/*"¿Desea que la Unidad ejecute el procedimiento BITE?"*/transerv.translate('MCTRL_MSG_03')) == false) return;
	    $("body").css("cursor", "progress");
	    dataservice.mnt_bite().then(
            function (respuesta) {
                console.log("GET: ", respuesta);
                $("body").css("cursor", "default");
                $scope.gRes = respuesta.data;
                $("#hBite").modal("show");
            },
            function (error) {
                alert("POST-ERROR: ", error);
            });
	}

    /** Para las versiones sofware */
	vm.verbose = {};
	vm.versiones = [];
	vm.idsoftware = "UG5K-REDAN";
	vm.myFile = "";

    /** */
	function vgetVerbose() {
	    dataservice.mnt_get_version().then(function (response) {
	        console.log("Verbose: ", response.data);
	        vm.verbose = response.data;
	    });
	}

    /** Para carga de Software */
    /** */
	function vgetVersiones() {
	    dataservice.mnt_get_versiones().then(function (response) {
	        console.log("Versiones: ", response.data);
	        vm.versiones = response.data;
	    });
	}

    /** */
	vm.software_load = function () {

	    //vm.diag = ngDialog.open({
	    //    template: './app/templates/ug5kweb-swload-templ.html',
	    //    className: 'ngdialog-theme-nucleo',
	    //    controller: ['$scope', 'dataservice', function ($scope, dataservice) {
	    //        // controller logic
	    //        $scope.idsoftware = "UG5K-REDAN";
	    //        $scope.version = vm.verbose.version;
	    //        //$scope.myFile = "";
	    //        $scope.software_load_send = function () {
	    //            if ($scope.myFile == undefined)
	    //                alert(/*"Debe Seleccionar un fichero!!!"*/transerv.translate('MCTRL_MSG_04'));
	    //            else {
	    //                var file = $scope.myFile;
	    //                console.log('file is ' + JSON.stringify(file));
	    //                var uploadUrl = "/sw_upload";
	    //                dataservice.send_file(uploadUrl, file, $scope.idsoftware, $scope.version).then(
        //                    function () {
        //                        console.log("Fichero Enviado..");
        //                        if (Confirma(/*"Fichero Enviado. ¿Activar la Version?.\nEl sistema se Reiniciara..."*/transerv.translate('MCTRL_MSG_05'))) {
        //                            dataservice.post('/mant/swactiva/1').then(
        //                                function (respuesta) {
        //                                    console.log("Version Software Activada");
        //                                    alert(/*"Version Software Activada"*/transerv.translate('MCTRL_MSG_06'));
        //                                    vgetVersiones();
        //                                    vgetVerbose();
        //                                },
        //                                function (error) {
        //                                    alert(/*"Error en Activacion software: "*/transerv.translate('MCTRL_MSG_07'), +error.data);
        //                                    vgetVersiones();
        //                                    vgetVerbose();
        //                                });
        //                        }
        //                        else {
        //                            dataservice.post('/mant/swactiva/0').then(
        //                                function (respuesta) {
        //                                    console.log("Cancelada Activacion de Version Software");
        //                                    alert(/*"Cancelada Activacion de Version Software"*/transerv.translate('MCTRL_MSG_08'));
        //                                    vgetVersiones();
        //                                    vgetVerbose();
        //                                },
        //                                function (error) {
        //                                    alert(/*"Error en Activacion software: "*/transerv.translate('MCTRL_MSG_09'), +error.data);
        //                                    vgetVersiones();
        //                                    vgetVerbose();
        //                                });
        //                        }

	    //                        //vgetVersiones();
	    //                        //vgetVerbose();
	    //                        ngDialog.close(vm.diag);
        //                    },
        //                    function (reason) {
        //                        alert(/*"Error al enviar el fichero: "*/transerv.translate('MCTRL_MSG_10') + reason.data);
        //                        ngDialog.close(vm.diag);
        //                    }
        //                    );
	    //            }
	    //        }
	    //    }]
	    //});
	}

    /** */
	vm.software_restore = function () {
	    //if (Confirma(/*"¿Desea Restaurar el Software a la version anterior?.\nEl sistema se Reiniciara..."*/transerv.translate('MCTRL_MSG_11'))) {
	    //    dataservice.post('/mant/swrestore').then(
        //        function (respuesta) {
        //            console.log("Restauracion Software Efectuada...");
        //            vgetVersiones();
        //            vgetVerbose();
        //        },
        //        function (error) {
        //            alert(/*"Error en Restauracion software: "*/transerv.translate('MCTRL_MSG_12'), +error.data);
        //        });
	    //}
	}


    /** */
	vm.software_load_send = function () {
	    var file = $scope.myFile;
	    console.log('file is ' + JSON.stringify(file));
	    var uploadUrl = "/sw_upload";
	    dataservice.send_file(uploadUrl, file).then(function () { alert(/*"Fichero Enviado.."*/transerv.translate('MCTRL_MSG_13')); });
	}

    /** */
	vm.logs = function () {
	    var win = window.open('/logs/uvki-gwser.log.csv', '_blank');
	    win.focus();
	}

    /** Pagina de Desarrollo */
    /** */
	vm.historico = "H01,";
	vm.desarrollo = function() {
	    return Desarrollando;
	}
    /** */
	vm.desarrollo_send_historico = function () {
	    dataservice.dev_hist_send(vm.historico).then(function (response) {
	        console.log("Trama: " + vm.historico + " enviada");
	    },
        function (response) {
            console.log("Error: " + response);
        });
	}
    
    /** */
	function Confirma(msg) {
	    if (authservice.check_session() && confirm(msg))
	        return true;
	    return false;
	}

    /** Inicializacion */
	MantService.init().then(function () {	   
	    vm.std = MantService.estado();
	    vgetVerbose();
	    vgetVersiones();
	    console.log("Servicio de Mantenimiento Inicializado");
	});

    /** */
	var cancelTimer = $interval(function () {
	    MantService.get_estado().then(function () {
	        vm.std = MantService.estado();
	    });
	}, 5000);

    /** Se ha pulsado el boton -aplicar- */
	$scope.$on('savecfg', function (data) {
	    if (CfgService.test_ip_virtual() == true ||
            confirm(transerv.translate('GCTRL_IPV_WARNING')) == true) {
	        CfgService.aplicar_cambios();
	    }
	});

    /** Finalizacion */
	$scope.$on("$destroy", function () {
	    $interval.cancel(cancelTimer);
	    MantService.dispose();
	});
}
