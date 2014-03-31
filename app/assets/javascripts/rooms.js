//$( document ).ready(function() {
//// Handler for .ready() called.
//
////    $('#modal-submit').click(function(){alert("OK");})
//    $('#new_room').on('click', '#modal-submit',  function(){
//        alert("REJECT");
//        $('#myModal').modal('hide')
//
//    });
//});
jQuery(function($){
    $(".user_friend").click(function(event){
        $.ajax({
            url: '/rooms_users',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: {
                room_id: $('li.active > a').attr('room_id'),
                user_id: $(this).attr('user_id')
            }
        });
        return false;
    });

    var list_item = $(document.getElementById(gon.user_id.toString()));
    if (document.getElementById(gon.user_id.toString())){

        $(document.getElementById(gon.user_id.toString())).confirm({
            text: "Are you sure you want to delete yourself?",
            title: "Confirmation required",
            confirm: function(button) {
                $.ajax({
                    url: '/rooms_users/' + list_item.attr('user_id')+'/' + list_item.attr('room_id'),
                    type: 'POST',
                    data: {
                        _method: 'DELETE',
                        room_id: list_item.attr('room_id'),
                        user_id: list_item.attr('user_id')
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


    $('ul').on('dblclick', '.joined_friend', function(e) {
        if ($(this).attr('user_id')!=gon.user_id.toString()){

            e.preventDefault();

            var strInputCode = $(this).html();
            strInputCode = strInputCode.replace(/&(lt|gt);/g, function (strMatch, p1){
                return (p1 == "lt")? "<" : ">";
            });
            var strTagStrippedText = strInputCode.replace(/<\/?[^>]+(>|$)/g, "");

            var posting = $.post('/rooms/', {
                express:true,
                room: {
                    name:  gon.user_login+" vs. "+strTagStrippedText,
                    topic: 'express chat'
                },
                user_id:$(this).attr('user_id')
            });
            posting.done(function(response){
                $.post('rooms_users/pusher_send_to_user')
                self.location=response;
            });
        }
    });
    $('ul').on('click', '.joined_friend', function(e) {
        if ($(this).attr('user_id')!=gon.user_id.toString()){
            self.location="/persons/"+$(this).attr('user_id');
        }
    });
});