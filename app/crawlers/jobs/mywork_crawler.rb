module MyworkScraper
    require_relative 'common_scraper.rb'
    include CommonScraper

    def get_summary_data_mywork(scrap_job)
        if check_exist_url(scrap_job.url.to_s)
            # Root link
            response = HTTParty.get(scrap_job.url.to_s)
            doc = Nokogiri::HTML(response.body)

            # Get job link in to map
            processing_summary_blocks = doc.css("li.jobslist-01-li")
            processing_summary_datas = []

            if processing_summary_blocks.present?
                processing_summary_blocks.each do |processing_summary_block|
                    unless processing_summary_block.css("div.jobslist-01-row-ttl a").nil?
                        job_link = processing_summary_block.css("div.jobslist-01-row-ttl a").map { |link| link['href']}.first
                        if job_link.present?
                            job_link.prepend("https://mywork.com.vn")
                        end
                    end

                    unless processing_summary_block.css("ul.list-feat li.ex-address").nil?
                        job_location = processing_summary_block.css("ul.list-feat li.ex-address").text.strip
                        job_location.sub!("Địa điểm: ", "")
                    end
                    
                    unless processing_summary_block.css("ul.list-feat li.ex-salary").nil?
                        job_salary = processing_summary_block.css("ul.list-feat li.ex-salary").text.strip
                        job_salary.sub!("Lương: ", "")
                    end

                    if scrap_job.company_id.present?
                        # Manual
                        @company = Company.friendly.find_by_id(scrap_job.company_id)
                        company_name = @company.name
                    elsif scrap_job.company_name.present?
                        # Manual
                        @company = Company.friendly.search(scrap_job.company_name).first
                        company_name = @company.name
                    else
                        unless processing_summary_block.css("h1.company-02-box-ttl").nil?
                            # Auto
                            company_name = processing_summary_block.css("h1.company-02-box-ttl").text.strip
                            company_name_converted = get_company_by_name(company_name) 
                            @company = Company.friendly.search(company_name_converted).first
                        end
                    end

                    if @company.present?
                        company_id = @company.id
                    end

                    if job_link.present? && job_location.present? && job_salary.present? && company_name.present? && company_id.present?
                        summary_data_temp = job_summary_params.new(company_name,
                                                                    company_id,
                                                                    job_location, 
                                                                    job_salary, 
                                                                    job_link)

                        processing_summary_datas.push(summary_data_temp)
                        
                    end
                end

                return processing_summary_datas
            end
        else
            return nil
        end
    end

    def get_detail_data_mywork(scrap_job)
        job_summary_params = get_summary_data_mywork(scrap_job)

        if job_summary_params.nil?
            return
        else
            processing_detail_datas = []
            job_summary_params.each do |job_summary_param|
                if check_exist_url(job_summary_param.job_link.to_s)
                    response = HTTParty.get(job_summary_param.job_link.to_s)
                    doc = Nokogiri::HTML(response.body)
                    
                    if doc.css("h1.detail-01-ttl").first.present?
                        title = doc.css("h1.detail-01-ttl").first.text.strip
                    end
                    @company = Company.friendly.find_by_id(job_summary_param.company_id)
                    #######################job detail start##########################
                    start_detail = doc.at_css("div.detail-01-row-block")
                    end_detail = doc.at_css("div.mt30")
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
                    location = job_summary_param.job_location.to_s
                    salary = job_summary_param.job_salary.to_s
                    if doc.css("div.ex-sl").present?
                        quantity = doc.css("div.ex-cb div.detail-01-info").first.text.strip
                    else
                        quantity = 1
                    end
                    if doc.css("div.ex-nn").present?
                        category = doc.css("div.ex-nn").map { |title| title['title']}.first
                    else
                        category = ""
                    end
                    if doc.css("div.ex-cb").present?
                        level = doc.css("div.ex-cb div.detail-01-info").first.text.strip
                    else
                        level = "Nhân viên"
                    end
                    language = "Tùy chọn"
                    dudate = Time.now
                    end_date = Time.now + 30.days
                    if doc.css("div.ex-ht").present?
                        level = doc.css("div.ex-cb div.detail-01-info").first.text.strip
                    else
                        typical = "Toàn thời gian"
                    end
                    urgent = false
                    apply_another_site_flag = true
                    apply_site = job_summary_param.job_link.to_s
                    address = @company.address
                    approved = true
                    user_id = Admin.first.id
                    if doc.css("div.ex-kn").present?
                        experience = doc.css("div.ex-cb div.detail-01-info").first.text.strip
                    else
                        experience = "Không yêu cầu"
                    end
                    
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
                end
            end
    
            return processing_detail_datas
        end
    end
end