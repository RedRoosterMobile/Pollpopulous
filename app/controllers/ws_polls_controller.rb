class WsPollsController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
    # check for more https://github.com/websocket-rails/websocket-rails/wiki/WebsocketRails%20Controllers

    # or check https://github.com/lukas2/websockets_chat
  end

  before_action :set_poll, only: [:revoke_vote,:add_candidate,:vote_for_candidate]
  before_action :set_vote_by_nickname, only: [:vote_for_candidate]
  #before_action :set_candidate_for_voting, only: [:vote_for_candidate]

  def add_candidate
    # prevent multiple adds of the same candidate-name for a poll
    if @poll.candidates.where(name: message[:name]).length == 0
      candidates = @poll.candidates.push(Candidate.new(name:message[:name]))

      trigger_success( message: true)

      last_candidate = candidates.last
      votes = last_candidate.votes

      # manipulate array to just use attributes
      vote_array = []
      votes.each do |vote|
        vote_array.push vote.attributes
      end

      return_hash = last_candidate.attributes
      return_hash['votes'] = vote_array

      # todo: add some hashvalue to avoid duplicated urls
      WebsocketRails[@poll.url.to_sym].trigger(:new_candidate, return_hash )
    else
      trigger_failure ( {message: "option with name #{message[:name]} exists already for this poll"})
    end
  end

  def revoke_vote
    nickname = message[:nickname]
    vote_id = message[:vote_id]
    candidate_id = message[:candidate_id]

    vote = Vote.find(vote_id)
    if vote.nickname==nickname
      if vote
        vote_attribs=vote.attributes
        trigger_success ( {message: 'vote revoked'})
        vote.delete
        # trigger update of all channel members
        WebsocketRails[@poll.url.to_sym].trigger(:revoked_vote, {candidate_id: candidate_id, vote: vote_attribs} )
      else
        trigger_failure ( {message: 'vote not found'})
      end
    else
      trigger_failure ( {message: 'this was not your vote'})
    end

  end

  def vote_for_candidate
    puts 'vote for candate'

    if @vote
      # already voted for this poll
      trigger_failure ( {message: 'you already voted for this poll'})
    else
      # create vote on poll
      # trigger success
      puts message
      candidate_id = message[:candidate_id]
      @new_vote = Vote.new(poll_id: @poll.id, candidate_id: candidate_id,nickname: message[:nickname])

      trigger_success( message: @new_vote.save)

      # trigger update of all channel members
      WebsocketRails[@poll.url.to_sym].trigger(:new_vote, {candidate_id: candidate_id, vote: @new_vote} )

      # todo: update votes on clients
    end
  end

  private

  #todo: do this after sleeping a few hours 8-(

  def set_candidate_for_voting
    # candidate_id,
    candidate = Candidate.find message[:candidate_id]
    puts 'set_candidate_for_voting'
    if @poll.id == candidate.poll_id
       # this is actually not supposed to happen
      if candidate.votes.where(nickname: message[:nickname]).length > 0
        # voted already
      else
        # vote ok send success signal

      end
    end
  end

  def set_poll
    if message[:poll_id]
      @poll = Poll.find(message[:poll_id])
    else
      @poll = Poll.find_by_url(message[:url])
    end
  end

  def set_vote_by_nickname
    @vote = @poll.votes.find_by_nickname(message[:nickname])
  end


end