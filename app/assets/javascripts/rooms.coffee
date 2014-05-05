mymodal = $("#myModal")
$("#modal-submit").click ->
  mymodal.hide()
  $(".modal-backdrop").hide()
  return

$ ->
  $("#modal-submit").click ->
    if $("#room_topic").val() is ""
      $.bootstrapGrowl "You have write TOPIC",
        type: "success" # (null, 'info', 'error', 'success')
        offset: # 'top', or 'bottom'
          from: "top"
          amount: 50

        align: "center" # ('left', 'right', or 'center')
        width: 250 # (integer, or 'auto')
        delay: 10000
        allow_dismiss: true
        stackup_spacing: 10 # spacing between consecutively stacked growls.

      mymodal.hide()
      $(".modal-backdrop").hide()
    return

  return

jQuery ($) ->
  singleClick = (e) ->
    self.location = "/persons/" + $(e).html()
    return
  doubleClick = (e) ->
    unless $(e).parent().attr("data-user-id") is gon.user_id.toString()
      strInputCode = $(e).html()
      strInputCode = strInputCode.replace(/&(lt|gt);/g, (strMatch, p1) ->
        (if (p1 is "lt") then "<" else ">")
      )
      strTagStrippedText = strInputCode.replace(/<\/?[^>]+(>|$)/g, "")
      $.ajax(
        type: "POST"
        url: "/rooms"
        data:
          express: true
          room:
            name: gon.user_login + " vs. " + strTagStrippedText
            topic: "express chat"

          user_id: $(e).parent().attr("data-user-id")
      ).done (response) ->
        self.location = response
        return

    return
  change_topic = ->
    $.ajax(
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "/rooms/change"
      data:
        query: $("input[name='change']").val()
        room_id: gon.room_id
    ).done (topic) ->
      window.system_message 'Rooms topic has been changed from: "' + topic.prev_topic + '" on: "' + topic.curr_topic + '"'
      $("#change").val ""
      return

    return
  mymodal.on "click", "#modal-submit", ->
    mymodal.modal "hide"
    return

  $(".right_search_user").on "click", ".user_friend", (event) ->
    $.ajax(
      url: "/rooms_users"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        room_id: gon.room_id
        user_id: $(this).data("user-id")
    ).done (response) ->
      window.system_message "User: " + response.joined_user.login + " has been added to room: " + response.room_name
      $('.user_friend[data-user-id = ' + response.joined_user.id + ']').parent().remove();
      return

    false

  clickCount = 0
  $(".list").on "click", "a", ->
    clickCount++
    href_query = this
    if clickCount is 1
      singleClickTimer = setTimeout(->
        clickCount = 0
        singleClick href_query
        return
      , 400)
    else if clickCount is 2
      clearTimeout singleClickTimer
      clickCount = 0
      doubleClick href_query
    return

  $(".change-topic").on "submit", ->
    change_topic()
    false

  return
