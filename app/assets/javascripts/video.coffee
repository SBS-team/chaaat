$(document).ready ->
  $("body").append "<div id='dialog-modal' title='Video dialog'></div>"
  $("#dialog-modal").hide
  $(".video-chat").click ->
    $("#dialog-modal").html("")
    for i in [0..gon.room_members_count-1]
      $("#dialog-modal").append "<div class='video-stream'>test</div>"
    $("#dialog-modal").dialog()