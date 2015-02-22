desc "Remind users if they haven't completed registration"



task :cleanup_old_polls => :environment do
  puts "#{CleanupWorker::LOG_ID}started"
  CleanupWorker.new.perform_poll_clean
  puts "#{CleanupWorker::LOG_ID}done"
end