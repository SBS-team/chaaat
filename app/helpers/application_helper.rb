module ApplicationHelper
  def avatar_url(user, foto_size)
      image_url = Gravatar.new(user.email).image_url :default => "http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif"
      return image_url
  end

  def get_user_status_style(user_status)
    case user_status
     when "Available"
        "glyphicon glyphicon-eye-open drop-av drop-col-mar"
     when "Away"
        "glyphicon glyphicon-eye-close drop-away drop-col-mar"
     when "Do not disturb"
        "glyphicon glyphicon-eye-close drop-dnd drop-col-mar"
     when "Offline"
        "glyphicon glyphicon-eye-close drop-col-mar"
     when "Help"
        "glyphicon glyphicon-question-sign drop-hlp drop-col-mar"
    end
  end
end

