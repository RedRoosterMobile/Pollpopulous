class Poll < ActiveRecord::Base
  has_many :votes,inverse_of: :candidate
  has_many :candidates ,inverse_of: :poll
end
