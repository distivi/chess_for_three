class RoomsController < ApplicationController
	def index
		if not signed_in?
			redirect_to root_path
		else
			room = current_user.room
			# if room
			# 	redirect_to :controller=>'game', :action => 'main', :id => room.id 
			# else 
				@rooms = Room.all
			# end
		end
	end

	def new
		@room = Room.new
	end

	def create
		puts "\n\n\nROOM_TEST\n\n\n#{params}\n\n\n"
		@room = Room.new(room_params)
		# @room.users.create(user_id: current_user.id)
		if @room.save
			flash[:success] = "Welcome to #{@room.name}, please select color"
			redirect_to @room
		else
			render 'new'
		end
	end

	def show
		@room = Room.find(params[:id])
		@player_white = User.find(@room.player_white_id) if (@room.player_white_id && @room.player_white_id.to_i != 0 )
		@player_black = User.find(@room.player_black_id) if (@room.player_black_id && @room.player_black_id.to_i != 0 )
		@player_red = User.find(@room.player_red_id) if (@room.player_red_id && @room.player_red_id.to_i != 0 )
	end

	def take_place
		room = Room.find(params[:room])
		user = User.find(params[:user])

		if user.room
			flash[:error] = "You are taking part in another room '#{user.room.name}'"
		else
			case params[:color]
			when "white"
				if not room.player_white_id
					room.player_white_id = user.id
					user.update_attribute(:room_id, room.id)
				else
					flash[:error] = "You can't take white color"
				end

			when "black"
				if not room.player_black_id
					room.player_black_id = user.id
					user.update_attribute(:room_id, room.id)
				else
					flash[:error] = "You can't take black color"
				end

			when "red"
				if not room.player_red_id
					room.player_red_id = user.id
					user.update_attribute(:room_id, room.id)
				else
					flash[:error] = "You can't take red color"
				end
			else
				flash[:error] = "Hmm, are you hacker ?"
			end

			room.save
		end

		if room_filled?(room)
			redirect_to :controller=>'game', :action => 'main', :id => room.id
		else
			redirect_to room
		end
	end


	def leave
		puts "<><>#{params}"
		user = current_user
		room = Room.find(params[:id])
		if not room
			flash[:error] = "Something went wrong."
		elsif user.room
			puts "user have room #{user.room.id} #{user.room.name}"
			if room.player_white_id.to_i == user.id.to_i
				room.update_attribute(:player_white_id, nil)
			elsif room.player_black_id.to_i == user.id.to_i
				room.update_attribute(:player_black_id, nil)
			elsif room.player_red_id.to_i == user.id.to_i
				room.update_attribute(:player_red_id, nil)
			end

			user.update_attribute(:room, nil)
		end

		redirect_to rooms_path
	end

	private

		def room_params
			params.require(:room).permit(:name)
		end

		def room_filled?(room)
			filled = room.player_white_id && room.player_black_id && room.player_red_id
			return filled
		end

end
