require 'kimurai'
require_relative 'topcv_company_crawler.rb'
require_relative 'common_company_crawler.rb'
include TopcvCompanyCrawler
include CommonCompanyCrawler

class CompanyCrawler < Kimurai::Base
    @name = "company_crawler"
    @engine = :mechanize
    # @engine = :selenium_firefox
    @start_urls = ["https://github.com"]
    @config = {
        skip_request_errors: [{ error: RuntimeError, message: "404 => Net::HTTPNotFound" }],
        user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36"
    }
    @@PAGE_COUNT = 0
    @@PAGE_MAX = 0

    def self.process(scrap_company)
        @@PAGE_MAX = 0
        if check_exist_url(scrap_company.url)
            scrap_company.url = rotate_url(scrap_company.url)
            @start_urls = [scrap_company.url.to_s]
            @@PAGE_MAX = scrap_company.page_num

            self.crawl!
        end
    end

    def parse(response, url:, data: {})
        response = browser.current_response

        # Root link
        if pre_datas = get_company_pre_data(url, response)
            begin
                pre_datas.each do |pre_data|
                    if check_exist_url(pre_data.company_link)
                        link = rotate_url(pre_data.company_link)
                        request_to :parse_company_page, url: absolute_url(link, base: url), data: data.merge(pre_data: pre_data)
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

    def parse_company_page(response, url:, data: {})
        if response = browser.current_response
            company_data = get_company_data(url, response, data[:pre_data])
            if company_data.present?
                processing_company(company_data)
            end
        end
    end

    def get_company_pre_data(url, response)
        pre_datas = nil

        if split_domain_name(url) == "topcv.vn"
            pre_datas = get_company_pre_data_topcv(url, response)
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

        if split_domain_name(url) == "topcv.vn"
            if next_page = response.css("ul.pagination li a").last
                next_page_link = next_page[:href]
            end
        end

        return next_page_link
    end

    def get_company_data(url, response, pre_data)
        company_data = nil

        if split_domain_name(url) == "topcv.vn"
            company_data = get_company_data_topcv(url, response, pre_data)
        end

        return company_data
    end
end