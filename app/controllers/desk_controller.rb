class DeskController < ApplicationController
	include DeskHelper

	def new
		first_three_players = User.where(is_waiting: true).limit(3)

		if first_three_players.count < 3
			redirect_to main_path
		else
			desk = Desk.create()

			3.times do |i|
				tmp_user = first_three_players[i]
				tmp_user.update_attribute(:is_waiting, false)
				tmp_user.update_attribute(:color, i + 1)
				tmp_user.update_attribute(:desk, desk)
			end

			desk.update_attribute(:user_walketh_id, first_three_players[0].id)

			create_squares_for_desk(desk)
			arrange_figures_for_users_on_desk(first_three_players,desk)

			if desk.save
				redirect_to desk

				# notify users for new game
				first_three_players.each do |user|
					channel = "/start_game/#{user.id}"
					PrivatePub.publish_to channel, :is_start => true
				end
			else
				redirect_to main_path
			end
		end
	end

	def show
		@desk = Desk.find(params[:id])

		respond_to do |format|
			format.html
			format.json do 
				render :json => json_for_all_figures_from_desk(@desk)
			end
		end
	end

	def select_figure
		if params[:square]
			if current_user.id == current_user.desk.user_walketh_id
				name = params[:square].upcase
				square = Desk.find(params[:id]).squares.where(:name => name).take
				if square.figure
					if square.figure.user == current_user
						render :json => square.figure
					else
						render :json => {error: "Not your figure"}
					end
				else
					render :json => {error: "Empty square"}
				end
			else
				render :json => {error: "Now is not your turn, please wait."}
			end
		else 
			render :json => {error: "Wrong params"}
		end
	end

	def move_figure
		puts "#{params}"
		from = params[:from]
		to = params[:to]
		if from and to
			desk = Desk.find(params[:id])
			if (is_user_can_move_from_to(desk,from,to))
				is_moved = move_figure_from_square_to_square(from,to,desk)
				if is_moved
					next_player_id = next_player_id_for_desk(desk)
					desk.update_attribute(:user_walketh_id, next_player_id)

					channel = "/chess_desk/#{desk.id}/update"
					PrivatePub.publish_to channel, :desk => desk

					render :json => json_for_all_figures_from_desk(desk)
				else
					render :json => {error: "You can't go there"}
				end
			else
				render :json => {error: "You can't go there"}
			end
		else
			render :json => {error: "Wrong params"}
		end
	end

	private

		def json_for_all_figures_from_desk(desk)
			return desk.to_json(:include => { 
						:users => { 
							:include => {:figures => {
								:include => {
										:square => {:only => :name}
									}, :only => :figure_type}
							}, :only => [:name, :color ]
						}
					})
		end

		def next_player_id_for_desk(desk)
			current_user_color_id = desk.user_walketh_id
			users = desk.users
			color = users.find(current_user_color_id).color
			color = (color == 3) ? 1 : color + 1
			next_user = users.where(:color => color).take
			return next_user.id
		end

		def create_squares_for_desk(desk)
			# warning!!! Very hardcoded ranges, don't touch anithing here

			('A'..'D').to_a.each do |char|
				[1,2,3,4,9,10,11,12].to_a.each do |number|
					name = char + number.to_s
					desk.squares.create!(name: name)
				end
			end

			('E'..'H').to_a.each do |char|
				(1..8).to_a.each do |number|
					name = char + number.to_s
					desk.squares.create!(name: name)
				end
			end

			('K'..'N').to_a.each do |char|
				(5..12).to_a.each do |number|
					name = char + number.to_s
					desk.squares.create!(name: name)
				end
			end
		end

		def arrange_figures_for_users_on_desk(users,desk)
			types = 6
			counters = [1, 1, 2, 2, 2, 8]
			users.each do |user|
				types.times do |type|
					counters[type].times do |counter|
						figure = user.figures.build(:figure_type => (type + 1))
						info = {:color => user.color, :type => figure.figure_type, :counter => counter}
						square_name = initial_square_name(info)
						square = desk.squares.where(name: square_name).take!
						square.update_attribute(:figure, figure)
						figure.update_attribute(:square, square)
					end
				end
			end
		end

		def initial_square_name(info)
			color = info[:color]
			type = info[:type]
			counter = info[:counter]

			if color == 1 #white
				if type == 1 # king
					return "E1"
				elsif type == 2 #queen
					return "D1"
				elsif type == 3 #rook
					return (counter == 0) ? "A1" : "H1"
				elsif type == 4 #bishop
					return (counter == 0) ? "C1" : "F1"
				elsif type == 5 #knight
					return (counter == 0) ? "B1" : "G1"
				elsif type == 6 #pawn
					str = ('A'..'H').to_a[counter] + "2"
					return str
				end

			elsif color == 2 # red
				if type == 1 # king
					return "D12"
				elsif type == 2 #queen
					return "K12"
				elsif type == 3 #rook
					return  (counter == 0) ? "N12" : "A12"
				elsif type == 4 #bishop
					return  (counter == 0) ? "L12" : "C12"
				elsif type == 5 #knight
					return  (counter == 0) ? "M12" : "B12"
				elsif type == 6 #pawn
					str = %w(N M L K D C B A)[counter] + "11"
					return str
				end

			elsif color == 3 # black
				if type == 1 # king
					return "K8"
				elsif type == 2 #queen
					return "E8"
				elsif type == 3 #rook
					return (counter == 0) ? "H8" : "N8"
				elsif type == 4 #bishop
					return (counter == 0) ? "F8" : "L8"
				elsif type == 5 #knight
					return (counter == 0) ? "G8" : "M8"
				elsif type == 6 #pawn
					str = %w(H G F E K L M N)[counter] + "7"
					return str
				end
			end
		end
end
