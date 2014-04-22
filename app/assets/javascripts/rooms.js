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
                user_id: $(this).data('user-id')}

        })
            .done(function(response){
                system_message("User: " + response.joined_user.login + " has been added to room: " + response.room_name);
                $('.user_friend[data-user-id = ' + response.joined_user.id + ']').remove();
            });
        return false;
    });

    function singleClick(e) {
        if ($(e).parent().attr('data-user-id')!=gon.user_id.toString()){
            self.location="/persons/"+$(e).html();
        }
    }

    function doubleClick(e) {
        if ($(e).parent().attr('data-user-id')!=gon.user_id.toString()){
            strInputCode = $(e).html();
            strInputCode = strInputCode.replace(/&(lt|gt);/g, function (strMatch, p1){
                return (p1 == "lt")? "<" : ">";
            });
            var strTagStrippedText = strInputCode.replace(/<\/?[^>]+(>|$)/g, "");
            $.ajax(
                {  type: "POST",
                    url: "/rooms",
                    data: {express:true,
                    room: {
                        name:  gon.user_login+" vs. "+strTagStrippedText,
                        topic: 'express chat'
                    },
                    user_id:$(e).parent().attr('data-user-id')}
                })

            .done(function(response){
                self.location=response;
            });
        }
    }

    var clickCount = 0;

    $('.list').on('click','a', function () {
        clickCount++;
        href_query=this
        if (clickCount === 1) {
            singleClickTimer = setTimeout(function () {
                clickCount = 0;
                singleClick(href_query);
            }, 400);
        }
        else if (clickCount === 2) {
            clearTimeout(singleClickTimer);
            clickCount = 0;
            doubleClick(href_query);
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
            .done(function(topic){
                system_message("Rooms topic has been changed from: \""+topic.prev_topic+"\" on: \""+topic.curr_topic+"\"");
                $('#change').val('');
            });

    }

});
