module TopcvCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_topcv(url, doc)
        if doc.present?
            processing_detail_datas = []

            unless doc.css("div.company-title span").nil?
                company_name = doc.css("div.company-title span").text.strip
                @company = get_company_by_name(company_name)
            else
                company_name = ""
            end

            if @company.present?
                company_id = @company.id
            else
                company_id = -1
            end
                    
            if doc.css("div.col-sm-9 h1.job-title").present?
                title = doc.css("div.col-sm-9 h1.job-title").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.col-md-8[id=col-job-left]").first
            if detail_block.present?
                start_detail = detail_block.at_css("h2")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 6 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            if doc.css("div.job-info-item span").present?
                location = doc.css("div.job-info-item span")[6].text.strip
            else
                location = "Hà Nội"
            end

            if doc.css("div.text-dark-gray").present?
                address = doc.css("div.text-dark-gray").first.text.strip
            else
                address = location
            end

            salary = "Thương lượng"

            if doc.css("div.job-info-item span").present?
                quantity = doc.css("div.job-info-item span")[2].text.strip
            else
                quantity = 1
            end

            if detail_block.present?
                category = detail_block.css("span").text.strip.squish!
            else
                category = ""
            end

            if doc.css("div.job-info-item span").present?
                level = doc.css("div.job-info-item span")[3].text.strip
            else
                level = "Nhân viên"
            end

            if doc.css("div.job-info-item span").present?
                experience = doc.css("div.job-info-item span")[4].text.strip
            else
                experience = "Không yêu cầu"
            end

            if doc.css("div.job-info-item span").present?
                typical = doc.css("div.job-info-item span")[1].text.strip
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now
            end_date = Time.now + 30.days
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