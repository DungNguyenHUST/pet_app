namespace :pull_job_tasks do
    desc "Scrap all job site"
    task job_puller: :environment do
        puts "Start scrap all job"
        scraper = ScrapJobsController.new
        scraper.pull_all
        puts "End scrap all job"
    end
end