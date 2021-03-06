class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :set_poll_by_url, only: [:show_candidates]
  before_action :auth, only: [:index, :destroy, :update]

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
    #todo: show screen to add candidates and vote for them
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)

    respond_to do |format|
      if @poll.save
        format.html { redirect_to "/vote_here/#{@poll.url}", notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_candidates
    @candidates = @poll.candidates.to_json(include: :votes)
    @title = @poll.title
    @poll_id = @poll.id
    #@votes = @poll.votes
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    def set_poll_by_url
      @poll = Poll.where(url: params[:url]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      poll = params.require(:poll).permit(:title, :url)
      # todo: add some random string
      poll['url'] = poll['url'].parameterize.underscore
      return poll
    end

  def auth
    if Rails.application.config.auth_code == params[:auth_code].to_s or
        Rails.application.config.auth_code == session[:auth_code]
      session[:auth_code] = Rails.application.config.auth_code
    else
      puts 'not authorized'
      render :file => 'public/404.html', :status => :unauthorized
    end
  end
end
