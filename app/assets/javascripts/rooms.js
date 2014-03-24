jQuery(function($){
    $(".user_friend").click(function(event){
        $.ajax({
            url: '/rooms_users',
            type: 'POST',
            data: {
                room_id: $(this).attr('data_room_id'),
                user_id: $(this).attr('data_user_id')

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
                    $.bootstrapGrowl("You can`t remove that user from room", {
                        type: 'success', // (null, 'info', 'error', 'success')
                        offset: {from: 'top', amount: 50}, // 'top', or 'bottom'
                        align: 'center', // ('left', 'right', or 'center')
                        width: 250, // (integer, or 'auto')
                        delay: 700,
                        allow_dismiss: true,
                        stackup_spacing: 10 // spacing between consecutively stacked growls.
                    });
                }
            }
        });

    });
});

