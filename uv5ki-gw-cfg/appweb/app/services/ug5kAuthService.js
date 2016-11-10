/** */
angular
    .module('Ug5kweb')
    .factory('authservice', authservice);

authservice.$inject = ['MantService', '$q', '$location', '$rootScope'];

/** */
function authservice(MantService, $q, $location, $rootScope) {
    var retorno = {
        browser_support: BrowserSupport
        , check_session_route: CheckSession
        , check_session: CheckSession_old
        , profile: Profile
        , ProfilePermission: ProfilePermission
        , Confirma: Confirma
        , global_enable: function (perfiles) {
            if (ProfilePermission(true, perfiles)==false)
                return false;
            var aislado = MantService.global_estado()==-3 ? true : false;
            if (aislado == false && MantService.modo() == "ul")
                return false;
            return true;
        }
        , global_validate: function (local_validate) {
            var aislado = MantService.global_estado() == -3 ? true : false;
            return (aislado == true) ? local_validate : MantService.modo() == "ul" ? true : local_validate;
        }
    };

    /** */
    function CheckSession_old() {
        var match = document.cookie.match(new RegExp('ssid' + '=([^;]+)'));
        if (session_supervision===true && !!match) {
            $location.path(routeForUnauthorizedAccess);
            return false;
        }
        return true;
    }

    /** */
    function CheckSession() {
        var deferred = $q.defer();
        var match = document.cookie.match(new RegExp('ssid' + '=([^;]+)'));

        if (session_supervision===true && !match) {
            $location.path(routeForUnauthorizedAccess);
            $rootScope.$on('$locationChangeSuccess', function (next, current) {
                deferred.resolve();
            });
        }
        else {
            deferred.resolve();
        }
        return deferred.promise;
    }

	/** */
	function Profile() {
		var match = document.cookie.match(new RegExp('ssid' + '=([^;]+)'));
		if (!match)
			return session_supervision===true ? 0 : 64;
		var _profile = parseInt(match[1].split('|')[1]);
		return _profile;
	}

	
    /** */
	function BrowserSupport() {
	    if (window.File && window.FileReader && window.FileList && window.Blob) {
	        alert("File API supported.!");
	    } else {
	        alert("The File APIs are not fully supported in this browser.");
	    }
	}

    /** */    
	function Confirma(msg) {
	    if (CheckSession_old() && confirm(msg))
	        return true;
	    return false;
	}

    /** */
	function ProfilePermission(global, profileList) {
	    if (global === true) {
	        if (typeof profileList == "undefined")
	            return false;

	        if (profileList.constructor === Array) {
	            var currentProfile = Profile();
	            for (i = 0; i < profileList.length; i++) {
	                if (currentProfile === profileList[i])
	                    return true;
	            }
	        }
	    }
	    return false;
	}

	return retorno;
}