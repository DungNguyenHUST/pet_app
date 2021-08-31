module JobsgoCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_jobsgo(url, doc)
        if doc.present?
            processing_detail_datas = []
            unless doc.css("div.media-body a.name h2").nil?
                company_name = doc.css("div.media-body a.name h2").text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = ""
            end

            if company_id.present?
                # company_name = Company.find_by_id(company_id).name
            else
                company_id = -1
            end

            if doc.css("div.job-detail-col-1 div.media-body-2 h1").first.present?
                title = doc.css("div.job-detail-col-1 div.media-body-2 h1").first.text.strip
            end

            #######################job detail start##########################
            start_detail = doc.at_css("div.job-detail-col-1 div.content-group")
            end_detail = doc.at_css("div.job-detail-col-1 div.panel-bk")
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

            detail_block = doc.css("div.job-detail-col-1 div.content-group").last

            if detail_block.css("div.giaphv p").present?
                location = doc.css("div.giaphv p").text.strip
                location.gsub!(/[➢]/, "")
            else
                location = ""
            end

            if doc.css("div.media-body-2 span.saraly").present?
                salary = doc.css("div.media-body-2 span.saraly").text.strip
            else
                salary = "Thương lượng"
            end

            quantity = 1

            if detail_block.css("div.list").present?
                category = doc.css("div.list").text.strip
            else
                category = ""
            end

            level = "Nhân viên"

            if detail_block.css("p a.btn-default").present?
                typical = doc.css("p a.btn-default").text.strip
            else
                typical = "Toàn thời gian"
            end

            if detail_block.css("div.box-jobs-info p").present?
                experience = doc.css("div.box-jobs-info p").last.text.strip
            else
                experience = "Không yêu cầu"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.media-body-2 span.deadline").present?
                date_str = doc.css("div.media-body-2 span.deadline").text.strip
                end_date = Time.now + date_str.to_i.days
            else
                end_date = Time.now + 30.days
            end

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