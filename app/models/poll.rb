class Poll < ActiveRecord::Base

  before_destroy :destroy_candidates, prepend: true

  has_many :votes,inverse_of: :candidate
  has_many :candidates ,inverse_of: :poll, dependent: :destroy

  private

  def destroy_candidates
    puts 'destroy candidates'
    candidates.destroy_all
  end

end
