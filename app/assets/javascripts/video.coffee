$(document).ready ->
  $("body").append "<div id='dialog-modal' title='Video dialog'></div>"
  $("#dialog-modal").hide
  modal_open=true
  $(".video-chat").click ->
    if modal_open is true
      $("#dialog-modal").html("")
      $("#dialog-modal").append "<div id='videos-container'></div></section>"

      connection = new RTCMultiConnection()
      firebaseURL = "https://chat.firebaseio.com/"
      roomFirebase = new Firebase(firebaseURL + connection.channel + "-session")
      console.log("roomFirebase",roomFirebase)
      roomFirebase.once "value", (data) ->
        modal_open=false
        sessionDescription = data.val()
        # checking for room; if not available "open" otherwise "join"
        unless sessionDescription?
          $.ajax(
            url: "/rooms_users"
            type: "POST"
            beforeSend: (xhr) ->
              xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
              return
            data:
              room_id: gon.room_id
              user_id: gon.user_id
          ).done (response) ->
            window.system_message "User: " + gon.user_login + " has been created video conference"
            return

          connection.open connection.sessionid

          # storing room on server
          roomFirebase.set connection.sessionDescription

          # if room owner leaves; remove room from the server
          roomFirebase.onDisconnect().remove()
        else
          # join as fast as possible
          # pure "sessionDescription" object is passed over "join" method
          connection.join sessionDescription
        console.debug "room is present?", not sessionDescription?
        return

    $("#dialog-modal").dialog()
    #
    $('.ui-dialog-titlebar-close').click ->


      connection.leave()
      connection.autoCloseEntireSession = true;
