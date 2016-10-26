/** */
angular
	.module('Ug5kweb')
	.controller('ug5kRectCtrl', ug5kRectCtrl);

ug5kRectCtrl.$inject = ['authservice', 'CfgService', 'ValidateService', 'transerv', '$scope', '$routeParams'];

function ug5kRectCtrl(authservice, CfgService, ValidateService, transerv, $scope, $routeParams) {
    var vm = this;
    var simul = true;

    /** Modelo */
    vm.selected = "0";
    vm.current = -1;
    vm.ltelef = [];
    vm.tdata = {};
    vm.pagina = 0;
    vm.vdata = [];
    vm.autosave = v2jdata;
    vm.dval = function () { return true; }

    CfgService.opcion(3);

    /** Validador de IdRecurso. Actualiza a la ver la URI Local */
    vm.id_val = function (value) {
        if (ValidateService.max_long_val(value) === true) {
            vm.tdata.IdRecurso = value;
            vm.vdata[3].Value = jamp_no_sip == 1 ? CfgService.quitar_sip(CfgService.rec_uri_get(vm.tdata)) : CfgService.rec_uri_get(vm.tdata);
            return true;
        }
        return false;
    }

    /** Validador cbm en A/D */
    vm.cbmad_val = function (value) {
        return value >= -13.4 && value <= 1.20 ? true : false;
    }

    /** Validador cmd en D/A */
    vm.cbmda_val = function (value) {
        return value >= -24.3 && value <= 1.10 ? true : false;
    }

    /** Validador nivel VOX */
    vm.vox_val = function (value) {
        return value >= -35 && value <= -15 ? true : false;
    }

    /** Validador cola VOX */
    vm.cvox_val = function (value) {
        return value >= 0 && value <= 30 ? true : false;
    }

    /** Validador Periodo tonos respuesta estado (s) */
    vm.ptre_val = function (value) {
        return value >= 1 && value <= 10 ? true : false;
    }

    /** Validador tiempo supervision (s) */
    vm.tsup_val = function (value) {
        return value >= 1 && value <= 10 ? true : false;
    }

    /** */
    vm.validate_ats_range = function (range) {
        var match = range.match(regx_atsrango);
        return (range == "" || match) ? true : false;
    }

    /** */
    vm.validate_ats_number = function (number) {
        var match = number.match(regx_atsnumber);
        return (number == "" || match) ? true : false;
    }

    /** */
    vm.validate_iwp = function (valor) {
        return (valor >= 5 && valor <= 15);
    }

    /** */
    vm.show_listas_bn = function () {
        //return !vm.show_rangos_ats();
        return false;
    }

    /** */
    vm.show_plbn = function () {
        return vm.show_rangos_ats();
    }

    /** */
    vm.show_clave = function () {
        return vm.vdata[4].Value == 1 ? true : false;
    }

    /** */
    vm.show_rangos_ats = function () {

        if (vm.tdata == undefined)
            return false;

        switch (vm.pagina) {
            case 0:
                return (vm.vdata.length > 0) && (vm.vdata[2].Value == 3 || vm.vdata[2].Value == 4 || vm.vdata[2].Value == 6);
            case 1:
            case 3:
            case 4:
                return (vm.tdata.telefonia.tipo == 3 || vm.tdata.telefonia.tipo == 4 || vm.tdata.telefonia.tipo == 6);
            case 2:
                return (vm.vdata.length > 0) && (vm.vdata[0].Value == 3 || vm.vdata[0].Value == 4 || vm.vdata[2].Value == 6);
        }
        return false;
    }

    /** */
    vm.bnorats = function () {
        return vm.show_rangos_ats() ? /*"Rangos ATS"*/transerv.translate('TCTRL_PG03_OPT1') : /*"Listas B/N"*/transerv.translate('TCTRL_PG03_OPT2');
    }

    /***********/
    vm.telgain_show = function (ind) {
        ////if (vm.pagina == 1)
        //    return true;
        switch (ind) {
            case 2:
                return (vm.vdata[1].Value == 0);
            case 4:
                return (vm.vdata[3].Value == 0);
        }
        return true;
    }
    /** */
    vm.update_telef = function () {
        if (vm.current != -1)
            set_telef_data(vm.current);
        get_telef_data(parseInt(vm.selected));

        vm.set_pagina(0);   
    }

    /** */
    vm.set_pagina = function (pagina) {
        if (!validate_page()) {
            alert(/*"Existen Errores de Formato o Rango. No puede cambiar de vista..."*/transerv.translate('ICTRL_MSG_01'));
        }
        else if (authservice.check_session() == true) {
            v2jdata();
            vm.pagina = pagina;
            j2vdata();
        }
    }

    /** */
    vm.lbn_show = function (ind) {
        if (vm.show_listas_bn()) {
            switch (ind) {
                case 1:
                    return (vm.vdata[0].Value == 2);
                case 2:
                    return (vm.vdata[0].Value == 1);
                default:
                    return true;
            }
        }
        return false;
    }

    /** */
    vm.tel_show = function (ind) {
        switch (ind) {
            case 0: // Tipo
                return true;

            case 1: // uri
                return vm.vdata[0].Value != 6;

            case 2: // Respuesta automatica simulada. Para R2/N5 y LCEN
            case 7: // Supervisa Colateral
                return (vm.vdata[0].Value == 3 || vm.vdata[0].Value == 4 || vm.vdata[0].Value == 5);

            case 4: // Lado.        N5/R2
            case 5: // Test Remoto.
            case 6: // Test Local.
            case 12: // Periodo Interrupt Warning
                return (vm.vdata[0].Value == 3 || vm.vdata[0].Value == 4);

            case 3: // Tiempo Release.
                return ((vm.vdata[0].Value == 3 || vm.vdata[0].Value == 4 || vm.vdata[0].Value == 5) && vm.vdata[2].Value == 1);

            case 8: // Tiempo Supervision Colateral
                return ((vm.vdata[0].Value == 3 || vm.vdata[0].Value == 4 || vm.vdata[0].Value==5 ) && vm.vdata[7].Value == 1);

            case 9: // Vox BL
                return (vm.vdata[0].Value == 0);
            case 10: // Umbral Vox BL
            case 11: // Cola Umbral BL
                return (vm.vdata[0].Value == 0 && vm.vdata[9].Value == 1);

            default:
                return false;
        }
    }

    /** */
    vm.restore = function () {
        CfgService.restore().then(function () {
            get_telef();
            get_telef_data(parseInt(vm.selected));
        });
    }

    /** */
    function get_telef() {
        vm.ltelef = CfgService.ltelef();
    }

    /** */
    function get_telef_data(telef) {
        vm.selected = telef.toString();
        vm.current = telef;
        vm.tdata = CfgService.telef_data_get(telef);
        j2vdata();
    }

    /** */
    function set_telef_data(telef) {
        if (vm.tdata != undefined) {
            v2jdata();
            CfgService.telef_data_set(telef, vm.tdata);
        }
    }

    /** */
    function j2vdata() {

        if (vm.tdata == undefined)
            return;

        switch (vm.pagina) {
            case 0:
                vm.vdata = [
					{
					    Name: /*'Recurso:'*/transerv.translate('TCTRL_P00_RES'),
					    Value: vm.tdata.IdRecurso,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.dval,
					    Val: vm.id_val
					},
					{
					    Name: /*'SLOT/Posicion:'*/transerv.translate('TCTRL_P00_ST'),
					    Value: vm.tdata.SlotPasarela + " / " + vm.tdata.NumDispositivoSlot,
					    Enable: authservice.ProfilePermission(false, []),
					    Input: 0,
					    Inputs: [],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'Tipo de Interfaz Telefonico:'*/transerv.translate('TCTRL_P00_ITF'),
					    Value: vm.tdata.telefonia.tipo.toString(),
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 1,
					    Inputs: [
                              /*"PP-BL"*/transerv.translate('TCTRL_P00_IBL')
                              ,/*"PP-BC"*/transerv.translate('TCTRL_P00_IBC')
                              ,/*"PP-AB"*/transerv.translate('TCTRL_P00_IAB')
                              ,/*"ATS-R2"*/transerv.translate('TCTRL_P00_IR2')
                              ,/*"ATS-N5"*/transerv.translate('TCTRL_P00_IN5')
                              ,/*"LCEN"*/transerv.translate('TCTRL_P00_ILC')
                              //,/*"ATS-QSIG"*/transerv.translate('TCTRL_P00_IQS')
                              //,/*"TUN-LOC"*/transerv.translate('TCTRL_P00_LTU')
                              //,/*"TUN-REM"*/transerv.translate('TCTRL_P00_RTU')
					    ],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'URI:'*/transerv.translate('TCTRL_P00_URI'),
					    Value: jamp_no_sip == 1 ? CfgService.quitar_sip(vm.tdata.Uri_Local) : vm.tdata.Uri_Local,
					    Enable: authservice.ProfilePermission(false, []),
					    Input: jamp_no_sip == 1 ? 3 : 0,
					    Inputs: [],
					    Show: vm.dval,
					    Val: ValidateService.uri_val
					},
                    {
                        Name: /*'Enable Registro ?:'*/transerv.translate('TCTRL_P00_REG'),
                        Value: vm.tdata.enableRegistro.toString(),
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: 1,
                        Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
                        Show: vm.dval,
                        Val: vm.dval
                    },
					{
					    Name: /*'Clave:'*/transerv.translate('TCTRL_P00_CLV'),
					    Value: vm.tdata.szClave,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.show_clave,
					    Val: ValidateService.max_long_val
					}
                ];
                break;
            case 1:
                vm.vdata = [
					{
					    Name: /*'CODEC :'*/transerv.translate('TCTRL_P01_COD'),
					    Value: vm.tdata.Codec.toString(),
					    Enable: authservice.ProfilePermission(false, []),
					    Input: 1,
					    Inputs: ["G711-A", "G711-U", "G729"],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'AGC en A/D ?:'*/transerv.translate('TCTRL_P01_AGCAD'),
					    Value: vm.tdata.hardware.AD_AGC.toString(),
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 1,
					    Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'Ajuste Cero Digital en A/D (dBm):'*/transerv.translate('TCTRL_P01_AGCAD_AJUSTE'),
					    Value: vm.tdata.hardware.AD_Gain / 10,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.telgain_show,
					    Val: vm.cbmad_val
					},
					{
					    Name: /*'AGC en D/A ?:'*/transerv.translate('TCTRL_P01_AGCDA'),
					    Value: vm.tdata.hardware.DA_AGC.toString(),
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 1,
					    Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'Ajuste Cero Digital en A/D (dBm)::'*/transerv.translate('TCTRL_P01_AGCDA_AJUSTE'),
					    Value: vm.tdata.hardware.DA_Gain / 10,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.telgain_show,
					    Val: vm.cbmda_val
					}
                ];
                break;
            case 2:
                vm.vdata = [
					{
					    Name: /*'Tipo de Interfaz Telefonico:'*/transerv.translate('TCTRL_P00_ITF'),
					    Value: vm.tdata.telefonia.tipo.toString(),
					    Enable: authservice.ProfilePermission(false, []),
					    Input: 1,
					    Inputs: [
                              /*"PP-BL"   */transerv.translate('TCTRL_P00_IBL'),
                              /*"PP-BC"   */transerv.translate('TCTRL_P00_IBC'),
                              /*"PP-AB"   */transerv.translate('TCTRL_P00_IAB'),
                              /*"ATS-R2"  */transerv.translate('TCTRL_P00_IR2'),
                              /*"ATS-N5"  */transerv.translate('TCTRL_P00_IN5'),
                              /*"LCEN"    */transerv.translate('TCTRL_P00_ILC'),
                              /*"ATS-QSIG"*/transerv.translate('TCTRL_P00_IQS'),
                              /*"TUN-LOC" */transerv.translate('TCTRL_P00_LTU'),
                              /*"TUN-REM" */transerv.translate('TCTRL_P00_RTU')],
					    Show: vm.dval,
					    Val: vm.dval
					},
					{
					    Name: /*'URI Remota:'*/transerv.translate('TCTRL_P02_RURI'),
					    Value: jamp_no_sip == 1 ? CfgService.quitar_sip(vm.tdata.telefonia.uri_remota) : vm.tdata.telefonia.uri_remota,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: jamp_no_sip == 1 ? 3 : 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: ValidateService.uri_val
					},
					{
					    Name: /*'Respuesta Automatica Simulada ?:'*/transerv.translate('TCTRL_P02_ARSP'),
					    Value: vm.tdata.telefonia.r_automatica.toString(),
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 1,
					    Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
					    Show: vm.tel_show,
					    Val: vm.dval
					},
					{
					    Name: /*'Periodo tonos respuesta estado (s):'*/transerv.translate('TCTRL_P02_PTON'),
					    Value: vm.tdata.telefonia.it_release,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.ptre_val
					},
					{
					    Name: /*'Lado:'*/transerv.translate('TCTRL_P02_LADO'),
					    Value: vm.tdata.telefonia.lado.toString(),
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 1,
					    Inputs: [/*"Lado A"*/transerv.translate('TCTRL_P02_LADOA'), /*"Lado B"*/transerv.translate('TCTRL_P02_LADOB')],
					    Show: vm.tel_show,
					    Val: vm.dval
					},
					{
					    Name: /*'Numero TEST Colateral:'*/transerv.translate('TCTRL_P02_CTES'),
					    Value: vm.tdata.telefonia.no_test_remoto,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.validate_ats_number
					},
					{
					    Name: /*'Numero TEST Local:'*/transerv.translate('TCTRL_P02_LTES'),
					    Value: vm.tdata.telefonia.no_test_local,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.validate_ats_number
					},
    				{
    				    Name: /*'Supervisa Colateral ?:'*/transerv.translate('TCTRL_P02_CSUP'),
    				    Value: vm.tdata.telefonia.superv_options.toString(),
    				    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
    				    Input: 1,
    				    Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
    				    Show: vm.tel_show,
    				    Val: vm.dval
    				},
					{
					    Name: /*'Tiempo Supervision (s):'*/transerv.translate('TCTRL_P02_TSUP'),
					    Value: vm.tdata.telefonia.tm_superv_options,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.tsup_val
					},
    				{
    				    Name: /*'Deteccion Vox ?:'*/transerv.translate('TCTRL_P02_VOX'),
    				    Value: vm.tdata.telefonia.detect_vox.toString(),
    				    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
    				    Input: 1,
    				    Inputs: [/*"No"*/transerv.translate('TCTRL_P00_NO'), /*"Si"*/transerv.translate('TCTRL_P00_SI')],
    				    Show: vm.tel_show,
    				    Val: vm.dval
    				},
					{
					    Name: /*'Umbral Vox (dbm):'*/transerv.translate('TCTRL_P02_UVOX'),
					    Value: vm.tdata.telefonia.umbral_vox,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.vox_val
					},
					{
					    Name: /*'Cola Vox (s):'*/transerv.translate('TCTRL_P02_CVOX'),
					    Value: vm.tdata.telefonia.tm_inactividad,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.cvox_val
					},
					{
					    Name: /*'Periodo Interrupt Warning'*/transerv.translate('TCTRL_P02_IWP'),
					    Value: vm.tdata.telefonia.iT_Int_Warning,
					    Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
					    Input: 0,
					    Inputs: [],
					    Show: vm.tel_show,
					    Val: vm.validate_iwp
					}
                ];
                break;
            case 3:
                vm.vdata = [
                    {
                        Name: /*'Tipo de Restriccion:'*/transerv.translate('TCTRL_P03_RES'),
                        Value: vm.tdata.restriccion.toString(),
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: 1,
                        Inputs: [
                            /*"Ninguna"*/transerv.translate('TCTRL_P03_RESN'), 
                            /*"Lista Negra"*/transerv.translate('TCTRL_P03_RESB'), 
                            /*"Lista Blanca"*/transerv.translate('TCTRL_P03_RESW')],
                        Show: vm.lbn_show,
                        Val: vm.dval
                    },
                    {
                        Name: '',
                        Value: jamp_no_sip == 1 ? CfgService.quitar_sip(vm.tdata.blanca) : vm.tdata.blanca,
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: jamp_no_sip == 1 ? 4: 2,
                        Inputs: [],
                        Show: vm.lbn_show,
                        Val: ValidateService.uri_val
                    },
                    {
                        Name: '',
                        Value: jamp_no_sip == 1 ? CfgService.quitar_sip(vm.tdata.negra) : vm.tdata.negra,
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: jamp_no_sip == 1 ? 4 : 2,
                        Inputs: [],
                        Show: vm.lbn_show,
                        Val: ValidateService.uri_val
                    },


                    {
                        Name: /*'Rango Abonados Origen.'*/transerv.translate('TCTRL_P03_OAB'),
                        Value: vm.tdata.restriccion,
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: -1,
                        Inputs: [],
                        Show: vm.show_rangos_ats,
                        Val: vm.dval
                    },
                    {
                        Name: ' ',
                        Value: ats2lista(vm.tdata.telefonia.ats_rangos_org),
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: 2,
                        Inputs: [],
                        Show: vm.show_rangos_ats,
                        Val: vm.validate_ats_range
                    },
                    {
                        Name: /*'Rango Abonados Destino.'*/transerv.translate('TCTRL_P03_DAB'),
                        Value: vm.tdata.restriccion,
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: -1,
                        Inputs: [],
                        Show: vm.show_rangos_ats,
                        Val: vm.dval
                    },
                    {
                        Name: ' ',
                        Value: ats2lista(vm.tdata.telefonia.ats_rangos_dst),
                        Enable: authservice.ProfilePermission(true, [ADMIN_PROFILE, ING_PROFILE]),
                        Input: 2,
                        Inputs: [],
                        Show: vm.show_rangos_ats,
                        Val: vm.validate_ats_range
                    },
                ];
                break;
            default:
                vm.vdata = [];
                break;
        }
    }

    /** */
    function v2jdata() {
        if (vm.tdata == undefined)
            return;
        switch (vm.pagina) {
            case 0:
                vm.tdata.IdRecurso = vm.vdata[0].Value;
                vm.tdata.telefonia.tipo = parseInt(vm.vdata[2].Value);
                vm.tdata.Uri_Local = jamp_no_sip == 1 ? CfgService.poner_sip(vm.vdata[3].Value) : vm.vdata[3].Value;
                vm.tdata.enableRegistro = parseInt(vm.vdata[4].Value);
                vm.tdata.szClave = vm.vdata[5].Value;
                break;
            case 1:
                vm.tdata.Codec = parseInt(vm.vdata[0].Value);
                vm.tdata.hardware.AD_AGC = parseInt(vm.vdata[1].Value);
                vm.tdata.hardware.AD_Gain = vm.vdata[2].Value*10;
                vm.tdata.hardware.DA_AGC = parseInt(vm.vdata[3].Value);
                vm.tdata.hardware.DA_Gain = vm.vdata[4].Value*10;
                break;
            case 2:
                vm.tdata.telefonia.tipo = vm.vdata[0].Value;
                vm.tdata.telefonia.uri_remota = jamp_no_sip == 1 ? CfgService.poner_sip(vm.vdata[1].Value) : vm.vdata[1].Value;
                vm.tdata.telefonia.r_automatica = parseInt(vm.vdata[2].Value);
                vm.tdata.telefonia.it_release = vm.vdata[3].Value;
                vm.tdata.telefonia.lado = parseInt(vm.vdata[4].Value);
                vm.tdata.telefonia.no_test_remoto = vm.vdata[5].Value;
                vm.tdata.telefonia.no_test_local = vm.vdata[6].Value;
                vm.tdata.telefonia.superv_options = parseInt(vm.vdata[7].Value);          //Supervisa Colateral ???
                vm.tdata.telefonia.tm_superv_options = vm.vdata[8].Value;       //Tiempo Supervision Colateral
                vm.tdata.telefonia.detect_vox = parseInt(vm.vdata[9].Value);              //VOX en BL ???
                vm.tdata.telefonia.umbral_vox = vm.vdata[10].Value;             //Umbral VOX en BL
                vm.tdata.telefonia.tm_inactividad = vm.vdata[11].Value;         //Cola VOX
                vm.tdata.telefonia.iT_Int_Warning = vm.vdata[12].Value;         // Periodo Interrupt Warning.
                break;
            case 3:
                if ((vm.tdata.telefonia.tipo == 3 || vm.tdata.telefonia.tipo == 4 || vm.tdata.telefonia.tipo == 6)) {
                    vm.tdata.telefonia.ats_rangos_org = lista2ats(vm.vdata[4].Value);
                    vm.tdata.telefonia.ats_rangos_dst = lista2ats(vm.vdata[6].Value);
                    console.log("Salvo ATS");
                }
                else {
                    vm.tdata.restriccion = parseInt(vm.vdata[0].Value);
                    vm.tdata.blanca = jamp_no_sip == 1 ? CfgService.poner_sip(vm.vdata[1].Value) : vm.vdata[1].Value;
                    vm.tdata.negra = jamp_no_sip == 1 ? CfgService.poner_sip(vm.vdata[2].Value) : vm.vdata[2].Value;
                    console.log("Salvo BN");
                }

                break;
        }
    }

    /** */
    function ats2lista(ats) {
        var lista = [];

        $.each(ats,
            function (index, value) {
                if (value.inicial == '' || value.final == '')
                    lista.push('');
                else
                    lista.push(value.inicial + '-' + value.final);
            });
        return lista;
    }

    /** */
    function lista2ats(lista) {
        var ats = [];
        $.each(lista,
            function (index, value) {
                if (value == "") {
                    ats.push({ inicial: '', final: '' });
                }
                else {
                    var match = value.match(regx_atsrango);
                    if (match) {
                        var abonados = value.split('-');
                        ats.push({ inicial: abonados[0], final: abonados[1] });
                    }
                    else {
                        alert(/*"Error Formato Rango: "*/transerv.translate('ICTRL_MSG_01') + value);
                    }
                }
            });
        return ats;
    }

    /** */
    function validate_lbn() {
        var validate = true;
        if (vm.vdata[0].Value == 1) {       // lista negra
            angular.forEach(vm.vdata[2].Value, function (value, index) {
                if (!ValidateService.uri_val(value)) validate = false;
            });
        }
        else if (vm.vdata[0].Value == 2) { // lista blanca.
            angular.forEach(vm.vdata[1].Value, function (value, index) {
                if (!ValidateService.uri_val(value)) validate = false;
            });
        }
        return validate;
    }

    /** */
    function validate_ranges() {
        var validate = true;
        
        /** Los rangos origen */
        angular.forEach(vm.vdata[4].Value, function(value,index){
            if (!vm.validate_ats_range(value)) validate = false;
        });

        /** Los rangos destino */
        angular.forEach(vm.vdata[6].Value, function (value, index) {
            if (!vm.validate_ats_range(value)) validate = false;
        });

        return validate;
    }

    /** */
    function validate_page() {

        if (vm.tdata == undefined)
            return true;

        switch (vm.pagina) {
            case 0:
                if (vm.vdata[3].Show(3) && !ValidateService.uri_val(vm.vdata[3].Value)) return false;
                break;
            case 1:
                if (vm.vdata[2].Show(2) && !vm.cbmad_val(vm.vdata[2].Value)) return false;
                if (vm.vdata[4].Show(4) && !vm.cbmda_val(vm.vdata[4].Value)) return false;
                break;
            case 2:
                if (vm.vdata[1].Show(1) && !ValidateService.uri_val(vm.vdata[1].Value)) return false;
                if (vm.vdata[3].Show(3) && !vm.ptre_val(vm.vdata[3].Value)) return false;
                if (vm.vdata[5].Show(5) && !vm.validate_ats_number(vm.vdata[5].Value)) return false;
                if (vm.vdata[6].Show(6) && !vm.validate_ats_number(vm.vdata[6].Value)) return false;
                if (vm.vdata[8].Show(8) && !vm.tsup_val(vm.vdata[8].Value)) return false;
                if (vm.vdata[10].Show(10) && !vm.vox_val(vm.vdata[10].Value)) return false;
                if (vm.vdata[11].Show(11) && !vm.cvox_val(vm.vdata[11].Value)) return false;
                break;
            case 3:
                if ((vm.tdata.telefonia.tipo == 3 || vm.tdata.telefonia.tipo == 4 || vm.tdata.telefonia.tipo == 6)) {
                    if (!validate_ranges()) return false;
                }
                else {
                    if (!validate_lbn()) return false;
                }
                break;
        }
        return true;
    }

    /** */
    function Init() {
        vm.selected = "0";
        vm.current = -1;
        vm.pagina = 0;
    }

    /** */
    CfgService.init().then(function () {
        get_telef();
        vm.selected = $routeParams.recId == -1 ? CfgService.telef_last_get().toString() :
                CfgService.telef_index_get(Math.floor($routeParams.recId / 4), $routeParams.recId % 4).toString();
        vm.update_telef();
    });

    /** Cambio de Vista... */
    $scope.$on("$locationChangeStart", function (event) {
        if (!validate_page()) {
            alert(/*"Existen Errores de Formato o Rango. No puede cambiar de vista..."*/transerv.translate('ICTRL_MSG_01'));
            event.preventDefault();
        }
        else
            set_telef_data(parseInt(vm.selected));
    });

    /** Se ha pulsado el boton -aplicar- */
    $scope.$on('savecfg', function (data) {
        console.log("savecfg");
        if (!validate_page()) {
            alert(/*"Existen Errores de Formato o Rango. No puede salvar lo cambios..."*/transerv.translate('ICTRL_MSG_01'));
        }
        else {
            if (CfgService.test_ip_virtual() == true ||
                confirm(transerv.translate('GCTRL_IPV_WARNING')) == true) {
                CfgService.aplicar_cambios();
            }
        }
    });

    /** */
    $scope.$on('loadcfg', function (data) {
        Init();
        get_telef();
        vm.selected = CfgService.telef_last_get().toString();
        vm.update_telef();
    });
}
