module CareerbuilderCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_careerbuilder(url, doc)
        if doc.present?
            processing_detail_datas = []
            unless doc.css("div.job-desc a.job-company-name").nil?
                company_name = doc.css("div.job-desc a.job-company-name").text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = ""
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
            end

            if doc.css("h1.title").first.present?
                title = doc.css("h1.title").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.detail-row")
            end_detail = doc.at_css("div.share-this-job")
            detail = ''
            next_step = 0
            loop do
                break if next_step == 3 # stop before end_detail
                if start_detail.present? && !start_detail.next_element.nil?
                    start_detail = start_detail.next_element
                    detail << start_detail.to_s
                end
                next_step += 1
            end
            #######################job detail end##########################

            if doc.css("div.map p").present?
                location = doc.css("div.map p").text.strip
            else
                location = ""
            end

            if doc.css("div.detail-box ul li p")[3].present?
                salary = doc.css("div.detail-box ul li p")[3].text.strip
            else
                salary = "Thương lượng"
            end

            quantity = 1

            if doc.css("div.detail-box ul li p")[2].present?
                category = doc.css("div.detail-box ul li p")[1].text.strip
                level = doc.css("div.detail-box ul li p")[2].text.strip
            else
                category = ""
                level = "Nhân viên"
            end

            if doc.css("div.detail-box ul li p")[4].present?
                experience = doc.css("div.detail-box ul li p")[4].text.strip
            else
                experience = "Không yêu cầu"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.detail-box ul li p")[6].present?
                date_str = doc.css("div.detail-box ul li p")[6].text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

            typical = "Toàn thời gian"
            urgent = false
            apply_another_site_flag = true
            apply_site = url.to_s
            address = location
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