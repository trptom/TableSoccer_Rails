class PossibleDateSelection < ActiveRecord::Base
  belongs_to :possible_date
  belongs_to :player
  
  attr_accessible :end_time, :priority, :start_time
end
