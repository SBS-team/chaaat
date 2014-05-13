module ApplicationHelper

  def avatar_url(user, foto_size)
    if user.avatar.present?
      foto_size == 50 ? user.avatar : user.profile_avatar
    else
      Gravatar.new(user.email).image_url( size: foto_size, default: "http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif?s=#{foto_size}" )
    end
  end

  def get_user_status_style(status)
     { Available: 'glyphicon glyphicon-eye-open drop-av drop-col-mar',
       Away: 'glyphicon glyphicon-eye-close drop-away drop-col-mar',
       :'Do not disturb' => 'glyphicon glyphicon-eye-close drop-dnd drop-col-mar',
       Offline: 'glyphicon glyphicon-eye-close drop-col-mar',
       Help: 'glyphicon glyphicon-question-sign drop-hlp drop-col-mar' }[status.to_sym]
  end

  def get_link_class(room)
    'active' if room.id == params[:id].to_i
  end

  def get_status(user)
    user.user_status == 'Offline' ? 'Offline ' + time_ago_in_words(user.updated_at) : user.user_status
  end

end
