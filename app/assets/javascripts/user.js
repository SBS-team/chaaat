$(document).ready(function(){

    $('.change-status').on('click',function(event){
        var strInputCode = $(this)[0].text;
        var strTagStrippedText = strInputCode.replace(/[\n]( *) /, "");
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


    rightPanel=$('.right_panel')[0].clientHeight;
    $('.list').css('height',rightPanel-78);
    window.onresize = function(event) {
        newHeight=$('.panel-default')[0].offsetTop;
        $('.list').css('height',newHeight-30);
        $('.right_search').css('height',$('.panel-default')[0].clientHeight-80);
    }

    clicked=false
    $('.collapsed').on('click',function(){
        rightPanel=$('.right_panel')[0].clientHeight;
        if (clicked==false){
            $('.panel-default').css('height','50%');
            bottomPanel=$('.panel-default')[0].clientHeight;
            $('.right_search ').css('height',bottomPanel-118);
            $('.list').css('height',rightPanel/2-30);
            $('.right_search').css('height',$('.panel-default')[0].clientHeight-80);
            clicked=true;
        }
        else{
            $('.panel-default').css('height','auto');
            $('.list').css('height', rightPanel-78);
            clicked=false;
        }
    });

});