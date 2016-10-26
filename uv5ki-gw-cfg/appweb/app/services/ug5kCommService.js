/** */
angular
    .module('Ug5kweb')
    .factory('dataservice', dataservice);

dataservice.$inject = ['$http', 'logger', 'Simulador', '$q'];

/** */
function dataservice($http, logger, Simulador, $q)
{
    return {
		logout: function () {
			return remotePost(rest_url_logout);
		}
		, get_tses: function() {
			return remoteGet(rest_url_tses);
		}
		, get_config: function() {
			return remoteGet(rest_url_config);
		}
		, set_config: function(cfg) {
			return remotePost(rest_url_config, cfg);
		}
		, upload_config: function() {
			return remotePost(rest_url_upconfig);
		}

		/** para ir eliminado */
        , get_data: getData,
        set_data: setData,
        put_data: putData,
        del_data: delData,
        send_file: sendFile,
        post: function (url) {
            return $http.post(url, "{}", {
                transformRequest: angular.identity,
                headers: {
                    'Content-Type': 'application/json,  charset=UTF-8'
                }
            });
        },
        get: function (url) {
            return $http.get(url, { header: { 'Content-Type': 'application/json; charset=UTF-8' } });
        }
//        get: function (url) {
//            return $http.get(url)
//                .then(function (response) { return response; });
////                .catch(DataFailed);
//        }
    };

	//
	function remoteGet(url) {
		return $http.get(normalizeUrl(url), {header : {'Content-Type' : 'application/json; charset=UTF-8'}});
	}

	//
	function remotePost(url, data) {
		return $http.post(normalizeUrl(url), data);
	}

	//
	function remotePut(url, data) {
		return $http.put(normalizeUrl(url), data);
	}

	//
	function remoteDel(url) {
		return $http.delete(normalizeUrl(url));
	}

	//
	function normalizeUrl(url) {
		if (Simulate == false)
			return url;
		return "./simulate" + url + ".json";
	}	
	
	/** Obsoletas. Para ir eliminando... */
	/** obsoleta */
    function DataFailed(error)
    {
        logger.error('XHR Failed: ' + error.data);
        return {error: error.data};
    };
    /** obsoleta */
    function getData(url, simul)
    {
            if (simul === true) {
                return Simulador.get_data(url).then(function (response) { return response; });
            } else {
                return $http.get(url, { header: { 'Content-Type': 'application/json; charset=UTF-8' } })
                    .then(function (response) { return response.data; })
                    .catch(DataFailed);
            }
    }

    /** obsoleta */
    function setData(url, data, simul)
    {
            if (simul === true) {
                return Simulador.set_data(url).then(function (response) { return response; });
            } else {
                return $http.post(url, data, { header: { 'Content-Type': 'application/json; charset=UTF-8' } })
                    .then(function (response) { return response.data; })
                    .catch(DataFailed);
            }
    }

    /** obsoleta */
    function putData(url, data)
    {
        return $http.put(url, data, { header: { 'Content-Type': 'application/json; charset=UTF-8' } })
				.then(function (res) { return res.data; })
				.catch(DataFailed);
    }

    /** obsoleta */
    function delData(url, data)
    {
            return $http.delete(url)
				.then(function (res) { return "OK"; })
				.catch(DataFailed);
    }

    /** obsoleta */
    function sendFileBlock(url, filename, nb, b, data, ldata, ret)
    {

        if (!ret) {
            ret = $q.defer();
        }

        if (b > nb)
            ret.resolve();
        else {
            var config = {
                headers: {
                    'Filename': filename,
                    'UploadControl': b + ':' + nb,
                    'Content-Type': 'application/octet-stream'
                }
            };
            $http.post(url, data, config)
                .then(
                function (response)
                {
                    sendFileBlock(url, filename, nb, b + 1, data, 1024, ret);
                })
                .catch(
                function (error)
                {
                    ret.reject(error.data);
                });
        }

        return ret.promise;
    }

    /** obsoleta */
    function sendFile1(url, filename, data, ldata)
    {
        var ret = $q.defer();


            sendFileBlock(url, filename, 1, 1, data, ldata)
                .then(
                    function () { ret.resolve("Fichero Enviado"); },
                    function (error) { ret.reject(error); }
                    );

        return ret.promise;
    }

    /** obsoleta */
    function sendFile(url, file, ids, version)
    {
        var fd = new FormData();
        fd.append('file', file);

        return $http.post(url, fd, {
            transformRequest: angular.identity,
            headers: {
                'Content-Type': undefined, 'Filename': file.name, 'ids': ids, 'version': version
            }
        });
    }

}