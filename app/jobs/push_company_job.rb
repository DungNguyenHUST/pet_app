class PushCompanyJob < ApplicationJob
    queue_as :file_serve

    def perform(*args)
        scraper = ScrapCompaniesController.new
        scraper.push_all
    end
end
