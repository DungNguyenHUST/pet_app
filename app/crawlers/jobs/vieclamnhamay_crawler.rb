module VieclamnhamayCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_vieclamnhamay(url, doc)
        job_items = doc.css("article.job-available")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                if job_item.css("div.job-info p.name").present?
                    company_name = job_item.css("div.job-info p.name").first.text.strip
                else
                    company_name = ""
                end

                if job_item.css("div.mng-company-pic a img").present?
                    company_avatar = job_item.css("div.mng-company-pic a img").map { |img| img['data-src'].prepend("https://vieclamnhamay.vn")}.first
                else
                    company_avatar = ""
                end

                job_location = ""

                job_salary = ""

                if job_item.css("p.job-title a").present?
                    job_link = job_item.css("p.job-title a").map { |link| link['href'].prepend("https://vieclamnhamay.vn")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_vieclamnhamay(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if pre_data.company_name
                company_search_name = pre_data.company_name
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

            if pre_data.company_avatar
                company_avatar = pre_data.company_avatar
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end
                    
            if doc.css("div.main-heading h1").present?
                title = doc.css("div.main-heading h1").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.tab-body").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.pull-right")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 1 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        start_detail = start_detail.next_element
                        detail << start_detail.to_s
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            if location_block = doc.css("div.job-overview div.job-overview-item")[4]
                location = location_block.css("a").text.strip
            else
                location = "Hà Nội"
            end

            address = location

            salary = "Thương lượng"

            if salary_block = doc.css("div.job-overview div.job-overview-item")[1]
                salary = salary_block.css("p").text.strip
                salary.gsub!(/Mức lương /, "")
                salary.squish!
            else
                salary = "Thương lượng"
            end

            if quantity_block = doc.css("div.job-overview div.job-overview-item")[2]
                quantity = quantity_block.css("p").text.strip
                quantity = quantity.to_i
            else
                quantity = 1
            end

            if category_block = doc.css("div.job-overview div.job-overview-item")[6]
                category = category_block.css("a").text.strip
            else
                category = ""
            end

            if level_block = doc.css("div.job-overview div.job-overview-item")[7]
                level = level_block.css("a").text.strip
            else
                level = "Nhân viên"
            end

            experience = "Không yêu cầu"

            if typical_block = doc.css("div.job-overview div.job-overview-item")[3]
                typical = typical_block.css("p").text.strip
                typical.gsub!(/Giờ làm việc /, "")
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if end_date_block = doc.css("div.job-overview div.job-overview-item")[0]
                date_str = end_date_block.css("p").text.strip
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