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



        var list_item = $(document.getElementById(gon.user_id.toString()));
        if (document.getElementById(gon.user_id.toString())){

            $(document.getElementById(gon.user_id.toString())).confirm({
                text: "Are you sure you want to delete yourself?",
                title: "Confirmation required",
                confirm: function(button) {
                    $.ajax({
                        url: '/rooms_users/' + list_item.attr('data_user_id')+'/' + list_item.attr('data_room_id'),
                        type: 'POST',
                        data: {
                            _method: 'DELETE',
                            room_id: list_item.attr('data_room_id'),
                            user_id: list_item.attr('data_user_id')
                        },
                        success: function(response){
                            list_item.remove();
                            self.location="/rooms";
                        }
                    });
                },

                confirmButton: "Yes I am",
                cancelButton: "No",
                post: false
            });
        }
            $('ul').on('click', '.joined_friend', function(e) {
            if ($(this).attr('data_user_id')!=gon.user_id.toString()){
                self.location="/persons/"+$(this).attr('data_user_id');
            }
        });
});


