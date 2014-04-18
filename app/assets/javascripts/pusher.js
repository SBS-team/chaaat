//#FIXME coffescript
Pusher.host = '192.168.137.75'
Pusher.ws_port = 8081
Pusher.wss_port = 8081
Handlebars.registerHelper("get_icon_status",function (value){return get_user_status_style(value)});
Handlebars.registerHelper("set_user_to_drop",function (room_owner_id){
    var drop_room_user_span = "";
    if(room_owner_id == gon.user_id)
        drop_room_user_span = "<span class=\"glyphicon glyphicon-minus pull-right drop_room_user\"></span>";
    return drop_room_user_span;
});
var template_add_user_right='<div class="member" id="{{user_id}}" data-room-id="{{room_id}}" data-toggle="tooltip" data-user-id="{{user_id}}" title="{{user_status}}"><span class ="{{#get_icon_status user_status}}{{/get_icon_status}}"></span><a href="#">{{user_login}}</a>{{#set_user_to_drop rooms_owner_id}}{{/set_user_to_drop}}</div>';
var add_user_right = Handlebars.compile(template_add_user_right);
var timer,timerId;
pusher_stat = new Pusher(gon.pusher_app);
channel_status = pusher_stat.subscribe('presence-status');

channel_status.bind('change_status', function(data) {
    var tmp = $('div[data-user-id='+data.user_id+']');
    tmp.attr('title',data.status);
    $('div[friend_id='+ data.user_id+']').find("a > span").attr("class", get_user_status_style(data.status));
    tmp.find(':first-child').attr('class', get_user_status_style(data.status));
    if(window.location.toString().match(/\/persons\//)){
        if(data.status == "Offline")
            $("#last_activity").html("Last seen at:"+ jQuery.timeago(data.user_sign_out_time));
        else
            tmp.attr('title',data.status);
        $("#last_activity").html("");
    }
});

channel_status.bind('pusher:member_removed', function(member) {
    timerId = setTimeout(function test(){
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "../pusher/stat/",
            data: { client_status: "Offline",user_id: member.id}
        })
    }, 5000);
});

channel_status.bind('pusher:member_added', function(member) {
    if (null!=typeof timerId){
    clearTimeout(timerId);
    }
    $.ajax({
        type: "POST",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: "../pusher/stat/",
        data: { client_status: "Available",user_id: member.id}
    })
});

channel_status.bind('delete_room', function(data) {
    $("table[data-room='"+data.room_id+"']").hide();
    $("a[room_id='"+data.room_id+"']").parents('li#room').hide();
});

function get_user_status_style(user_status_id){
    switch(user_status_id){
        case 'Available':
            return "glyphicon glyphicon-eye-open drop-av drop-col-mar";
        case 'Away':
            return "glyphicon glyphicon-eye-close drop-away drop-col-mar";
        case 'Do not disturb':
            return "glyphicon glyphicon-eye-close drop-dnd drop-col-mar";
        case 'Help':
            return "glyphicon glyphicon-question-sign drop-hlp drop-col-mar";
        case 'Offline':
            return "glyphicon glyphicon-eye-close drop-col-mar";
    }
}

pusher = new Pusher(gon.pusher_app);

var channel2 = pusher.subscribe('private-'+gon.user_id);

channel2.bind('user_add_to_room', function(data) {
    $.bootstrapGrowl("You have been added to the room: "+data.rooms_name, {
        type: 'success',
        offset: {from: 'top', amount: 50},
        align: 'center',
        width: 250,
        delay: 10000,
        allow_dismiss: true,
        stackup_spacing: 10
    });
    $(".lobby-panel #tabs").append("<li id=\"room\"><a room_id="+data.rooms_id+" href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
    var remove_room_span = "";
    if (gon.user_id == data.rooms_owner_id){
        remove_room_span = "<span class='delete_room glyphicon glyphicon-remove-circle' data-id='"+ data.rooms_id +"'></span>"
    }
    $("div#room_list").append("<table class='rooms_group' data-room='" + data.rooms_id +"'>" +
        "<tr>" +
        "<td class='name'>"+
        "<a class='clean'>" +
        "<a href='\/rooms\/"+ data.rooms_id +"' room_id='" + data.rooms_id + "'>" + data.rooms_name +"</a>" +
        "</a>" +
        "</td>" +
        "<td class='memb-count'>" + data.room_members_count + " members" + "</td>" +
        "<td class='owner'> Owned by: " +
        "<a href='/persons/"+ data.room_owner_id +"'>" + data.rooms_owner_login + "</a>" +
        "</td>" +
        "<td class='set-arr'>" + remove_room_span + "</td>" +
        "</tr>" +
        "</table>"
    );

    room_owner_id = data.rooms_owner_id;
});

channel2.bind('private_del_user_from_room', function(data) {
    $.bootstrapGrowl("You have been removed from the room: " + data.rooms_name, {
        type: 'success', // (null, 'info', 'error', 'success')
        offset: {from: 'top', amount: 50}, // 'top', or 'bottom'
        align: 'center', // ('left', 'right', or 'center')
        width: 250, // (integer, or 'auto')
        delay: 10000,
        allow_dismiss: true,
        stackup_spacing: 10 // spacing between consecutively stacked growls.
    });
    $("a[room_id=\'" + data.room_id + "\']").parent().remove();
    if(self.location.pathname == "/rooms")
        $(".rooms_group[data-room='" + data.room_id + "']").remove();
    if(self.location.pathname != "/rooms")
        self.location = "/rooms"
});

if(gon.room_id){
    pusher = new Pusher(gon.pusher_app, {authEndpoint:'/pusher/auth?room_id=' + gon.room_id});
    channel = pusher.subscribe('private-'+gon.room_id);

    var channel3 = pusher.subscribe('private-'+gon.user_id);
    channel3.bind('notification-room', function(data) {
        if (data.room_id!=gon.room_id){
            if (null!=typeof timer) {clearTimeout(timer);}
            var newTxt="New message";
            var oldTxt=document.title;
            function migalka(){
                if(document.title==oldTxt){
                    document.title=newTxt;
                }else{
                    document.title=oldTxt;
                }
            }
            timer = setInterval(migalka,800);
            $('li#room a[room_id="'+data.room_id+'"]').parent().css('background-color','#999');
        }
    });


    channel.bind('add_user_to_room', function(data) {
        users.push(data.user_login);
        $('.list').append(add_user_right(data));
        if (data.user_status == "Offline"){
            document.getElementById(data.user_id).title = "Offline "+jQuery.timeago(data.user_sign_out_time);
        }
        else{
            document.getElementById(data.user_id).title = data.user_status;
        }
        joined_member = $(".member[id = '" + data.user_id +"']");
        $(joined_member.find('.drop_room_user')).confirm({
            text: "Are you sure you want to delete user?",
            title: "User deleting confirmation",
            confirm: function() {
                $.ajax({
                    url: '/rooms_users/' + joined_member.data('user-id')+'/' + joined_member.data('room-id'),
                    type: 'POST',
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                    data: {
                        _method: 'DELETE',
                        room_id: joined_member.attr('data-room-id'),
                        user_id: joined_member.attr('data-user-id')
                    },
                    success: function(response){
                        joined_member.remove();
                    }
                });
            },
            confirmButton: "Yes I am",
            cancelButton: "No",
            post: false
        });
    });


    channel.bind('change-topic', function(data) {
        $('h3.room_topic').text(data.topic);

    });

    channel.bind('del_user_from_room', function(data) {
        $(".member[data-user-id = \"" + data.drop_user_id + "\"]").remove();
    });

}

window.onfocus = function(){clearTimeout(timer);$('title').text('Chat')};
