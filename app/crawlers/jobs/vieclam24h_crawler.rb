module Vieclam24hCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_vieclam24h(url, doc)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.box_chi_tiet_cong_viec div.title-company a").present?
                company_name = doc.css("div.box_chi_tiet_cong_viec div.title-company a").first.text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = "Đang cập nhật"
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
            end
                    
            if doc.css("div.box_chi_tiet_cong_viec h1.title-job").present?
                title = doc.css("div.box_chi_tiet_cong_viec h1.title-job").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.job_description").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.item")
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

            job_info_box_1 = doc.css("div.job_detail div.list-info").first
            job_info_box_2 = doc.css("div.job_detail div.list-info").last

            if job_info_box_1 && job_info_box_2
                if location_box = job_info_box_2.css("div.line-icon")[0]
                    location = location_box.css("a").text.strip
                else
                    location = "Hà Nội"
                end

                address = location

                if salary_box = job_info_box_1.css("div.line-icon")[0]
                    salary = salary_box.css("span.job_value").text.strip
                else
                    salary = "Thương lượng"
                end

                if quantity_box = job_info_box_1.css("div.line-icon")[3]
                    quantity = quantity_box.css("span.job_value").text.strip
                else
                    quantity = 1
                end

                if category_box = job_info_box_2.css("div.line-icon")[6]
                    category = category_box.css("a").text.strip
                else
                    category = ""
                end

                if level_box = job_info_box_2.css("div.line-icon")[1]
                    level = level_box.css("span.job_value").text.strip
                else
                    level = "Nhân viên"
                end

                if experience_box = job_info_box_1.css("div.line-icon")[1]
                    experience = experience_box.css("span.job_value").text.strip
                else
                    experience = "Không yêu cầu"
                end

                if typical_box = job_info_box_2.css("div.line-icon")[2]
                    typical = typical_box.css("span.job_value").text.strip
                else
                    typical = "Toàn thời gian"
                end

                language = "Tùy chọn"
                dudate = Time.now

                if doc.css("div.box_chi_tiet_cong_viec span.text-color-effect-second").present?
                    date_str = doc.css("div.box_chi_tiet_cong_viec span.text-color-effect-second").text.strip
                    end_date = Date.parse(date_str)
                else
                    end_date = Time.now + 30.days
                end
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