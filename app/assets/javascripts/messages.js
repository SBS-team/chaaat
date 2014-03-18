$(document).ready(function(){
//        var t=document.getElementsByTagName('p')[0].innerHTML.trim();
//    alert(document.getElementsByTagName('p')[0].innerHTML);
//    document.getElementsByTagName('p')[0].innerHTML=t;

    document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-200+"px";

    $( window ).resize(function() {
        document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-200+"px";
    });

    $("#send_message").click(function(){

        send_message();
    });

    $('#message').keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey==false) {
            send_message();
            return false;
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
            return false;
        }
    });

    $('#message').keyup(function(){
        if ((this.value.indexOf(' @')>-1) || (this.value.indexOf('@')>-1 && this.value.indexOf('@')<1)){
            // $("#request-user").css("display","block");
        }else{
            // $("#request-user").css("display","none");
        }
    });


    $("#search").keyup(function(){
        $.ajax({
            type: "POST",
            url: "../message/search/",
            data: { query: $("#search").val() }
        })
            .done(function(msg) {
                $('#messages-wrapper').html('');
                for (var i = 0; i <= msg.length - 1; i++) {
                    render_message(msg[i].user_id,msg[i].login,msg[i].body,msg[i].created_at);
                };
            });
    });

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private');
    channel.bind('new_message', function(data) {
        render_message(data.user_id,data.login,data.message,data.create_at);
    });


    function render_message(user_id,login,body,time){
        if(gon.user_id==user_id){

            $('#messages-wrapper').append("<li class=\"from clearfix\">"+
            "<span class=\"chat-img pull-left\">"+
                "<img class=\"img-circle\" src=\"http://placehold.it/50/55C1E7/fff&text=ME\" alt=\"User Avatar\">"+
            "</span>"+
                "<div class=\"chat-body clearfix\">"+
                "<div class=\"header\">"+
                    "<strong class=\"primary-font\">"+login+"</strong>"+
                    "<small class=\"pull-right text-muted\">"+
                        "<span class=\"glyphicon glyphicon-time\"></span>"+time+
                    "</small>"+
                "</div>"+
                "<p>"+ HtmlEncode(body).trim()+"</p>"+
            "</div>"+
            "</li>");

        }else{
            $('#messages-wrapper').append("<li class=\"to clearfix\">"+
                "<span class=\"chat-img pull-left\">"+
                "<img class=\"img-circle\" src=\"http://placehold.it/50/FA6F57/fff&text=U\" alt=\"User Avatar\">"+
                "</span>"+
                "<div class=\"chat-body clearfix\">"+
                "<div class=\"header\">"+
                "<strong class=\"primary-font\">"+login+"</strong>"+
                "<small class=\"pull-right text-muted\">"+
                "<span class=\"glyphicon glyphicon-time\"></span>"+time+
                "</small>"+
                "</div>"+
                "<p>"+ HtmlEncode(body).trim()+"</p>"+
                "</div>"+
                "</li>");
        }
        var objDiv = document.getElementsByClassName('panel-body')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
    }

    function send_message(){
        if ($.trim( $('#message').val()).length>0){

            $.ajax({
                type: "POST",
                url: "../message/new",
                data: { message:  $('#message').val() }
            }).done(function(msg) {
                    $('#message').val('');
                });
        }
    }

    function HtmlEncode(val) {
        return $("<div/>").text(val).html();
    }

});