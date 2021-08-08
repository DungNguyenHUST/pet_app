class ScraperJob < ApplicationJob
    require_relative 'careerbuilder_scraper.rb'
    require_relative 'itviec_scraper.rb'
    require_relative 'common_scraper.rb'
    include CareerbuilderScraper
    include ItviecScraper
    include CommonScraper

    queue_as :default

    def perform(scrap_job)
        processing_data(scrap_job)
    end

    def processing_data(scrap_job)
        puts "Start scrap data..."
        if check_exist_url(scrap_job.url)
            if split_domain_name(scrap_job.url) == "itviec.com"
                processing_job(get_detail_data_itviec(scrap_job))
            end
        
            if split_domain_name(scrap_job.url) == "careerbuilder.vn"
                processing_job(get_detail_data_careerbuilder(scrap_job))
            end
        else
            puts "Wrong url"
        end
        puts "End scrap data!!!"
    end
end
