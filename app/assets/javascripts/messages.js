$(document).ready(function(){

    var message_textarea=$("#message");
    var users= gon.rooms_users;
    var message_offset = 10;
    invoted_users();

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private-'+gon.room_id.toString());
    $('#pop').popover({html:true});
    channel.bind('new_message', function(data) {
        render_message(data.user_id,data.login,data.message,data.avatar,data.create_at,true,data.attach_file_path);
    });

    $(document).on('click', '.emoji', function(e) {
        $("#message").val($("#message").val() + $(e.target).attr("title"));
        $("#message").focus();
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
            document.getElementById('message_input').value += "\r\n";
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
                $('#messages-wrapper').html('');
                for (var i = 0; i <= msg.length - 1; i++) {
                    render_message(msg[i].user_id,msg[i].login,msg[i].body,msg[i].avatar,msg[i].created_at,false,msg[i].attach_file_path);

                };

            });
    });

    function get_user_status_style(user_status_id){
        switch(user_status_id){
            case 'Available':
                return "glyphicon glyphicon-eye-open drop-av drop-col-mar";
            case 'Away':
                return "glyphicon glyphicon-eye-open drop-away drop-col-mar";
            case 'Do not disturb':
                return "glyphicon glyphicon-eye-close drop-dnd drop-col-mar"
            case "Offline":
                return  "glyphicon glyphicon-share-alt drop-col-mar";
        }
    }

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
        var objDiv = document.getElementsByClassName('chat')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
        }
        emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
        for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
            emojify.run(document.getElementsByClassName('chat-body')[i]);
        }
    }

    function prepend_message(user_id,login,body,avatar,time,message,attach_file_path){
        if(gon.user_id == user_id){

            $('#messages-wrapper').prepend(create_message(user_id, login, body, avatar, time,"from"));
        }
        else{
            $('#messages-wrapper').prepend(create_message(user_id, login, body, avatar, time,"to"));
        }
    }

    function invoted_users(){
        messages=$("li .chat-body p");
        for(var i=0; i<messages.length; i++){
            messages[i].innerHTML=changetags(messages[i].innerHTML);
            emojify.run(messages[i]);
        }
        attached_file=$(".attach_file");
        for(var i=0; i<attached_file.length; i++){
            attached_file[i].innerHTML=check_file(attached_file[i].innerHTML);
        }
    }

    function changetags(text) {
        var words = text.split(' '),
            results = [];

        for (var i = 0; i < words.length; i++) {
            var word = words[i];

            if ((word.match(/\@\S*/)) && (!word.match(/<span>\@\S*/) && (word.match(/\@\S*/g)[0] == "@" + gon.user_login))) {
                results.push(word.replace(/\@\S*/, "<span class=\"to-user\">" + $.trim(word.match(/\@\S*/)[0]) + "</span> "));
            } else if (word.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/)) {
                results.push(word.replace(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/,
                    "<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/" + youtube_parser(word) + "\" frameborder=\"0\" allowfullscreen></iframe><br>"));
            } else if (word.match(/http.*(jpg|gif|jpeg)/)) {
                src = word.match(/http.*(jpg|gif|jpeg)/);
                results.push(word.replace(/http.*(jpg|gif|jpeg)/, "<br><img src=" + src[0] + " height=\"500px\" width=\"300px\"/a>"));
            }else if (word.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)) {
                word=word.replace("view","embed");
                src = "\""+word+"?muted=false&autostart=false&originalSize=false&hideTopBar=false&noSiteButtons=false&startWithHD=false"+"\"";
                results.push("<br><iframe src=" +src + "\" frameborder=\"0\" allowfullscreen=\"true\" height=\"315px\" width=\"560px\"></iframe><br>");
            } else if (word.match(/http.*/)) {
                results.push("<a href=" + word + ">"+word+"</a>");
            }
            else {
                results.push(word);
            }
        }
        var parsedMessage = results.join(' ');
        return parsedMessage;
    }

    function youtube_parser(url) {
        var regExp = /http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/;
        var match = url.match(regExp);
        if (match && match[7].length == 11) {
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
            return '@' + value + ' ';
        },
        index: 1,
        maxCount: 5
    }
    ]).on({
    'textComplete:show': function () {            
        set_top=setInterval(function(){$('ul.dropdown-menu:last').css('top',-$('ul.dropdown-menu:last').height())},100);
        },
        'textComplete:hide': function () {
            if(set_top) clearInterval(set_top);
        }
    });

    function replaceTag(tag) {
        return tagsToReplace[tag] || tag;
    }

    function safe_tags_replace(str) {
        return str.replace(/[&<>]/g, replaceTag);
    }

    $(".friend").click(function(){
        sender = $(this);
        if(self.location.toString().indexOf('persons/')!= -1){
            self.location = sender.attr('user_id');
        }
        else{
            self.location = 'persons/' + sender.attr('user_id');
        }
    });


    $(".friend_action.add_friend").click(function(){
        $.ajax({
           type: "POST",
           beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
           url: "/friendships",
           data:{
                friend_id: $(this).parent().attr('friend_id')
           },
            success: function(response){
                $('tr[friend_id = \"' + response + '\"]').remove();
            }
        });

    });

    $('.friend_action.remove_friend').click(function(){
        $.ajax({
            url: "/friendships/" + $(this).attr("friend_id"),
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                _method: 'DELETE',
                friend_id: $(this).attr('friend_id')
            },
            success: function(response){
                $('tr[friend_id = \"' + response + '\"]').remove();
            }
        });
    });

    $(".pag").click(function(){
        $.ajax({
            url: '/rooms/previous_messages',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                room_id: gon.room_id,
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