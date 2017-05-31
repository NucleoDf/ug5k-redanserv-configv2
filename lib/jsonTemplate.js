/**
 * Created by vjmolina on 25/5/17.
 */

exports.fillTemplate = function fillTemplate(object) {
	var template=emptyTemplate();
	
	var result = extend(object, template);
	
	return result;
}

function emptyTemplate() {
	var template =
		{
			"tipo": 1,
			"idConf": "",
			"fechaHora": "",
			"general": {
				"name": "",
				"emplazamiento": "",
				"dualidad": 1,
				"ipv": "",
				"ips": "",
				"nivelconsola": 0,
				"puertoconsola": 19710,
				"nivelIncidencias": 3,
				"cpus": [
					{
						"tlan": 1,
						"ip0": "",
						"ms0": "",
						"ip1": "",
						"ms1": "",
						"ipb": "192.168.0.50",
						"msb": "255.255.255.0",
						"ipg": "192.168.0.1"
					},
					{
						"tlan": 1,
						"ip0": "",
						"ms0": "",
						"ip1": "",
						"ms1": "",
						"ipb": "192.168.0.52",
						"msb": "255.255.255.0",
						"ipg": "192.168.0.1"
					}
				]
			},
			"hardware": {
				"slv": [
					{
						"tp": 0,
						"pos": [
							{
								"tp": 1,
								"cfg": 1
							},
							{
								"tp": 1,
								"cfg": 1
							},
							{
								"tp": 0,
								"cfg": 0
							},
							{
								"tp": 0,
								"cfg": 0
							}
						]
					},
					{
						"tp": 0,
						"pos": [
							{
								"tp": 1,
								"cfg": 2
							},
							{
								"tp": 1,
								"cfg": 2
							},
							{
								"tp": 1,
								"cfg": 2
							},
							{
								"tp": 1,
								"cfg": 2
							}
						]
					},
					{
						"tp": 0,
						"pos": [
							{
								"tp": 1,
								"cfg": 2
							},
							{
								"tp": 1,
								"cfg": 2
							},
							{
								"tp": 0,
								"cfg": 0
							},
							{
								"tp": 0,
								"cfg": 0
							}
						]
					},
					{
						"tp": 0,
						"pos": [
							{
								"tp": 0,
								"cfg": 0
							},
							{
								"tp": 0,
								"cfg": 0
							},
							{
								"tp": 0,
								"cfg": 0
							},
							{
								"tp": 1,
								"cfg": 1
							}
						]
					}
				]
			},
			"recursos": [],
			"users": [],
			"servicios": {
				"name": "MADRID-REGION-5-GW-01-01",
				"idSERVICIOS": 25,
				"sip": {
					"PuertoLocalSIP": 5060,
					"KeepAlivePeriod": 200,
					"KeepAliveMultiplier": 10,
					"SupresionSilencio": 0,
					"PeriodoSupervisionSIP": 90,
					"proxys": [
						{
							"ip": "10.5.1.250",
							"selected": 1
						},
						{
							"ip": "",
							"selected": 0
						}
					],
					"registrars": [
						{
							"ip": "10.5.1.250",
							"selected": 1
						},
						{
							"ip": "",
							"selected": 0
						}
					]
				},
				"web": {
					"wport": 8080,
					"stime": 0
				},
				"snmp": {
					"agcomm": "public",
					"agcont": "NUCLEO-DF DT. MADRID. SPAIN",
					"agloc": "NUCLEO-DF LABS",
					"agname": "ULISESG5000i",
					"agv2": 1,
					"sport": 65000,
					"snmpp": 161,
					"traps": [
						"2,10.5.1.250/162",
						""
					]
				},
				"grab": {
					"rtsp_ip": "10.5.1.250",
					"rtspb_ip": "127.0.0.1",
					"rtsp_port": 554,
					"rtsp_uri": "",
					"sport": 65001,
					"rtsp_rtp": 1,
					"rtp_pl": 8,
					"rtp_sr": 8000
				},
				"sincr": {
					"ntp": 2,
					"servidores": [
						{
							"ip": "10.5.1.250",
							"selected": 1
						},
						{
							"ip": "192.168.0.129",
							"selected": 0
						}
					]
				}
			},
			"ulises": {
				"MulticastGroup": "224.100.10.1",
				"MulticastPort": 1000,
				"plannumeracionats": [],
				"plandireccionamientoip": [],
				"plantroncales": [],
				"planredes": [],
				"planasignacionusuarios": [],
				"planasignacionrecursos": [],
				"plandireccionamientosip": []
			}
		}
	return template;
}

function extend(a, b){
	for(var key in b)
		if(b.hasOwnProperty(key))
			a[key] = b[key];
	return a;
}