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
require_relative 'viecoi_crawler.rb'
require_relative 'careerlink_crawler.rb'
require_relative 'vieclamnhamay_crawler.rb'
require_relative 'joboko_crawler.rb'
require_relative 'timviec_crawler.rb'
require_relative 'viectotnhat_crawler.rb'
require_relative 'tuoitre_crawler.rb'
require_relative 'vieclam1001_crawler.rb'
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
include ViecoiCrawler
include CareerlinkCrawler
include VieclamnhamayCrawler
include JobokoCrawler
include TimviecCrawler
include ViectotnhatCrawler
include TuoitreCrawler
include Vieclam1001Crawler
include CommonCrawler

class JobCrawler < Kimurai::Base
    PROXIES = ["113.160.247.217:5678:https", "14.177.235.178:4145:https"]
    @name = "job_crawler"
    @engine = :mechanize
    # @engine = :selenium_firefox
    @start_urls = ["https://github.com"]
    @config = {
        skip_request_errors: [{ error: RuntimeError, message: "404 => Net::HTTPNotFound" }],
        user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36"
    }
    @@PAGE_COUNT = 0
    @@PAGE_MAX = 0

    def self.process(scrap_job)
        @@PAGE_MAX = 0
        if check_exist_url(scrap_job.url)
            scrap_job.url = rotate_url(scrap_job.url)
            @start_urls = [scrap_job.url.to_s]
            @@PAGE_MAX = scrap_job.page_num

            # Change to use proxy mode
            if scrap_job.proxy
                @engine = :selenium_firefox
                @config = {
                    proxy: -> { PROXIES.sample },
                    skip_request_errors: [{ error: RuntimeError, message: "404 => Net::HTTPNotFound" }],
                    before_request: {
                        change_proxy: true,
                        delay: 1..3
                    }
                }
            end

            self.crawl!
        end
    end

    def parse(response, url:, data: {})
        response = browser.current_response

        # Root link
        if pre_datas = get_job_pre_data(url, response)
            begin
                pre_datas.each do |pre_data|
                    if check_exist_url(pre_data.job_link)
                        link = rotate_url(pre_data.job_link)
                        request_to :parse_job_page, url: absolute_url(link, base: url), data: data.merge(pre_data: pre_data)
                    end
                end
            rescue
                print "*****************Handle link error*******************\n"
            end
        end

        # Next page press
        if next_page_link = find_next_page_link(url, response)
            print "------------------------------Next page #{@@PAGE_COUNT}/#{@@PAGE_MAX}--------------------------------"
            request_to :parse, url: absolute_url(next_page_link, base: url)
        end
    end

    def parse_job_page(response, url:, data: {})
        if response = browser.current_response
            job_data = get_job_data(url, response, data[:pre_data])
            if job_data.present?
                processing_job(job_data)
            end
        end
    end

    def get_job_pre_data(url, response)
        pre_datas = nil

        if split_domain_name(url) == "careerbuilder.vn"
            pre_datas = get_job_pre_data_careerbuilder(url, response)
        end

        if split_domain_name(url) == "topcv.vn"
            pre_datas = get_job_pre_data_topcv(url, response)
        end

        if split_domain_name(url) == "itviec.com"
            pre_datas = get_job_pre_data_itviec(url, response)
        end

        if split_domain_name(url) == "mywork.com.vn"
            pre_datas = get_job_pre_data_mywork(url, response)
        end

        if split_domain_name(url) == "jobsgo.vn"
            pre_datas = get_job_pre_data_jobsgo(url, response)
        end

        if split_domain_name(url) == "123job.vn"
            pre_datas = get_job_pre_data_123job(url, response)
        end

        if split_domain_name(url) == "vietnamworks.com"
            pre_datas = get_job_pre_data_vietnamwork(url, response)
        end

        if split_domain_name(url) == "timviec365.vn"
            pre_datas = get_job_pre_data_timviec365(url, response)
        end

        if split_domain_name(url) == "vieclam24h.vn"
            pre_datas = get_job_pre_data_vieclam24h(url, response)
        end

        if split_domain_name(url) == "viecoi.vn"
            pre_datas = get_job_pre_data_viecoi(url, response)
        end

        if split_domain_name(url) == "careerlink.vn"
            pre_datas = get_job_pre_data_careerlink(url, response)
        end

        if split_domain_name(url) == "vieclamnhamay.vn"
            pre_datas = get_job_pre_data_vieclamnhamay(url, response)
        end

        if split_domain_name(url) == "vn.joboko.com"
            pre_datas = get_job_pre_data_joboko(url, response)
        end

        if split_domain_name(url) == "timviec.com.vn"
            pre_datas = get_job_pre_data_timviec(url, response)
        end

        if split_domain_name(url) == "viectotnhat.com"
            pre_datas = get_job_pre_data_viectotnhat(url, response)
        end

        if split_domain_name(url) == "vieclam.tuoitre.vn"
            pre_datas = get_job_pre_data_tuoitre(url, response)
        end

        if split_domain_name(url) == "1001vieclam.com"
            pre_datas = get_job_pre_data_vieclam1001(url, response)
        end

        return pre_datas
    end

    def find_next_page_link(url, response)
        next_page = nil
        next_page_link = nil

        @@PAGE_COUNT += 1

        if @@PAGE_COUNT == @@PAGE_MAX
            print "------------------------------End at page #{@@PAGE_COUNT}--------------------------------"
            @@PAGE_COUNT = 0
            return nil
        end

        if split_domain_name(url) == "careerbuilder.vn"
            if next_page = response.at_css("div.pagination li.next-page a")
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "topcv.vn"
            if next_page = response.css("ul.pagination li a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "itviec.com"
            if next_page = response.css("ul.pagination li a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "mywork.com.vn"
            next_page_link = "https://mywork.com.vn/tuyen-dung?action=search&branch=mw.all&q=&page=#{@@PAGE_COUNT}"
        end

        if split_domain_name(url) == "jobsgo.vn"
            if next_page = response.at_css("ul.pagination li.next a")
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "123job.vn"
            if next_page = response.css("ul.pagination li a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "vietnamworks.com"
            if next_page = response.css("ul.pagination li.page-item a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "timviec365.vn"
            if next_page = response.at_css("div.pagination_wrap a.next")
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "vieclam24h.vn"
            next_page_link = "https://vieclam24h.vn/tim-kiem-viec-lam-nhanh?page=#{@@PAGE_COUNT}"
        end

        if split_domain_name(url) == "viecoi.vn"
            if next_page = response.css("div.pagination li a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "careerlink.vn"
            if next_page = response.css("ul.pagination li.page-item a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "vieclamnhamay.vn"
            if next_page = response.at_css("ul.pagination li.next a")
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "vn.joboko.com"
            if next_page = response.css("div.pagination a").last
                next_page_link = next_page[:href].prepend("https://vn.joboko.com")
            end
        end

        if split_domain_name(url) == "timviec.com.vn"
            if next_page = response.css("ul.pagination li.page-item a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "viectotnhat.com"
            next_page_link = "https://viectotnhat.com/viec-lam/tim-kiem?tu_khoa=&nganh_nghe=0&tinh_thanh=0&page=#{@@PAGE_COUNT}"
        end

        if split_domain_name(url) == "vieclam.tuoitre.vn"
            if next_page = response.css("div.paginationTwoStatus a").last
                next_page_link = next_page[:href]
            end
        end

        if split_domain_name(url) == "1001vieclam.com"
            if next_page = response.css("div.pageNavigation span.nextBtn a").last
                next_page_link = next_page[:href]
            end
        end

        return next_page_link
    end

    def get_job_data(url, response, pre_data)
        job_data = nil

        if split_domain_name(url) == "careerbuilder.vn"
            job_data = get_job_data_careerbuilder(url, response, pre_data)
        end

        if split_domain_name(url) == "topcv.vn"
            job_data = get_job_data_topcv(url, response, pre_data)
        end

        if split_domain_name(url) == "itviec.com"
            job_data = get_job_data_itviec(url, response, pre_data)
        end

        if split_domain_name(url) == "mywork.com.vn"
            job_data = get_job_data_mywork(url, response, pre_data)
        end

        if split_domain_name(url) == "jobsgo.vn"
            job_data = get_job_data_jobsgo(url, response, pre_data)
        end

        if split_domain_name(url) == "123job.vn"
            job_data = get_job_data_123job(url, response, pre_data)
        end

        if split_domain_name(url) == "vietnamworks.com"
            job_data = get_job_data_vietnamwork(url, response, pre_data)
        end

        if split_domain_name(url) == "timviec365.vn"
            job_data = get_job_data_timviec365(url, response, pre_data)
        end

        if split_domain_name(url) == "vieclam24h.vn"
            job_data = get_job_data_vieclam24h(url, response, pre_data)
        end

        if split_domain_name(url) == "viecoi.vn"
            job_data = get_job_data_viecoi(url, response, pre_data)
        end

        if split_domain_name(url) == "careerlink.vn"
            job_data = get_job_data_careerlink(url, response, pre_data)
        end

        if split_domain_name(url) == "vieclamnhamay.vn"
            job_data = get_job_data_vieclamnhamay(url, response, pre_data)
        end

        if split_domain_name(url) == "vn.joboko.com"
            job_data = get_job_data_joboko(url, response, pre_data)
        end

        if split_domain_name(url) == "timviec.com.vn"
            job_data = get_job_data_timviec(url, response, pre_data)
        end

        if split_domain_name(url) == "viectotnhat.com"
            job_data = get_job_data_viectotnhat(url, response, pre_data)
        end

        if split_domain_name(url) == "vieclam.tuoitre.vn"
            job_data = get_job_data_tuoitre(url, response, pre_data)
        end

        if split_domain_name(url) == "1001vieclam.com"
            job_data = get_job_data_vieclam1001(url, response, pre_data)
        end

        return job_data
    end
end