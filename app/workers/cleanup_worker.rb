class CleanupWorker

  LOG_ID = "[#{CleanupWorker.name.upcase}]"

  def perform_poll_clean
    puts LOG_ID+' performing.........'

    # votes.created_at < 1.days.ago

    old_polls = Poll.joins('LEFT JOIN votes ON votes.poll_id = polls.id').where('votes.created_at < ?',2.minutes.ago).select('polls.id').distinct


  end
end