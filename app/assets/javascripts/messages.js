//#FIXME coffescript
function system_message(body){
    var fd = new FormData();
    fd.append('messages[body]', $.trim(body));
    fd.append('messages[room_id]', gon.room_id);
    fd.append('messages[message_type]', "system");
    $.ajax({
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: '/messages',
        data:  fd,
        processData: false,
        contentType: false
    })
}

$(document).ready(function(){
    Handlebars.registerHelper("equal",function (r_value){if (gon.user_id == r_value) {return 'from';}else{$('#new-message')[0].play();return 'to';}});
    Handlebars.registerHelper("safe_mess",function (messag){if(messag.length>240 || messag.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/) || messag.match(/http.*(jpg|gif|jpeg)/) || messag.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i) ){
                            if (messag.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/) || messag.match(/http.*(jpg|gif|jpeg)/) || messag.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i) ){
                                return "<div id=\"short-text\" style=\"display: block;\">" +
                                    "<small class=\"pull-right text-muted\">" +
                                    "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>"+
                                    "<p class=\"primary-font\">"+"<div class=\"text-muted\">"+"<i>"+"this text has a content..."+"</i></div></p></div>" +
                                    "<div id=\"long-text\" style=\"display: none;\">"+
                                    "<small class=\"pull-right text-muted\">" +
                                    "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>"+
                                    "<p>"+$.trim(changetags(safe_tags_replace(messag)))+"</p>" + "</div>"; }
                            else{if (messag.match(/(\b\w+:\/\/\w+((\.\w)*\w+)*\.\S{2,3}(\/\S*|\.\w*|\?\w*\=\S*)*)/)){
                                return "<div id=\"short-text\" style=\"display: block;\">" +
                                    "<small class=\"pull-right text-muted\">" +
                                    "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>"+
                                    "<p><a href="+messag.substr(0,109)+"..."+"\"  target=\"_blank\">"+messag.substr(0,109) +"..." +"</a></p></div>" +
                                    "<div id=\"long-text\" style=\"display: none;\">"+
                                    "<small class=\"pull-right text-muted\">" +
                                    "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>"+
                                    "<p>"+$.trim(changetags(safe_tags_replace(messag)))+"</p>" +
                                    "</div>";
                                }
                                else{
                                return "<div id=\"short-text\" style=\"display: block;\">" +
                                "<small class=\"pull-right text-muted\">" +
                                "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>"+
                                "<p>"+$.trim(changetags(safe_tags_replace(messag))).substr(0,109) +"..." +"</p></div>" +
                                "<div id=\"long-text\" style=\"display: none;\">"+
                                "<small class=\"pull-right text-muted\">" +
                                "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>"+
                                "<p>"+$.trim(changetags(safe_tags_replace(messag)))+"</p>" +
                                "</div>";}}}
                        else {return  "<p>"+$.trim(changetags(safe_tags_replace(messag)))+ "</p>"; }});
    Handlebars.registerHelper("attach-files",function (attach_file_path){return check_file(attach_file_path) });

    Handlebars.registerHelper("change_login",function (user_id,login){return (user_id!= null) ? "<a href=\"/persons/"+ user_id +"\">"+ login + "</a>" : "chat notification";});
    var template = Handlebars.compile($('#template_message').html());

    function smiles_render(){
        message=document.getElementsByClassName('chat-body');
        for(var i= 0;i<message.length; i++){
            emojify.run(message[i]);
        }
    }

    $('#pop').popover({html:true});
    var message_textarea=$("#message");
    var iframe = $('iframe');
    var search = $("#search");
    var input_file = $("input[type=file]#attach_path");
    users=['all'].concat(gon.rooms_users);
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

            for (var i = 0; $('#messages-wrapper li').size()>30; i++) {
                $('#messages-wrapper li').first().remove();
            };
        });
    };
    $(document).on('click', '.smile', function(e) {
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

    $('.list').on('click','.drop_room_user',function(event){
        drop_user_span = event.currentTarget;
        joined_member = $(drop_user_span).parent();
    });

    $('.drop_room_user').confirm({
        text: "Are you sure you want to delete user?",
        title: "User deleting confirmation",
        confirm: function() {
            $.ajax({
                url: '/rooms_users/' + joined_member.data('user-id')+'/' + joined_member.data('room-id'),
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: {
                    _method: 'DELETE',
                    room_id: joined_member.data('room-id'),
                    user_id: joined_member.data('user-id')
                },
                success: function(response){
                    system_message("User: " + response.user_login + " has been deleted from room: " + response.room_name);
                    joined_member.remove();
                    users.splice(users.indexOf(response.user_login), 1);
                }
            });
        },
        confirmButton: "Yes I am",
        cancelButton: "No",
        post: false
    });

    $('.content').on('click','.delete_room',function(event){
        element_delete_room = event.currentTarget;
    });

    $('.delete_room').confirm({
        text: "Are you sure you want to delete this room?",
        title: "Confirmation required",
        confirm: function() {
            $.ajax({
                url: '../rooms/' +$(element_delete_room).data("id") ,
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: { _method: "DELETE",
                    id: $(element_delete_room).data("id") },
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

    message_textarea.keydown(function(e)
    {
        if (e.keyCode == 13 && e.ctrlKey == false) {
            send_message();
            e.preventDefault();
            return false;
            if(input_file){
                $(".attach_wrapper").remove();
                $('label.upload-but').popover('hide');
            }
        }
        if (e.keyCode ==13 && e.ctrlKey) {
            document.getElementById('message').value += "\r\n";
        }
    });

    $('.send_message_button').click(function(){
        send_message();
        if(input_file){
            $(".attach_wrapper").remove();
            $('label.upload-but').popover('hide');
        }
    });

    $("#search").keyup(function(){
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "../messages/search/",
            data: { query:  $("#search").val(),room_id: gon.room_id }
        })
            .done(function(msg) {
                $('#messages-wrapper').html(template(msg));
                smiles_render();
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

    var i=0;
    pagExist=false;
    if ($('.pag').length > 0){
        pagExist=true;
    }
    function send_message(){
        ++i;
        if (i==31){
            if (pagExist!=true)
            $('.chat').prepend('<div class="pag"><div class="glyphicon glyphicon-chevron-up"></div></div>');
        }
        if ($('input[type="file"]')[0].files[0]){
            $('.input').block({
                message: '<img src="../img/busy.gif" /><p>File uploading, please wait</p>',
                css: {}
            });
        }
        if ($.trim(message_textarea.val()).length>0 || ($('input[type="file"]')[0].files[0])){
            var fd = new FormData();
            fd.append('messages[body]', $.trim(message_textarea.val()));
            fd.append('messages[room_id]', gon.room_id);
            fd.append('messages[attach_path]', $('input[type="file"]')[0].files[0]);
            $.ajax({
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                url: '/messages',
                data: fd,
                processData: false,
                contentType: false,
                success: function(data){
                    $("#new_message")[0].reset();
                    $('.input').unblock();
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
            if (input_file[0].files[0].size>40000000){
                $.bootstrapGrowl("File size over than 40mb", {
                    type: 'success', // (null, 'info', 'error', 'success')
                    offset: {from: 'bottom', amount: 50}, // 'top', or 'bottom'
                    align: 'center', // ('left', 'right', or 'center')
                    width: 250, // (integer, or 'auto')
                    delay: 5000,
                    allow_dismiss: true,
                    stackup_spacing: 10 // spacing between consecutively stacked growls.
                });
                input_file.replaceWith(input_file.clone(true));
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
                    $(".attach_wrapper").remove();
                    $popup_target.popover('hide');
                });
            }
        })
    }

    function render_message(data){
        $("#messages-wrapper").append(template(data));
        var objDiv = document.getElementsByClassName('chat')[0];
        objDiv.scrollTop = objDiv.scrollHeight+2000;
        smiles_render();
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
            if ((word.match(/\@\S*/)) && (!word.match(/<span>\@\S*/) && ((word.match(/\@\S*/g)[0] == "@" + gon.user_login) || (word.match(/\@\S*/g)[0] == "@all")))) {
                results.push(word.replace(/\@\S*/, "<span class=\"to-user\">" + $.trim(word.match(/\@\S*/)[0]) + "</span> "));
            } else if (word.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/)) {
                results.push(word.replace(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/,
                    "<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/" + youtube_parser(word) + "\" frameborder=\"0\" allowfullscreen></iframe><br>"));
            } else if (word.match(/http.*(jpg|gif|jpeg)/)) {
                src = word.match(/http.*(jpg|gif|jpeg)/);
                results.push(word.replace(/http.*(jpg|gif|jpeg)/, "<br><img src=" + src[0] + " height=\"500px\" width=\"300px\"/a>"));
            }else if (word.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)) {
                word=word.replace("view","embed");
                src = "\""+word.slice(0,27)+"?muted=false&autostart=false&originalSize=false&hideTopBar=false&noSiteButtons=false&startWithHD=false"+"\"";
                results.push("<br><iframe src=" +src + "\" frameborder=\"0\" allowfullscreen=\"true\" height=\"315px\" width=\"560px\"></iframe><br>");
            } else if (word.match(/(\b\w+:\/\/\w+((\.\w)*\w+)*\.\S{2,3}(\/\S*|\.\w*|\?\w*\=\S*)*)/)) {
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

    $(".chat").on('click','.pag',(function(){
        $.ajax({
            url: '../rooms/previous_messages',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                room_id: gon.room_id,
                messages: $('.clearfix').first().data('id')
            },
            success: function(response){
                if(response.messages.length > 0){
                    $('#messages-wrapper').prepend('<div class="glyphicon glyphicon-resize-vertical" style="margin:0 50% 0 50%;opacity:0.5;font-size:20px"></div>');
                    $('#messages-wrapper').prepend(template(response));
                    smiles_render();

                    message_offset += 10;
                }
            }
        });
    }));

    function inviteAjax(InputId){
        $.ajax({
            url: '/users/invite_user',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data:{
                email: InputId
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
    }
    $('.inv').on('click', function(e){
        inviteAjax($("#email").val());
        e.preventDefault();
    });
     function send_invite (){
        $('li .send_invite').on('click', function(){
            inviteAjax($("#search-user").val());
        });

     }


    Handlebars.registerHelper("check_room_user_presence",function (user_login, user_id){
        var add_room_user_span = "";
        if(users.indexOf(user_login) == -1){
            add_room_user_span = "<span class='glyphicon glyphicon-plus pull-right user_friend' data-user-id='" + user_id + "'></span>";
        }
        return add_room_user_span;
    });

    var template_search_user_right='{{#users}}<div class=\"member\" friend_id={{id}} ><a data-method="post" href="/persons/{{login}}" rel="nofollow"><span class="{{#get_icon_status user_status}}{{/get_icon_status}}"></span>{{login}}</a>{{#check_room_user_presence login id}}{{/check_room_user_presence}}</div>{{/users}}';
    var search_user_right = Handlebars.compile(template_search_user_right);
    $('#search-user').keyup(function(){
        if ($(this).val().match(/^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@([a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/)){
            $('.right_search').html("<li style='text-align:center'><button class='btn send_invite'>Send invite</button></li>")
            send_invite();
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
                    $('.right_search').html(search_user_right(response))
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
    $('body').on('click', function (e) {
        $('[data-toggle="popover"]').each(function () {
            if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                $(this).popover('hide');
            }
        });
    });

    $('.content').on('click','#short-text .glyphicon.glyphicon-chevron-down',function() {
        $(this).parents('.message').find('#short-text').hide();
        $(this).parents('.message').find('#long-text').show();
    });

    $('.content').on('click','#long-text .glyphicon.glyphicon-chevron-up',function() {
        $(this).parents('.message').find('#short-text').show();
        $(this).parents('.message').find('#long-text').hide();
    });
});
