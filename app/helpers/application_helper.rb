module ApplicationHelper
  def avatar_url(user, foto_size)
    if user.avatar.present?
      if foto_size==50
       user.avatar
      else
        user.profile_avatar
      end
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{foto_size}&d=#{CGI.escape("mm")}"
    end
  end

  def with_link(message_str)
    flag=false
    split_message=message_str.split(" ")
    mas_str =[]
    split_message.each do |str|
      if str.scan("http://")+str.scan(".jpg")==["http://", ".jpg"]
        str=str.gsub(str, "<img src=\""+str+"\" >")
        flag=true
      end
      if str.scan(/youtube(.*)v/)!=[]
        split_str=str.split("=")
        if str.scan(/youtube(.*)v/)==[[".com/watch?"]]
          str= "<br><iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/"+split_str[1].to_s+"\" frameborder=\"0\" allowfullscreen></iframe><br>"
          flag=true
        end
      end
      mas_str+=[str]
    end

    if flag==true
      res= mas_str.join("\r")
      CGI::escapeHTML(res)
      res.html_safe
    else
      res= mas_str.join(" ")
    end
  end
end