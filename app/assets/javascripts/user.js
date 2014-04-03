$(document).ready(function(){

    $('.change-status').on('click',function(event){
        var strInputCode = $(this)[0].text;
        strTagStrippedText = strInputCode.replace(/[\n]( *) /, "");
        $.ajax({
            type: "GET",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "../users/status/",
            dataType: "html",
            contentType: "text/html; charset=utf-8",
            data: { status: strTagStrippedText}
        })
            .done(function(msg) {
                $("#drop1.dropdown-toggle.avail")[0].innerHTML ="<span class=\""+get_user_status_style(msg)+"\"></span>"+msg+"<span class=\"glyphicon glyphicon-hand-down\"></span>";
            });
    });
});