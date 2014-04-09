class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :avatar


  def avatar
    object.avatar
     if object.avatar==nil
        default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5::hexdigest(object.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=#{CGI.escape("mm")}"  #FIXME gem
    else
       object.avatar
    end

  end
end