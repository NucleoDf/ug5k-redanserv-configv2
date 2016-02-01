angular.module("Uv5kinbx")
.controller("uv5kiConfigCtrl", function ($scope, $interval, $serv) {
    /** Inicializacion */
    var ctrl = this;
    ctrl.pagina = 0;

    /** */
    ctrl.lc = {
        // pgn: { name: "Parametros Generales", par: [] }
        // , pif: { name: "Parametros Infraestructura", par: [] }
        // , prd: { name: "Parametros Servicio Radio", par: [] }
        // , pcf: { name: "Parametros Servicio Configuracion", par: [] }
        // , pit: { name: "Parametros Servicio Interfaces", par: [] }
        // , ppx: { name: "Parametros Pabx", par: [] }
    };
    lconfig_load();
    /*ctrl.lp = lp_get();*/
    
    /** */
    /** */
    ctrl.change_pagina = function (new_pagina) {

        /** Salvamos lo cambios */
        lp_set(ctrl.lp);

        /** Cargamos la nueva lista */
        ctrl.pagina = new_pagina;
        ctrl.lp = lp_get();
    }
    
    /** */
    ctrl.SalvarCambios = function() {
        /** Salvar los cambios locales */
        lp_set(ctrl.lp);
        
        if (confirm("¿ Desea Salvar los cambios efectuados ?")==true) {
            lconfig_save();    
        }
    
    }
    
    ctrl.autosave = function () {
        // body...
    }

    /** Obtiene la lista seg�n la p�gina*/
    function lp_get() {
        switch (ctrl.pagina) {
            case 0:
                return ctrl.lc.pgn;
            case 1:
                return ctrl.lc.pif;
            case 2:
                return ctrl.lc.prd;
            case 3:
                return ctrl.lc.pcf;
            case 4:
                return ctrl.lc.pit;
            case 5:
                return ctrl.lc.ppx;
            default:
                return { name: "Error Pagina", par: [] };
        }
    }

    /** Salva la lista segun la pagina */
    function lp_set(new_data) {
        switch (ctrl.pagina) {
            case 0:
                ctrl.lc.pgn = new_data;
                break;
            case 1:
                ctrl.lc.pif = new_data;
                break;
            case 2:
                ctrl.lc.prd = new_data;
                break;
            case 3:
                ctrl.lc.pcf = new_data;
                break;
            case 4:
                ctrl.lc.pit = new_data;
                break;
            case 5:
                ctrl.lc.ppx = new_data;
                break;
            default:
                break;
        }
    }

    /** */
    function lconfig_load() {
        $serv.lconfig_get().then(function(response) {
            ctrl.lc = response.data;
            ctrl.lp = lp_get();
        }, function(response) {
            
        });
    }
    
    /** */
    function lconfig_save() {
        $serv.lconfig_set(ctrl.lc).then(function(response) {
            
        }, function(response) {
            
        });
    }
    
});
