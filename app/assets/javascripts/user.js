$(document).ready(function(){

    function get_user_status_style(user_status_id){
        switch(user_status_id){
            case 'Available':
                return "glyphicon glyphicon-eye-open drop-av drop-col-mar";
            case 'Away':
                return "glyphicon glyphicon-eye-close drop-away drop-col-mar";
            case 'Do not disturb':
                return "glyphicon glyphicon-eye-close drop-dnd drop-col-mar"
            case "Offline":
                return  "glyphicon glyphicon-share-alt drop-col-mar";
        }
    }

    $('.change-status').on('click',function(event){
    $.ajax({
      type: "GET",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url: "../users/status/",
      data: { status: $(this)[0].text }
      })
      .done(function(msg) {
          $("#drop1.dropdown-toggle.avail")[0].innerHTML ="<span class=\""+get_user_status_style(msg)+"\"></span>"+msg+"<span class=\"glyphicon glyphicon-hand-down\"></span>";
      });
    });
});