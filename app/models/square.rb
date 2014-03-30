class Square < ActiveRecord::Base
	belongs_to :figure
	belongs_to :desk
end
