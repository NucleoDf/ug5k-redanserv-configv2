/**
 * Created by vjmolina on 13/9/17.
 */

/************************************/
/*	FUNCTION: GetTablesBss	 		*/
/*  PARAMS: 						*/
/*  REV 1.0.2 VMG					*/
/************************************/
var GetExtResources = function(f) {
	/** 20170511 AGL PERFILES */
	if (Authorize($('#BodyRedan').data('perfil'),[ccAdminProfMsc,ccConfiProfMsc])==false) {
		/*if ((($('#BodyRedan').data('perfil') & 16) != 16) && (($('#BodyRedan').data('perfil') & 64) != 64)) {
		 *****************************/
		alertify.error('No tiene asignados permisos para la gestión de las tablas de calificación de audio.');
		return;
	}
	
	$('#AddResources').hide();
	$("#FormResources").show();
	$('#DivResources').animate({width: '535px'});
	
	$.ajax({type: 'GET',
	 	url: '/externalResources'})
	 	.done(function(data){
	 		$("#listResources").empty();
			if (data.lista_uris != null && data.lista_uris.length > 0){
	 			$.each(data.lista_uris, function(index, value){
					 var item = $("<li><a onclick='GetExtResource(" + value.idrecursos_externos + ")'>"+value.alias+": "+value.uri+"</li>");
					 item.appendTo($("#listResources"));
	 			});
				if (f != null)
					f();
	 		}
	 		else{
				var item = $("<li>No hay elementos disponibles</li>");
				item.appendTo($("#listResources"));
			}
	 			
	 		//else if (f != null)
	 		//	f();
	 	});
};

/************************************/
/*	FUNCTION: GetExtResource	 	*/
/*  PARAMS: idTable (IN)			*/
/*  REV 1.0.2 VMG					*/
/************************************/
var GetExtResource = function (idExtResource){
	$('#DivResources').animate({width:'950px'});
	$('#AddResources').show();
	
	$.ajax({
		type: 'GET',
		url: '/externalResources/' + idExtResource,
		success: function(data){
			if (data.lista_uris != null){
				translateWord('Update',function(result){
					$('#UpdateTableButton').text(result)
						.attr('onclick','PutTable()');
				});
				$('#FormResources').data('idrecursos_externos',data.lista_uris[0].idrecursos_externos);
				$('#aliasExtResource').val(data.lista_uris[0].alias);
				$('#uriExtResource').val(data.lista_uris[0].uri);
				$('#RowCreationUser').hide();
				$('#RowCreationDate').show();
				$('#RowModificationUser').hide();
				$('#RowModificationDate').hide();
				//$('#LblCreationUser').text(data.tables[0].UsuarioCreacion);
				$('#LblCreationDate').text(data.tables[0].FechaCreacion);
				//$('#LblModificationUser').text(data.tables[0].UsuarioModificacion);
				//$('#LblModificationDate').text(data.tables[0].FechaModificacion);
				
				$('#CbRssi0 option[value="' + data.tables[0].valor0 +'"]').prop('selected', true);
				$('#CbRssi1 option[value="' + data.tables[0].valor1 +'"]').prop('selected', true);
				$('#CbRssi2 option[value="' + data.tables[0].valor2 +'"]').prop('selected', true);
				$('#CbRssi3 option[value="' + data.tables[0].valor3 +'"]').prop('selected', true);
				$('#CbRssi4 option[value="' + data.tables[0].valor4 +'"]').prop('selected', true);
				$('#CbRssi5 option[value="' + data.tables[0].valor5 +'"]').prop('selected', true);
				$('#DeleteTableButton').show();
				$('#RowValuesTable').show();
			}
		}
	});
};