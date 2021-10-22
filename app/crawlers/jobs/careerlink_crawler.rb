module CareerlinkCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_careerlink(url, doc)
        job_items = doc.css("li.job-item")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("a.job-link").present?
                    job_link = job_item.css("a.job-link").map { |link| link['href'].prepend("https://careerlink.vn/")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_careerlink(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.job-title-and-org-name span").present?
                company_search_name = doc.css("div.job-title-and-org-name span").first.text.strip
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

            if doc.css("div.company-logo img").present?
                company_avatar = doc.css("div.company-logo img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("div.job-title-and-org-name h1.job-title").present?
                title = doc.css("div.job-title-and-org-name h1.job-title").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.job-detail-body").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.border-bottom-mb")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 2 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            if doc.css("div.job-overview li.address").present?
                location = doc.css("div.job-overview li.address").text.strip
            else
                location = "Hà Nội"
            end

            address = location

            if doc.css("div.job-overview p.salary").present?
                salary = doc.css("div.job-overview p.salary").text.strip
                salary.gsub!(/MONTH/, "")
            else
                salary = "Thương lượng"
            end

            detail_block_1 = doc.css("div.job-detail-body div.border-bottom-mb")[2]

            quantity = 1

            if detail_block_1 && category_block = detail_block_1.css("div.job-summary-item")[6]
                category = category_block.css("div.font-weight-bolder").text.strip.squish!
            else
                category = ""
            end

            if detail_block_1 && level_block = detail_block_1.css("div.job-summary-item")[1]
                level = level_block.css("div.font-weight-bolder").text.strip.squish!
            else
                level = "Nhân viên"
            end

            if detail_block_1 && experience_block = detail_block_1.css("div.job-summary-item")[2]
                experience = experience_block.css("div.font-weight-bolder").text.strip.squish!
            else
                experience = "Không yêu cầu"
            end

            if detail_block_1 && typical_block = detail_block_1.css("div.job-summary-item")[0]
                typical = typical_block.css("div.font-weight-bolder").text.strip.squish!
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.contact-information span.d-none").present?
                date_str = doc.css("div.contact-information span.d-none").last.text.strip
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