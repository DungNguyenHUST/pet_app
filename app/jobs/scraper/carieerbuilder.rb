module CareerBuilderScraper
    include CommonScraper

    def get_data_careerbuilder(scrap_job)
        # get company id by name
        if scrap_job.company_name.present?
            @company = Company.friendly.search(scrap_job.company_name).approved.first
        else
            @company = Company.friendly.find_by_id(scrap_job.company_id)
        end

        if(@company.present?)
            # Root link
            response = HTTParty.get(scrap_job.url.to_s)
            doc = Nokogiri::HTML(response.body)

            # Get job link in to map
            processing_block = doc.css("div.figcaption div.title")
            links = processing_block.css("a").map { |link| link['href']}
            
            # Start to get data
            processing_datas = []
            if links.present?
                links.each do |link|
                    if check_exist_url(link)
                        response = HTTParty.get(link.to_s)
                        doc = Nokogiri::HTML(response.body)

                        title = doc.css("h1.title").first.text.strip
                        
                        # get detail job
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

                        if scrap_job.location.present?
                            location = scrap_job.location.to_s
                        else
                            location = "Hà Nội"
                        end
                        salary = "Thương lượng"
                        quantity = 1
                        category = "IT"
                        language = "Tùy chọn"
                        level = "Nhân viên"
                        dudate = Time.now
                        end_date = Time.now + 30.days
                        job_type = "Full Time"
                        urgent = false
                        apply_another_site_flag = true
                        apply_site = link.to_s
                        address = @company.address
                        approved = true
                        user_id = 1

                        data_temp = job_params.new(title,
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

                        processing_datas.push(data_temp)
                    end
                end
                return processing_datas
            else
                return nil
            end
        else
            return nil
        end
    end
end