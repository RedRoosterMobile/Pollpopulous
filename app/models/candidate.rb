class Candidate < ActiveRecord::Base
  belongs_to :poll, inverse_of: :candidates
  has_many :votes, dependent: :destroy

  before_destroy :delete_votes, prepend: true

  private

  def delete_votes
    votes.destroy_all
  end

end
