
require_relative 'itviec_review_crawler.rb'
require_relative 'common_review_crawler.rb'
include ItviecReviewCrawler
include CommonReviewCrawler

class ReviewCrawler
    def self.process(crawl_review)
        self.processing_data(crawl_review)
    end

    def self.processing_data(crawl_review)
        puts "Start crawl data..."
        if CommonReviewCrawler::check_exist_url(crawl_review.url)
            if split_domain_name(crawl_review.url) == "itviec.com"
                processing_review(get_detail_review_data_itviec(crawl_review))
            end
        else
            puts "Wrong url"
        end
        puts "End crawl data!!!"
    end
end
