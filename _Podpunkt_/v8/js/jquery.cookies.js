function cookiesAccept() {

        checkCookie();

        function getCookie(c_name) {
            var i, x, y, ARRcookies = document.cookie.split(";");

            for (i = 0; i < ARRcookies.length; i++) {
                x = ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
                y = ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
                x = x.replace(/^\s+|\s+$/g,"");
                if (x == c_name) { return unescape(y); }
            }
        }

        function setCookie() {
            var exdate = new Date();
            exdate.setDate(exdate.getDate() + 365);
            var c_value = escape('1') + ((365==null) ? "" : "; expires=" + exdate.toUTCString());
            document.cookie = 'cookies_info' + "=" + c_value;

            //animate cookie div
            $('.cookie').animate({"opacity":0, "height":0}, 300);
            setTimeout(function() {$('.cookie').css({"display":"none"});}, 300);
        }

        function checkCookie() {
            var cookies_info = getCookie("cookies_info");
            if (cookies_info == null || cookies_info == "") {
                $(document).on({ "touchstart, click": function () { setCookie(); } }, '.cookie span');
            } else { 
                $('.cookie').css({"display":"none"});  
            }
        }

}

$(document).ready(function() {
        cookiesAccept();
});   