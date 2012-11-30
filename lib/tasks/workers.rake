# Rake task to restart Resque workers
namespace :workers do

  task :stop => :environment do
    pids =
      Resque.workers.map { |worker| worker.to_s.split(/:/).second }
    
    if pids.size > 0
      system("sudo -u www-data kill -QUIT #{pids.join(' ')}")
    end
  end
end
