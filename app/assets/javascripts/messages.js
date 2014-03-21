$(document).ready(function(){

    if (document.getElementsByClassName('panel-body')[0]!=undefined){
        document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-152+"px";

        $( window ).resize(function() {
            document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-152+"px";
        });
    }

    var message_textarea=$("#message");

    $("#send_message").click(function(){
        send_message();
    });

    message_textarea.keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey==false) {
            send_message();
            $('html, body').animate({scrollTop: $("body").height()}, 800);
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
        }
    });


    message_textarea.keyup(function(){
        message_textarea_value=message_textarea.val();
        if ((message_textarea_value.indexOf(' @')>-1) || (message_textarea_value.indexOf('@')>-1 && message_textarea_value.indexOf('@')<1)){
            $('#request-user').html('');
            $.ajax({
                type: "POST",
                url: "../users/search/",
                data: { login: $.trim(message_textarea_value.match(/\@(\S+.)/)[1]) }
            }).done(function(msg) {
                    if ((msg.length==0) || (msg[0].login==$.trim(message_textarea_value.match(/\@(\S+.)/)[1]))) {
                        $("#request-user").css("display","none");
                    }else{
                        for (var i = msg.length - 1; i >= 0; i--) {
                            $('#request-user').append('<div data-login="@'+msg[i].login+'" class="replace">@'+msg[i].login+'</div>');
                        };
                        $("#request-user").css("display","block");
                    }
                });

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


    $('#request-user').on('click', '.replace', function(event){
        login=$('#message').val();
        login=login.replace($.trim($('#message').val().match(/\@(\S+.)/)[0]),$(event.currentTarget).attr('data-login'));
        $('#message').val(login);
        $(this).css('display','none');
    });

    eval(function(p,a,c,k,e,d){e=function(c){return c};if(!''.replace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('2.1=\'/3/4?0=\'+5.0.6();',7,7,'room_id|channel_auth_endpoint|Pusher|pusher|auth|gon|toString'.split('|'),0,{}))

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private-'+gon.room_id.toString());

    channel.bind('new_message', function(data) {

        render_message(data.user_id,data.login,data.message,data.avatar,data.create_at);
    });

    function send_message(){
        if ($.trim(message_textarea.val()).length>0){
            $.ajax({
                type: "POST",
                url: "../message/new",
                data: { message: $.trim(message_textarea.val()),room_id: gon.room_id }
            }).done(function(msg) {
                    message_textarea.val('');
                });
        }
    }

    function HtmlEncode(val) {
        var el = $(val);
        if (el.is('iframe')) return val;
        if (el.is('img')) return val;
        return $("<div/>").text(val).html();

    }

    function render_message(user_id,login,body,avatar,time){
        if(gon.user_id==user_id){

            $('#messages-wrapper').append("<li class=\"from clearfix\">"+
                "<span class=\"chat-img pull-left\">"+
                "<img class=\"avatar\""+"src="+avatar+">"+
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
            document.getElementById('new-message').play();
            $('#messages-wrapper').append("<li class=\"to clearfix\">"+
                "<span class=\"chat-img pull-left\">"+
                "<img class=\"avatar\""+"src="+avatar+">"+
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



});