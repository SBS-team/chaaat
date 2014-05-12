$ ->
  $("#myModal").on "click", "#modal-submit", ->
    $("#myModal").modal "hide"
    return

  getUrlVars = ->
    vars = {}
    parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/g, (m, key, value) ->
      vars[key] = value
      return
    )
    vars

  if parseInt(getUrlVars()["page"])>0
    $("a[href='#pane3']").tab('show');

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
