module ViecoiCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_viecoi(url, doc)
        job_items = doc.css("div.jobs-info")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("h3.title-jobs-home a").present?
                    job_link = job_item.css("h3.title-jobs-home a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_viecoi(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.name-job h5 a").present?
                company_search_name = doc.css("div.name-job h5 a").first.text.strip
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

            if doc.css("div.div-in-logo a img").present?
                company_avatar = doc.css("div.div-in-logo a img").map { |img| img['src'].prepend("https://viecoi.vn/")}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("div.position_title_job h1.title-jobs-home").present?
                title = doc.css("div.position_title_job h1.title-jobs-home").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.row-mobile-job-detail")
            if detail_block.present?
                start_detail = detail_block.css("div.property-margin-detail")[2]
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

            if doc.css("div.div-salary div.color-orange")[0].present?
                salary = doc.css("div.div-salary div.color-orange")[0].text.strip
                salary.gsub!(/Lương:/, "")
            else
                salary = "Thương lượng"
            end

            detail_block_0 = doc.css("div.property-margin-detail")[0]

            if detail_block_0.css("ul.ul-sub-detail li")[2].present?
                location = detail_block_0.css("ul.ul-sub-detail li")[2].text.strip
                location.gsub!(/Nơi làm:/, "")
            else
                location = "Hà Nội"
            end

            address = location

            if detail_block_0.css("ul.ul-sub-detail li")[1].present?
                category = detail_block_0.css("ul.ul-sub-detail li")[1].text.strip
                category.gsub!(/Danh mục:/, "")
            else
                category = ""
            end

            if detail_block_0.css("ul.ul-sub-detail li")[3].present?
                date_str = detail_block_0.css("ul.ul-sub-detail li")[3].text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

            detail_block_1 = doc.css("div.property-margin-detail")[1]

            if detail_block_1.css("ul.ul-sub-detail li")[0].present?
                quantity = detail_block_1.css("ul.ul-sub-detail li")[0].text.strip
            else
                quantity = 1
            end

            if detail_block_1.css("ul.ul-sub-detail li")[4].present?
                level = detail_block_1.css("ul.ul-sub-detail li")[4].text.strip
                level.gsub!(/Cấp bậc:/, "")
            else
                level = "Nhân viên"
            end

            if detail_block_1.css("ul.ul-sub-detail li")[2].present?
                experience = detail_block_1.css("ul.ul-sub-detail li")[2].text.strip
                experience.gsub!(/Kinh nghiệm làm việc:/, "")
            else
                experience = "Không yêu cầu"
            end

            typical = "Toàn thời gian"

            language = "Tùy chọn"
            dudate = Time.now

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