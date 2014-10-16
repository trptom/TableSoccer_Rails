class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
  belongs_to :game
  belongs_to :comment
  
  has_many :comments, :dependent => :destroy
  
  attr_accessible :content, :title, :visible,
    :user, :user_id,
    :comment, :comment_id,
    :match, :match_id,
    :game, :game_id
end
