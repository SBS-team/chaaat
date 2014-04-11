//#FIXME coffescript
$(document).ready(function(){
    Handlebars.registerHelper("equal",function (r_value){if (gon.user_id == r_value) {return 'from';}else{$('#new-message')[0].play();return 'to';}});
    Handlebars.registerHelper("safe_mess",function (messag){return $.trim(changetags(safe_tags_replace(messag)))});
    Handlebars.registerHelper("attach-files",function (attach_file_path){return check_file(attach_file_path) });
    Handlebars.registerHelper("change_login",function (user_id,login){return (user_id!= null) ? "<a href=\"/persons/"+ user_id +"\">"+ login + "</a>" : "chat notification";});
    var template_message = '{{#message}}<li class="{{#equal user_id}}{{/equal}} clearfix"><span class="chat-img pull-left"><img class="avatar" src="{{avatar}}"></span><div class="chat-body clearfix"><div class="header"> <strong class="primary-font">{{#change_login user_id login}}{{/change_login}}</strong><small class="pull-right text-muted"><span class="glyphicon glyphicon-time"></span>{{create_at}}</small></div><p>{{#safe_mess message}}{{/safe_mess}}</p>{{#if attach_file_path}}<p class="attach-file">{{#attach-files attach_file_path}}{{/attach-files}}</p>{{/if}}</div></li>{{/message}}';
    var template = Handlebars.compile(template_message);

    $('#pop').popover({html:true});
    var message_textarea=$("#message");
    var iframe = $('iframe');
    var search = $("#search");
    var input_file = $("input[type=file]#attach_path");
    users=gon.rooms_users;
    var message_offset = 10;
    invoted_users();
    show_attachment();

    if (gon.room_id) {
        Pusher.host = '192.168.137.75'
        Pusher.ws_port = 8081
        Pusher.wss_port = 8081

        var pusher = new Pusher(gon.pusher_app, {authEndpoint:'/pusher/auth?room_id='+gon.room_id});
        var channel = pusher.subscribe('private-'+gon.room_id);
        channel.bind('new_message',function(data){
            render_message(data);
            if ($('#messages-wrapper li').size()>30){
                $('#messages-wrapper li').first().remove();
            }
        });
    };
    $(document).on('click', '.emoji', function(e) {
        message_textarea.val(message_textarea.val() + $(e.target).attr("id"));
        message_textarea.focus();
    });

    $(document).on('click', '.show_smile', function(){
        iframe.each(function(){
            var url = $(this).attr("src");
            var char = "?";
            if(url.indexOf("?") != -1){
                var char = "&";
            }

            $(this).attr("src",url+char+"wmode=transparent");
        });
    });

    $('.content').on('click','.delete_room',function(event){
        element_delete_room = event.currentTarget;
    });

    $('.delete_room').confirm({
        text: "Are you sure you want to delete this room?",
        title: "Confirmation required",
        confirm: function() {
            $.ajax({
                url: '../rooms/del/',
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: { id: $(element_delete_room).data("id") },
                success: function(response){
                    $(element_delete_room).parents('table.rooms_group').hide();
                    $("a[room_id='"+$(element_delete_room).data("id")+"']").parents('li#room').hide();
                }
            });
        },
        confirmButton: "Yes I am",
        cancelButton: "No",
        post: false
    });

    iframe.each(function(){
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

    $(".panel-footer").on('submit',function(){
        send_message();
        return false;
    });

    message_textarea.keyup(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey == false) {
            send_message();
            if(input_file){
                $("attach_wrapper").remove();
                $('label.upload-but').popover('hide');
            }
            $('html, body').animate({scrollTop: $("body").height()}, 800);
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
        }
    });

    $('.send_message_button').click(function(){
        send_message();
        if(input_file){
            $("attach_wrapper").remove();
            $('label.upload-but').popover('hide');
        }
        $('html, body').animate({scrollTop: $("body").height()}, 800);
    });

    $("#search").keyup(function(){
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "../message/search/",
            data: { query:  $("#search").val(),room_id: gon.room_id }
        })
            .done(function(msg) {
                $('#messages-wrapper').html(template(msg));
            });
    });

    function check_file(attach_file_path){
        url_to_file=location.origin+attach_file_path;
        if (url_to_file.match(/http.*(jpg|gif|jpeg|png)/)){
            return '<img src="'+url_to_file+'" height="200px" width="200px"/>';
        }else{
            return '<a href="'+url_to_file+'" download><span class="glyphicon glyphicon-download-alt"></span>'+attach_file_path.match(/(\w|[-.])+$/)[0]+'</a>';
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

    function show_attachment(){
        $popup_target = $('label.upload-but');
        input_file.change(function(){
            if (input_file[0].files[0].size>30000000){
                $.bootstrapGrowl("File size over than 30mb");
            }else{
                $popup_target.attr({
                    "id": "attach_popup",
                    "data-container": "body",
                    "data-content": '<div class="attach_wrapper"><div class="attach_header"><span class="glyphicon glyphicon-remove"></span></div><div class="attach_content"><span>'+input_file[0].files[0].name+'</span></div></div>',
                    "data-placement": "top",
                    "data-toggle": "popover",
                    "type": "button"
                });
                message_textarea.focus();
                $popup_target.popover({html:true});
                $popup_target.popover('show');
                $(".popover-content").find("span.glyphicon.glyphicon-remove").click(function(){
                    $("#attach_path").val("");
                    $("attach_wrapper").remove();
                    $popup_target.popover('hide');
                });
            }
        })
    }


    function render_message(data){
        $("#messages-wrapper").append(template(data));
        var objDiv = document.getElementsByClassName('chat')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
        emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
        for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
            emojify.run(document.getElementsByClassName('chat-body')[i]);
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
                results.push("<a href=" + word+ " target=\"_blank\">"+word+"</a>");
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

    $('.rooms_group').on('click',".friend_action.add_friend",function(){
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
            url: '../rooms/previous_messages',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                room_id: gon.room_id,
                offset_records: message_offset
            },
            success: function(response){
                if(response.message.length > 0){
                    $('#messages-wrapper').prepend('<div class="glyphicon glyphicon-resize-vertical" style="margin:0 50% 0 50%;opacity:0.5;font-size:20px"></div>');
                    $('#messages-wrapper').prepend(template(response));
                    emojify.setConfig({ emoticons_enabled: true, people_enabled: true, nature_enabled: true, objects_enabled: true, places_enabled: true, symbols_enabled: true });
                    for(var i= 0;i<document.getElementsByClassName('chat-body').length; i++){
                        emojify.run(document.getElementsByClassName('chat-body')[i]);
                    }
                    message_offset += 10;
                }
            }
        });
    });



    $('ul').on('click','.send_invite', function(){
        $.ajax({
            url: '/users/invite_user',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                email: $("#search-user").val()
            },
            success: function(response){
                $.bootstrapGrowl("You have send invite to: "+response, {
                    type: 'success',
                    offset: {from: 'top', amount: 50},
                    align: 'center',
                    width: 250,
                    delay: 10000,
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('#search-user').val('');
                $('.right_search_user').html("")
            }
        });
    });





    var template_search_user_right='{{#users}}<li><a data-method="post" href="/persons/{{login}}" rel="nofollow"><span class="{{#get_icon_status user_status}}{{/get_icon_status}}"></span>{{login}}</a><span class="glyphicon glyphicon-plus pull-right user_friend" data-user-id="{{id}}"></span></li>{{/users}}';
    var search_user_right = Handlebars.compile(template_search_user_right);
    $('#search-user').keyup(function(){
        if ($(this).val().match(/^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@([a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/)){
            $('.right_search_user').html("<li style='text-align:center'><button class='btn send_invite'>Send invite</button></li>")
        }
        else{
            $.ajax({
                url: '/users/search',
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data:{
                    login: $("#search-user").val()
                },
                success: function(response){
                    $('.right_search_user').html(search_user_right(response))
                }
            });
        }
    });


    var template_search_user='{{#users}}<tr friend_id="{{id}}"><td><div class="friend_photo"><img class="avatar" src="{{avatar}}"></div><div class="friend_name"></div><a href="/persons/{{login}}">{{login}}</a></td><td class="friend_action add_friend"><span class="glyphicon glyphicon-plus add_new_friend"></span></td></tr>{{/users}}';
    var search_user = Handlebars.compile(template_search_user);
    $("#search-box").keyup(function(){
        $.ajax({
            url: '/users/search',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                login: $("#search-box").val()
            },
            success: function(response){
                $('.rooms_group').html(search_user(response))
            }
        });
    });

});