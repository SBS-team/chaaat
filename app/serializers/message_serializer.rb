class MessageSerializer < ActiveModel::Serializer
  attributes :message, :user_id, :login, :avatar, :create_at, :attach_file_path

  def message
    object.body
  end

  def login
  	object.user.login
  end

  def attach_file_path
    object.attach_path.url
  end

  def create_at
  	object.created_at.strftime("%a %T")
  end

  def avatar
    object.user.avatar
     if object.user.avatar==nil
        default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5::hexdigest(object.user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=#{CGI.escape("mm")}"  #FIXME gem
    else
       object.user.avatar
    end

  end

end