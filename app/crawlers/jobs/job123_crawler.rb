module Job123Crawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_123job(url, doc)
        if doc.present?
            processing_detail_datas = []
            unless doc.css("div.company-review p.cpn-title").nil?
                company_name = doc.css("div.company-review p.cpn-title").text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = ""
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
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
                deatail_data_temp = job_params.new(title,
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
                                                    experience)

                processing_detail_datas.push(deatail_data_temp)
            end

            return processing_detail_datas
        end
    end
end