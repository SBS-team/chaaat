class MessageSerializer < ActiveModel::Serializer
  attributes :id, :messages, :user_id, :login, :firstname, :lastname, :avatar, :create_at, :attach_file_path

  def messages
    object.body
  end

  def login
    object.user.login if object.user.respond_to?('login')
  end

  def firstname
    object.user.firstname if object.user.respond_to?('firstname')
  end

  def lastname
    object.user.lastname if object.user.respond_to?('lastname')
  end

  def attach_file_path
    object.attach_path.url
  end

  def create_at
  	object.created_at.strftime('%a %T')
  end

  def avatar
    if object.user.respond_to?('avatar')
      object.user.avatar
      if object.user.avatar.blank?
        Gravatar.new(object.user.email).image_url( size: 50, default: 'http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif?s=50' )
      else
        object.user.avatar
      end
    else
      '../img/sys-notification.png'
    end
  end

end