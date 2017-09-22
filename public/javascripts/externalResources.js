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
			if (data.tables != null && data.tables.length > 0){
	 			$.each(data.tables, function(index, value){
					 var item = $("<li><a onclick='GetTable(" + value.idtabla_bss + ")'>" + value.name + "</li>");
					 item.appendTo($("#listTablesBss"));
	 			});
				if (f != null)
					f();
	 		}
	 		else if (f != null)
	 			f();
	 	});
};
