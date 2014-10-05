class PossibleDate < ActiveRecord::Base
  belongs_to :match
  attr_accessible :end_time, :start_time
end
