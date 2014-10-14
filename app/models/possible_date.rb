class PossibleDate < ActiveRecord::Base
  belongs_to :match
  has_many :possible_date_selections, :dependent => :destroy
  
  attr_accessible :end_time, :start_time, :match, :match_id
end
