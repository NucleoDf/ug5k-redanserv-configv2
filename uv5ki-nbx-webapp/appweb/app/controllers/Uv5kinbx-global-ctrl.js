/** */
angular.module("Uv5kinbx")
.controller("uv5kiGlobalCtrl", function($scope) {
	this.user="agl";
	
	setInterval(function() {
		this.date=(new Date()).toLocaleDateString();
		this.hora=(new Date()).toLocaleTimeString();
	}, 1000);
	
	
});


