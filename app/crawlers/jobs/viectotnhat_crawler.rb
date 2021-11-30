module ViectotnhatCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_viectotnhat(url, doc)
        job_items = doc.css("div.job-info")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("h3.job-name a").present?
                    job_link = job_item.css("h3.job-name a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_viectotnhat(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            info_block_0 = doc.css("div.box-white-content")[0]

            if info_block_0.present? && info_block_0.css("h2").present?
                company_search_name = info_block_0.css("h2").text.strip
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

            if doc.css("div.job-ads div.img-ads img").present?
                company_avatar = doc.css("div.job-ads div.img-ads img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end
                    
            if info_block_0.present? && info_block_0.css("h1.title-job").present?
                title = info_block_0.css("h1.title-job").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.list-thong-tin").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.clearfix")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 8 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            info_block_1 = doc.css("div.list-thong-tin ul")[0]
            info_block_2 = doc.css("div.list-thong-tin ul")[1]

            if info_block_2.present? && info_block_2.css("li")[0].present?
                location = info_block_2.css("li")[0].text.strip
                location.gsub!(/Địa điểm làm việc: /, "")
            else
                location = "Hà Nội"
            end

            address = location

            if info_block_1.present? && info_block_1.css("li")[0].present?
                salary = info_block_1.css("li")[0].text.strip
                salary.gsub!(/Mức lương: /, "")
            else
                salary = "Thương lượng"
            end

            if info_block_1.present? && info_block_1.css("li")[3].present?
                quantity = info_block_1.css("li")[3].text.strip
                quantity.gsub!(/Số lượng cần tuyển: /, "")
            else
                quantity = 1
            end

            if info_block_1.present? && info_block_1.css("li")[4].present?
                category_block = info_block_1.css("li")[4]
                category = category_block.css("a").map { |link| link['title']}
                category = category.to_s
                category.gsub!(/Ngành nghề: /, "")
                category.gsub!(/[""]/, "")
            else
                category = ""
            end

            if info_block_2.present? && info_block_2.css("li")[1].present?
                level = info_block_2.css("li")[1].text.strip
                level.gsub!(/Chức vụ: /, "")
            else
                level = "Nhân viên"
            end

            if info_block_1.present? && info_block_1.css("li")[1].present?
                experience = info_block_1.css("li")[1].text.strip
                experience.gsub!(/Kinh nghiệm: /, "")
            else
                experience = "Không yêu cầu"
            end

            if info_block_2.present? && info_block_2.css("li")[2].present?
                typical = info_block_2.css("li")[2].text.strip
                typical.gsub!(/Hình thức làm việc: /, "")
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if info_block_0.present? && info_block_0.css("span").present?
                date_str = info_block_0.css("span").last.text.strip
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