class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :avatar, :user_status


  def avatar
    object.avatar
     if object.avatar.blank?
       Gravatar.new(object.email).image_url( size: 50, default: 'http://cdn2.vox-cdn.com/images/verge/default-avatar.v9899025.gif?s=50')
    else
       object.avatar
    end
  end
end