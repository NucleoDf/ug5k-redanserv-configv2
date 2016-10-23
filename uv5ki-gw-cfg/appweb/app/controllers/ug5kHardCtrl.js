/** */
angular
	.module('Ug5kweb')
	.controller('ug5kHardCtrl', ug5kHardCtrl);

ug5kHardCtrl.$inject = ['CfgService', 'authservice', 'transerv', '$scope', '$location'];

function ug5kHardCtrl(CfgService, authservice, transerv, $scope, $location) {
	var vm = this;

	/** */
	vm.jslv = {};
	vm.slv = 0;
	
	/** Funciones AJAX */
	/** Get Data */
	vm.get_data = function (slv) {
	    vm.jslv = CfgService.hw_data_get(slv);
	}

	/** Post Data. */
	vm.post_data = function (slv) {
	    CfgService.hw_data_set(slv, vm.jslv);
	}

	/** */
	vm.set_slv = function (slv) {
	    vm.post_data(vm.slv);
		vm.slv = slv;
		vm.get_data(slv);
	}
	
    /** */
	vm.restore = function () {
	    CfgService.restore().then(function () {
	        vm.get_data(vm.slv);
	    });
	}

    /** */
	vm.pos_change = function (pos) {
	    if (authservice.Confirma(Mensaje(pos)))
	        vm.post_data(vm.slv);
	    else
	        vm.get_data(vm.slv);
	}

    /** */
	vm.enable_pos = function (pos) {
	    return authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]);
	}

    /** */
	vm.pos_click = function (pos,tipo) {
	    if (tipo == 0)
	        return;
	    var route = tipo == 1 ? "/precr/" : "prect/";
	    route += (vm.slv * 4 + pos).toString();
	    $location.path(route);
	}

    /** */
	function Mensaje(pos) {
	    if (vm.jslv.pos[pos].cfg == 0)
	        return transerv.translate('HCTRL_MSG_01');    // "¿ Desea Eliminar este recurso ?";
	    else if (vm.jslv.pos[pos].cfg == 1)
	        return transerv.translate('HCTRL_MSG_02');    // "¿ Desea Añadir este recurso radio ?";
	    else if (vm.jslv.pos[pos].cfg == 2)
	        return transerv.translate('HCTRL_MSG_03');    // "¿ Desea Añadir este recurso de telefonía ?";
	}

    /** */
	CfgService.init().then(function () {
	    vm.slv = CfgService.hw_last_get() == -1 ? 0 : CfgService.hw_last_get();
	    vm.get_data(vm.slv);
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
        vm.post_data(vm.slv);
    });

    /** */
	$scope.$on('loadcfg', function (data) {
	    vm.get_data(vm.slv);
	});
}
