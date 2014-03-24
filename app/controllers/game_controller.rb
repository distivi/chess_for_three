class GameController < ApplicationController
	def main
		@room = Room.find(params[:id])
		if @room
			@player_white = User.find(@room.player_white_id) if @room.player_white_id
			@player_black = User.find(@room.player_black_id) if @room.player_black_id
			@player_red = User.find(@room.player_red_id) if @room.player_red_id
		end

		if @room && @player_white && @player_black && @player_red 
			puts "START THE GAME!!!"
		else
			redirect_to rooms_path
		end
	end
end
