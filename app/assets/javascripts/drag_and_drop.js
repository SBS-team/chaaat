$(document).ready(function () {
    var dropZone = $('#dropZone'),
        maxFileSize = 500000;
    if (typeof(window.FileReader) == 'undefined') {
        dropZone.addClass('error');
    }
    dropZone[0].ondragover = function () {
        dropZone.addClass('hover');
        return false;
    };
    dropZone[0].ondragleave = function () {
        dropZone.removeClass('hover');
        return false;
    };
    dropZone[0].ondrop = function (event) {
        event.preventDefault();
        dropZone.removeClass('hover');
        dropZone.addClass('drop');
        var file = event.dataTransfer.files[0];

        if (file.size > maxFileSize) {
            $.bootstrapGrowl("File size over than 1mb", {
                type: "success",
                offset: {
                    from: "bottom",
                    amount: 50
                },
                align: "center",
                width: 250,
                delay: 5000,
                allow_dismiss: true,
                stackup_spacing: 10
            });
            dropZone.addClass('error');
            return false;
        }
//        if (file.size > maxFileSize) {
//        alert('Файл слишком большой!');
//            dropZone.addClass('error');
//            return false;
//        }
        var formData = new FormData();
        formData.append("messages[body]", $("#message").val());
        formData.append("messages[room_id]", gon.room_id);
        formData.append("messages[attach_path]", file);
        $.ajax({
            type: "POST",

            url: "/messages",
            data: formData,
            processData: false,
            contentType: false,
            success: function(data) {
                $("#new_message")[0].reset();
            },
            error: function(data) {
                console.log(data);
            }
        });
    };
    jQuery.ajaxSetup({
        'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    });

    $.fn.ajaxPagination = function() {
        this.on("click", function () {
            $.get(this.href, null, null, "script");
            return false;
        });
    };

    $(document).ready(function() {
        $( ".pagination a" ).ajaxPagination();
    })

});