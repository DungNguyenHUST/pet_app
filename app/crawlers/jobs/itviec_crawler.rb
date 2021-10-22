module ItviecCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_itviec(url, doc)
        job_items = doc.css("div.job_content")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("h2.title a").present?
                    job_link = job_item.css("h2.title a").map { |link| link['href'].prepend("https://itviec.com")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_itviec(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("h3.employer-long-overview__name a").present?
                company_search_name = doc.css("h3.employer-long-overview__name a").first.text.strip
                company = get_company_id_by_name(company_search_name)
            end

            if company.present?
                company_name = company_search_name
                company_id = company["id"]
            elsif company_search_name.present?
                company_name = company_search_name
                company_id = -1
            else
                company_name = ""
                company_id = -1
            end

            if doc.css("div.employer-long-overview__logo picture").present?
                company_avatar = doc.css("div.employer-long-overview__logo picture img").map { |img| img['data-src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("h1.job-details__title").first.present?
                title = doc.css("h1.job-details__title").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.job-details__divider")
            end_detail = doc.at_css("div.jd-page__employer-overview")
            detail = ''
            next_step = 0
            loop do
                break if next_step == 8 # stop before end_detail
                if start_detail.present? && !start_detail.next_element.nil?
                    start_detail = start_detail.next_element
                    detail << start_detail.to_s
                end
                next_step += 1
            end
            #######################job detail end##########################

            if doc.css("div.svg-icon__text span").present?
                location = doc.css("div.svg-icon__text span").text.strip
            else
                location = ""
            end

            if doc.css("div.svg-icon__text span").present?
                address = doc.css("div.svg-icon__text span").text.strip
            else
                address = location
            end

            salary = "Thương lượng"

            quantity = 1

            category = "CNTT - Phần mềm"

            level = "Nhân viên"

            experience = "Không yêu cầu"

            typical = "Toàn thời gian"

            language = "Tùy chọn"
            dudate = Time.now
            end_date = Time.now + 30.days
            urgent = false
            apply_another_site_flag = true
            apply_site = url
            approved = true
            admin_id = Admin.first.id
            
            if title.present? && apply_site.present?
                detail_data_temp = job_params.new(title,
                                                    detail,
                                                    location, 
                                                    salary, 
                                                    quantity, 
                                                    category,
                                                    language, 
                                                    level,
                                                    dudate,
                                                    end_date,
                                                    typical, 
                                                    urgent, 
                                                    apply_another_site_flag, 
                                                    apply_site, 
                                                    address,
                                                    admin_id,
                                                    approved,
                                                    company_id,
                                                    company_name,
                                                    company_avatar,
                                                    experience)

                processing_detail_datas.push(detail_data_temp)
            end

            return processing_detail_datas
        end
    end
end