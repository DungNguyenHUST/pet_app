module MyworkCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_mywork(url, doc)
        job_items = doc.css("div.jobslist-01-row")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("div.jobslist-01-row-ttl a").present?
                    job_link = job_item.css("div.jobslist-01-row-ttl a").map { |link| link['href'].prepend("https://mywork.com.vn")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_mywork(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.detail-01 a.detail-01-com").present?
                company_search_name = doc.css("div.detail-01 a.detail-01-com").first.text.strip
                company = get_company_id_by_name(company_search_name)
            end

            if company.present?
                company_name = company[:name]
                company_id = company[:id]
            elsif company_search_name.present?
                company_name = company_search_name
                company_id = -1
            else
                company_name = ""
                company_id = -1
            end

            if doc.css("div.detail-01-right-com img").present?
                company_avatar = doc.css("div.detail-01-right-com img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("h1.detail-01-ttl").first.present?
                title = doc.css("h1.detail-01-ttl").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.detail-01-row-block")
            end_detail = doc.at_css("div.mt30")
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

            if doc.css("div.ex-addr div.detail-01-info a").present?
                location = doc.css("div.ex-addr div.detail-01-info a").text.strip
            else
                location = ""
            end

            address = location

            if doc.css("div.ex-ml div.detail-01-info").present?
                salary = doc.css("div.ex-ml div.detail-01-info").text.strip
            else
                salary = "Thương lượng"
            end

            if doc.css("div.ex-sl div.detail-01-info").present?
                quantity = doc.css("div.ex-sl div.detail-01-info").text.strip
            else
                quantity = 1
            end

            if doc.css("div.ex-nn div.detail-01-info").present?
                category = doc.css("div.ex-nn div.detail-01-info").text.strip
            else
                category = ""
            end

            if doc.css("div.ex-cb div.detail-01-info").present?
                level = doc.css("div.ex-cb div.detail-01-info").text.strip
            else
                level = "Nhân viên"
            end

            if doc.css("div.ex-kn div.detail-01-info").present?
                experience = doc.css("div.ex-kn div.detail-01-info").text.strip
            else
                experience = "Không yêu cầu"
            end

            if doc.css("div.ex-ht div.detail-01-info").present?
                typical = doc.css("div.ex-ht div.detail-01-info").text.strip
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.ex-han-nop div.detail-01-info").present?
                date_str = doc.css("div.ex-han-nop div.detail-01-info").text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

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