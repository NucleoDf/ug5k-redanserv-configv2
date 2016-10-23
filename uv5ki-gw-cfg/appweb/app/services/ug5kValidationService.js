/** */
angular
    .module('Ug5kweb')
    .factory('ValidateService', ValidateService);

ValidateService.$inject = ['$q'];

/** */
function ValidateService($q) {

    /** */
    function local_max_length_val(value, maximo) {
        if (maximo === undefined)
            maximo = max_id_length;
        if (typeof value === "string")
            return value.length > maximo ? false : true;
        return true;
    }

    /** */
    return {
        def_val: function () {
            return true;
        }
        ,ip_val: function (value) {
            if (value != "" && value.match(regx_ipval) == null)
                return false;
            return true;
        }
        ,url_val: function (value) {
            if (value != "" && value.match(regx_ipportval) == null)
                return false;
            return true;
        }
        , uri_val: function (value) {
            if (local_max_length_val(value, max_id_length + 16) === false)
                return false;
            if (value != "" && value.match(jamp_no_sip == 1 ? regx_urival_nosip: regx_urival) == null)
                return false;
            return true;
        }
        ,uri_rtsp_val: function (value) {
            if (value != "" && value.match(regx_urirtspval) == null)
                return false;
            return true;
        }
        , max_long_val: function (value) {
            return local_max_length_val(value);
        }
    };
}