class ScraperJob < ApplicationJob
    queue_as :default

    def perform(scrap_job)
        processing_data(scrap_job.url, scrap_job.company_name, scrap_job.company_id)
    end

    def get_data_itviec(url, company_name, company_id)
        # get company id by name
        if company_name.present?
            @company = Company.friendly.search(company_name).approved.first
        else
            @company = Company.friendly.find_by_id(company_id)
        end

        if(@company.present?)
            # Root link
            response = HTTParty.get(url.to_s)
            doc = Nokogiri::HTML(response.body)

            # Get job link in to map
            processing_block = doc.css("h4.title")
            links = processing_block.css("a").map { |link| link['href']}
            links.map { |h| h.to_s.prepend("https://itviec.com/")}			
            
            # Start to get data
            processing_datas = []
            links.each do |link|
                response = HTTParty.get(link.to_s)
                doc = Nokogiri::HTML(response.body)

                title = doc.css("h1.job-details__title").first.text.strip
                
                # get detail job
                start_detail = doc.at_css("div.job-details__divider")
                end_detail = doc.at_css("div.jd-page__employer-overview")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 8 # stop before end_detail
                    if !start_detail.next_element.nil?
                    start_detail = start_detail.next_element
                    detail << start_detail.to_s
                    end
                    next_step += 1
                end

                location = "Hà Nội"
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
                address = "Hà Nội"
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

            return processing_datas
        else
            return nil
        end
    end

    def get_data_careerbuilder(url, company_name, company_id)
        # get company id by name
        if company_name.present?
            @company = Company.friendly.search(company_name).approved.first
        else
            @company = Company.friendly.find_by_id(company_id)
        end

        if(@company.present?)
            # Root link
            response = HTTParty.get(url.to_s)
            doc = Nokogiri::HTML(response.body)

            # Get job link in to map
            processing_block = doc.css("div.figcaption div.title")
            links = processing_block.css("a").map { |link| link['href']}
            
            # Start to get data
            processing_datas = []
            links.each do |link|
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

                location = "Hà Nội"
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
                address = "Hà Nội"
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

            return processing_datas
        else
            return nil
        end
    end

    def processing_job(job_datas)
        if job_datas.nil?
            return
        else
            job_datas.each do |job_data|
            @company = Company.friendly.find_by_id(job_data.company_id)
            @company_job = @company.company_jobs.create!(:title => job_data.title,
                                    :detail => job_data.detail,
                                    :location => job_data.location,
                                    :salary => job_data.salary,
                                    :quantity => job_data.quantity,
                                    :category => job_data.category,
                                    :language => job_data.language,
                                    :level => job_data.level,
                                    :dudate => job_data.dudate,
                                    :end_date => job_data.end_date,
                                    :job_type => job_data.job_type,
                                    :urgent => job_data.urgent,
                                    :apply_another_site_flag => job_data.apply_another_site_flag,
                                    :apply_site => job_data.apply_site,
                                    :address => job_data.address,
                                    :user_id => job_data.user_id,
                                    :approved => job_data.approved)
            @company_job.save!
            end
        end
    end

    def job_params
        job_param = Struct.new(:title,
                :detail,
                :location, 
                :salary, 
                :quantity, 
                :category, 
                :language, 
                :level, 
                :dudate,
                :end_date,
                :job_type, 
                :urgent, 
                :apply_another_site_flag, 
                :apply_site, 
                :address,
                :user_id,
                :approved,
                :company_id)
    end

    def split_domain_name(url)
        uri = url.split("/")[2].sub(/^www./,'').downcase
        return uri.to_s
    end

    def processing_data(url, company_name, company_id)
        puts "Start scrap data..."
        if split_domain_name(url) == "itviec.com"
            processing_job(get_data_itviec(url, company_name, company_id))
        end
        if split_domain_name(url) == "careerbuilder.vn"
            processing_job(get_data_careerbuilder(url, company_name, company_id))
        end
        puts "End scrap data!!!"
    end
end
