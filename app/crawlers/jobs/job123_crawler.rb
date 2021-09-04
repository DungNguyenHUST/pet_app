module Job123Crawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_123job(url, doc)
        job_items = doc.css("div.job__list-item")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css(" h2.job__list-item-title a").present?
                    job_link = job_item.css("h2.job__list-item-title a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_123job(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.company-review p.cpn-title").present?
                company_search_name = doc.css("div.company-review p.cpn-title").first.text.strip
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

            if doc.css("div.company-info__avatar img").present?
                company_avatar = doc.css("div.company-info__avatar img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end

            if doc.css("h2.job-title strong").first.present?
                title = doc.css("h2.job-title strong").first.text.strip
                title.gsub!(/Tuyển dụng /, "")
                title = title.capitalize
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.box-info-job div.content-group-basic")
            end_detail = doc.at_css("div.box-info-job div.content-group-summary")
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

            detail_block = doc.css("div.box-info-job div.content-group-basic").last

            if detail_block.css("div.item")[0].present?
                location = doc.css("div.item")[0].text.strip
                location.gsub!(/Việc làm tại: /, "")
            else
                location = ""
            end

            if doc.css("div.item")[1].present?
                salary = doc.css("div.item")[1].text.strip
                salary.gsub!(/Mức lương: /, "")
            else
                salary = "Thương lượng"
            end

            if doc.css("div.item")[6].present?
                quantity = doc.css("div.item")[6].text.strip
                quantity.gsub!(/Số lượng: /, "")
            else
                quantity = 1
            end

            category = ""

            if detail_block.css("div.item")[3].present?
                level = doc.css("div.item")[3].text.strip
                level.gsub!(/Chức vụ: /, "")
            else
                level = "Nhân viên"
            end

            if detail_block.css("div.item")[4].present?
                typical = doc.css("div.item")[4].text.strip
                typical.gsub!(/Hình thức: /, "")
            else
                typical = "Toàn thời gian"
            end

            if detail_block.css("div.item")[5].present?
                experience = doc.css("div.item")[5].text.strip
                experience.gsub!(/Kinh nghiệm: /, "")
            else
                experience = "Không yêu cầu"
            end

            if detail_block.css("div.item")[2].present?
                date_str = doc.css("div.item")[2].text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

            language = "Tùy chọn"
            dudate = Time.now
            urgent = false
            apply_another_site_flag = true
            apply_site = url.to_s
            address = location
            approved = true
            user_id = Admin.first.id
            
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
                                                    user_id,
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