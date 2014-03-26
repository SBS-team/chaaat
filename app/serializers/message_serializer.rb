class MessageSerializer < ActiveModel::Serializer
  attributes :body, :user_id, :login, :avatar, :created_at

  def login
  	object.user.login
  end

  def created_at
  	object.created_at.strftime("%a %T")
  end

  def avatar
    object.user.avatar
     if object.user.avatar==nil
        default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5::hexdigest(object.user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=#{CGI.escape("mm")}"
    else
       object.user.avatar
    end

  end

end