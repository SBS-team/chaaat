/**
 * Created by moroka on 18.03.14.
 */
jQuery(function($){
    $(".user_friend").click(function(event){
        $.ajax({
            url: '/rooms_users',
            type: 'POST',
            data: {
                room_id: $(this).attr('data_room_id'),
                user_id: $(this).attr('data_user_id')
           },
            success: function(response){
                if(response.joined_user != null && response.room_id != null)
                   var joined_users_list =  $("ul.nav.side-nav-rigth");
//                   joined_users_list.append("<li class=\"joined_friend\"><a href=\"/rooms_users/" + response.joined_user.id + "/"+response.room_id
//                                                                          + " \"data-method=\"delete\">"
//                                                                          + response.joined_user.firstname + " "
//                                                                          + response.joined_user.lastname +" "
//                                                                          + "<span class = \"glyphicon glyphicon-minus pull-right\">"
//                                                                          +"</span></a></li>");
                joined_users_list.append("<li class=\"joined_friend\" data_room_id=\""
                                                              + response.room_id+"\""
                                                              + "data_user_id=\""+ response.joined_user.id +"\">" + " "
                                                              +"<a href=\"#\">"
                                                              + response.joined_user.firstname + " "
                                                              + response.joined_user.lastname + "</a>"
                                                              +" <span class=\"glyphicon glyphicon-minus pull-right\"></span></li>");
            }
        });
    });


    $('ul').on('click', '.joined_friend', function(e) {
            var list_item = $(this);
            $.ajax({
                url: '/rooms_users/' + list_item.attr('data_user_id')+'/' + list_item.attr('data_room_id'),
                type: 'POST',
                data: {
                    _method: 'DELETE',
                    room_id: list_item.attr('data_room_id'),
                    user_id: list_item.attr('data_user_id')
                },
                success: function(response){
                    if(response.drop_user_id == response.cur_user_id){
                        list_item.remove();
                    }else{
                        alert("You can`t remove user from room");
                    }
                }
            });

    });

//    $("#new_room").submit(function(e){
//        e.preventDefault();
//
//        var $form  = $(this),
//            url = $form.attr('action');
//
//        var posting = $.post(url, {
//            room: {
//                name:  $('input[type="text"]#room_name').val(),
//                topic: $('input[type="text"]#room_topic').val()
//            }
//        });
//        posting.done(function(response){
//           alert("ROOM WAS CREATED");
//           //Code to kill modal window for creating form here
//           //and redirect to room#show page
//        });
//    });

});
