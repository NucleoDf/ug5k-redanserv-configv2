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
                    case 3:                     // Identificador de Frecuencia VHF
                        return vfrec_val(data);
                    case 4:                     // Identificador de Frecuencia UHF
                        return ufrec_val(data);
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

        /** XXX.YZ */
        function vfrec_val(value) {
            return value.match(regx_fid_vhf) != null;
        }

        /** XXX.YZ */
        function ufrec_val(value) {
            return value.match(regx_fid_uhf) != null;
        }
    });

