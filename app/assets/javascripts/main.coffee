$ ->
  $("#myModal").on "click", "#modal-submit", ->
    $("#myModal").modal "hide"
    return

  $("#editModal").on "submit", "form", ->
    $.ajax
      url: "/users"
      type: "POST"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      data:
        _method: "PUT"
        "user[login]": $("#user_login").val()
        "user[firstname]": $("#user_firstname").val()
        "user[lastname]": $("#user_lastname").val()
        "user[email]": $("#user_email").val()
        "user[password]": $("#user_password").val()
        "user[password_confirmation]": $("#user_password_confirmation").val()
        "user[current_password]": $("#user_current_password").val()

      success: (response) ->
        #(?<=<ul><li>).+(?=<\/li><\/ul>)
        #<\/?[^>]+(>|$)
        errors_div = $("#error_explanation")
        errors_div.html("")
        errors_div.show()
        if(response.indexOf("<div id=\"error_explanation\">") != -1)
          regexp_res = response.match("<ul><li>.+<\/li><\/ul>")
          errors_text = regexp_res.toString().replace("</li>", "\n").replace(/(<([^>]+)>)/ig,"").split("\n")
          for curr_error in errors_text
            errors_div.append(curr_error + "<br>")
        else
          gon_record = response.match(/gon.user_login=\"[a-zA-Z0-9\.\-_]+\"/).toString()
          parsed_login = gon_record.match(/\"[a-zA-Z0-9\.\-_]+\"/).toString().replace(/"/g, "")
          user_login_dom_el = $(".current_user_login")
          user_login_dom_el.html parsed_login
          $(errors_div).hide()
          $("#editModal").modal "hide"
        return
    false

  $("#editModal").on "hidden.bs.modal", ->
    $("#error_explanation").hide()
    return

#  ---------------------------------- user profile photo from gravatar here  ---------------------------------------
  $("a.glyphicon-cog").click ->
    $("#profile_avatar").attr("src", $(".avatar_mini").attr("src"))
# ----------------------------------------------------------------------------------------------------------------
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
