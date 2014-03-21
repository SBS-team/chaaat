$(document).ready(function(){


    $( window ).resize(function() {
        document.getElementsByClassName('panel-body')[0].style.height=$(window).height()-152+"px";
    });

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


    $('.change-status').click(function(event){
        $.ajax({
            type: "GET",
            url: "../users/status/",
            data: { status: $(this).attr("data-id") }
        })
            .done(function(msg) {
               $("#userStatus")[0].innerHTML=msg+" <span class=\"caret\"></span>";
            });
    });


    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private');
    channel.bind('new_message', function(data) {
        render_message(data.user_id,data.login,data.message,data.avatar,data.create_at);
    });

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
                "<p>"+ $.trim(changetags(safe_tags_replace(body))) +"</p>"+
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
                "<p>"+ $.trim(changetags(safe_tags_replace(body))) +"</p>"+
                "</div>"+
                "</li>");
        }
        var objDiv = document.getElementsByClassName('panel-body')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
    }

function invoted_users(){
    messages=$("li .chat-body p")
    for(var i=0; i<messages.length; i++){
        messages[i].innerHTML=changetags(messages[i].innerHTML);
    }
}

function changetags(text){
    if((text.match(/\@(\S+.)/)) && (!text.match(/<span>\@(\S+.)/))){
        return text.replace(/\@(\S+.)/,"<span style=\"background-color:blue;border-radius:3px;padding-left:3px;padding-right:3px;\">"+ $.trim(text.match(/\@(\S+.)/)[0]) +"</span> ");
    }if(text.match(/h.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]\S\w*)/)){
        return text.replace(/h.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]\S\w*)/,"<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/"+youtube_parser(text)+"\" frameborder=\"0\" allowfullscreen></iframe><br>");
    }else{
        return text;
    }
}

function youtube_parser(url){
    var regExp = /h.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]\S\w*)/;
    var match = url.match(regExp);
    if (match&&match[7].length==11){
        return match[7];
    }
}

var tagsToReplace = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;'
};

function replaceTag(tag) {
    return tagsToReplace[tag] || tag;
}

function safe_tags_replace(str) {
    return str.replace(/[&<>]/g, replaceTag);
}



invoted_users();
});