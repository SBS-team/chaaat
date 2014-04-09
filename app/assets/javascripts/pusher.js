//#FIXME coffescript
Pusher.host = '192.168.137.75'
Pusher.ws_port = 8081
Pusher.wss_port = 8081
Handlebars.registerHelper("get_icon_status",function (value){return get_user_status_style(value)});
var template_add_user_right='<div class="member" data-room-id="{{room_id}}" data-toggle="tooltip" data-user-id="{{user_id}}" title="{{user_status}}"><span class ="{{#get_icon_status user_status}}{{/get_icon_status}}"></span><a href="/persons/{{user_id}}">{{user_login}}</a></div>';
var add_user_right = Handlebars.compile(template_add_user_right);

if (gon.room_id){
    pusher = new Pusher(gon.pusher_app, {authEndpoint:'/pusher/auth?room_id='+gon.room_id});
    channel = pusher.subscribe('private-'+gon.room_id);

    channel.bind('del_user_from_room', function(data) {
        $.bootstrapGrowl("User "+data.user_login+" has been deleted ", {
            type: 'success',
            offset: {from: 'top', amount: 50},
            align: 'center',
            width: 250,
            delay: 1700,
            allow_dismiss: true,
            stackup_spacing: 10
        });
        document.getElementById(data.drop_user_id.toString()).remove();
    });

    channel.bind('add_user_to_room', function(data) {
        $.bootstrapGrowl("User "+data.user_login+" has been added to room: "+data.rooms_name, {
            type: 'success',
            offset: {from: 'top', amount: 50},
            align: 'center',
            width: 250,
            delay: 1700,
            allow_dismiss: true,
            stackup_spacing: 10
        });
        $('.list').append(add_user_right(data));
    });
}

channel_status = pusher.subscribe('status');
channel_status.bind('change_status', function(data) {
        var tmp=$('div[data-user-id='+data.user_id+']');
        tmp.attr('title',data.status);
        tmp.find('span').attr('class', get_user_status_style(data.status))
        if(window.location.toString().match(/\/persons\//)){
        if(data.status == "Offline")
            $("#last_activity").html("Last seen at:"+ jQuery.timeago(data.user_sign_out_time));
        else            
            tmp.attr('title',data.status);
            $("#last_activity").html("");
    }
});

channel_status.bind('delete_room', function(data) {
    $("table[data-room='"+data.room_id+"']").hide();
    $("a[room_id='"+data.room_id+"']").parents('li#room').hide();
});

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
    $(".tabs.ui-sortable").append("<li><a room_id="+data.rooms_id+" href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
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