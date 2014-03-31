class MainController < ApplicationController

	def index
		puts "#{params}"
		if not signed_in?
			redirect_to root_path
		else
			@users = User.all
		end
	end

	def random_game
		puts "random_game: #{params}"
		puts "user #{current_user.id} is_waiting #{current_user.is_waiting}"

		if current_user.desk
			redirect_to desk_path(current_user.desk)
		else
			waiting_count = User.where(is_waiting: true).count

			if not current_user.is_waiting and not current_user.desk
				current_user.update_attribute(:is_waiting, true)
				waiting_count += 1
				channel = "/player_queue_update"
				PrivatePub.publish_to channel, :waiting_queue_count => waiting_count
			end

			if waiting_count >= 3
				first_three_players = User.where(is_waiting: true).limit(3)
				puts "lets create desk"
				redirect_to new_desk_path
				channel = "/player_queue_update"
				PrivatePub.publish_to channel, :waiting_queue_count => waiting_count
			else
				@count = waiting_count
			end
		end
	end
end
