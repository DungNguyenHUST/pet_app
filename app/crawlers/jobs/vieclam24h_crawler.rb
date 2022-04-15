module Vieclam24hCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_vieclam24h(url, doc)
        job_items = doc.css("div.rounded-sm")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("a.rounded-sm").present?
                    job_link = job_item.css("a.rounded-sm").map { |link| link['href'].prepend("https://vieclam24h.vn")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_vieclam24h(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.ml-5 a").present?
                company_search_name = doc.css("div.ml-5 a").first.text.strip
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

            if doc.css("div.items-center div.box-border img").present?
                company_avatar = doc.css("div.items-center div.box-border img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end
                    
            if doc.css("div.items-center div.w-full h3").present?
                title = doc.css("div.items-center div.w-full h3").text.strip
            end

            #######################job detail start##########################
            if detail_block = doc.css("div.JobInfo_jobInfoContainer__3WzDU").first
                detail = detail_block
            end

            # if detail_block.present?
            #     start_detail = detail_block.at_css("h4.text-18")
            #     detail = ''
            #     next_step = 0
            #     loop do
            #         break if next_step == 3 # stop before end_detail
            #         if start_detail.present? && !start_detail.next_element.nil?
            #             detail << start_detail.to_s
            #             start_detail = start_detail.next_element
            #         end
            #         next_step += 1
            #     end
            # end
            #######################job detail end##########################

            job_info_box_1 = doc.css("div.grid-cols-2").first
            job_info_box_2 = doc.css("div.grid-cols-1").first

            if job_info_box_1 && job_info_box_2
                if location_box = job_info_box_2.css("div.flex")[2]
                    location = location_box.css("div.font-semibold").text.strip
                else
                    location = "Hà Nội"
                end

                address = location

                if salary_box = job_info_box_1.css("div.border-se-blue-10")[1]
                    salary = salary_box.css("div.font-semibold").text.strip
                else
                    salary = "Thương lượng"
                end

                if quantity_box = job_info_box_1.css("div.flex")[3]
                    quantity = quantity_box.css("div.font-semibold").text.strip
                else
                    quantity = 1
                end

                if category_box = job_info_box_2.css("div.flex")[0]
                    category = category_box.css("div.font-semibold").text.strip
                else
                    category = ""
                end

                if level_box = job_info_box_1.css("div.border-se-blue-10")[2]
                    level = level_box.css("div.font-semibold").text.strip
                else
                    level = "Nhân viên"
                end

                if experience_box = job_info_box_1.css("div.border-se-blue-10")[0]
                    experience = experience_box.css("div.font-semibold").text.strip
                else
                    experience = "Không yêu cầu"
                end

                if typical_box = job_info_box_1.css("div.border-se-blue-10")[3]
                    typical = typical_box.css("div.font-semibold").text.strip
                else
                    typical = "Toàn thời gian"
                end

                language = "Tùy chọn"
                dudate = Time.now

                if date_box = job_info_box_2.css("div.flex").last
                    date_str = date_box.css("div.font-semibold").text.strip
                    end_date = Date.parse(date_str)
                else
                    end_date = Time.now + 30.days
                end
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