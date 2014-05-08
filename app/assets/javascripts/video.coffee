$(document).ready ->
  $("body").append "<div id='dialog-modal' title='Video dialog'></div>"
  $("#dialog-modal").hide
  $(".video-chat").click ->
    $("#dialog-modal").html("")
#    for i in [0..gon.room_members_count-1]
    $("#dialog-modal").append "<button id='setup-new-room'>Setup New Conference</button>"
    $("#dialog-modal").append "<div id='videos-container'></div>"
    config =
      openSocket: (config) ->

        # http://socketio-over-nodejs.hp.af.cm/
        # http://socketio-over-nodejs.jit.su:80/
        # http://webrtc-signaling.jit.su:80/
        SIGNALING_SERVER = "http://webrtc-signaling.jit.su:80/"
        defaultChannel = gon.room_id
        channel = config.channel or defaultChannel
        sender = Math.round(Math.random() * 999999999) + 999999999
        io.connect(SIGNALING_SERVER).emit "new-channel",
          channel: channel
          sender: sender

        socket = io.connect(SIGNALING_SERVER + channel)
        socket.channel = channel
        socket.on "connect", ->
          config.callback socket  if config.callback
          return

        socket.send = (message) ->
          socket.emit "message",
            sender: sender
            data: message
            t: "tttttt"

          return

        socket.on "message", config.onmessage
        socket.on "message", (data) ->
          return

        return

      onRemoteStream: (media) ->
        video = media.video
        video.setAttribute "controls", true
        video.setAttribute "id", media.user_id #somebody else
        console.log "id " + window.my_id

        video_in_div = document.createElement("div")
        video_in_div.setAttribute "class", "stream"
#        videosContainer.insertBefore video, videosContainer.firstChild

        videosContainer.insertBefore video_in_div, videosContainer.firstChild

        video_in_div.insertBefore video, video_in_div.firstChild

        video.play()
        return

      onRemoteStreamEnded: (stream) ->
        alert "Peer has audio stream."
        alert "Peer has video stream."
        console.log "rem " + stream.id
        video = document.getElementById(stream.id)
        video.parentNode.removeChild video  if video
        return

      onRoomFound: (room) ->
        captureUserMedia ->
          conferenceUI.joinRoom
            roomToken: room.broadcaster
            joinUser: room.broadcaster
            my_id: gon.user_id

          return

        return

    conferenceUI = conference(config)
    videosContainer = document.getElementById("videos-container")

    $('#setup-new-room').click ->
      @disabled = true
      captureUserMedia ->
        conferenceUI.createRoom roomName: gon.user_login
        return
      return
    $("#dialog-modal").dialog()

    $('.ui-dialog-titlebar-close').click ->
      conferenceUI.leaveRoom
        left: true
      return



    


    captureUserMedia = (callback) ->
      check_video = document.getElementById("me")
      unless check_video
        video = document.createElement("video")
        video.setAttribute "autoplay", true
        video.setAttribute "controls", true
        video.setAttribute "id", "me" #you

        video_in_div = document.createElement("div")
        video_in_div.setAttribute "class", "stream"

        videosContainer.insertBefore video_in_div, videosContainer.firstChild

        video_in_div.insertBefore video, video_in_div.firstChild
        getUserMedia
          video: video
          onsuccess: (stream) ->
            config.attachStream = stream
            video.setAttribute "muted", true
            callback()
            return
      return
