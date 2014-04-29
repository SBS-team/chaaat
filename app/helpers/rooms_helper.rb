module RoomsHelper
  def count_members(rooms_preload,room_id)
    member_count=0
    rooms_preload.each do |t|
      if t.room_id == room_id
         member_count=member_count+1
      end
    end
    member_count
  end

  def user_in_room?(room_id, user_id)
    if RoomsUser.where(:room_id => room_id, :user_id => user_id).first != nil
      true
    else
      false
    end
  end

end