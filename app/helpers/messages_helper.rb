module MessagesHelper

  def message_body_scan?(message)
    message.body.scan(/http.*(jpg|gif|jpeg|png)/) != [] ||
    message.body.scan(/http.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?].\S\S*)/) != [] ||
    message.body.scan(/http:\/\/(coub\.com\/view\/.*|coub\.com\/embed\/.*)/i) != []
  end

end
