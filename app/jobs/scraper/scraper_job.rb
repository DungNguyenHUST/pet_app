class ScraperJob < ApplicationJob
    include ApplicationHelper
    include ItViecScraper
    include CareerBuilderScraper
    include CommonScraper

    queue_as :default

    def perform(scrap_job)
        processing_data(scrap_job)
    end

    def processing_data(scrap_job)
        puts "Start scrap data..."
        if check_exist_url(scrap_job.url)
            if split_domain_name(scrap_job.url) == "itviec.com"
                processing_job(get_data_itviec(scrap_job))
            end
        
            if split_domain_name(scrap_job.url) == "careerbuilder.vn"
                processing_job(get_data_careerbuilder(scrap_job))
            end
        else
            puts "Wrong url"
        end
        puts "End scrap data!!!"
    end
end
