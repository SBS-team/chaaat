$(document).ready(function () {
    console.log("aaaa")
    var dropZone = $('#dropZone'),
        maxFileSize = 10000000;
    if (typeof(window.FileReader) == 'undefined') {
//        alert('не поддерживается браузером "drag and drop"!');
        dropZone.addClass('error');
    }
    dropZone[0].ondragover = function () {
        console.log("bbbb")
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
        console.log(file)

    if (file.size > maxFileSize) {
        alert('Файл слишком большой!');
        dropZone.addClass('error');
        return false;
    }
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

});