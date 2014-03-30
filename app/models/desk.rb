class Desk < ActiveRecord::Base
	has_many :users
	has_many :squares
end
