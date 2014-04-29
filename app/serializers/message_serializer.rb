class MessageSerializer < ActiveModel::Serializer
  attributes :id, :messages, :user_id, :login, :avatar, :create_at, :attach_file_path

  def messages
    object.body
  end

  def login
    if object.user.respond_to?('login')
      object.user.login
    end
  end

  def attach_file_path
    object.attach_path.url
  end

  def create_at
  	object.created_at.strftime("%a %T")
  end

  def avatar
    if object.user.respond_to?('avatar')
        object.user.avatar
        if object.user.avatar==nil
          default_url = "#{root_url}images/guest.png"
          gravatar_id = Digest::MD5::hexdigest(object.user.email).downcase
          "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=#{CGI.escape("mm")}"  #FIXME gem
        else
          object.user.avatar
        end
    else
      default_url="../img/sys-notification.png"
    end


  end

end