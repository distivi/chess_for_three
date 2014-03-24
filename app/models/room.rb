class Room < ActiveRecord::Base
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true

	def users_count
		count = 0
		count += 1 if self.player_white_id
		count += 1 if self.player_black_id
		count += 1 if self.player_red_id
		return count
	end

end
