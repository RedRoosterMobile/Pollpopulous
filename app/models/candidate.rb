class Candidate < ActiveRecord::Base
  belongs_to :poll, inverse_of: :candidates
  has_many :votes
end
