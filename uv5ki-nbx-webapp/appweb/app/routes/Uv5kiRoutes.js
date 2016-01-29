/** */
angular
    .module('Uv5kinbx')
    .config(config);

function config($routeProvider) {
    $routeProvider
        .when(routeDefault, {
            templateUrl: 'app/views/Uv5kinbx-generales.html',
            controller: 'uv5kiGeneralesCtrl',
            controllerAs: 'ctrl'
			})
        .when(routeConfig, {
            templateUrl: 'app/views/Uv5kinbx-config.html',
            controller: 'uv5kiConfigCtrl',
            controllerAs: 'ctrl'
        })
    // .when(routeForUnauthorizedAccess, {
		    // templateUrl: 'app/views/session-expired.html'
		    // // templateUrl: 'session-expired.html'
            // }
		// );
}

