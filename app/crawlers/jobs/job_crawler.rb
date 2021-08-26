require 'kimurai'
require_relative 'careerbuilder_crawler.rb'
require_relative 'topcv_crawler.rb'
require_relative 'common_crawler.rb'
include CareerbuilderCrawler
include TopcvCrawler
include CommonCrawler

class JobCrawler < Kimurai::Base
    @name = "job_crawler"
    @engine = :mechanize
    @start_urls = ["https://firework.vn"]
    @config = {}

    def self.process(scrap_job)
        if check_exist_url(scrap_job.url)
            @start_urls = [scrap_job.url.to_s]
            self.crawl!
        end
    end

    def parse(response, url:, data: {})
        response = browser.current_response

        # Root link
        if links = find_root_link(url, response)
            # begin
                links.each do |link|
                    if check_exist_url(link)
                        request_to :parse_job_page, url: absolute_url(link, base: url)
                    end
                end
            # rescue
            #     print "*****************Handle link error*******************\n"
            # end
        end

        # Next page press
        # if next_page = find_next_page(url, response)
        #     request_to :parse, url: absolute_url(next_page[:href], base: url)
        # end
    end

    def parse_job_page(response, url:, data: {})
        # Detail link
        if response = browser.current_response
            data = get_job_data(url, response)
            if data.present?
                processing_job(data)
            end
        end
    end

    def find_root_link(url, response)
        links = nil
        if split_domain_name(url) == "careerbuilder.vn"
            links = response.css("div.job-item a.job_link").map { |link| link['href']}
        end

        if split_domain_name(url) == "topcv.vn"
            links = response.css("div.job h4.job-title a").map { |link| link['href']}
        end

        return links
    end

    def find_next_page(url, response)
        next_page = nil
        if split_domain_name(url) == "careerbuilder.vn"
            next_page = response.at_css("div.pagination li.next-page a")
        end

        if split_domain_name(url) == "topcv.vn"
            next_page = response.css("ul.pagination li a").last
        end

        return next_page
    end

    def get_job_data(url, response)
        job_data = nil
        if split_domain_name(url) == "careerbuilder.vn"
            job_data = get_job_data_careerbuilder(url, response)
        end

        if split_domain_name(url) == "topcv.vn"
            job_data = get_job_data_topcv(url, response)
        end

        return job_data
    end
end