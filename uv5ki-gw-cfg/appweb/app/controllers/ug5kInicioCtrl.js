/** */
angular
	.module('Ug5kweb')
	.controller('ug5kInicioCtrl', ug5kInicioCtrl);

ug5kInicioCtrl.$inject = ['$scope', '$route', 'CfgService', 'authservice', 'ValidateService', 'MantService', 'transerv'];

/** */
function ug5kInicioCtrl($scope, $route, CfgService, authservice, ValidateService, MantService, transerv) {
	var vm = this;
	var url = '/general';	
	/** */
	vm.j_data = {};
	vm.v_data = [];
	vm.pagina = -1;
	vm.autosave = v2jdata;

	vm.estado = MantService.estado();

	/** */
	vm.set_pagina = function(pagina) {
	    if (!validate_page()) {
	        alert(/*"Existen Errores de Formato o Rango. No puede cambiar de vista..."*/transerv.translate('ICTRL_MSG_01'));
	    }
	    else if (authservice.check_session() == true) {
	        post_data();
			vm.pagina = pagina;
			j2vdata();
		}
	}

	/** */
	vm.show = function(index){
		if (vm.pagina == 0)
			return true;
		switch (index)
		{
			case 1:
			case 2:
			case 3:
			case 4:
				return vm.v_data[0].Value==0;
			case 5:
			case 6:
				return vm.v_data[0].Value==1;
		}
		return true;
	}

    /** */
	vm.show_cpu2 = function () {
	    return vm.pagina == 0 ? (vm.v_data[2].Value == 1) : (vm.j_data.dualidad==1);
	}

    /** */
	vm.restore = function () {
	    CfgService.restore().then(function () {
            get_data();
	    });
	}

    /** */
	function get_data() {
	    vm.j_data = CfgService.inicio_data_get();
	    j2vdata();
	}

    /** Post Data. */
	function post_data() {
	    v2jdata();
	    CfgService.inicio_data_set(vm.j_data);
	}


    /** */
	function j2vdata() {
		switch(vm.pagina)
		{
			case 0:	// General
				vm.v_data = [
					{
					    Name: /*'Emplazamiento:'*/transerv.translate('ICTRL_01_EMP'),
					    Value: vm.j_data.emplazamiento,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: MantService.hide_on_ulises(),
					    Val: ValidateService.max_long_val
					},
					{
					    Name: /*'Identificador:'*/transerv.translate('ICTRL_01_ID'),
					    Value: vm.j_data.name,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.max_long_val
					},
					{
					    Name: /*'Modo:'*/transerv.translate('ICTRL_01_MD'),
					    Value: vm.j_data.dualidad.toString(),
					    Enable: authservice.ProfilePermission(false),
					    Input: 1,
					    Inputs: [
                            /*"Simple"*/transerv.translate('ICTRL_01_SIMPLE'),
                            /*"Dual"*/transerv.translate('ICTRL_01_DUAL')],
					    Show: MantService.hide_on_ulises(), // TODO: Depende del modo...
					    Val: ValidateService.def_val
					},
					{
					    Name: /*'IP Virtual:'*/transerv.translate('ICTRL_01_VIP'),
					    Value: vm.j_data.ipv,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: /*'Servidor de Configuracion:'*/transerv.translate('ICTRL_01_SERV'),
					    Value: vm.j_data.ips,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.url_val
					}
				];
				break;
			case 1:	// CPU-0
				vm.v_data = [
					{
					    Name: /*'LAN Dual:'*/transerv.translate('ICTRL_02_LDUAL'),
					    Value: vm.j_data.cpus[0].tlan.toString(),
					    Enable: false,
					    Input: 1,
					    Inputs: [
                            /*"No"*/transerv.translate('ICTRL_02_NO'),
                            /*"Principal/Reserva"*/transerv.translate('ICTRL_02_PR'), "LACP"],
					    Show: true,
					    Val: ValidateService.def_val
					},
					{
					    Name: 'ETH0 Ip:',
					    Value: vm.j_data.cpus[0].ip0,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH0 Msk:',
					    Value: vm.j_data.cpus[0].ms0,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH1 Ip:',
					    Value: vm.j_data.cpus[0].ip1,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH1 Msk',
					    Value: vm.j_data.cpus[0].ms1,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'BOND Ip:',
					    Value: vm.j_data.cpus[0].ipb,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'BOND Msk:',
					    Value: vm.j_data.cpus[0].msb,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'Gateway Ip:',
					    Value: vm.j_data.cpus[0].ipg,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					}
				];
				break;
			case 2:	// CPU-1
				vm.v_data = [
					{
					    Name: /*'LAN Dual:'*/transerv.translate('ICTRL_02_LDUAL'),
					    Value: vm.j_data.cpus[1].tlan.toString(),
					    Enable: false,
					    Input: 1,
					    Inputs: [
                            /*"No"*/transerv.translate('ICTRL_02_NO'),
                            /*"Principal/Reserva"*/transerv.translate('ICTRL_02_PR'), "LACP"],
					    Show: true,
					    Val: ValidateService.def_val
					},
					{
					    Name: 'ETH0 Ip:',
					    Value: vm.j_data.cpus[1].ip0,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH0 Msk:',
					    Value: vm.j_data.cpus[1].ms0,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH1 Ip:',
					    Value: vm.j_data.cpus[1].ip1,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'ETH1 Msk',
					    Value: vm.j_data.cpus[1].ms1,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'BOND Ip:',
					    Value: vm.j_data.cpus[1].ipb,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'BOND Msk:',
					    Value: vm.j_data.cpus[1].msb,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					},
					{
					    Name: 'Gateway Ip:',
					    Value: vm.j_data.cpus[1].ipg,
					    Enable: authservice.global_enable([ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: true,
					    Val: ValidateService.ip_val
					}
				];
				break;
			default:
			    vm.v_data = [];
                
		}
	}
	
	/** */
	function v2jdata() {
	    switch (vm.pagina)
		{
			case 0: // General
			    vm.j_data.emplazamiento = vm.v_data[0].Value;
			    vm.j_data.name = vm.v_data[1].Value;
				vm.j_data.dualidad = parseInt(vm.v_data[2].Value);
				vm.j_data.ipv = vm.v_data[3].Value;
				vm.j_data.ips = vm.v_data[4].Value;
				break;
			case 1: //CPU0
			    vm.j_data.cpus[0].tlan = parseInt(vm.v_data[0].Value);
			    vm.j_data.cpus[0].ip0 = vm.v_data[1].Value;
			    vm.j_data.cpus[0].ms0 = vm.v_data[2].Value;
			    vm.j_data.cpus[0].ip1 = vm.v_data[3].Value;
			    vm.j_data.cpus[0].ms1 = vm.v_data[4].Value;
			    vm.j_data.cpus[0].ipb = vm.v_data[5].Value;
			    vm.j_data.cpus[0].msb = vm.v_data[6].Value;
			    vm.j_data.cpus[0].ipg = vm.v_data[7].Value;
				break;
			case 2: //CPU1
				vm.j_data.cpus[1].tlan = parseInt(vm.v_data[0].Value);
				vm.j_data.cpus[1].ip0 = vm.v_data[1].Value;
				vm.j_data.cpus[1].ms0 = vm.v_data[2].Value;
				vm.j_data.cpus[1].ip1 = vm.v_data[3].Value;
				vm.j_data.cpus[1].ms1 = vm.v_data[4].Value;
				vm.j_data.cpus[1].ipb = vm.v_data[5].Value;
				vm.j_data.cpus[1].msb = vm.v_data[6].Value;
				vm.j_data.cpus[1].ipg = vm.v_data[7].Value;
				break;
		}
	}

    /** */
	function validate_page() {
	    /** Recompongo las URI's por si ha cambiado la IPV */
	    CfgService.rec_uri_nor();

	    switch (vm.pagina) {
	        case 0:
	            return ValidateService.ip_val(vm.v_data[3].Value) && ValidateService.url_val(vm.v_data[4].Value);
	        case 1:
	        case 2:
	            return ValidateService.ip_val(vm.v_data[5].Value) && ValidateService.ip_val(vm.v_data[6].Value) && ValidateService.ip_val(vm.v_data[7].Value);
	    }
	    return false;
	}

    /** */
	CfgService.init().then(function () {
	    get_data();
	    vm.pagina = 0;
	    j2vdata();
	});

    /** Cambio de Vista... */
	$scope.$on("$locationChangeStart", function (event) {
	    if (!validate_page()) {
	        alert(/*"Existen Errores de Formato o Rango. No puede cambiar de vista..."*/transerv.translate('ICTRL_MSG_01'));
	        event.preventDefault();
	    }
	    else
	        post_data();
	});

    /** Se ha pulsado el boton -aplicar- */
	$scope.$on('savecfg', function (data) {
	    console.log("savecfg");
	    if (!validate_page()) {
	        alert(/*"Existen Errores de Formato o Rango. No puede salvar lo cambios..."*/transerv.translate('ICTRL_MSG_01'));
	    }
	    else {
	        //if (vm.last_ip_virtual != vm.j_data.ipv) {
	        if (CfgService.test_ip_virtual() == false) {
	            if (confirm(transerv.translate('GCTRL_IPV_WARNING'))) {
	                CfgService.aplicar_cambios();
	            }
	        }
	        else {
	            CfgService.aplicar_cambios();
	        }
	    }
	    //else if (confirm("�Realmente desea activar los cambios efectuados?")) {
	    //    if (vm.last_ip_virtual != vm.j_data.ipv) {
	    //        if (confirm("Ha cambiado la IP Virtual. Si contin�a se Reiniciar� la Unidad...")) {
	    //            CfgService.save();
	    //            vm.last_ip_virtual = vm.j_data.ipv;
	    //        }
	    //    }
	    //    else {
	    //        CfgService.save();
	    //    }
	    //}
	});

    /** */
	//$scope.$on("$destroy", function () {
	//    post_data();
	//});

    /** */
	$scope.$on('loadcfg', function (data) {
	    get_data();
	    j2vdata();
	});

    /** */
	$scope.$on('std_change', function (data) {
	    console.log("std_change");
	    j2vdata();
	    estado = MantService.estado();
	    $route.reload();
	});

    ///** */
	//$scope.$on('restorecfg', function (data) {
	//    console.log("restorecfg");
	//});
}
