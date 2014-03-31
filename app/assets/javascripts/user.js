$('.change-status').click(function(event){
    $.ajax({
        type: "GET",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: "../users/status/",
        data: { status: $(this).attr("data-id") }
    })
        .done(function(msg) {
            $("#userStatus")[0].innerHTML ="<span class=\""+ get_status_icon_style(msg) +"\"></span>"
                                        +"Status"+" <span class=\"caret\"></span>";
        });
});