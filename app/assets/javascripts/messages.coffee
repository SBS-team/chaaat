$(document).ready ->
  check_file = (attach_file_path) ->
    url_to_file = location.origin + attach_file_path
    if url_to_file.match(/http.*(jpg|gif|jpeg|png)/)
      "<img src=\"" + url_to_file + "\" height=\"200px\" width=\"200px\"/>"
    else
      "<a href=\"" + url_to_file + "\" download><span class=\"glyphicon glyphicon-download-alt\"></span>" + attach_file_path.match(/(\w|[-.])+$/)[0] + "</a>"
  send_message = ->
    if $.trim(message_textarea.val()).length > 0 or ($("input[type=\"file\"]")[0].files[0])
      fd = new FormData()
      fd.append "message[body]", $.trim(message_textarea.val())
      fd.append "message[room_id]", gon.room_id
      fd.append "message[attach_path]", $("input[type=\"file\"]")[0].files[0]
      $.ajax
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        url: "../message/new"
        data: fd
        processData: false
        contentType: false
        success: (data) ->
          $("#new_message")[0].reset()
          return

        error: (data) ->
          console.log data
          return

    return
  show_attachment = ->
    $popup_target = $("label.upload-but")
    input_file.change ->
      $popup_target.attr
        id: "attach_popup"
        "data-container": "body"
        "data-content": "<div class=\"attach_wrapper\"><div class=\"attach_header\"><span class=\"glyphicon glyphicon-remove\"></span></div><div class=\"attach_content\"><span>" + $input_file[0].files[0].name + "</span></div></div>"
        "data-placement": "top"
        "data-toggle": "popover"
        type: "button"

      message_textarea.focus()
      $popup_target.popover html: true
      $popup_target.popover "show"
      $(".popover-content").find("span.glyphicon.glyphicon-remove").click ->
        $("#attach_path").val ""
        $("attach_wrapper").remove()
        $popup_target.popover "hide"
        return

      return

    return
  render_message = (data) ->
    $("#messages-wrapper").append template(data)
    objDiv = document.getElementsByClassName("chat")[0]
    objDiv.scrollTop = objDiv.scrollHeight + 2000
    emojify.setConfig
      emoticons_enabled: true
      people_enabled: true
      nature_enabled: true
      objects_enabled: true
      places_enabled: true
      symbols_enabled: true

    i = 0

    while i < document.getElementsByClassName("chat-body").length
      emojify.run document.getElementsByClassName("chat-body")[i]
      i++
    return
  prepend_message = (user_id, login, body, avatar, time, message, attach_file_path) ->
    if gon.user_id is user_id
      $("#messages-wrapper").prepend create_message(user_id, login, body, avatar, time, "from")
    else
      $("#messages-wrapper").prepend create_message(user_id, login, body, avatar, time, "to")
    return
  invoted_users = ->
    messages = $("li .chat-body p")
    i = 0

    while i < messages.length
      messages[i].innerHTML = changetags(messages[i].innerHTML)
      emojify.run messages[i]
      i++
    attached_file = $(".attach_file")
    i = 0

    while i < attached_file.length
      attached_file[i].innerHTML = check_file(attached_file[i].innerHTML)
      i++
    return
  changetags = (text) ->
    words = text.split(" ")
    results = []
    i = 0

    while i < words.length
      word = words[i]
      if (word.match(/\@\S*/)) and (not word.match(/<span>\@\S*/) and (word.match(/\@\S*/g)[0] is "@" + gon.user_login))
        results.push word.replace(/\@\S*/, "<span class=\"to-user\">" + $.trim(word.match(/\@\S*/)[0]) + "</span> ")
      else if word.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/)
        results.push word.replace(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/, "<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/" + youtube_parser(word) + "\" frameborder=\"0\" allowfullscreen></iframe><br>")
      else if word.match(/http.*(jpg|gif|jpeg)/)
        src = word.match(/http.*(jpg|gif|jpeg)/)
        results.push word.replace(/http.*(jpg|gif|jpeg)/, "<br><img src=" + src[0] + " height=\"500px\" width=\"300px\"/a>")
      else if word.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)
        word = word.replace("view", "embed")
        src = "\"" + word + "?muted=false&autostart=false&originalSize=false&hideTopBar=false&noSiteButtons=false&startWithHD=false" + "\""
        results.push "<br><iframe src=" + src + "\" frameborder=\"0\" allowfullscreen=\"true\" height=\"315px\" width=\"560px\"></iframe><br>"
      else if word.match(/http.*/)
        results.push "<a href=" + word + ">" + word + "</a>"
      else
        results.push word
      i++
    parsedMessage = results.join(" ")
    parsedMessage
  youtube_parser = (url) ->
    regExp = /http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/
    match = url.match(regExp)
    match[7]  if match and match[7].length is 11
  replaceTag = (tag) ->
    tagsToReplace[tag] or tag
  safe_tags_replace = (str) ->
    str.replace /[&<>]/g, replaceTag
  Handlebars.registerHelper "equal", (r_value) ->
    (if (gon.user_id is r_value) then "from" else "to")

  Handlebars.registerHelper "safe_mess", (messag) ->
    $.trim changetags(safe_tags_replace(messag))

  Handlebars.registerHelper "attach-files", (attach_file_path) ->
    check_file attach_file_path

  template_message = "{{#message}}<li class=\"{{#equal user_id}}{{/equal}} clearfix\"><span class=\"chat-img pull-left\"><img class=\"avatar\" src=\"{{avatar}}\"></span><div class=\"chat-body clearfix\"><div class=\"header\"> <strong class=\"primary-font\"> <a href=\"/persons/{{url}}\">{{login}}</a></strong><small class=\"pull-right text-muted\"><span class=\"glyphicon glyphicon-time\"></span>{{create_at}}</small></div><p>{{#safe_mess message}}{{/safe_mess}}</p>{{#if attach_file_path}}<p class=\"attach-file\">{{#attach-files attach_file_path}}{{/attach-files}}</p>{{/if}}</div></li>{{/message}}"
  template = Handlebars.compile(template_message)
  $("#pop").popover html: true
  message_textarea = $("#message")
  iframe = $("iframe")
  search = $("#search")
  input_file = $("input[type=file]#attach_path")
  users = gon.rooms_users
  message_offset = 10
  invoted_users()
  show_attachment()
  Pusher.host = "192.168.137.75"
  Pusher.ws_port = 8081
  Pusher.wss_port = 8081
  pusher = new Pusher("255267aae6802ec7914f")
  channel = pusher.subscribe("private-" + gon.room_id)
  channel.bind "new_message", (data) ->
    render_message data
    return

  $(document).on "click", ".emoji", (e) ->
    message_textarea.val message_textarea.val() + $(e.target).attr("title")
    message_textarea.focus()
    return

  $(document).on "click", ".show_smile", ->
    iframe.each ->
      url = $(this).attr("src")
      char = "?"
      char = "&"  unless url.indexOf("?") is -1
      $(this).attr "src", url + char + "wmode=transparent"
      return

    return

  $(".content").on "click", ".delete_room", (event) ->
    element_delete_room = event.currentTarget
    return

  $(".delete_room").confirm
    text: "Are you sure you want to delete this room?"
    title: "Confirmation required"
    confirm: ->
      $.ajax
        url: "../rooms/del/"
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        data:
          id: $(element_delete_room).data("id")

        success: (response) ->
          $(element_delete_room).parents("table.rooms_group").hide()
          $("a[room_id='" + $(element_delete_room).data("id") + "']").parents("li#room").hide()
          return

      return

    confirmButton: "Yes I am"
    cancelButton: "No"
    post: false

  iframe.each ->
    ifr_source = $(this).attr("src")
    wmode = "wmode=transparent"
    unless ifr_source.indexOf("?") is -1
      getQString = ifr_source.split("?")
      oldString = getQString[1]
      newString = getQString[0]
      $(this).attr "src", newString + "?" + wmode + "&" + oldString
    else
      $(this).attr "src", ifr_source + "?" + wmode
    return

  $(".panel-footer").on "submit", ->
    send_message()
    false

  message_textarea.keyup (e) ->
    if e.keyCode is 13 and e.ctrlKey is false
      send_message()
      if input_file
        $("attach_wrapper").remove()
        $("label.upload-but").popover "hide"
      $("html, body").animate
        scrollTop: $("body").height()
      , 800
    document.getElementById("message_input").value += "\r\n"  if e.keyCode is 13 and e.ctrlKey
    return

  search.keyup ->
    $.ajax(
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "../message/search/"
      data:
        query: search.val()
        room_id: gon.room_id
    ).done (msg) ->
      $("#messages-wrapper").html template(msg)
      return

    return

  tagsToReplace =
    "&": "&amp;"
    "<": "&lt;"
    ">": "&gt;"

  $("#message").textcomplete([
    match: /\B@([\-+\w]*)$/
    search: (term, callback) ->
      callback $.map(users, (user) ->
        (if user.indexOf(term) is 0 then user else null)
      )
      return

    template: (value) ->
      "@" + value

    replace: (value) ->
      "@" + value + " "

    index: 1
    maxCount: 5
  ]).on
    "textComplete:show": ->
      set_top = setInterval(->
        $("ul.dropdown-menu:last").css "top", -$("ul.dropdown-menu:last").height()
        return
      , 100)
      return

    "textComplete:hide": ->
      clearInterval set_top  if set_top
      return

  $(".friend").click ->
    sender = $(this)
    unless self.location.toString().indexOf("persons/") is -1
      self.location = sender.attr("user_id")
    else
      self.location = "persons/" + sender.attr("user_id")
    return

  $(".friend_action.add_friend").click ->
    $.ajax
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "/friendships"
      data:
        friend_id: $(this).parent().attr("friend_id")

      success: (response) ->
        $("tr[friend_id = \"" + response + "\"]").remove()
        return

    return

  $(".friend_action.remove_friend").click ->
    $.ajax
      url: "/friendships/" + $(this).attr("friend_id")
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        _method: "DELETE"
        friend_id: $(this).attr("friend_id")

      success: (response) ->
        $("tr[friend_id = \"" + response + "\"]").remove()
        return

    return

  $(".pag").click ->
    $.ajax
      url: "../rooms/previous_messages"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        room_id: gon.room_id
        offset_records: message_offset

      success: (response) ->
        if response.rooms.length > 0
          $("#messages-wrapper").prepend "<div class=\"glyphicon glyphicon-resize-vertical\" style=\"margin:0 50% 0 50%;opacity:0.5;font-size:20px\"></div>"
          i = 0

          while i <= response.rooms.length - 1
            prepend_message response.rooms[i].user_id, response.rooms[i].login, response.rooms[i].body, response.rooms[i].avatar, response.rooms[i].created_at, response.rooms[i].attach_file_path
            i++
          emojify.setConfig
            emoticons_enabled: true
            people_enabled: true
            nature_enabled: true
            objects_enabled: true
            places_enabled: true
            symbols_enabled: true

          i = 0

          while i < document.getElementsByClassName("chat-body").length
            emojify.run document.getElementsByClassName("chat-body")[i]
            i++
          message_offset += 10
        return

    return

  return