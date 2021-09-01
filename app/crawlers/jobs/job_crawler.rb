require 'kimurai'
require_relative 'careerbuilder_crawler.rb'
require_relative 'topcv_crawler.rb'
require_relative 'itviec_crawler.rb'
require_relative 'mywork_crawler.rb'
require_relative 'jobsgo_crawler.rb'
require_relative 'job123_crawler.rb'
require_relative 'vietnamwork_crawler.rb'
require_relative 'timviec365_crawler.rb'
require_relative 'vieclam24h_crawler.rb'
require_relative 'common_crawler.rb'
include CareerbuilderCrawler
include TopcvCrawler
include ItviecCrawler
include MyworkCrawler
include JobsgoCrawler
include Job123Crawler
include VietnamworkCrawler
include Timviec365Crawler
include Vieclam24hCrawler
include CommonCrawler

class JobCrawler < Kimurai::Base
    @name = "job_crawler"
    @engine = :mechanize
    @start_urls = ["https://github.com"]
    @config = {}

    def self.process(scrap_job)
        if check_exist_url(scrap_job.url)
            scrap_job.url = rotate_url(scrap_job.url)
            @start_urls = [scrap_job.url.to_s]
            self.crawl!
        end
    end

    def parse(response, url:, data: {})
        response = browser.current_response

        # Root link
        if links = find_root_link(url, response)
            begin
                links.each do |link|
                    if check_exist_url(link)
                        link = rotate_url(link)
                        request_to :parse_job_page, url: absolute_url(link, base: url)
                    end
                end
            rescue
                print "*****************Handle link error*******************\n"
            end
        end

        # Next page press
        if next_page = find_next_page(url, response)
            print "nextxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            request_to :parse, url: absolute_url(next_page[:href], base: url)
        end
    end

    def parse_job_page(response, url:, data: {})
        # Detail link
        if response = browser.current_response
            job_data = get_job_data(url, response)
            if job_data.present?
                processing_job(job_data)
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

        if split_domain_name(url) == "itviec.com"
            links = response.css("div.job__body h2.title a").map { |link| link['href'].prepend("https://itviec.com")}
        end

        if split_domain_name(url) == "mywork.com.vn"
            links = response.css("div.jobslist-01-row-ttl a").map { |link| link['href'].prepend("https://mywork.com.vn")}
        end

        if split_domain_name(url) == "jobsgo.vn"
            links = response.css("div.brows-job-position div.h3 a").map { |link| link['href']}
        end

        if split_domain_name(url) == "123job.vn"
            links = response.css("div.job__list-item h2.job__list-item-title a").map { |link| link['href']}
        end

        if split_domain_name(url) == "vietnamworks.com"
            links = response.css("div.job-item h3 a.job-title").map { |link| link['href'].prepend("https://vietnamworks.com")}
        end

        if split_domain_name(url) == "timviec365.vn"
            links = response.css("div.item_cate h3 a").map { |link| link['href'].prepend("https://timviec365.vn")}
        end

        if split_domain_name(url) == "vieclam24h.vn"
            links = response.css("div.job-box a").map { |link| link['href'].prepend("https://vieclam24h.vn")}
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

        if split_domain_name(url) == "itviec.com"
            next_page = response.css("ul.pagination li a").last
        end

        if split_domain_name(url) == "mywork.com.vn"
            next_page = response.at_css("div.pagination-not-bottom a.btn-next")
        end

        if split_domain_name(url) == "jobsgo.vn"
            next_page = response.at_css("ul.pagination li.next a")
        end

        if split_domain_name(url) == "123job.vn"
            next_page = response.css("ul.pagination li a").last
        end

        if split_domain_name(url) == "vietnamworks.com"
            next_page = response.css("ul.pagination li.page-item a").last
        end

        if split_domain_name(url) == "timviec365.vn"
            next_page = response.at_css("div.pagination_wrap a.next")
        end

        if split_domain_name(url) == "vieclam24h.vn"
            next_page = response.css("ul.pagination li a.page-link").last
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

        if split_domain_name(url) == "itviec.com"
            job_data = get_job_data_itviec(url, response)
        end

        if split_domain_name(url) == "mywork.com.vn"
            job_data = get_job_data_mywork(url, response)
        end

        if split_domain_name(url) == "jobsgo.vn"
            job_data = get_job_data_jobsgo(url, response)
        end

        if split_domain_name(url) == "123job.vn"
            job_data = get_job_data_123job(url, response)
        end

        if split_domain_name(url) == "vietnamworks.com"
            job_data = get_job_data_vietnamwork(url, response)
        end

        if split_domain_name(url) == "timviec365.vn"
            job_data = get_job_data_timviec365(url, response)
        end

        if split_domain_name(url) == "vieclam24h.vn"
            job_data = get_job_data_vieclam24h(url, response)
        end

        return job_data
    end
end