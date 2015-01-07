class WsPollsController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
    # check for more https://github.com/websocket-rails/websocket-rails/wiki/WebsocketRails%20Controllers

    # or check https://github.com/lukas2/websockets_chat
  end

  before_action :set_poll_by_url, only: [:add_candidate,:vote_for_candidate]
  #before_action :set_vote_by_nickname, only: [:vote_for_candidate]
  before_action :set_candidate_for_voting, only: [:vote_for_candidate]

  def add_candidate
    # prevent multiple adds of the same name for a poll
    if @poll.candidates.where(name: message[:name]).length == 0
      candidates = @poll.candidates.push(Candidate.new(name:message[:name]))
      trigger_success( message: true)
      #todo: add some hashvalue to avoid duplicated urls
      WebsocketRails[@poll.url.to_sym].trigger(:new_candidate, candidates.last.attributes)
    else
      trigger_failure ( {message: "option with name #{message[:name]} exists already for this poll"})
    end
  end

  def vote_for_candidate
    if @vote
      # already voted for this poll
      # trigger failure
    else
      # create vote on poll
      # trigger success
    end
  end

  private

  #todo: do this after sleeping a few hours 8-(

  def set_candidate_for_voting
    # candidate_id,
    candidate = Candidate.find message[:candidate_id]
    if @poll.id == candidate.poll_id
       # this is actually not supposed to happen
      @candidate = candidate.votes.where(nickname: message[:nickname])
    end
  end

  def set_poll_by_url
    @poll = Poll.find_by_url(message[:url])
  end

  def set_vote_by_nickname
    @vote = @poll.votes.find_by_nickname(message[:nickname])
  end


end