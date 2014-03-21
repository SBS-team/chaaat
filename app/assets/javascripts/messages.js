$(document).ready(function(){

 $(document).on('click', '.bla', function(e) {
    $("#message").val($("#message").val() + $(e.target).attr("title"));
    });
    $(document).on('click', '.bla', function(e) {
        $("#message").val($("#message").val() + $(e.target).attr("title"));
    });
    if (document.getElementsByClassName('panel-body')[0]!=undefined){
        document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-250+"px";

        $( window ).resize(function() {
            document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-250+"px";
        });
    }

    var message_textarea=$("#message");

    $("#send_message").click(function(){
        send_message();

    });


    function send_message(){
        $.ajax({
            type: "POST",
            url: "message/new",
            data: { message: $("#message").val() }
        })
            .done(function(msg) {
                $("#message").val('');
            });
    };

    $('#message').keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey==false) { send_message();$('html, body').animate({scrollTop: $("body").height()}, 800); return false; }
        if (e.keyCode ==13 && e.ctrlKey) {document.getElementById('message').value += "\r\n"; return false;}

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



    var pusher =new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private');
    //+gon.user_id.toString()
    channel.bind('new_message', function(data) {

        render_message(data.user_id,data.login,data.message,data.create_at);
//        $('#messages').append("<div id='user_name'>"+data.firstname+':'+"</div>"+"<div id='message_body'>"+HtmlEncode(data.message).replace(/\n/g,"<br>")+"</div>"+"<span class=\"pull-right time\">"+data.create_at+"</span><br>");
    });

    function render_message(user_id,login,body,time){
        if(gon.user_id==user_id){
            $('#messages-wrapper').append("<pre class=\"message to\">"+"<div class=\"message_login\" style=margin:0px;>"+login+':'+"</div>"+"<div class=\"message_body\" style=margin:0px;>"+HtmlEncode(body)+"</div>"+"<span class=\"pull-right time\">"+time+"</span></pre>");
        }else{
            $('#messages-wrapper').append("<pre class=\"message from\">"+"<div class=\"message_login\" style=margin:0px;>"+login+':'+"</div>"+"<div class=\"message_body\" style=margin:0px;>"+HtmlEncode(body)+"</div>"+"<span class=\"pull-right time\">"+time+"</span></pre>");
        }

    }
//
//    $('.message_body').emoticonize({
//        delay: 800,
//    animate: true
//
//});
    emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
    for(var i= 0;i<document.getElementsByClassName('message_body').length; i++){
    emojify.run(document.getElementsByClassName('message_body')[i]);
    }
});

function HtmlEncode(val) {

    return $("<div/>").text(val).html();
}

    emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
    for(var i= 0;i<document.getElementsByClassName('chat-body.clearfix').length; i++){
        emojify.run(document.getElementsByClassName('chat-body clearfix')[i]);
    }
});
