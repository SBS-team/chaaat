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

  def get_user_status_style(user_status)
    case user_status
     when 'Available'
        'glyphicon glyphicon-eye-open drop-av drop-col-mar'
     when 'Away'
        'glyphicon glyphicon-eye-close drop-away drop-col-mar'
     when 'Do not disturb'
        'glyphicon glyphicon-eye-close drop-dnd drop-col-mar'
      when 'Offline'
        'glyphicon glyphicon-eye-open drop-col-mar'
    end
  end
end