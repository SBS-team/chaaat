class MessageSerializer < ActiveModel::Serializer
  attributes :body, :user_id, :login, :created_at

  def login
  	object.user.login
  end

  def created_at
  	object.created_at.strftime("%a %T")
  end

end
