module DeskHelper
	# WARNING!! very hardcoded string (business logic), don't touch anithing in constants
	VERTICAL_LINES = [%w(A1 A2 A3 A4 A9 A10 A11 A12),
						%w(B1 B2 B3 B4 B9 B10 B11 B12),
						%w(C1 C2 C3 C4 C9 C10 C11 C12),
						%w(D1 D2 D3 D4 D9 D10 D11 D12),

						%w(E1 E2 E3 E4 E5 E6 E7 E8),
						%w(F1 F2 F3 F4 F5 F6 F7 F8),
						%w(G1 G2 G3 G4 G5 G6 G7 G8),
						%w(H1 H2 H3 H4 H5 H6 H7 H8),

						%w(K8 K7 K6 K5 K9 K10 K11 K12),
						%w(L8 L7 L6 L5 L9 L10 L11 L12),
						%w(M8 M7 M6 M5 M9 M10 M11 M12),
						%w(N8 N7 N6 N5 N9 N10 N11 N12)]

	HORIZONTAL_LINE = [%w(A1 B1 C1 D1 E1 F1 G1 H1),
						%w(A2 B2 C2 D2 E2 F2 G2 H2),
						%w(A3 B3 C3 D3 E3 F3 G3 H3),
						%w(A4 B4 C4 D4 E4 F4 G4 H4),

						%w(H8 G8 F8 E8 K8 L8 M8 N8),
						%w(H7 G7 F7 E7 K7 L7 M7 N7),
						%w(H6 G6 F6 E6 K6 L6 M6 N6),
						%w(H5 G5 F5 E5 K5 L5 M5 N5),

						%w(N12 M12 L12 K12 D12 C12 B12 A12),
						%w(N11 M11 L11 K11 D11 C11 B11 A11),
						%w(N10 M10 L10 K10 D10 C10 B10 A10),
						%w(N9 M9 L9 K9 D9 C9 B9 A9)]

	DIAGONALS = [%w(G1 H2),
					%w(F1 G2 H3),
					%w(E1 F2 G3 H4),
					%w(D1 E2 F3 G4 H5),
					%w(C1 D2 E3 F4 G5 H6),
					%w(B1 C2 D3 E4 F5 G6 H7),
					%w(B1 A2),
					%w(C1 B2 A3),
					%w(D1 C2 B3 A4),
					%w(E1 D2 C3 B4 A9),
					%w(F1 E2 D3 C4 B9 A10),
					%w(G1 F2 E3 D4 C9 B10 A11),
					%w(B12 A11),
					%w(C12 B11 A10),
					%w(D12 C11 B10 A9),
					%w(K12 D11 C10 B9 A4),
					%w(L12 K11 D10 C9 B4 A3),
					%w(M12 L11 K10 D9 C4 B3 A2),
					%w(M12 N11),
					%w(L12 M11 N10),
					%w(K12 L11 M10 N9),
					%w(D12 K11 L10 M9 N5),
					%w(C12 D11 K10 L9 M5 N6),
					%w(B12 C11 D10 K9 L5 M6 N7),
					%w(M8 N7),
					%w(L8 M7 N6),
					%w(K8 L7 M6 N5),
					%w(E8 K7 L6 M5 N9),
					%w(F8 E7 K6 L5 M9 N10),
					%w(G8 F7 E6 K5 L9 M10 N11),
					%w(G8 H7),
					%w(F8 G7 H6),
					%w(E8 F7 G6 H5),
					%w(K8 E7 F6 G5 H4),
					%w(L8 K7 E6 F5 G4 H3),
					%w(M8 L7 K6 E5 F4 G3 H2)]

	CENTER_DIAGONALS_WHITE = [%w(H1 G2 F3 E4),
								%w(A12 B11 C10 D9),
								%w(N8 M7 L6 K5)]

	CENTER_DIAGONALS_BLACK = [%w(A1 B2 C3 D4),
								%w(N12 M11 L10 K9),
								%w(H8 G7 F6 E5)]


	def is_user_can_move_from_to(desk,from,to)
		puts "is_user_can_move_from_to #{desk} #{from} #{to} #{current_user} #{current_user.desk.user_walketh_id}"
		if current_user.id == current_user.desk.user_walketh_id
			puts "check point 1 <"
			from_name = from.upcase
			to_name = to.upcase

			from_square = desk.squares.where(:name => from_name).take
			
			if from_square and from_square.figure and from_square.figure.user == current_user
				puts "check point 2 <"

				to_square = desk.squares.where(:name => to_name).take

				if to_square 
					if to_square.figure and to_square.figure.user == current_user
						puts "check point 2.1 <"
						return false
					end
					puts "check point 3 <"
					# check how figure moving
					selected_figure = from_square.figure
					current_color = current_user.color

					is_can_move = false

					if selected_figure.figure_type == 1 #king
						moving_line = moving_line_for_rook_at_square_to_square(from_name,to_name)
						if moving_line
							is_can_move = is_king_can_move_on_path(from_name,to_name,moving_line,desk)
							if not is_can_move
								# may be King can make_castling
								is_casting = is_king_can_make_castling(from_name,to_name,moving_line,desk)
								puts "check point qweqwe #{is_casting}"
								if is_casting
									# move rook
									# {move_rook: {from: path[rook_index], to: path[new_rook_square_index]}}
									rook_from_square = is_casting[:move_rook][:from]
									rook_to_square = is_casting[:move_rook][:to]
									move_figure_from_square_to_square(rook_from_square,rook_to_square,desk)

									return true
								end
							end
							return is_can_move
						end

						moving_diagonal = moving_diagonal_for_bishop_at_square_to_square(from_name,to_name)
						if moving_diagonal
							is_can_move = is_king_can_move_on_path(from_name,to_name,moving_diagonal,desk)
							return is_can_move
						end

						return false
						# king END:
					elsif selected_figure.figure_type == 2 #queen
						moving_line = moving_line_for_rook_at_square_to_square(from_name,to_name)
						if moving_line
							is_can_move = is_nobody_overlap_way_from_to_on_path(from_name,to_name,moving_line,desk)
							return is_can_move
						end

						moving_diagonal = moving_diagonal_for_bishop_at_square_to_square(from_name,to_name)
						if moving_diagonal
							is_can_move = is_nobody_overlap_way_from_to_on_path(from_name,to_name,moving_diagonal,desk)
							return is_can_move
						end

						return false
						# queen END:
					elsif selected_figure.figure_type == 3 #rook
						moving_line = moving_line_for_rook_at_square_to_square(from_name,to_name)
						if moving_line
							is_can_move = is_nobody_overlap_way_from_to_on_path(from_name,to_name,moving_line,desk)
							return is_can_move
						end

						return false
						# rook END
					elsif selected_figure.figure_type == 4 #bishop
						moving_diagonal = moving_diagonal_for_bishop_at_square_to_square(from_name,to_name)
						if moving_diagonal
							is_can_move = is_nobody_overlap_way_from_to_on_path(from_name,to_name,moving_diagonal,desk)
							return is_can_move
						end

						return false
						#bishop END
					elsif selected_figure.figure_type == 5 #knight
						available_squares = available_squares_for_knight_at_square(from_name)
						available_squares.each do |tmp_square|
							if tmp_square == to_name
								return true
							end
						end

						return false
						# knight END:
					elsif selected_figure.figure_type == 6 #pawn
						moving_length = is_pawn_first_move(from_name,current_color) ? 2 : 1
						pawn_on_line = vertical_line_for_square(from_name)
						pawn_on_line = sort_vertical_line_for_pawn_with_color(pawn_on_line,from_name,current_color)

						if pawn_on_line and pawn_on_line.include? to_name

							from_index = pawn_on_line.index(from_name)
							to_index = pawn_on_line.index(to_name)
							length_bitween_square = to_index - from_index

							if length_bitween_square > 0 and length_bitween_square <= moving_length

								((from_index + 1)..to_index).to_a.each do |square_index|
									square_tmp_name = pawn_on_line[square_index]
									if desk.squares.where(:name => square_tmp_name).take.figure
										return false
									end
									return true
								end
							end
						else # pawn_on_line and pawn_on_line.include? to_name
							# may be pawn can attack someone
							attack_squares = attack_squares_for_pawn_at_square(from_name, pawn_on_line, current_color)
							if attack_squares
								attack_squares.each do |attack_square|
									if attack_square == to_name and to_square.figure
										return true
									end
								end
							end
						end
					end

				end
			end
		end

		return false
	end

	def move_figure_from_square_to_square(from_square,to_square,desk)
		to_square = desk.squares.where(:name => to_square.upcase).take
		if to_square.figure 
			to_square.figure.delete
		end

		from_figure = desk.squares.where(:name => from_square.upcase).take.figure

		from_figure.square.update_attribute(:figure, nil)
		to_square.update_attribute(:figure, from_figure)
		from_figure.update_attribute(:square, to_square)

		if from_figure.figure_type == 6 # pawn
			if is_pawn_come_to_last_line(to,current_user.color)
				from_figure.update_attribute(:figure_type, 2)
			end
		end
	end

	def is_pawn_come_to_last_line(square_name, pawn_color)
		square = square_name.upcase
		horizontal_line = horizontal_line_for_square(square)
		line_index = HORIZONTAL_LINE.index(horizontal_line)
		if pawn_color == 1 and (line_index == 4 or line_index == 8)
			return true
		elsif pawn_color == 2 and (line_index == 0 or line_index == 4)
			return true
		elsif pawn_color == 3 and (line_index == 0 or line_index == 8)
			return true
		end
		return false
	end

	def is_pawn_first_move(square_name, color)
		start_line_for_pawn = (color == 1) ? "2" : (color == 2 ? "11" : "7") 
		if square_name.sub(/\w/,'') == start_line_for_pawn
			return true
		end
		return false
	end

	def vertical_line_for_square(square_name)
		VERTICAL_LINES.each do |line|
			if line.include? square_name
				return line 
			end
		end
	end

	def horizontal_line_for_square(square_name)
		HORIZONTAL_LINE.each do |line|
			if line.include? square_name
				return line 
			end
		end
	end

	def diagonals_for_square(square_name)
		diagonals = []
		DIAGONALS.each do |diagonal|
			if diagonal.include? square_name
				diagonals << diagonal
			end
		end
		return (diagonals.length > 0) ? diagonals : nil
	end

	def center_diagonals_for_square(square_name)
		white_diagonal = center_diagonal_white_for_square(square_name)
		black_diagobal = center_diagonal_black_for_square(square_name)
		return {white: white_diagonal, black: black_diagobal}
	end

	def center_diagonal_white_for_square(square_name)
		CENTER_DIAGONALS_WHITE.each do |diagonal|
			if diagonal.include? square_name
				return diagonal
			end
		end
		return nil
	end

	def center_diagonal_black_for_square(square_name)
		CENTER_DIAGONALS_BLACK.each do |diagonal|
			if diagonal.include? square_name
				return diagonal
			end
		end
		return nil
	end

	def attack_squares_for_pawn_at_square(square_name, line, pawn_color)
		pawn_index = line.index(square_name)
		next_square = line[pawn_index + 1]

		if next_square
			horizontal_line = horizontal_line_for_square(next_square)
			if horizontal_line
				# check for squares with standart 2 players logic
				index = horizontal_line.index(next_square)
				attack_squares = []
				if horizontal_line[index + 1]
					attack_squares << horizontal_line[index + 1]
				end
				if horizontal_line[index - 1]
					attack_squares << horizontal_line[index - 1]
				end

				# check for squares with 3 players logic on center diagonals
				center_attack_squares = attack_squares_for_pawn_at_square_with_color(square_name, pawn_color)
				if center_attack_squares
					attack_squares += center_attack_squares
					attack_squares.uniq!
				end
				
				return (attack_squares.length == 0) ? nil : attack_squares
			end
		end
		return nil
	end

	def sort_vertical_line_for_pawn_with_color(line,pawn_square,color)
		line_index = VERTICAL_LINES.index line
		square_index = line.index pawn_square

		if color == 1 and line_index > 7 and line_index < 12
			if square_index < 4
				return line.reverse
			end
		elsif color == 2 
			puts "check point ololo >>> #{line_index} #{square_index}"
			unless line_index > 3 and line_index < 8 and square_index > 3
				puts "check point ololo >>> #{line.reverse}"
				return line.reverse
			end
		elsif color ==3 
			if (line_index >=4 and line_index < 8) or
				(line_index >= 0 and line_index < 4 and square_index < 4)
				return line.reverse
			end
		end
		return line
	end

	def attack_squares_for_pawn_at_square_with_color(square_name, pawn_color)
		diagonals = center_diagonals_for_square(square_name)
		diagonal = diagonals[:white] || diagonals[:black]

		if diagonal
			# which center diagonal
			center_diagonal = diagonals[:white] ? CENTER_DIAGONALS_WHITE : CENTER_DIAGONALS_BLACK
			square_index = diagonal.index(square_name)

			if square_index == 3
				diagonalIndex = center_diagonal.index(diagonal)

				if pawn_color == 1 and diagonalIndex == 0
					return [center_diagonal[1][3],center_diagonal[2][3]]
				elsif pawn_color == 2 and diagonalIndex == 1
					return [center_diagonal[0][3],center_diagonal[3][3]]
				elsif pawn_color == 3 and diagonalIndex == 2
					return [center_diagonal[0][3],center_diagonal[1][3]]
				end
			end
		end
		return nil;
	end

	def moving_diagonal_for_bishop_at_square_to_square(from_square,to_square)
		diagonals = diagonals_for_square(from_square)
		if diagonals
			#check if to_square on it diagonal
			diagonals.each do |diagonal|
				if diagonal.include? to_square
					return diagonal
				end
			end
		end

		# check if can move on center diagonal
		center_diagonals = center_diagonals_for_square(from_square)
		center_diagonal = center_diagonals[:white] ? CENTER_DIAGONALS_WHITE : CENTER_DIAGONALS_BLACK

		from_diagonal = center_diagonals[:white] || center_diagonals[:black]

		#check if to_square on it diagonal
		center_diagonal.each do |tmp_diagonal|
			if tmp_diagonal.include? to_square
				from_diagonal_index = center_diagonal.index(from_diagonal)
				to_diagonal_index = center_diagonal.index(tmp_diagonal)
				if from_diagonal_index == to_diagonal_index
					return from_diagonal
				else
					long_diagonal = from_diagonal + tmp_diagonal.reverse
					return long_diagonal
				end
			end
		end

		return nil
	end

	def moving_line_for_rook_at_square_to_square(from_square,to_square)
		h_line = horizontal_line_for_square(from_square)
		if h_line.include? to_square
			return h_line
		end

		v_line = vertical_line_for_square(from_square)
		if v_line.include? to_square
			return v_line
		end

		return nil
	end

	def available_squares_for_knight_at_square(from_square)
		available_squares = []

		v_line = vertical_line_for_square(from_square)
		square_index = v_line.index(from_square)

		if square_index < 6 
			step_one_square = v_line[square_index + 2]
			available_squares += get_horizontal_squares_for_knight_step_one_square(step_one_square)
		end

		if square_index > 1
			step_one_square = v_line[square_index - 2]
			available_squares += get_horizontal_squares_for_knight_step_one_square(step_one_square)
		end

		h_line = horizontal_line_for_square(from_square)
		square_index = h_line.index(from_square)

		if square_index < 6
			step_one_square = h_line[square_index + 2]
			available_squares += get_vertical_squares_for_knight_step_one_square(step_one_square)
		end

		if square_index > 1
			step_one_square = h_line[square_index - 2]
			available_squares += get_vertical_squares_for_knight_step_one_square(step_one_square)
		end

		return ( available_squares.length > 0 ) ? available_squares : nil
	end

	def get_horizontal_squares_for_knight_step_one_square(for_square)
		available_squares = []
		h_line = horizontal_line_for_square(for_square)
		h_square_index = h_line.index(for_square)
		available_squares << h_line[h_square_index + 1] if h_line[h_square_index + 1]
		available_squares << h_line[h_square_index - 1] if h_line[h_square_index - 1]
		return available_squares
	end

	def get_vertical_squares_for_knight_step_one_square(for_square)
		available_squares = []
		v_line = vertical_line_for_square(for_square)
		v_square_index = v_line.index(for_square)
		available_squares << v_line[v_square_index + 1] if v_line[v_square_index + 1]
		available_squares << v_line[v_square_index - 1] if v_line[v_square_index - 1]
		return available_squares
	end

	def is_nobody_overlap_way_from_to_on_path(from_square,to_square,path,desk)
		from_index = path.index(from_square)
		to_index = path.index(to_square)
		if from_index and to_index
			min_index = [from_index, to_index].min + 1
			max_index = [from_index, to_index].max - 1
			(min_index..max_index).to_a.each do |index|
				tmp_square_name = path[index]
				if desk.squares.where(:name => tmp_square_name).take.figure
					return false
				end
			end
			return true
		end
		return false
	end

	def is_king_can_move_on_path(from_square,to_square,path,desk)
		from_index = path.index(from_square)
		to_index = path.index(to_square)
		length = (from_index - to_index).abs

		if length == 1
			return true
		end

		return false
	end

	def is_king_can_make_castling(from_square,to_square,path,desk)
		puts "is_king_can_make_castling !!!"
		king = current_user.figures.where(:figure_type => 1).take
		if king.untouched
			puts "is_king_can_make_castling king.untouched"
			is_horizontal_path = HORIZONTAL_LINE.include?(path)
			puts "is_king_can_make_castling is_horizontal_path #{is_horizontal_path}"
			if is_horizontal_path and path.include? to_square
				from_index = path.index(from_square)
				to_index = path.index(to_square)
				length = (from_index - to_index).abs
				puts "is_king_can_make_castling length #{length}"
				if length == 2
					rooks = current_user.figures.where(:figure_type => 3, :untouched => true)
					if rooks.count > 0
						rook_index = (from_index > to_index) ? 0 : 7

						rooks.each do |rook|
							puts "rook.square.name == path[rook_index] #{rook.square.name} | #{path[rook_index]}"
							if rook.square.name == path[rook_index]
								is_can_move = is_nobody_overlap_way_from_to_on_path(from_square,path[rook_index],path,desk)
								if is_can_move
									new_rook_square_index = (rook_index == 0) ? 3 : 5;
									return {move_rook: {from: path[rook_index], to: path[new_rook_square_index]}}
								end
							end
						end

					end
				end
			end
		end
		return nil
	end

end
