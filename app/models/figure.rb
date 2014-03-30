class Figure < ActiveRecord::Base
	belongs_to :user
	belongs_to :square

	validates :figure_type, presence: true
	validates :figure_type, :inclusion => { :in => 1..6, :message => "Figure type should be in range 1..6" }

	after_initialize :set_name_for_type

	private
		def set_name_for_type
			names = %w(King Queen Rook Bishop Knight Pawn)
			self.name = names[self.figure_type - 1]
		end

	#	figure_type	|	name
	#		1		|	King
	#		2		|	Queen
	#		3		|	Rook
	#		4		|	Bishop
	#		5		|	Knight
	#		6		|	Pawn
end
