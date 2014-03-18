$(document).ready(function(){
var message_textarea=$("#message");

    $("#send_message").click(function(){
        send_message();
    });

    message_textarea.keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey==false) {
            send_message();
            $('html, body').animate({scrollTop: $("body").height()}, 800);
            return false;
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
            return false;
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


    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private');
    channel.bind('new_message', function(data) {
        render_message(data.user_id,data.login,data.message,data.create_at);
    });


    function render_message(user_id,login,body,time){
        if(gon.user_id==user_id){
            $('#messages-wrapper').append("<pre class=\"message to\">"+"<div class=\"message_login\" style=margin:0px;>"+login+':'+"</div>"+"<div class=\"message_body\" style=margin:0px;>"+HtmlEncode(body)+"</div><span class=\"pull-right time\">"+time+"</span></pre>");
        }else{
            $('#messages-wrapper').append("<pre class=\"message from\">"+"<div class=\"message_login\" style=margin:0px;>"+login+':'+"</div>"+"<div class=\"message_body\" style=margin:0px;>"+HtmlEncode(body)+"</div><span class=\"pull-right time\">"+time+"</span></pre>");
        }
    }

    function send_message(){
        if ($.trim(message_textarea.val()).length>0){
            $.ajax({
                type: "POST",
                url: "../message/new",
                data: { message: $.trim(message_textarea.val()) }
                }).done(function(msg) {
                    message_textarea.val('');
                });
        }
    }

    function HtmlEncode(val) {
        return $("<div/>").text(val).html();
    }



});