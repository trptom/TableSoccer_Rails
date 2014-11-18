class BlackDot < ActiveRecord::Base
  belongs_to :player
  attr_accessible :count, :description, :type, :viewed, :player, :player_id
end
