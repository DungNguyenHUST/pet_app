module CareerbuilderScraper
    require_relative 'common_scraper.rb'
    include CommonScraper

    def get_summary_data_careerbuilder(scrap_job)
        if check_exist_url(scrap_job.url.to_s)
            if scrap_job.company_name.present?
                @company = Company.friendly.search(scrap_job.company_name).first
            else
                @company = Company.friendly.find_by_id(scrap_job.company_id)
            end
            @company = Company.first
            
            if @company.present?
                # Root link
                response = HTTParty.get(scrap_job.url.to_s)
                doc = Nokogiri::HTML(response.body)

                # Get job link in to map
                processing_summary_blocks = doc.css("div.figcaption")
                processing_summary_datas = []

                processing_summary_blocks.each do |processing_summary_block|
                    job_link = processing_summary_block.css("div.title a").map { |link| link['href']}.first
                    job_location = processing_summary_block.css("div.location ul").text.strip
                    job_salary = processing_summary_block.css("div.salary p").text.strip
                    company_name = processing_summary_block.css("div.caption a.company-name").text.strip
                    company_id = @company.id
                    summary_data_temp = job_summary_params.new(company_name,
                                                                company_id,
                                                                job_location, 
                                                                job_salary, 
                                                                job_link)

                    processing_summary_datas.push(summary_data_temp)
                    # puts company_name
                    # puts company_id
                    # puts job_location
                    # puts job_salary
                    # puts job_link
                end

                return processing_summary_datas
            else
                return nil
            end
        else
            return nil
        end
    end

    def get_detail_data_careerbuilder(scrap_job)
        job_summary_params = get_summary_data_careerbuilder(scrap_job)

        if job_summary_params.nil?
            return
        else
            processing_detail_datas = []
            job_summary_params.each do |job_summary_param|
                if check_exist_url(job_summary_param.job_link.to_s)
                    response = HTTParty.get(job_summary_param.job_link.to_s)
                    doc = Nokogiri::HTML(response.body)
                    
                    title = doc.css("h1.title").first.text.strip
                    @company = Company.friendly.find_by_id(job_summary_param.company_id)
                    #######################job detail start##########################
                    start_detail = doc.at_css("div.detail-row")
                    end_detail = doc.at_css("div.share-this-job")
                    detail = ''
                    next_step = 0
                    loop do
                        break if next_step == 3 # stop before end_detail
                        if !start_detail.next_element.nil?
                            start_detail = start_detail.next_element
                            detail << start_detail.to_s
                        end
                        next_step += 1
                    end
                    #######################job detail end##########################
                    location = job_summary_param.job_location.to_s
                    salary = job_summary_param.job_salary.to_s
                    quantity = 1
                    category = "IT"
                    language = "Tùy chọn"
                    level = "Nhân viên"
                    dudate = Time.now
                    end_date = Time.now + 30.days
                    job_type = "Full Time"
                    urgent = false
                    apply_another_site_flag = true
                    apply_site = job_summary_param.job_link.to_s
                    address = @company.address
                    approved = true
                    user_id = 1

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
                                                        job_type, 
                                                        urgent, 
                                                        apply_another_site_flag, 
                                                        apply_site, 
                                                        address,
                                                        user_id,
                                                        approved,
                                                        @company.id)

                    processing_detail_datas.push(deatail_data_temp)
                else
                    return nil
                end
            end
    
            return processing_detail_datas
        end
    end
end