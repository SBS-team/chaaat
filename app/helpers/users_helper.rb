module UsersHelper

  def is_friend?(user_id) #FIXME refactoring
    current_user.friendships.pluck(:friend_id).include? user_id
  end

end
