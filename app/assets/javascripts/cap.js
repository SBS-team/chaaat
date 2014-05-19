function msieversion() {
    var ua = window.navigator.userAgent
    var msie = ua.indexOf ( "MSIE " )

    if ( msie > 0 )      // If Internet Explorer, return version number
       return parseInt (ua.substring (msie+5, ua.indexOf (".", msie )))
    else                 // If another browser, return 0
       return 0

}

window.onload = function() {
    ieversion = msieversion();
    if ( ieversion < 10 && ieversion >= 3){
        var newDiv = document.createElement('div');
        newDiv.className = 'bws_reload';
        $("body").html( '<div class="cwrp"><h1>Did you know that your Internet Browser is out of date?</h1><p>Your browser is out of date, and may not be compatible with our website. </p> <p> A list of the most popular web browsers can be found below. It is insistently recommended to you to choose and establish any of modern browsers.</p>'+
            '<p>Just click on the icons to get to the download page.  It is free of charge and also will take only some minutes.</p>' +
            '<ul><li class="firefox"><h2>Mozilla Firefox</h2><div><ul class="file"><li style="padding-left: 0px;"><noindex><a rel="nofollow" href="http://www.mozilla.org/en-US/firefox/new/">Mozilla Firefox</a></noindex></li></ul></div></li>' +
            '<li class="chrome"><h2>Google Chrome</h2><div><ul class="file"><li style="padding-left: 0px;"><noindex><a rel="nofollow" href="https://www.google.com/intl/en/chrome/browser/">Google Chrome</a></noindex></li></ul></div></li>' +
            '<li class="opera"><h2>Opera</h2><div><ul class="file"><li style="padding-left: 0px;"><noindex><a rel="nofollow" href="http://www.opera.com/">Opera</a></noindex></li></ul></div></li>' +
            '<li class="ie"><h2>Internet Explorer</h2><div><ul class="file"><li style="padding-left: 0px;"><noindex><a rel="nofollow" href="http://windows.microsoft.com/en-us/windows/home">Internet Explorer</a></noindex></li></ul></div></li></ul></div>');
        document.body.appendChild(newDiv);
    }
}
