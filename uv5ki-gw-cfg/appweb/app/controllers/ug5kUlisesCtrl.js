/** */
angular
	.module('Ug5kweb')
	.controller('ug5kUlisesCtrl', ug5kUlisesCtrl);

ug5kUlisesCtrl.$inject = ['$scope', '$route', 'dataservice', 'authservice', 'CfgService', 'transerv'];

function ug5kUlisesCtrl($scope, $route, dataservice, authservice, CfgService, transerv) {
    var vm = this;

    CfgService.opcion(9);

    /** */
    vm.pagina = 0;
    vm.opcion = 0;
    vm.traduce = transerv;

    /** */
    vm.Pagina = function (n) {
        if (authservice.check_session() == true) {
            vm.pagina = n;
            vm.opcion = 0;
        }
    }

    /** */
    vm.Opcion = function (n) {
        if (authservice.check_session() == true)
            vm.opcion = n;
    }

    /** */
    CfgService.init().then(function () {
        vm.ulises = CfgService.ulises();
        vm.pdir_ip = vm.ulises.plandireccionamientoip;
        vm.pdir_sip = vm.ulises.plandireccionamientosip;
        vm.pasg_usu = vm.ulises.planasignacionusuarios;
        vm.pasg_rec = vm.ulises.planasignacionrecursos;
        vm.ats_red = vm.ulises.planredes;
        vm.ats_trc = vm.ulises.plantroncales;
        vm.ats_num = vm.ulises.plannumeracionats;
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
    $scope.$on('std_change', function (data) {
        console.log("std_change");
        $route.reload();
    });

}
