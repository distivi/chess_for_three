class Room < ActiveRecord::Base
	has_many :users
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true

	def users_count
		count = 0
		count += 1 if (self.player_white_id && self.player_white_id.to_i != 0)
		count += 1 if (self.player_black_id && self.player_black_id.to_i != 0)
		count += 1 if (self.player_red_id && self.player_red_id.to_i != 0)
		return count
	end

end
