module RoomsHelper
  def count_members(room_id)
    RoomsUser.where(:room_id=>room_id).count
  end
end