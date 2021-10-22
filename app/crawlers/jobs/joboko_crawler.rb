module JobokoCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_joboko(url, doc)
        job_items = doc.css("div.job-descrip2")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("div.titjob2 p.subtitj a").present?
                    job_link = job_item.css("div.titjob2 p.subtitj a").map { |link| link['href'].prepend("https://vn.joboko.com/")}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_joboko(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("section.job-detail div.job-author-ttl a").present?
                company_search_name = doc.css("section.job-detail div.job-author-ttl a").first.text.strip
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

            if doc.css("section.job-detail div.job-author-img a img").present?
                company_avatar = doc.css("section.job-detail div.job-author-img a img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("section.job-info h1.job-info-ttl").present?
                title = doc.css("section.job-info h1.job-info-ttl").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("section.job-detail div.post-content").first
            if detail_block.present?
                start_detail = detail_block.at_css("h3")
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

            if doc.css("section.job-info ul.job-info-list li")[0].present?
                location = doc.css("section.job-info ul.job-info-list li")[0].text.strip
                location.gsub!(/Địa điểm làm việc: /, "")
            else
                location = "Hà Nội"
            end

            address = location

            if doc.css("section.job-info ul.job-info-list li")[1].present?
                salary = doc.css("section.job-info ul.job-info-list li")[1].text.strip
                salary.gsub!(/Mức lương: /, "")
            else
                salary = "Thương lượng"
            end

            quantity = 1

            category = ""

            level = "Nhân viên"

            experience = "Không yêu cầu"

            typical = "Toàn thời gian"

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("section.job-info ul.job-info-list li")[2].present?
                date_str = doc.css("section.job-info ul.job-info-list li")[2].text.strip
                salary.gsub!(/Hạn nộp: /, "")
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

            return nil
        end
    end
end