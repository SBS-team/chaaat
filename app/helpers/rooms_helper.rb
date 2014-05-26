module RoomsHelper

  def user_in_room?(room_id, user_id)
    RoomsUser.where(room_id: room_id, user_id: user_id).first.present?
  end

  def get_10_messages
    @messages.order( created_at: :asc ).last(10)
  end

  def check_current_user
    @room_users.pluck(:id).to_a.include? current_user.id
  end

end