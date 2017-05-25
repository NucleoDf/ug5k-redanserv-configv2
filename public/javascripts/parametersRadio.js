function ResetRadioParameters(){
	$('#NameResource').text('Resource: ');

	// Ocultar tab de telefonia
	$('#ListMenuParameters li:nth-child(3)').hide();
	$('#ListMenuParameters li:nth-child(6)').hide();
	//  Mostrar tab de radio
	$('#ListMenuParameters li:nth-child(2)').show();

	// Ocultar/Mostrar tab listas dependiendo de si esta seleccionada o no la restricción
	if ($('#LbTypeRadio option:selected').val() < 4 || $('#SRestriccion option:selected').val() == 0)
		$('#ListMenuParameters li:nth-child(4)').hide();
	else
		$('#ListMenuParameters li:nth-child(4)').show();

	$('#CbAdAgc').prop('checked',false);
	$('#TbAdGain').val('0');
	$('#CbDaAgc').prop('checked',false);
	$('#TbDaGain').val('0');
	$('#GranularityRow').attr('style','display:table-row');
	
	// Parametros jitter
	$('#TbMin').val('0');
	$('#TbMax').val('0');
	//$('#TbJitterBufferDelay').val('0');


	$('#LbTypeRadio option[value=0]').prop('selected', true);
	$('#LbSquelchType option[value=0]').prop('selected', true);
	$('#LbPttType option[value=0]').prop('selected', true);
	//$('#TbTiempoMaxPtt').val('0');
	$('#CbBssEnable').prop('checked',false);
	$('#CbBssMethod option[value=0]').prop('selected', true);
	$('#CbBssMethodAvailable option[value=0]').prop('selected', true);
	$('#TbVad').val('0');
	$('#TbSqDesactivacion').val('1');
	$('#TbClimaxDelayoption[value=0]').prop('selected', true);
	$('#CbCompensation').val('100');
	$('#TbBssWindow').val('0');
	$('#TbBssSquelchQueue').val('0');
	$('#CbPttSquelchEvents').prop('checked',false);
	$('#TbGrsInternalDelay').val('0');
	$('#LbPttPriority option[value=0]').prop('selected', true);
	$('#LbSipPriority option[value=0]').prop('selected', true);
}


function AddRadioParameters(){
	var hw={RECURSO_idRECURSO:  $('#DivParameters').data('idRecurso'),
			AD_AGC: 			$('#CbAdAgc').prop('checked') ? '1' : '0',
			AD_Gain:			$('#TbAdGain').val()=='' ? 0 : parseFloat($('#TbAdGain').val())*10,
			DA_AGC:				$('#CbDaAgc').prop('checked') ? '1' : '0',
			DA_Gain:			$('#TbDaGain').val()=='' ? 0 : parseFloat($('#TbDaGain').val())*10
		};
	var rd={RECURSO_idRECURSO:  $('#DivParameters').data('idRecurso'),
			tipo: 				$('#LbTypeRadio option:selected').val(),
			sq: 				$('#LbSquelchType option:selected').val(),
			ptt: 				$('#LbPttType option:selected').val(),
			tiempoPtt: 			0, //$('#TbTiempoMaxPtt').val()=='' ? 0 : $('#TbTiempoMaxPtt').val(),
			bss: 				$('#CbBssEnable').prop('checked')  ? '1' : '0',
			metodoBss: 			$('#LbTypeRadio option:selected').val() > 3 ? $('#CbBssMethod option:selected').val() : $('#CbBssMethodAvailable option:selected').val(),
			umbralVad: 			$('#TbVad').val()=='' ? 0 : $('#TbVad').val(),
			desactivacionSq: 	1, //$('#TbSqDesactivacion').val()=='' ? 0 : $('#TbSqDesactivacion').val(),
			climaxDelay: 		$('#TbClimaxDelay option:selected').val(),
			tmRetardoFijo: 		$('#CbCompensation').val() == '' ? 10 : $('#CbCompensation').val(),
			tmVentanaRx: 		$('#TbBssWindow').val()=='' ? 0 : $('#TbBssWindow').val(),
			retrasoSqOff: 		$('#TbBssSquelchQueue').val()=='' ? 0 : $('#TbBssSquelchQueue').val(),
			evtPTT: 			$('#CbPttSquelchEvents').prop('checked')  ? '1' : '0',
			tjbd:				0,	//$('#TbJitterBufferDelay').val()=='' ? 0 : $('#TbJitterBufferDelay').val(),
			tGRSid: 			$('#TbGrsInternalDelay').val()=='' ? 0 : $('#TbGrsInternalDelay').val(),
			iEnableGI: 			$('#CbEnableRecording').prop('checked') ? '1' : '0',
			iPttPrio: 			$('#LbPttPriority option:selected').val(),
			iSesionPrio: 		$('#LbSipPriority option:selected').val(),
			iPrecisionAudio:	$('#CbGranularity option:selected').val(),
			iModoCalculoClimax: (($('#LbTypeRadio option:selected').val()==2 || $('#LbTypeRadio option:selected').val() ==3) && 
								$('#CbBssEnable').prop('checked') && 
								($('#TbClimaxDelay option:selected').val()==1 || $('#TbClimaxDelay option:selected').val()==2))?$('#TbModoCalculoClimax option:selected').val():0

			//ForcedSignal: 		$('#CbInputSignalForced').prop('checked') ? '1' : '0', 
		};
	var jitter={
		RECURSO_idRECURSO:  $('#DivParameters').data('idRecurso'),
		min: 	$('#TbMin').val()=='' ? 0 : $('#TbMin').val(),
		max: 	$('#TbMax').val()=='' ? 0 : $('#TbMax').val()
	};


	if (($('#LbTypeRadio option:selected').val()==4 || $('#LbTypeRadio option:selected').val()==6 ) &&
		$('#CbBssMethod option:selected').val() == 0 && $('#CbBssAudioTable option:selected').val() == -1){
		alertify.error('El recurso radio debe tener asignado una tabla de calificación de audio.');
		return;
	}
	
	$.ajax({type: 'POST', 
			dataType: 'json', 
			contentType:'application/json',
			url: '/resources/' + $('#DivParameters').data('idRecurso') + '/radioParameters', 
			data: JSON.stringify({
				// Parámetros Hw
				"hw": hw,
				// Parámetros radio
				"rd": rd,
				// Jitter
				"jt": jitter,
				// Tabla calificación de audio
				"tAudio": rd.tipo > 3  ? /* Remoto */ $('#CbBssAudioTable option:selected').val() : /* Local */ $('#CbBssAudioTableAvailble option:selected').val()
			}),
			success: function (data){
				if (data.error == null){
					GenerateHistoricEvent(ID_HW,MODIFY_HARDWARE_RESOURCE_LOGIC_PARAM,$('#TbNameResource').val(),$('#loggedUser').text());
					//alert ('Radio parameters was been updated successfully.')
				}
				Close();
			}
	});
}

function OnChangeClimax(sel){
	if (sel.value == '2'){
		$('#CompensationRow').attr('style','display:table-row');
		//$('#TbGrsInternalDelay').show();
		//$('#LblClimax').show();
	}
	else{
		$('#CompensationRow').attr('style','display:table-column');
		//$('#TbGrsInternalDelay').hide();
		//$('#LblClimax').hide();
	}

	if (sel.value == '1' || sel.value == '2'){
		$('#ModoCalculoClimaxRow').attr('style','display:table-row');
	}
	else{
		$('#ModoCalculoClimaxRow').attr('style','display:table-column');
	}
}

function OnSelectSQActivation(sel){
	if (sel.value != 1)
		$('#VadRow').attr('style','display:table-column');
	else
		$('#VadRow').attr('style','display:table-row');
}

function GetRemoteRadioResources(){
	var cfgName = $('#name').val();
	
	$('#CBFacedSite').empty();
	$('#CBFacedGtw').empty();
	$('#CBFacedResources').empty();

	SelectSite(cfgName);
	
	/*$.ajax({type: 'GET', 
		url: '/resources/remote/' + cfgName + '/null/null',
		success: function(data){
			$('#CBFacedCfg').empty();
			$('#CBFacedSite').empty();
			$('#CBFacedGtw').empty();
			$('#CBFacedResources').empty();

			if (data.data != null){
			    var numCfg = 0;
			    var options = '<option value="" disabled selected>Seleccione configuración</option>';

				$('#CBFacedCfg').append(options);
				$.each(data.data, function(index, value){
					var encontrado = false;

					if ($("#CBFacedCfg option[value='" + value.cfName + "']").length == 0){
						options = '<option value="' + value.cfName + '">' + value.cfName + '</option>';
						$('#CBFacedCfg').append(options);
					}
				})
				
			}
		}
	});	*/
}

function SelectSite(cfgName){
	$.ajax({type: 'GET', 
		url: '/resources/remote/' + cfgName + '/null/null',
		success: function(data){
			$('#CBFacedSite').empty();$('#CBFacedSite').text('');
			$('#CBFacedGtw').empty();$('#CBFacedGtw').text('');
			$('#CBFacedResources').empty();$('#CBFacedResources').text('');

			if (data.data != null){
			    var numCfg = 0;
			    var options = '<option value="" disabled selected>Seleccione emplazamiento</option>';

				$('#CBFacedSite').append(options);
				$.each(data.data, function(index, value){
					var encontrado = false;

					if ($("#CBFacedSite option[value='" + value.eName + "']").length == 0){
						options = '<option value="' + value.eName + '">' + value.eName + '</option>';
						$('#CBFacedSite').append(options);
					}
				});
			}
		}
	});
}

function SelectGtw(cfgName,site){
	$.ajax({type: 'GET', 
		url: '/resources/remote/' + cfgName + '/' + site + '/null',
		success: function(data){
			$('#CBFacedGtw').empty();$('#CBFacedGtw').text('');
			$('#CBFacedResources').empty();$('#CBFacedResources').text('');

			if (data.data != null){
			    var numCfg = 0;
			    var options = '<option value="" disabled selected>Seleccione pasarela</option>';

				$('#CBFacedGtw').append(options);
				$.each(data.data, function(index, value){
					var encontrado = false;

					if ($("#CBFacedGtw option[value='" + value.gName + "']").length == 0){
						options = '<option value="' + value.gName + '">' + value.gName + '</option>';
						$('#CBFacedGtw').append(options);
					}
				});
			}
		}
	});
}

function SelectResource (cfgName,site,gtw){
	$.ajax({type: 'GET', 
		url: '/resources/remote/' + cfgName + '/' + site + '/' + gtw,
		success: function(data){
			$('#CBFacedResources').empty();$('#CBFacedResources').text('');
			
			if (data.data != null){
			    var numCfg = 0;
			    var options = '<option value="" disabled selected>Seleccione recurso</option>';

				$('#CBFacedResources').append(options);
				$.each(data.data, function(index, value){
					var encontrado = false;

					if ($("#CBFacedResources option[value='" + value.gIpv + "']").length == 0){
						options = '<option value="' + value.rName + '@' + value.gIpv + '">' + value.rName + '</option>';
						$('#CBFacedResources').append(options);
					}
				});
			}
		}
	});
}

function MakeFacedUri(target){
	// if ($('#CBFacedCfg option:selected').val() == ""){
	// 	alertify.error('Seleccione configuración');
	// 	return;
	// }
	if ($('#CBFacedSite option:selected').val() == ""){
		alertify.error('Seleccione emplazamiento');
		return;
	}
	if ($('#CBFacedGtw option:selected').val() == ""){
		alertify.error('Seleccione pasarela');
		return;
	}
	if ($('#CBFacedResources option:selected').val() == ""){
		alertify.error('Seleccione recurso');
		return;
	}

	$(target).val($("#CBFacedResources option:selected").val());
}