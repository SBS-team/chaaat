module MessageHelper

  #def with_link(message_str)
  #  split_message=message_str.split(" ")
  #  mas_str =[]
  #  split_message.each do |str|
  #    if str.scan("http://")+str.scan(".jpg")==["http://", ".jpg"]
  #      str=str.gsub(str, "<img src=\""+str+"\" >")
  #      CGI::escapeHTML(str)
  #      str.html_safe
  #    end
  #
  #    if str.scan("http://www.youtube.com/watch?v")!=[] || str.scan("https://www.youtube.com/watch?v")!=[]
  #      split_str=str.split("=")
  #      if split_str[0]=="http://www.youtube.com/watch?v"
  #        str= "<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/"+split_str[1].to_s+"\" frameborder=\"0\" allowfullscreen></iframe>"
  #        CGI::escapeHTML(str)
  #        str.html_safe
  #       #raw(str)
  #      end
  #    end
  #    mas_str+=[str]
  #  end
  #  res= mas_str.join("\r")
  #end

end
