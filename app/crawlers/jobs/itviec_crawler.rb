module ItviecCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_itviec(url, doc)
        if doc.present?
            processing_detail_datas = []

            unless doc.css("h3.employer-long-overview__name a").nil?
                company_name = doc.css("h3.employer-long-overview__name a").text.strip
                @company = get_company_by_name(company_name)
            else
                company_name = ""
            end

            if @company.present?
                company_id = @company.id
            else
                company_id = -1
            end
                    
            if doc.css("h1.job-details__title").first.present?
                title = doc.css("h1.job-details__title").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.job-details__divider")
            end_detail = doc.at_css("div.jd-page__employer-overview")
            detail = ''
            next_step = 0
            loop do
                break if next_step == 8 # stop before end_detail
                if start_detail.present? && !start_detail.next_element.nil?
                    start_detail = start_detail.next_element
                    detail << start_detail.to_s
                end
                next_step += 1
            end
            #######################job detail end##########################

            if doc.css("div.svg-icon__text span").present?
                location = doc.css("div.svg-icon__text span").text.strip
            else
                location = ""
            end

            if doc.css("div.svg-icon__text span").present?
                address = doc.css("div.svg-icon__text span").text.strip
            else
                address = location
            end

            salary = "Thương lượng"

            quantity = 1

            category = "CNTT - Phần mềm"

            level = "Nhân viên"

            experience = "Không yêu cầu"

            typical = "Toàn thời gian"

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