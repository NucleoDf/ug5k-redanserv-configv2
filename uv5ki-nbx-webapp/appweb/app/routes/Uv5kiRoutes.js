/** */
angular
    .module('Uv5kinbx')
    .config(config);

function config($routeProvider) {
    $routeProvider
        .when('/', {
            templateUrl: 'app/views/Uv5kinbx-generales.html',
            controller:  'uv5kiGeneralesCtrl'
			})
		// .when(routeForUnauthorizedAccess, {
		    // templateUrl: 'app/views/session-expired.html'
		    // // templateUrl: 'session-expired.html'
            // }
		// );
}