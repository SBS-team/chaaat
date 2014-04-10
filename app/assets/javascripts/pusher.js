//#FIXME coffescript
Pusher.host = '192.168.137.75'
Pusher.ws_port = 8081
Pusher.wss_port = 8081

Pusher.channel_auth_endpoint='/pusher/auth?room_id='+gon.room_id;

pusher = new Pusher('255267aae6802ec7914f'); //#FIXME move to config
channel = pusher.subscribe('private-'+gon.room_id.toString());

channel_status = pusher.subscribe('presence-status');

channel_status.bind('change_status', function(data) {
    if(window.location.toString().match(/\/persons\//)){
        if(data.status == "Offline")
            $("#last_activity").html("Last seen at:"+ jQuery.timeago(data.user_sign_out_time));
        else
            $("#last_activity").html("");
    }
    else{
        var temp=document.getElementById(data.user_id);
        temp.getElementsByTagName('span')[0].className=get_user_status_style(data.status);
        if (data.status==="Offline"){
            temp.title="Offline "+jQuery.timeago(new Date());
        }
        else{
            temp.title=data.status;
        }
    }
});

channel_status.bind('delete_room', function(data) {
    $("table[data-room='"+data.room_id+"']").hide();
    $("a[room_id='"+data.room_id+"']").parents('li#room').hide();
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

    $(".tabs.ui-sortable").append("<li><a room_id="+data.rooms_id+" href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
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
    clearTimeout(timerId);
    $.ajax({
        type: "POST",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: "../pusher/stat/",
        data: { client_status: "Available",user_id: member.id}
    })
});

channel.bind('add_user_to_room', function(data) {
    users.push(data.user_login);
    var user_status_icon_style = get_user_status_style(data.user_status);
    var fd = new FormData();
    fd.append('message[body]', $.trim("User: "+data.user_login+" has been added to room: "+data.rooms_name));
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
    $(".list").append(
        "<div class = \"member\" id="+data.user_id+" user_id="+ data.user_id +" room_id="+ data.room_id +">"+  //#FIXME jquery template/handlebars
            "<span class = \""+ user_status_icon_style +"\"></span>" +
            "<a href=\"#\">"+ data.user_login +"</a></div>"
    );
    if (data.user_status=="Offline"){
        document.getElementById(data.user_id).title="Offline "+jQuery.timeago(data.user_sign_out_time);
    }
    else{
        document.getElementById(data.user_id).title=data.user_status;
    }
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

channel.bind('del_user_from_room', function(data) {
    var fd = new FormData();
    fd.append('message[body]', $.trim("User: "+data.user_login+" has been deleted from room: "+data.room_name));
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
    document.getElementById(data.drop_user_id.toString()).remove();
});