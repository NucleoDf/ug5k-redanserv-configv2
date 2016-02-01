/** */
angular
    .module('Uv5kinbx')
    .factory('$serv', function ($q, $http) {
        return {
            stdgen_get: function () {
                return remoteGet(rest_url_std);
            }
            , preconf_list: function () {
                return remoteGet(rest_url_preconf);
            }
            , preconf_delete: function (name) {
                return remoteDel(rest_url_preconf + "/" + name);
            }
            , preconf_activate: function (fecha, name) {
                return remotePost(rest_url_preconf, { fecha: fecha, nombre: name });
            }
            , preconf_saveas: function (name) {
                return remotePut(rest_url_preconf);
            }
            , lconfig_get: function () {
                return remoteGet(rest_url_local_config);
            }
            , lconfig_set: function (data) {
                return remotePost(rest_url_local_config, data);
            }
        };

        //
        function remoteGet(url) {
            return $http.get(normalizeUrl(url));
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
        function remoteDel(url, data) {
            return $http.delete(normalizeUrl(url));
        }

        //
        function normalizeUrl(url) {
            if (Simulate == false)
                return url;
            return "./simulate" + url + ".json";
        }

    });

