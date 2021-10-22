module Timviec365Crawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_timviec365(url, doc)
        job_items = doc.css("div.item_cate")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("div.center_cate_l h3 a").present?
                    job_link = job_item.css("div.center_cate_l h3 a").map { |link| link['href'].prepend("https://timviec365.vn")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_timviec365(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.box_tit_detail a.na_cty").present?
                company_search_name = doc.css("div.box_tit_detail a.na_cty").first.text.strip
                company = get_company_id_by_name(company_search_name)
            end

            if company.present?
                company_name = company["name"]
                company_id = company["id"]
            elsif company_search_name.present?
                company_name = company_search_name
                company_id = -1
            else
                company_name = ""
                company_id = -1
            end

            if doc.css("div.img_detail img").present?
                company_avatar = doc.css("div.img_detail img").map { |img| img['data-src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
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