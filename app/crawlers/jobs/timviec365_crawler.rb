module Timviec365Crawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_timviec365(url, doc)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.box_tit_detail a.na_cty").present?
                company_name = doc.css("div.box_tit_detail a.na_cty").first.text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = "Đang cập nhật"
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
            end
                    
            if doc.css("div.right_tit h1").present?
                title = doc.css("div.right_tit h1").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.tt_td").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.box_mota")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 4 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            if location_box = doc.css("div.right_tit p.dd_tuyen")
                location = location_box.css("a").text.strip
            else
                location = "Hà Nội"
            end

            address = location

            if doc.css("div.right_tit_2 p.lv_luong span").present?
                salary = doc.css("div.right_tit_2 p.lv_luong span").text.strip
            else
                salary = "Thương lượng"
            end

            if quantity_box = doc.css("div.box_tomtat_2 p")[5]
                quantity = quantity_box.css("span").text.strip
            else
                quantity = 1
            end

            if category_box = doc.css("div.box_tomtat_2 p")[6]
                category = category_box.css("a").text.strip
            else
                category = ""
            end

            if level_box = doc.css("div.box_tomtat_2 p")[0]
                level = level_box.css("span").text.strip
            else
                level = "Nhân viên"
            end

            if experience_box = doc.css("div.box_tomtat_2 p")[1]
                experience = experience_box.css("span").text.strip
            else
                experience = "Không yêu cầu"
            end

            if typical_box = doc.css("div.box_tomtat_2 p")[2]
                typical = typical_box.css("span").text.strip
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if date_box = doc.css("div.right_tit p").last
                date_str = date_box.css("span").text.strip
                end_date = Date.parse(date_str)
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