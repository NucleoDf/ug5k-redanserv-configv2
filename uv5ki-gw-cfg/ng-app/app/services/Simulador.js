// logger.js
angular
	.module('Ug5kweb')
	.factory('Simulador', Simulador);

	Simulador.$inject = ['$q'];
	
function Simulador($q) {
	var lradios = [{slv:0,can:0,id:'Radio-11'},{slv:1,can:1,id:'Radio-12'}];
	var ltelef = [{slv:0,can:0,id:'Telef-21'},{slv:1,can:1,id:'Telef-22'}];
	var rradios = [
	{
      IdRecurso: 'Radio/Telef-11',
      Radio_o_Telefonia: 0,
      SlotPasarela: 0,
      NumDispositivoSlot: 0,
      TamRTP: "20",
      Codec: "0",
      Uri_Local: "uri local",
      Buffer_jitter: {
        min: "Valor mínimo",
        max: "Valor máximo"
      },
      hardware: {
        AD_AGC: 0,
        AD_Gain: 10,
        DA_AGC: 1,
        DA_Gain: -10
      },
      radio: {
        TipoRadio: 0,
        SQ: "h",
        PTT: "h",
        BSS: false,
        ModoConfPTT: "0",
        RepSQyBSS: "1",
        DesactivacionSQ: "1",
        TimeoutPTT: "200",
        MetodoBSS: "0",
        UmbralVAD: "-33",
        NumFlujosAudio: "1",
        TiempoPTT: "0",
        tm_ventana_rx: "100",
        climax_delay: 1,
        modo_compensacion: 1,
        bss_rtp: 0,
        tabla_indices_calidad: [],
        colateral: {
          name: "FRECUENCIA-1",
          tipoConmutacion: 0,
          emplazamientos: [
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A o B",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A o B"
            },
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A"
            },
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A"
            }
          ]
        }
      },
      telefonia: {
        TipoTelefonia: 0,
        Lado: 1,
        t_eym: 0,
        h2h4: 0,
        r_automatica: 0,
        uri_remota: "uri"
      },
      restriccion: 0,
      listablanca: [
        "uri0",
        "uri1",
        "uri2",
        "uri3"
      ],
      listanegra: [
        "uri0",
        "uri1",
        "uri2",
        "uri3"
      ]
    },
	{
      IdRecurso: 'Radio/Telef-12',
      Radio_o_Telefonia: 1,
      SlotPasarela: 0,
      NumDispositivoSlot: 0,
      TamRTP: "20",
      Codec: "0",
      Uri_Local: "uri local",
      Buffer_jitter: {
        min: "Valor mínimo",
        max: "Valor máximo"
      },
      hardware: {
        AD_AGC: 1,
        AD_Gain: -15,
        DA_AGC: 0,
        DA_Gain: 5
      },
      radio: {
        TipoRadio: 1,
        SQ: "h",
        PTT: "h",
        BSS: false,
        ModoConfPTT: "0",
        RepSQyBSS: "1",
        DesactivacionSQ: "1",
        TimeoutPTT: "200",
        MetodoBSS: "0",
        UmbralVAD: "-33",
        NumFlujosAudio: "1",
        TiempoPTT: "0",
        tm_ventana_rx: "100",
        climax_delay: 1,
        modo_compensacion: 1,
        bss_rtp: 0,
        tabla_indices_calidad: [],
        colateral: {
          name: "FRECUENCIA-2",
          tipoConmutacion: 0,
          emplazamientos: [
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A o B",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A o B"
            },
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A"
            },
            {
              uriTxA: "uriA",
              uriTxB: "uriB",
              activoTx: "A",
              uriRxA: "uriA",
              uriRxB: "uriB",
              activoRx: "A"
            }
          ]
        }
      },
      telefonia: {
        TipoTelefonia: 0,
        Lado: 1,
        t_eym: 0,
        h2h4: 0,
        r_automatica: 0,
        uri_remota: "uri"
      },
      restriccion: 0,
      listablanca: [
        "uri0",
        "uri1",
        "uri2",
        "uri3"
      ],
      listanegra: [
        "uri0",
        "uri1",
        "uri2",
        "uri3"
      ]
    }
	];
	var retorno = 
	{
        /** */
	    get_data: function (url) {
	        var deferred = $q.defer();
	        var datacomp = url.split('/');
	        if (datacomp.length > 1) {
	            if (datacomp[1] === "radios") {
	                if (datacomp.length === 2)
	                    deferred.resolve(lradios);
	                else {
	                    deferred.resolve(rradios[parseInt(datacomp[2])]);
	                }
	            } else if (datacomp[1] === "telef") {
	                if (datacomp.length === 2)
	                    deferred.resolve(ltelef);
	                else {
	                    deferred.resolve(rradios[parseInt(datacomp[2])]);
	                }
	            } else if (datacomp[1] === "mant") {
	            } else {
	                deferred.resolve('URL No Implementada en Simulador. ' + url);
	            }
	        } else {
	            deferred.resolve('Error URL Simulador. ' + url);
	        }
	        return deferred.promise;
	    },
	    set_data: function(url, data) {
	        var deferred = $q.defer();
	        var datacomp = url.split('/');
	        if (datacomp.length > 1) {
	            if (datacomp[1] === "radios") {
	                deferred.resolve("OK");	            
	            } else if (datacomp[1] === "telef") {
	                deferred.resolve("OK");
	            } else if (datacomp[1] === "mant") {
	                deferred.resolve("OK");
	            } else {
	                deferred.resolve('URL No Implementada en Simulador. ' + url);
	            }
	        } else {
	            deferred.resolve('Error URL Simulador. ' + url);
	        }
	        return deferred.promise;
	    }
	};
	return retorno;
}