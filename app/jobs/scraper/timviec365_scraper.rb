module Timviec365Scraper
    require_relative 'common_scraper.rb'
    include CommonScraper

    def get_summary_data_timviec365(scrap_job)
        if check_exist_url(scrap_job.url.to_s)
            # Root link
            response = HTTParty.get(scrap_job.url.to_s)
            doc = Nokogiri::HTML(response.body)

            # Get job link in to map
            processing_summary_blocks = doc.css("div.item_vl_com")
            processing_summary_datas = []

            if processing_summary_blocks.present?
                processing_summary_blocks.each do |processing_summary_block|
                    unless processing_summary_block.css("h3 a.title_com_com").nil?
                        job_link = processing_summary_block.css("h3 a.title_com_com").map { |link| link['href']}.first
                        if job_link.present?
                            job_link.prepend("https://timviec365.vn")
                        end
                    end

                    unless processing_summary_block.css("div.box_tomtat div.ic8").nil?
                        job_location = processing_summary_block.css("div.box_tomtat div.ic8").text.strip
                    end
                    
                    unless processing_summary_block.css("div.box_tomtat div.ic2").nil?
                        job_salary = processing_summary_block.css("div.box_tomtat div.ic2").text.strip
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
                        unless processing_summary_block.css("div.name_cty").nil?
                            # Auto
                            company_name = processing_summary_block.css("div.name_cty").text.strip
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

    def get_detail_data_timviec365(scrap_job)
        job_summary_params = get_summary_data_timviec365(scrap_job)

        if job_summary_params.nil?
            return
        else
            processing_detail_datas = []
            job_summary_params.each do |job_summary_param|
                if check_exist_url(job_summary_param.job_link.to_s)
                    response = HTTParty.get(job_summary_param.job_link.to_s)
                    doc = Nokogiri::HTML(response.body)
                    
                    if doc.css("div.box_tit_detail div.right_tit h1").first.present?
                        title = doc.css("div.box_tit_detail div.right_tit h1").first.text.strip
                    end
                    @company = Company.friendly.find_by_id(job_summary_param.company_id)
                    #######################job detail start##########################
                    start_detail = doc.at_css("div.box_mota")
                    end_detail = doc.at_css("div.span_ut")
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
                    if doc.css("div.box_tomtat_2 p").present?
                        category = doc.css("div.box_tomtat_2 p")[6].text.strip.squish!
                        level = doc.css("div.box_tomtat_2 p")[0].text.strip.squish!
                        quantity = doc.css("div.box_tomtat_2 p")[5].text.strip.squish!
                        typical = doc.css("div.box_tomtat_2 p")[2].text.strip.squish!
                        experience = doc.css("div.box_tomtat_2 p")[1].text.strip.squish!
                    else
                        category = ""
                        level = "Nhân viên"
                        quantity = 1
                        typical = "Toàn thời gian"
                        experience = "Không yêu cầu"
                    end
                    category.sub!("- Ngành nghề: ", "")
                    level.sub!("- Chức vụ: ", "")
                    quantity.sub!("- Số lượng cần tuyển: ", "")
                    typical.sub!("- Hình thức làm việc: ", "")
                    experience.sub!("- Kinh nghiệm: ", "")

                    language = "Tùy chọn"
                    dudate = Time.now
                    end_date = Time.now + 30.days
                    urgent = false
                    apply_another_site_flag = true
                    apply_site = job_summary_param.job_link.to_s
                    address = @company.address
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