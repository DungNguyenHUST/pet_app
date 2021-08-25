module TopcvCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_topcv(url, doc)
        unless doc.css("div.company-title span").nil?
            company_name = doc.css("div.company-title span").text.strip
            @company = get_company_by_name(company_name)
        end
        @company = Company.first

        if @company.present?
            processing_detail_datas = []
                    
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

            location = "Hà Nội"
            location.sub!("Khu vực: ", "")
            salary = "Thương lượng"
            quantity = 1
            if detail_block.present?
                category = detail_block.css("span").text.strip.squish!
            else
                category = ""
            end
            level = "Nhân viên"
            language = "Tùy chọn"
            dudate = Time.now
            end_date = Time.now + 30.days
            typical = "Toàn thời gian"
            urgent = false
            apply_another_site_flag = true
            apply_site = url
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