function get_user_status_style(user_status_id){
    switch(user_status_id){
        case 1:
            return "glyphicon glyphicon-eye-open drop-av drop-col-mar";
        case 2:
            return "glyphicon glyphicon-eye-close drop-dnd drop-col-mar";
        case 3:
            return "glyphicon glyphicon-eye-open drop-away drop-col-mar"
        case 4:
            return  "glyphicon glyphicon-eye-close drop-dnd drop-col-mar";
    }
}

  eval(function(p,a,c,k,e,d){e=function(c){return c};if(!''.replace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('2.1=\'/3/4?0=\'+5.0.6();',7,7,'room_id|channel_auth_endpoint|Pusher|pusher|auth|gon|toString'.split('|'),0,{}))

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('private-'+gon.room_id.toString());

    var channel_status = pusher.subscribe('status');

    channel_status.bind('change_status', function(data) {
        var temp=document.getElementById(data.user_id);
        temp.getElementsByClassName('glyphicon-off')[0].className = get_user_status_style(data.user_status_id);
        if (data.user_status_id == 2){
        temp.title="Offline "+jQuery.timeago(new Date());
        }
        else{
        temp.title =data.status;
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
//        $("ul.nav.side-nav").append("<li><a href=/rooms/"+data.rooms_id+">"+data.rooms_name+"</a></li>");
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
        var user_status_icon_style = get_user_status_style(data.user_status_id);
        $(".list").append(
            "<div class = \"member\">" +
                "<span class = \""+ user_status_icon_style +"\"></span>" +
                "<a href=\"/persons/" + data.user_id +"\">"+ data.user_login +"</a></div>"
        );

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

    $('#message').bind('textchange', function () {
        clearTimeout(timeout);
        typing_status("typing");
    });