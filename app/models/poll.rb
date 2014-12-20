class Poll < ActiveRecord::Base
  has_many :votes
  has_many :candidates ,inverse_of: :poll




end
