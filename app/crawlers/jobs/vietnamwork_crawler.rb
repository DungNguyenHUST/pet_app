module VietnamworkCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_vietnamwork(url, doc)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.company-name a").present?
                company_name = doc.css("div.company-name a").first.text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = "Đang cập nhật"
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
            end
                    
            if doc.css("div.job-header-info h1.job-title").present?
                title = doc.css("div.job-header-info h1.job-title").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.tab-main-content").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.what-we-offer")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 3 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            if doc.css("div.job-locations div.location-name").present?
                location = doc.css("div.job-locations div.location-name").text.strip
            else
                location = "Hà Nội"
            end

            if doc.css("div.job-locations div.location-name").present?
                address = doc.css("div.job-locations div.location-name").first.text.strip
            else
                address = location
            end

            salary = "Thương lượng"
            quantity = 1

            if category_box = doc.css("div.box-summary div.summary-item")[2]
                category = category_box.css("span.content").text.strip
                category.squish!
            else
                category = ""
            end

            if level_box = doc.css("div.box-summary div.summary-item")[1]
                level = level_box.css("span.content").text.strip
            else
                level = "Nhân viên"
            end

            experience = "Không yêu cầu"

            typical = "Toàn thời gian"

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("span.expiry").present?
                date_str = doc.css("span.expiry").text.strip
                date_num = date_str.scan(/\d+/).map(&:to_i).first
                if date_str.include?("tháng")
                    date_num = date_num * 30
                end
                end_date = Time.now + date_num.days
            else
                end_date = Time.now + 30.days
            end

            urgent = false
            apply_another_site_flag = true
            apply_site = url
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