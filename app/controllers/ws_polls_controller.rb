class WsPollsController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
    # check for more https://github.com/websocket-rails/websocket-rails/wiki/WebsocketRails%20Controllers

    # or check https://github.com/lukas2/websockets_chat
  end

  before_filter :only => :add_candidate do
    puts 'add_candidate was called'
  end

  def add_candidate
    # prevent multiple adds of the same name
    poll = Poll.find_by_url(message[:url])

    poll.candidates.each do |element|
      if element.name == message[:name]
        trigger_failure ( {:message => "option with name #{message[:name]} exists already"})
        break
      end
    end

    poll.candidates.push(Candidate.new(name:message[:name]))
    trigger_success( {:message => poll.candidates.last})

  end


end