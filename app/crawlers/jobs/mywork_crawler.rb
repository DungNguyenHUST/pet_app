module MyworkCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler

    def get_job_data_mywork(url, doc)
        if doc.present?
            processing_detail_datas = []

            unless doc.css("div.detail-01 a.detail-01-com").nil?
                company_name = doc.css("div.detail-01 a.detail-01-com").text.strip
                company_id = get_company_id_by_name(company_name)
            else
                company_name = ""
            end

            unless company_id.present?
                company_id = -1
            end
                    
            if doc.css("h1.detail-01-ttl").first.present?
                title = doc.css("h1.detail-01-ttl").first.text.strip
            end

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

            if doc.css("div.ex-addr div.detail-01-info a").present?
                location = doc.css("div.ex-addr div.detail-01-info a").text.strip
            else
                location = ""
            end

            address = location

            if doc.css("div.ex-ml div.detail-01-info").present?
                salary = doc.css("div.ex-ml div.detail-01-info").text.strip
            else
                salary = "Thương lượng"
            end

            if doc.css("div.ex-sl div.detail-01-info").present?
                quantity = doc.css("div.ex-sl div.detail-01-info").text.strip
            else
                quantity = 1
            end

            if doc.css("div.ex-nn div.detail-01-info").present?
                category = doc.css("div.ex-nn div.detail-01-info").text.strip
            else
                category = ""
            end

            if doc.css("div.ex-cb div.detail-01-info").present?
                level = doc.css("div.ex-cb div.detail-01-info").text.strip
            else
                level = "Nhân viên"
            end

            if doc.css("div.ex-kn div.detail-01-info").present?
                experience = doc.css("div.ex-kn div.detail-01-info").text.strip
            else
                experience = "Không yêu cầu"
            end

            if doc.css("div.ex-ht div.detail-01-info").present?
                typical = doc.css("div.ex-ht div.detail-01-info").text.strip
            else
                typical = "Toàn thời gian"
            end

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