/** */
angular
	.module('Ug5kweb')
	.controller('ug5kConfCtrl', ug5kConfCtrl);

ug5kConfCtrl.$inject = ['dataservice', 'authservice', 'CfgService', 'transerv', '$q', '$scope', '$http'];

function ug5kConfCtrl(dataservice, authservice, CfgService, transerv, $q, $scope, $http) {
    var vm = this;

    CfgService.opcion(5);

    /** */
    function post(url, data) {
        var deferred = $q.defer();
        dataservice.set_data(url, data, false).then(
			function (respuesta) {
			    console.log("POST: ", respuesta);
			    deferred.resolve();
			}
		);
        return deferred.promise;
    }
    /** */
    vm.pcfgNumber = undefined;

    /** */
    vm.preconf = [];
    vm.preconfname = /*"Introduzca nombre"*/transerv.translate('CCTRL_MSG_00');
    vm.pagina = 1;
    vm.traduce = transerv;
    /** */
    vm.Pagina = function (n) {
        if (authservice.check_session() == true)
            vm.pagina = n;
    }

    /** */
    vm.mostrar = function (boton) {
        switch (boton) {
            case 0:         // Exportar
            case 1:         // Importar
            case 2:         // Guardar
            case 3:         // Activar
            case 4:         // Borrar
                return authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]);
                break;
        }
        return false;
    }

    /** */
    vm.salvar = function () {
        CfgService.aplicar_cambios();
    }

    /** */
    vm.descartar = function () {
        if (Confirma(/*"¿Realmente desea descartar los cambios efectuados?"*/transerv.translate('CCTRL_MSG_01'))) {
            // post('/conf/descartar', {});
            CfgService.restore();
        }
    }

    /** */
    vm.salvarcomo = function () {
        var existe = false;
        var listaconfs = vm.preconf.preconfs;

        if (validate_max_preconf() == false) return;
        /** */
        vm.preconfname = prompt(transerv.translate('CCTRL_MSG_00')/*"Introduzca Identificador"*/, "");
        if (vm.preconfname == null)
            return;

        /** */
        for (var i = 0; i < listaconfs.length; i++) {
            if (vm.preconfname == listaconfs[i].name) {
                alert(/*"Ya existe una preconfiguración con el nombre:"*/transerv.translate('CCTRL_MSG_03') + listaconfs[i].name +
                    /*" con fecha: "*/transerv.translate('CCTRL_MSG_04') + listaconfs[i].date);
                existe = true;
            }
        }
        if ((existe == false) && ((vm.preconfname != /*"Introduzca nombre"*/transerv.translate('CCTRL_MSG_00')) && (vm.preconfname != ""))) {
            var pre = /*"¿Quiere salvar la configuracion actual como "*/transerv.translate('CCTRL_MSG_05') + vm.preconfname + " ?";
            if (Confirma(pre)) {
                $("body").css("cursor", "progress");
                post('/preconf/' + vm.preconfname, {})
                 .then(
                     function (res) {
                         vm.get_preconf();
                         alert(/*"Preconfiguración "*/transerv.translate('CCTRL_MSG_06') + vm.preconfname + /*" guardada correctamente."*/transerv.translate('CCTRL_MSG_07'));
                         vm.preconfname = /*"Introduzca nombre"*/transerv.translate('CCTRL_MSG_00');
                         $("body").css("cursor", "default");
                     }
                 );
            }
        }
        else {
            alert(/*"Debe introducir un nombre y este debe se inexistente"*/transerv.translate('CCTRL_MSG_08'));
            vm.preconfname = /*"Introduzca nombre"*/transerv.translate('CCTRL_MSG_00');
        }

    };


    /** */
    vm.activar = function (name) {
        name = preconf_name_get(name);
        if (name == undefined) return;
        var pre = /*"¿Quiere activar la Preconfiguracion "*/transerv.translate('CCTRL_MSG_09') + name + " ?";
        if (Confirma(pre)) {
            $("body").css("cursor", "progress");
            dataservice.put_data('/preconf/' + name, {})
                .then(function (res) {
                    console.log("PUT: ", res);
                    CfgService.restore();
                    $("body").css("cursor", "default");
                    alert(name + ": " + res.res);
                });
        }
    }
    /**.*/
    vm.eliminar = function (name) {
        name = preconf_name_get(name);
        if (name == undefined) return;
        var pre = /*"¿Quiere Eliminar la Preconfiguracion "*/transerv.translate('CCTRL_MSG_10') + name + " ?";
        if (Confirma(pre)) {
            dataservice.del_data('/preconf/' + name, {})
                .then(
                    function (res) {
                        console.log("DELETE: ", res);
                        vm.get_preconf();
                        vm.pcfgNumber = undefined;
                    });
        }
    }

    /** */
    vm.get_preconf = function () {
        var deferred = $q.defer();
        var url = '/preconf';

        console.log("GET ", url);
        dataservice.get_data(url, false).then(
			function (respuesta) {
			    console.log("res:", respuesta);
			    vm.preconf = respuesta;
			    deferred.resolve();
			}
		);

        return deferred.promise;
    }

    /** */
    vm.import = function () {
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            if (validate_max_preconf() == false) return;
            var chooser = $('#openDialog4Import');
             chooser.unbind('change');
             chooser.change(function (evt) {
                var filename = $(this).val().replace("C:\\fakepath\\", "");

                if (Confirma(transerv.translate('CCTRL_MSG_11')/*"¿Desea Importar el fichero "*/ + filename + "?") == false)
                    return;

                var file = evt.target.files[0];
                var reader = new FileReader();

                reader.onload = function (e) {
                    var text = reader.result;
                    try {
                        var obj = JSON.parse(text);
                        $http.post("/impexp/"+filename, obj).then(function (response) {
                            if (response.data.res === "ok") {
                                alert(/*"Preconfiguración "*/transerv.translate('CCTRL_MSG_06') + /*" guardada correctamente."*/transerv.translate('CCTRL_MSG_07'));
                                vm.get_preconf();
                            }
                            else {
                                alert("Error: " + response.data.res);
                            }
                        }, function (response) {                
                            console.log(response);                
                            alert(transerv.translate('CCTRL_MSG_12')/*"Error Comunicaciones. Mire Log Consola..."*/);
                        });

                        console.log('Object: ' + obj);
                    }
                    catch (e) {
                        alert("Error: " + e);
                    }
                }
                reader.readAsText(file);
                 // Reset the selected value to empty ('')
                $(this).val('');
                console.log("NAME: " + filename + ",File: " + file);
            });
             chooser.trigger('click');
        } else {
            alert('The File APIs are not fully supported in this browser...');
        }
    }

    /** */
    vm.export = function () {
        var name = preconf_name_get(undefined);
        if (name == undefined) return;
        try {

            if (Confirma(transerv.translate('CCTRL_MSG_13')/*"¿Desea Exportar la preconfiguracion "*/ + name + "?") == false)
                return;

            $http.get("/impexp/" + name).then(function (response) {
                download(name + ".json", JSON.stringify(response.data));
                alert(transerv.translate('CCTRL_MSG_14')/*"Preconfiguración exportada correctamente"*/);
            }, function (response) {
                console.log(response);
                alert(transerv.translate('CCTRL_MSG_12')/*"Error Comunicaciones. Mire Log Consola..."*/);
            });

        }
        catch (error) {
            alert("Error: " + e);
        }
    }

    /** */
    function validate_max_preconf() {
        var listaconfs = vm.preconf.preconfs;
        /** */
        if (listaconfs.length >= 8) {
            alert(/*"Se ha alcanzado el número máximo de preconfiguraciones (8) que se pueden almacenar. Elimine alguna antes de generar una nueva."*/
                transerv.translate('CCTRL_MSG_02'));
            return false;
        }
        return true;
    }

    /** */
    function preconf_name_get(name) {
        if (name == undefined) {
            if (vm.pcfgNumber == undefined) {
                alert(transerv.translate('CCTRL_MSG_15')/*"Seleccione una Preconfiguracion!!!"*/);
                return undefined;
            }
            name = vm.pcfgNumber.name;
        }
        return name;
    }

    /** */
    function linkDownload(a, filename, content) {
        contentType = 'data:application/octet-stream,';
        uriContent = contentType + encodeURIComponent(content);
        a.setAttribute('href', uriContent);
        a.setAttribute('download', filename);
    }

    /** */
    function download(filename, content) {
        var a = document.createElement('a');
        linkDownload(a, filename, content);
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }

    /** */
    function Confirma(msg) {
        if (authservice.check_session() && confirm(msg))
            return true;
        return false;
    }

    /** */
    CfgService.init().then(function () {
        vm.get_preconf();
    });

    /** Se ha pulsado el boton -aplicar- */
    $scope.$on('savecfg', function (data) {
        if (CfgService.test_ip_virtual() == true ||
            confirm(transerv.translate('GCTRL_IPV_WARNING')) == true) {
            CfgService.aplicar_cambios();
        }
    });

    /** */
    $scope.$on("$destroy", function () {
    });

    /** */
}
