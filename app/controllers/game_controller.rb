class GameController < ApplicationController
	def main
		id = params[:id]

		if not signed_in?
			redirect_to root_path
		elsif not current_user.room || current_user.room.id != id
			redirect_to rooms_path
		else
			@room = Room.find(params[:id]) if id
			if not @room
				redirect_to rooms_path
			end
		end
	end

	def send_message
		room_id = params[:room]
		user_id = params[:user]
		msg = params[:message]

		right_room = current_user.room.id.to_i == room_id.to_i
		right_user = current_user.id.to_i == user_id.to_i

		if !msg.blank? and right_user
			channel = "/messages/#{room_id}/new"
			color = "guest"
			if right_room
				color = color_for_user(user_id,room_id)
			end

			PrivatePub.publish_to channel, :chat_message => msg, :user => current_user.name, :color => color
		end
	end

	private 
		def color_for_user(user_id,room_id)
			room = Room.find(room_id)

			if room.player_white_id.to_i == user_id.to_i
				return "white"
			elsif room.player_black_id.to_i == user_id.to_i
				return "black"
			elsif room.player_red_id.to_i == user_id.to_i
				return "red"
			end
			return "guest"
		end

end
