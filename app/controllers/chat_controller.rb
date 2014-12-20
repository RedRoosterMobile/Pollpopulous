class ChatController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
    # check for more https://github.com/websocket-rails/websocket-rails/wiki/WebsocketRails%20Controllers

    # or check https://github.com/lukas2/websockets_chat
  end
end