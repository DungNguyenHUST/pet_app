module CareerbuilderCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_careerbuilder(url, doc)
        unless doc.css("div.job-desc a.job-company-name").nil?
            company_name = doc.css("div.job-desc a.job-company-name").text.strip
            @company = get_company_by_name(company_name)
        end
        @company = Company.first

        if @company.present?
            processing_detail_datas = []
                    
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
                location = "Hà Nội"
            end

            if doc.css("div.detail-box ul li p").present?
                salary = doc.css("div.detail-box ul li p")[3].text.strip
            else
                salary = "Thương lượng"
            end

            quantity = 1

            if doc.css("div.detail-box ul li p").present?
                category = doc.css("div.detail-box ul li p")[1].text.strip
                level = doc.css("div.detail-box ul li p")[2].text.strip
            else
                category = ""
                level = "Nhân viên"
            end

            language = "Tùy chọn"
            dudate = Time.now
            end_date = Time.now + 30.days
            typical = "Toàn thời gian"
            urgent = false
            apply_another_site_flag = true
            apply_site = url.to_s
            address = @company.address
            approved = true
            user_id = Admin.first.id
            experience = "Không yêu cầu"
            
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
                                                    @company.id,
                                                    @company.name,
                                                    experience)

                processing_detail_datas.push(deatail_data_temp)
            end

            return processing_detail_datas
        end
    end
end