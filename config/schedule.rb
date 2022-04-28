# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

#Creates a output log for you to view previously run cron jobs
env :PATH, ENV['PATH']
set :path, "#{path}"
set :output, "#{path}/log/cronjob.log"
set :bundle_command, "$HOME/.rbenv/shims/bundle exec"

#Sets the environment to run during development mode (Set to production by default)

# set :environment, 'development'
# if @environment == 'development'

#     every :day, at: '0:01' do
#         rake "pull_job_tasks:job_puller"
#     end

#     every :day, at: '12:01' do
#         rake "pull_job_tasks:job_puller"
#     end
    
#     every :day, at: '6:06' do
#         command "sh $HOME/pet_app/auto_upload.sh"
#     end

#     every :day, at: '18:06' do
#         command "sh $HOME/pet_app/auto_upload.sh"
#     end
# else
    every :day, at: '7:07' do
        rake "push_job_tasks:job_pusher"
    end

    every :day, at: '19:07' do
        rake "push_job_tasks:job_pusher"
    end
# end

# Delete expire job 
every :day, at: '2:02' do
    rake "delete_job_tasks:job_delete"
end

# Reindex all job - not need at update
# every :day, at: '3:03' do
#     rake "index_job_tasks:job_indexing"
# end

# Genarate new sitemap
every 1.day, :at => '3:03' do
    rake "-s sitemap:refresh"
end

# Learn more: http://github.com/javan/whenever
