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

    if (document.getElementsByClassName('panel-body')[0]!=undefined){

        document.getElementsByClassName('panel-body')[0].style.height=$('body').height()-250+"px";


//        $( window ).resize(function() {
//            document.getElementsByClassName('panel-body')[0].style.minHeight=$('body').height()-190+"px";
//
//        });
    }

    var message_textarea=$("#message");
    var users= gon.rooms_users;

    $(".panel-footer").on('submit',function(){
        send_message();
        return false;
    });
    message_textarea.keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey == false) {
            send_message();
            $('html, body').animate({scrollTop: $("body").height()}, 800);
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
        }
    });

    $("#search").keyup(function(){
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "../message/search/",
            data: { query: $("#search").val(),room_id: gon.room_id }

        })
            .done(function(msg) {
                console.log("THIS IS THE RESPONSE: " + msg);
                $('#messages-wrapper').html('');
                for (var i = 0; i <= msg.length - 1; i++) {
                    render_message(msg[i].user_id,msg[i].login,msg[i].body,msg[i].avatar,msg[i].created_at,false,msg[i].attach_file_path);

                };

            });
    });

    $('.change-status').click(function(event){
        $.ajax({
            type: "GET",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
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
        render_message(data.user_id,data.login,data.message,data.avatar,data.create_at,true,data.attach_file_path);
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
        if ($.trim(message_textarea.val()).length>0 || ($('input[type="file"]')[0].files[0])){
            var fd = new FormData();
            fd.append('message[body]', $.trim(message_textarea.val()));
            fd.append('message[room_id]', gon.room_id);
            fd.append('message[attach_path]', $('input[type="file"]')[0].files[0]);
            $.ajax({
              type: 'POST',
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              url: '../message/new',
              data: fd,
              processData: false,
              contentType: false,
              success: function(data){
                $("#new_message")[0].reset();
              },
              error: function(data) {
                console.log(data);
              }
            });
        }
    }

    function create_message(user_id, login, body, avatar, time,msg_class,attach_file_path){
        message= "<li class=\""+ msg_class +" clearfix\">"
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
            + "<p>"+ $.trim(changetags(safe_tags_replace(body))) +"</p>";
            if(attach_file_path){
             message=message + "<p class=\"attach-file\">"+check_file(attach_file_path)+"</p>";
            }
            message=message + "</div>"
        + "</li>";
        return message;
    }

    function check_file(url){
        url_to_file=location.origin+url;
        if (url_to_file.match(/http.*(jpg|gif|jpeg|png)/)){
            return '<img src="'+url_to_file+'" height="200px" width="200px"/>';
        }else{
            return '<a href="'+url_to_file+'" download><span class="glyphicon glyphicon-download-alt"></span>'+url.match(/(\w|[-.])+$/)[0]+'</a>';
        }
    }


    function render_message(user_id, login, body, avatar, time,scroll_true,attach_file_path){
        if(gon.user_id==user_id){
            $('#messages-wrapper').append(create_message(user_id, login, body, avatar, time,"from",attach_file_path));
        }else{
            document.getElementById('new-message').play();
            $('#messages-wrapper').append(create_message(user_id, login, body, avatar, time,"to",attach_file_path));
        }
        if (scroll_true==true)
        {
        var objDiv = document.getElementsByClassName('panel-body')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
        }
        emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
        for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
            emojify.run(document.getElementsByClassName('chat-body')[i]);
        }
    }



    function prepend_message(user_id,login,body,avatar,time,message,attach_file_path){
        if(gon.user_id == user_id){
            $('#messages-wrapper:first-child').prepend(create_message(user_id, login, body, avatar, time,"from",attach_file_path));
        }
        else{
            $('#messages-wrapper:first-child').prepend(create_message(user_id, login, body, avatar, time,"to",attach_file_path));
        }
    }

    function invoted_users(){
        messages=$("li .chat-body p");
        for(var i=0; i<messages.length; i++){
            messages[i].innerHTML=changetags(messages[i].innerHTML);
        }
        attached_file=$(".attach_file");
        for(var i=0; i<attached_file.length; i++){
            attached_file[i].innerHTML=check_file(attached_file[i].innerHTML);
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

$('#message').textcomplete([
    {
        match: /\B@([\-+\w]*)$/,
        search: function (term, callback) {
            callback($.map(users, function (user) {
                return user.indexOf(term) === 0 ? user : null;
            }));
        },
        template: function (value) {
            return '@' + value;
        },
        replace: function (value) {
            return '@' + value+' ';
        },
        index: 1,
        maxCount: 5
    }
]);

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
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                room_id: $("li.active > a").attr('room_id'),
                offset_records: message_offset
            },
            success: function(response){
                if(response.rooms.length > 0){

                    $('#messages-wrapper').prepend("<div class=\"glyphicon glyphicon-resize-vertical\" style=\"margin:0 50% 0 50%;opacity:0.5;font-size:20px\"\"></div>");
                    for (var i = 0; i <= response.rooms.length - 1; i++) {
                        prepend_message(response.rooms[i].user_id,response.rooms[i].login,response.rooms[i].body,response.rooms[i].avatar,response.rooms[i].created_at,response.rooms[i].attach_file_path);
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
