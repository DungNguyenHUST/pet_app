namespace :push_job_tasks do
    desc "Push all job to production"
    task job_pusher: :environment do
        puts "Start push all job"
        PushingJob.perform_later
        puts "End push all job"
    end
end