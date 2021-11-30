module CareerbuilderCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_careerbuilder(url, doc)
        job_items = doc.css("div.job-item")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                if job_item.css("div.image img").present?
                    company_avatar = job_item.css("div.image img").map { |img| img['data-src']}.first
                else
                    company_avatar = image_url("defaults/company_avatar_default.svg")
                end

                job_location = ""

                job_salary = ""

                if job_item.css("a.job_link").present?
                    job_link = job_item.css("a.job_link").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_careerbuilder(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.job-desc a.job-company-name").present?
                company_search_name = doc.css("div.job-desc a.job-company-name").first.text.strip
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

            if pre_data && pre_data.company_avatar
                company_avatar = pre_data.company_avatar
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end

            if doc.css("h1.title").first.present?
                title = doc.css("h1.title").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.detail-row")
            end_detail = doc.at_css("div.share-this-job")
            detail = ''
            next_step = 0
            loop do
                break if next_step == 3 # stop before end_detail
                if start_detail.present? && !start_detail.next_element.nil?
                    start_detail = start_detail.next_element
                    detail << start_detail.to_s
                end
                next_step += 1
            end
            #######################job detail end##########################

            if doc.css("div.map p").present?
                location = doc.css("div.map p").text.strip
            else
                location = ""
            end

            if doc.css("div.detail-box ul li p")[3].present?
                salary = doc.css("div.detail-box ul li p")[3].text.strip
            else
                salary = "Thương lượng"
            end

            quantity = 1

            if doc.css("div.detail-box ul li p")[2].present?
                category = doc.css("div.detail-box ul li p")[1].text.strip
                level = doc.css("div.detail-box ul li p")[2].text.strip
            else
                category = ""
                level = "Nhân viên"
            end

            if doc.css("div.detail-box ul li p")[4].present?
                experience = doc.css("div.detail-box ul li p")[4].text.strip
            else
                experience = "Không yêu cầu"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.detail-box ul li p")[6].present?
                date_str = doc.css("div.detail-box ul li p")[6].text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

            typical = "Toàn thời gian"
            urgent = false
            apply_another_site_flag = true
            apply_site = url.to_s
            address = location
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