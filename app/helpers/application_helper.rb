module ApplicationHelper
  def avatar_url(user, foto_size)
    #if user.respond_to?('avatar')
    if user.avatar.present?
      if foto_size == 50
       user.avatar
      else
        user.profile_avatar
      end
    else
      Gravatar.new(user.email).image_url(:size => foto_size, :default => "http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif?s=#{foto_size}" )
    end
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

