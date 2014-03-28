$(document).ready(function(){
    $(document).on('click', '.emoji', function(e) {
        $("#message").val($("#message").val() + $(e.target).attr("title"));
    });
    $(document).on('click', '.show_smile', function(){
        $('iframe').each(function(){
            var url = $(this).attr("src");
            var char = "?";
            if(url.indexOf("?") != -1){
                var char = "&";
            }

            $(this).attr("src",url+char+"wmode=transparent");
        });
    });

    $(document).ready(function() {
        $("iframe").each(function(){
            var ifr_source = $(this).attr('src');
            var wmode = "wmode=transparent";
            if(ifr_source.indexOf('?') != -1) {
                var getQString = ifr_source.split('?');
                var oldString = getQString[1];
                var newString = getQString[0];
                $(this).attr('src',newString+'?'+wmode+'&'+oldString);
            }
            else $(this).attr('src',ifr_source+'?'+wmode);
        });
    });

    var message_textarea=$("#message_input");

    $("#send_message").click(function(){
        send_message();
    });

    message_textarea.keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey == false) {
            send_message();
            $('html, body').animate({scrollTop: $("body").height()}, 800);
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message_input').value += "\r\n";
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
            data: { query: $("#search").val(),room_id: gon.room_id }

        })
            .done(function(msg) {
                console.log("THIS IS THE RESPONSE: " + msg);
                $('#messages-wrapper').html('');
                for (var i = 0; i <= msg.length - 1; i++) {
                    render_message(msg[i].user_id,msg[i].login,msg[i].body,msg[i].avatar,msg[i].created_at,false);

                };

            });
    });

    $('#request-user').on('click', '.replace', function(event){
        login=$('#message').val();
        login=login.replace($.trim($('#message').val().match(/\@(\S+.)/)[0]),$(event.currentTarget).attr('data-login'));
        $('#message').val(login);
        $(this).css('display','none');
    });


    function get_status_icon_style(user_status){
        icon_style = "";
        switch(user_status){
            case "Offline":
                icon_style = "offline";
                break;
            case "Away":
                icon_style = "away";
                break;
            case "Do not disturb":
                icon_style = "do_not_disturb";
                break;
            default:
                icon_style = "online";
                break;
        }

        return icon_style;
    }

    $('.change-status').click(function(event){
        $.ajax({
            type: "GET",
            url: "../users/status/",
            data: { status: $(this).attr("data-id") }
        })
            .done(function(msg) {
                $("#userStatus")[0].innerHTML ="<span class=\"glyphicon glyphicon-off "+ get_status_icon_style(msg) +"\"></span>"
                                            +"Status"+" <span class=\"caret\"></span>";
            });
    });

    $('.change-status').click(function(event){
        $.ajax({
            type: "POST",
            url: "../pusher/change_status/",
            data: { status: $(this).attr("data-id")}
        })
    });

    eval(function(p,a,c,k,e,d){e=function(c){return c};if(!''.replace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('2.1=\'/3/4?0=\'+5.0.6();',7,7,'room_id|channel_auth_endpoint|Pusher|pusher|auth|gon|toString'.split('|'),0,{}))

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private-'+gon.room_id.toString());

    channel.bind('new_message', function(data) {

        render_message(data.user_id,data.login,data.message,data.avatar,data.create_at,true);
    });

    var channel_status = pusher.subscribe('status');

    channel_status.bind('change_status', function(data) {
        var temp=document.getElementById(data.user_id);
        temp.getElementsByClassName('glyphicon-off')[0].className="glyphicon glyphicon-off "+get_status_icon_style(data.status);
        if (data.status=="Offline"){
        temp.title="Offline "+jQuery.timeago(new Date());
        }
        else{
        temp.title=data.status;
        }
    });

    var channel2 = pusher.subscribe('private-'+gon.user_id.toString());

    channel2.bind('user_add_to_room', function(data) {
        $.bootstrapGrowl("You have been added to the room: "+data.rooms_name, {
            type: 'success', // (null, 'info', 'error', 'success')
            offset: {from: 'top', amount: 50}, // 'top', or 'bottom'
            align: 'center', // ('left', 'right', or 'center')
            width: 250, // (integer, or 'auto')
            delay: 10000,
            allow_dismiss: true,
            stackup_spacing: 10 // spacing between consecutively stacked growls.
        });
        $("ul.nav.side-nav").append("<li><a href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
    });

    channel.bind('add_user_to_room', function(data) {
        $.bootstrapGrowl("User "+data.user_login+" has been added to room: "+data.rooms_name, {
            type: 'success', // (null, 'info', 'error', 'success')
            offset: {from: 'top', amount: 50}, // 'top', or 'bottom'
            align: 'center', // ('left', 'right', or 'center')
            width: 250, // (integer, or 'auto')
            delay: 1700,
            allow_dismiss: true,
            stackup_spacing: 10 // spacing between consecutively stacked growls.
        });

        status_icon_style = get_status_icon_style(data.user_status);

        $("ul.nav.side-nav-rigth").append(
             "<li class=\"joined_friend\" data-toggle=\"tooltip\" id="+data.user_id
           + " data_user_id=" + data.user_id + " data_room_id=" + data.room_id+"><a href=#>"
           +"<span class=\"glyphicon glyphicon-off " + status_icon_style +"\"></span>"+ data.user_login +"</a></li>");
        if (data.user_status=="Offline"){
            document.getElementById(data.user_id).title="Offline "+jQuery.timeago(data.user_sign_out_time);
        }
        else{
            document.getElementById(data.user_id).title=data.user_status;
        }
    });

    channel.bind('del_user_from_room', function(data) {
        $.bootstrapGrowl("User "+data.user_login+" has been deleted ", {
            type: 'success', // (null, 'info', 'error', 'success')
            offset: {from: 'top', amount: 50}, // 'top', or 'bottom'
            align: 'center', // ('left', 'right', or 'center')
            width: 250, // (integer, or 'auto')
            delay: 1700,
            allow_dismiss: true,
            stackup_spacing: 10 // spacing between consecutively stacked growls.
        });

        document.getElementById(data.drop_user_id.toString()).remove();
    });

    function typing_status()
    {
      $.post('/pusher/typing_status', {room_id:gon.room_id,login:gon.user_login});
    }

    var timeout;
    channel.bind('typing_status', function(data) {

            $('.typing').html(data.login+' typing...');
        timeout = setTimeout(function () {
            $('.typing').html('<br>');
        }, 1300);

     });

    $('#message').bind('textchange', function () {

        clearTimeout(timeout);
        typing_status("typing");
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

    function create_message(user_id, login, body, avatar, time,msg_class){
        return "<li class=\""+ msg_class +" clearfix\">"
            + "<span class=\"chat-img pull-left\">"
            + "<img class=\"avatar\" src="+avatar+">"
            + "</span>"
            + "<div class=\"chat-body clearfix\">"
            + " <div class=\"header\">"
            + " <strong class=\"primary-font\"><a href=\"/persons/"+ user_id +"\">"
            + login
            + "</a></strong>"
            + "<small class=\"pull-right text-muted\">"
            + "<span class=\"glyphicon glyphicon-time\"></span>"+time
            + "</small>"
            + "</div>"
            + "<p>"+ $.trim(changetags(safe_tags_replace(body))) +"</p>"
            + "</div>"
        + "</li>"
    }


    function render_message(user_id, login, body, avatar, time,scroll_true){
        if(gon.user_id==user_id){
            $('#messages-wrapper').append(create_message(user_id, login, body, avatar, time,"from"));
        }else{
            document.getElementById('new-message').play();
            $('#messages-wrapper').append(create_message(user_id, login, body, avatar, time,"to"));
        }
        if (scroll_true==true)
        {
        var objDiv = document.getElementsByClassName('chat')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
        }
        emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
        for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
            emojify.run(document.getElementsByClassName('chat-body')[i]);
        }
    }



    function prepend_message(user_id,login,body,avatar,time){
        if(gon.user_id == user_id){
            $('#messages-wrapper').prepend(create_message(user_id, login, body, avatar, time,"from"));
        }
        else{
            $('#messages-wrapper').prepend(create_message(user_id, login, body, avatar, time,"to"));
        }
    }

    function invoted_users(){
        messages=$("li .chat-body p")
        for(var i=0; i<messages.length; i++){
            messages[i].innerHTML=changetags(messages[i].innerHTML);

        }
    }


    function changetags(text){
        if((text.match(/\@\S*/)) && (!text.match(/<span>\@\S*/) && (text.match(/\@\S*/)[0]=="@"+gon.user_login))){
            return text.replace(/\@\S*/,"<span class=\"to-user\">"+ $.trim(text.match(/\@\S*/)[0]) +"</span> ");
        }
        if(text.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/)){
            return text.replace(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/,"<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/"+youtube_parser(text)+"\" frameborder=\"0\" allowfullscreen></iframe><br>");
        }
        if (text.match(/http.*(jpg|gif|jpeg)/)){
            src=text.match(/http.*(jpg|gif|jpeg)/);
            return text.replace(/http.*(jpg|gif|jpeg)/,"<img src="+src[0]+" height=\"500px\" width=\"300px\"/>");
        }
        else{
            return text;
        }
    }

    function youtube_parser(url){
        var regExp = /http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/;
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

    var message_offset = 10;

    $(".pag").click(function(){
        $.ajax({
            url: '/rooms/previous_messages',
            type: 'POST',
            data:{
                room_id: gon.room_id,
                offset_records: message_offset
            },
            success: function(response){
                if(response.rooms.length > 0){

                    $('#messages-wrapper').prepend("<div class=\"glyphicon glyphicon-resize-vertical\" style=\"margin:0 50% 0 50%;opacity:0.5;font-size:20px\"\"></div>");
                    for (var i = 0; i <= response.rooms.length - 1; i++) {
                        prepend_message(response.rooms[i].user_id,response.rooms[i].login,response.rooms[i].body,response.rooms[i].avatar,response.rooms[i].created_at);
                    }
                    emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
                    for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
                        emojify.run(document.getElementsByClassName('chat-body')[i]);
                    }
                    message_offset += 10;
                }

            }
        });
    });
});
