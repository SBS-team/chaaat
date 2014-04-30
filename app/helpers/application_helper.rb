module ApplicationHelper
  def avatar_url(user, foto_size)
      Gravatar.new(user.email).image_url default: 'http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif'
  end

  def get_user_status_style(status)
     { :Available => 'glyphicon glyphicon-eye-open drop-av drop-col-mar',
       :Away => 'glyphicon glyphicon-eye-close drop-away drop-col-mar',
       :'Do not disturb' => 'glyphicon glyphicon-eye-close drop-dnd drop-col-mar',
       :Offline => 'glyphicon glyphicon-eye-close drop-col-mar',
       :Help => 'glyphicon glyphicon-question-sign drop-hlp drop-col-mar' }[status.to_sym]
  end
end

