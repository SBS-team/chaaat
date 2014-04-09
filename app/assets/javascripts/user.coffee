$(document).ready ->
  $(".change-status").on "click", (event) ->
    strInputCode = $(this)[0].text
    strTagStrippedText = strInputCode.replace(/[\n]( *) /, "")
    $.ajax(
      type: "GET"
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

      url: "/users/status/"
      dataType: "html"
      contentType: "text/html; charset=utf-8"
      data:
        status: strTagStrippedText
    ).done (msg) ->
      $("#drop1.dropdown-toggle.avail")[0].innerHTML = "<span class=\"" + get_user_status_style(msg) + "\"></span>" + msg + "<span class=\"glyphicon glyphicon-hand-down\"></span>"
      return

    return

  return