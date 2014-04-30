module RoomsHelper

  def user_in_room?(room_id, user_id)
    RoomsUser.where(room_id: room_id, user_id: user_id).first.present?
  end

end