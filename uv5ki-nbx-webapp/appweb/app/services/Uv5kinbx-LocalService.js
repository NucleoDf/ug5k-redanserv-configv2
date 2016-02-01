/** */
angular
    .module('Uv5kinbx')
    .factory('$lserv', function ($q, $http) {
        return {
            validate: function (tipo, data, max, min) {
                switch (tipo) {
                    case 0:
                        return true;
                    case 1:                     // IP
                        return ip_val(data);
                    case 2:                     // Numerico entre margenes min <= val <= max
                        return (data >= min && data <= max);
                    default:
                        return true;
                }
            }
        };

        /** */
        function ip_val(value) {
            if (value != "" && value.match(regx_ipval) == null)
                return false;
            return true;
        }

    });

