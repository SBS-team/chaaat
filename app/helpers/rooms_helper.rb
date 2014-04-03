module RoomsHelper
  def count_members(rooms_preload,room_id,member_count=0)
    rooms_preload.each do |t|
      if t.room_id == room_id
         member_count=member_count+1
      end
    end
    member_count
  end
end