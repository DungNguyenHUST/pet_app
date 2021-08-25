class ScraperReviewJob < ApplicationJob
    require_relative 'itviec_review_scraper.rb'
    include ItviecReviewScraper
    include CommonReviewScraper

    queue_as :default

    def perform(scrap_review)
        processing_data(scrap_review)
    end

    def processing_data(scrap_review)
        puts "Start scrap data..."
        if check_exist_url(scrap_review.url)
            if split_domain_name(scrap_review.url) == "itviec.com"
                processing_review(get_detail_review_data_itviec(scrap_review))
            end
        else
            puts "Wrong url"
        end
        puts "End scrap data!!!"
    end
end
