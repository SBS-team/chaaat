root = exports ? this
$(document).ready ->

  smiles_render = ->
    message = document.getElementsByClassName("chat-body")
    i = 0

    while i < message.length
      emojify.run message[i]
      i++
    return
  check_file = (attach_file_path) ->
    url_to_file = location.origin + attach_file_path
    if url_to_file.match(/http.*(jpg|gif|jpeg|png)/)
      "<img src=\"" + url_to_file + "\" height=\"200px\" width=\"200px\"/>"
    else
      "<a href=\"" + url_to_file + "\" download><span class=\"glyphicon glyphicon-download-alt\"></span>" + attach_file_path.match(/(\w|[-.])+$/)[0] + "</a>"
  send_message = ->
    ++i
    (($(".chat").prepend "<div class=\"pag\"><div class=\"glyphicon glyphicon-chevron-up\"></div></div>")  if pagExist isnt true)  if i is 31
    if $("input[type=\"file\"]")[0].files[0]
      $(".input").block
        message: "<img src=\"../img/busy.gif\" /><p>File uploading, please wait</p>"
        css: {}

    if $.trim(message_textarea.val()).length > 0 or ($("input[type=\"file\"]")[0].files[0])
      fd = new FormData()
      fd.append "messages[body]", $.trim(message_textarea.val())
      fd.append "messages[room_id]", gon.room_id
      fd.append "messages[attach_path]", $("input[type=\"file\"]")[0].files[0]
      $.ajax
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        url: "/messages"
        data: fd
        processData: false
        contentType: false
        success: (data) ->
          $("#new_message")[0].reset()
          $(".input").unblock()
          return

        error: (data) ->
          console.log data
          return

    return
  show_attachment = ->
    $popup_target = $("label.upload-but")
    input_file.change ->
      if input_file[0].files[0].size > 40000000
        $.bootstrapGrowl "File size over than 40mb",
          type: "success"
          offset:
            from: "bottom"
            amount: 50

          align: "center"
          width: 250
          delay: 5000
          allow_dismiss: true
          stackup_spacing: 10

        input_file.replaceWith input_file.clone(true)
      else
        $popup_target.attr
          id: "attach_popup"
          "data-container": "body"
          "data-content": "<div class=\"attach_wrapper\"><div class=\"attach_header\"><span class=\"glyphicon glyphicon-remove\"></span></div><div class=\"attach_content\"><span>" + input_file[0].files[0].name + "</span></div></div>"
          "data-placement": "top"
          "data-toggle": "popover"
          type: "button"

        message_textarea.focus()
        $popup_target.popover html: true
        $popup_target.popover "show"
        $(".popover-content").find("span.glyphicon.glyphicon-remove").click ->
          $("#attach_path").val ""
          $(".attach_wrapper").remove()
          $popup_target.popover "hide"
          return

      return

    return
  render_message = (data) ->
    $("#messages-wrapper").append template(data)
    objDiv = document.getElementsByClassName("chat")[0]
    objDiv.scrollTop = objDiv.scrollHeight + 2000
    smiles_render()
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
      if (word.match(/\@\S*/)) and (not word.match(/<span>\@\S*/) and ((word.match(/\@\S*/g)[0] is "@" + gon.user_login) or (word.match(/\@\S*/g)[0] is "@all")))
        results.push word.replace(/\@\S*/, "<span class=\"to-user\">" + $.trim(word.match(/\@\S*/)[0]) + "</span> ")
      else if word.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/)
        results.push word.replace(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/, "<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/" + youtube_parser(word) + "\" frameborder=\"0\" allowfullscreen></iframe><br>")
      else if word.match(/http.*(jpg|gif|jpeg)/)
        src = word.match(/http.*(jpg|gif|jpeg)/)
        results.push word.replace(/http.*(jpg|gif|jpeg)/, "<br><img src=" + src[0] + " height=\"500px\" width=\"300px\"/a>")
      else if word.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)
        word = word.replace("view", "embed")
        src = "\"" + word.slice(0, 27) + "?muted=false&autostart=false&originalSize=false&hideTopBar=false&noSiteButtons=false&startWithHD=false" + "\""
        results.push "<br><iframe src=" + src + "\" frameborder=\"0\" allowfullscreen=\"true\" height=\"315px\" width=\"560px\"></iframe><br>"
      else if word.match(/(\b\w+:\/\/\w+((\.\w)*\w+)*\.\S{2,3}(\/\S*|\.\w*|\?\w*\=\S*)*)/)
        results.push "<a href=" + word + " target=\"_blank\">" + word + "</a>"
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
  inviteAjax = (InputId) ->
    $.ajax
      url: "/users/invite_user"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        email: InputId

      success: (response) ->
        $.bootstrapGrowl "You have send invite to: " + response,
          type: "success"
          offset:
            from: "top"
            amount: 50

          align: "center"
          width: 250
          delay: 10000
          allow_dismiss: true
          stackup_spacing: 10

        $("#search-user").val ""
        $(".right_search_user").html ""
        return

    return
  send_invite = ->
    $("li .send_invite").on "click", ->
      inviteAjax $("#search-user").val()
      return

    return
  root.system_message = (body) ->
    fd = new FormData()
    fd.append "messages[body]", $.trim(body)
    fd.append "messages[room_id]", gon.room_id
    fd.append "messages[message_type]", "system"
    $.ajax
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "/messages"
      data: fd
      processData: false
      contentType: false

    return
  Handlebars.registerHelper "equal", (r_value) ->
    if gon.user_id is r_value
      "from"
    else
      $("#new-message")[0].play()
      "to"

  Handlebars.registerHelper "safe_mess", (messag) ->
    if messag.length > 240 or messag.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/) or messag.match(/http.*(jpg|gif|jpeg)/) or messag.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)
      if messag.match(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/) or messag.match(/http.*(jpg|gif|jpeg)/) or messag.match(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i)
        "<div id=\"short-text\" style=\"display: block;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>" + "<p class=\"primary-font\">" + "<div class=\"text-muted\">" + "<i>" + "This message has a content..." + "</i></div></p></div>" + "<div id=\"long-text\" style=\"display: none;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>" + "<p>" + $.trim(changetags(safe_tags_replace(messag))) + "</p>" + "</div>"
      else
        if messag.match(/(\b\w+:\/\/\w+((\.\w)*\w+)*\.\S{2,3}(\/\S*|\.\w*|\?\w*\=\S*)*)/)
          "<div id=\"short-text\" style=\"display: block;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>" + "<p><a href=" + messag.substr(0, 109) + "..." + "\"  target=\"_blank\">" + messag.substr(0, 109) + "..." + "</a></p></div>" + "<div id=\"long-text\" style=\"display: none;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>" + "<p>" + $.trim(changetags(safe_tags_replace(messag))) + "</p>" + "</div>"
        else
          "<div id=\"short-text\" style=\"display: block;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-down\" style=\"cursor: pointer;\"></span></small>" + "<p>" + $.trim(changetags(safe_tags_replace(messag))).substr(0, 109) + "..." + "</p></div>" + "<div id=\"long-text\" style=\"display: none;\">" + "<small class=\"pull-right text-muted\">" + "<span class=\"glyphicon glyphicon-chevron-up\" style=\"cursor: pointer;\"></span></small>" + "<p>" + $.trim(changetags(safe_tags_replace(messag))) + "</p>" + "</div>"
    else
      "<p>" + $.trim(changetags(safe_tags_replace(messag))) + "</p>"

  Handlebars.registerHelper "attach-files", (attach_file_path) ->
    check_file attach_file_path

  Handlebars.registerHelper "change_login", (user_id, login) ->
    (if (user_id isnt null) then "<a href=\"/persons/" + user_id + "\">" + login + "</a>" else "chat notification")

  template = Handlebars.compile($("#template_message").html())
  $("#pop").popover html: true
  message_textarea = $("#message")
  iframe = $("iframe")
  search = $("#search")
  input_file = $("input[type=file]#attach_path")
  root.users = ["all"].concat(gon.rooms_users)
  message_offset = 10
  invoted_users()
  show_attachment()
  if gon.room_id
    Pusher.host = "192.168.137.75"
    Pusher.ws_port = 8081
    Pusher.wss_port = 8081
    pusher = new Pusher(gon.pusher_app,
      authEndpoint: "/pusher/auth?room_id=" + gon.room_id
    )
    channel = pusher.subscribe("private-" + gon.room_id)
    channel.bind "new_message", (data) ->
      render_message data
      i = 0

      while $("#messages-wrapper li").size() > 30
        $("#messages-wrapper li").first().remove()
        i++
      return

  $(document).on "click", ".smile", (e) ->
    message_textarea.val message_textarea.val() + $(e.target).attr("id")
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

  $(".list").on "click", ".drop_room_user", (event) ->

    drop_user_span = event.currentTarget
    root.joined_member = $(drop_user_span).parent()
    return

  $(".drop_room_user").confirm
    text: "Are you sure you want to delete user?"
    title: "User deleting confirmation"
    confirm: ->
      $.ajax
        url: "/rooms_users/" + root.joined_member.data("user-id") + "/" + root.joined_member.data("room-id")
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        data:
          _method: "DELETE"
          room_id: root.joined_member.data("room-id")
          user_id: root.joined_member.data("user-id")

        success: (response) ->
          root.system_message "User: " + response.user_login + " has been deleted from room: " + response.room_name
          root.joined_member.remove()
          return

      return

    confirmButton: "Yes I am"
    cancelButton: "No"
    post: false

  $(".content").on "click", ".delete_room", (event) ->
    root.element_delete_room = event.currentTarget
    return

  $(".delete_room").confirm
    text: "Are you sure you want to delete this room?"
    title: "Confirmation required"
    confirm: ->
      $.ajax
        url: "../rooms/" + $(root.element_delete_room).data("id")
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        data:
          _method: "DELETE"
          id: $(root.element_delete_room).data("id")

        success: (response) ->
          $(root.element_delete_room).parents("table.rooms_group").hide()
          $("a[room_id='" + $(root.element_delete_room).data("id") + "']").parents("li#room").hide()
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

  message_textarea.keydown (e) ->
    if e.keyCode is 13 and e.ctrlKey is false
      send_message()
      if input_file
        $(".attach_wrapper").remove()
        $("label.upload-but").popover "hide"
      e.preventDefault()
    document.getElementById("message").value += "\r\n"  if e.keyCode is 13 and e.ctrlKey
    return

  $(".send_message_button").click ->
    send_message()
    if input_file
      $(".attach_wrapper").remove()
      $("label.upload-but").popover "hide"
    return

  $("#search").keyup ->
    $.ajax(
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "../messages/search/"
      data:
        query: $("#search").val()
        room_id: gon.room_id
    ).done (msg) ->
      $("#messages-wrapper").html template(msg)
      smiles_render()
      return

    return

  i = 0
  pagExist = false
  pagExist = true  if $(".pag").length > 0
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

  $(".rooms_group").on "click", ".friend_action.add_friend", ->
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

  $(".chat").on "click", ".pag", (->
    $.ajax
      url: "../rooms/previous_messages"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        room_id: gon.room_id
        messages: $(".clearfix").first().data("id")

      success: (response) ->
        if response.messages.length > 0
          $("#messages-wrapper").prepend "<div class=\"glyphicon glyphicon-resize-vertical\" style=\"margin:0 50% 0 50%;opacity:0.5;font-size:20px\"></div>"
          $("#messages-wrapper").prepend template(response)
          smiles_render()
          message_offset += 10
        return

    return
  )
  $(".inv").on "click", (e) ->
    inviteAjax $("#email").val()
    e.preventDefault()
    return

  template_search_user_right = "{{#users}}<div class=\"member\"><a data-method=\"post\" href=\"/persons/{{login}}\" rel=\"nofollow\"><span class=\"{{#get_icon_status user_status}}{{/get_icon_status}}\"></span>{{login}}</a><span class=\"glyphicon glyphicon-plus pull-right user_friend\" data-user-id=\"{{id}}\"></span></div>{{/users}}"
  search_user_right = Handlebars.compile(template_search_user_right)
  $("#search-user").keyup ->
    if $(this).val().match(/^[-a-z0-9!#$%&'*+\/=?^_`{|}~]+(\.[-a-z0-9!#$%&'*+\/=?^_`{|}~]+)*@([a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/)
      $(".right_search").html "<li style='text-align:center'><button class='btn send_invite'>Send invite</button></li>"
      send_invite()
    else
      $.ajax
        url: "/users/search"
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
          return

        data:
          login: $("#search-user").val()

        success: (response) ->
          $(".right_search").html search_user_right(response)
          return

    return

  template_search_user = "{{#users}}<tr friend_id=\"{{id}}\"><td><div class=\"friend_photo\"><img class=\"avatar\" src=\"{{avatar}}\"></div><div class=\"friend_name\"></div><a href=\"/persons/{{login}}\">{{login}}</a></td><td class=\"friend_action add_friend\"><span class=\"glyphicon glyphicon-plus add_new_friend\"></span></td></tr>{{/users}}"
  search_user = Handlebars.compile(template_search_user)
  $("#search-box").keyup ->
    $.ajax
      url: "/users/search"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        login: $("#search-box").val()

      success: (response) ->
        $(".rooms_group").html search_user(response)
        return

    return

  $("body").on "click", (e) ->
    $("[data-toggle=\"popover\"]").each ->
      $(this).popover "hide"  if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
      return

    return

  $(".content").on "click", "#short-text .glyphicon.glyphicon-chevron-down", ->
    $(this).parents(".message").find("#short-text").hide()
    $(this).parents(".message").find("#long-text").show()
    return

  $(".content").on "click", "#long-text .glyphicon.glyphicon-chevron-up", ->
    $(this).parents(".message").find("#short-text").show()
    $(this).parents(".message").find("#long-text").hide()
    return

  return