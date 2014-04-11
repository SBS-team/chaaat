//#FIXME coffescript
Pusher.host = '192.168.137.75'
Pusher.ws_port = 8081
Pusher.wss_port = 8081
Handlebars.registerHelper("get_icon_status",function (value){return get_user_status_style(value)});
var template_add_user_right='<div class="member" id="{{user_id}}" data-room-id="{{room_id}}" data-toggle="tooltip" data-user-id="{{user_id}}" title="{{user_status}}"><span class ="{{#get_icon_status user_status}}{{/get_icon_status}}"></span><a href="#">{{user_login}}</a></div>';
var add_user_right = Handlebars.compile(template_add_user_right);

pusher_stat = new Pusher(gon.pusher_app);

channel_status = pusher_stat.subscribe('presence-status');

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
    if(timerId!= null){
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

if (gon.room_id){
    pusher = new Pusher(gon.pusher_app, {authEndpoint:'/pusher/auth?room_id='+gon.room_id});
    channel = pusher.subscribe('private-'+gon.room_id);

var channel3 = pusher.subscribe('private-'+gon.user_id);
channel3.bind('notification-room', function(data) {
    if (data.room_id!=gon.room_id){
        $('li#room a[room_id="'+data.room_id+'"]').parent().css('background-color','#999');
    }
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
//    $('.lobby-panel').load('/rooms/'+data.room_id+' .lobby-panel');
    $(".tabs.ui-sortable").append("<li><a room_id="+data.rooms_id+" href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
});

    function system_message(body){
    var fd = new FormData();
    fd.append('message[body]', $.trim(body));
    fd.append('message[room_id]', gon.room_id);
    fd.append('message[message_type]', "system");
    $.ajax({
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: '../message/new',
        data:  fd,
        processData: false,
        contentType: false
    })
    }
channel.bind('add_user_to_room', function(data) {
    users.push(data.user_login);
    system_message("User: "+data.user_login+" has been added to room: "+data.rooms_name);
    $('.list').append(add_user_right(data));
//    $('.list').load('/rooms/445 .list');
    if (data.user_status=="Offline"){
        document.getElementById(data.user_id).title="Offline "+jQuery.timeago(data.user_sign_out_time);
    }
    else{
        document.getElementById(data.user_id).title=data.user_status;
    }
});


channel.bind('change-topic', function(data) {
    system_message("Rooms topic has been changed from: \""+data.previous_topic+"\" on: \""+data.topic+"\"");
    $('h3.room_topic').text(data.topic);

})

channel.bind('del_user_from_room', function(data) {
    system_message("User: "+data.user_login+" has been deleted from room: "+data.room_name);
    document.getElementById(data.drop_user_id.toString()).remove();
});

}

