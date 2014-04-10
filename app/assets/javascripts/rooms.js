//#FIXME coffescript
var mymodal = $("#myModal");

$(function () {
    $('#modal-submit').click(function(){mymodal.hide();$(".modal-backdrop").hide();})
})

jQuery(function($){
    mymodal.on('click','#modal-submit', function(){
        mymodal.modal('hide');
    });

    $(".right_search_user").on('click',".user_friend",function(event){
        $.ajax({
            url: '/rooms_users',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: {
                room_id: gon.room_id,
                user_id: $(this).data('user-id')
            }
        });
        return false;
    });

    var list_item = $(document.getElementById(gon.user_id));
    if (document.getElementById(gon.user_id)){
        $(document.getElementById(gon.user_id)).confirm({
            text: "Are you sure you want to delete yourself?",
            title: "Confirmation required",
            confirm: function(button) {
                $.ajax({
                    url: '/rooms_users/' + list_item.attr('user_id')+'/' + list_item.attr('room_id'),
                    type: 'POST',
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
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

    $('.member').on('dblclick','a', function(e) {
        if ($(this).parent().attr('user_id')!=gon.user_id.toString()){
            strInputCode = $(this).html();
            strInputCode = strInputCode.replace(/&(lt|gt);/g, function (strMatch, p1){
                return (p1 == "lt")? "<" : ">";
            });
            var strTagStrippedText = strInputCode.replace(/<\/?[^>]+(>|$)/g, "");
            posting = $.post('/rooms/',
            {   express:true,
                room: {
                    name:  gon.user_login+" vs. "+strTagStrippedText,
                    topic: 'express chat'
                },
                user_id:$(this).parent().attr('user_id')
            });

            posting.done(function(response){
                $.post('rooms_users/pusher_send_to_user')
                self.location=response;
            });
        }
    });

    $('.member').on('click','a', function(e) {
        if ($(this).parent().attr('user_id')!=gon.user_id.toString()){
            self.location="/persons/"+$(this).parent().attr('user_id');
        }
    });

    $('.change-topic').on('submit',function(){
        change_topic();
        return false;
    });
    function change_topic(){
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: "/rooms/change",
            data: { query: $("input[name='change']").val(),room_id:gon.room_id}

        })
            .done(function(chang){
                $('#change').val('');
            });

    }

});
