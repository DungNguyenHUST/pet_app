class PushingJob < ApplicationJob
    queue_as :file_serve

    def perform(*args)
        scraper = ScrapJobsController.new
        scraper.push_all
    end
end
