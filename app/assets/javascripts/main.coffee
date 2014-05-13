$ ->
  $("#myModal").on "click", "#modal-submit", ->
    $("#myModal").modal "hide"
    return

  $("#secret_b").on "click", ->
    $.ajax(
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return
      url: "/rooms/secret"
      data:
        room_id: @getAttribute "data-id"
    ).done (secret) ->
       alert("sss")
       $("#secret-token").html(secret)
       return
    return


  $(".script").each ->
    eval_ $(this).text()
    return

  setText = ($textarea, text) ->
    range = undefined
    textarea = $textarea.get(0)
    textarea.focus()
    if typeof textarea.selectionStart is "number"
      textarea.value = text
      textarea.selectionStart = textarea.selectionEnd = text.length
      return
    range = textarea.createTextRange()
    range.text = text
    range.select()
    return

  $textarea = $("#message")
  textarea = $textarea.get(0)
  if textarea isnt `undefined`
    $textarea.focus()
    if typeof textarea.selectionStart is "number"
      textarea.selectionStart = textarea.selectionEnd = $textarea.val().length
    else
      range = textarea.createTextRange()
      range.select()
    $textarea.keyup()
  return



