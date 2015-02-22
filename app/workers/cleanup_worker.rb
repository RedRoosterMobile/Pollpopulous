class CleanupWorker

  LOG_ID = "[#{CleanupWorker.name.upcase}] "

  def perform_poll_clean
    puts LOG_ID+'performing.........'

    puts LOG_ID+ 'last vote on poll older than 30 days'
    old_polls = Poll.joins('LEFT JOIN votes ON votes.poll_id = polls.id')
                    .where('votes.updated_at < ?',30.days.ago)
                    .select('polls.id')
                    .distinct
                    .to_a
    if old_polls.length > 0
      old_polls.each do |poll|
        poll.destroy
      end
    end

    puts LOG_ID+'polls older than 60 days in general'
    old_polls =Poll.where('updated_at < ?',1.second.ago)
    if old_polls.length > 0
      old_polls.each do |poll|
        poll.destroy
      end
    end

  end
end