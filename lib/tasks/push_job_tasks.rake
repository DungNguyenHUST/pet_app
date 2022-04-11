namespace :push_job_tasks do
    desc "Push all job to production"
    task job_pusher: :environment do
        puts "Start push all job"
        scraper = ScrapJobsController.new
        scraper.push_all
        puts "End push all job"
    end
end