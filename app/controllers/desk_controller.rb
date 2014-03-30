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

			create_squares_for_desk(desk)
			arrange_figures_for_users_on_desk(first_three_players,desk)

			if desk.save
				redirect_to desk
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
				render :json => @desk.to_json(:include => { 
					:users => { 
						:include => {:figures => {
							:include => {
									:square => {:only => :name}
								}, :only => :figure_type}
						}, :only => [:name, :color ]
					}
				})

				# render json: @desk.users.map { |user| user.figures 
				#render :json => @notes.to_json(:include => { :user => { :only => :username } })
			end
		end
	end

	def help
		puts "#{params}"
		if params[:square]
			name = params[:square].upcase
			square = Desk.find(params[:id]).squares.where(:name => name).take
			if square.figure
				render :json => square.figure
			else
				render :json => {error: "Empty square"}
			end
		else 
			render :json => {error: "Wrong params"}
		end
	end

	def move
		puts "#{params}"
		from = params[:from]
		to = params[:to]
		if from and to
			desk = Desk.find(params[:id])
			from_square = desk.squares.where(:name => from).take
			if from_square.figure
				render :json => {from: from, to: to}
			else
				render :json => {error: "Empty square"}
			end
		else
			render :json => {error: "Wrong params"}
		end
	end

	private

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