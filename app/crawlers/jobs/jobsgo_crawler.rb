module JobsgoCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_jobsgo(url, doc)
        job_items = doc.css("div.brows-job-list")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("div.brows-job-position div.h3 a").present?
                    job_link = job_item.css("div.brows-job-position div.h3 a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_jobsgo(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.media-body a.name h2").present?
                company_search_name = doc.css("div.media-body a.name h2").first.text.strip
                company = get_company_id_by_name(company_search_name)
            end

            if company.present?
                company_name = company_search_name
                company_id = company["id"]
            elsif company_search_name.present?
                company_name = company_search_name
                company_id = -1
            else
                company_name = ""
                company_id = -1
            end

            if doc.css("div.profile-thumb img").present?
                company_avatar = doc.css("div.profile-thumb img").map { |img| img['data-src'].prepend("https://jobsgo.vn")}.last
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
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
            admin_id = Admin.first.id
            
            if title.present? && apply_site.present?
                detail_data_temp = job_params.new(title,
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
                                                    admin_id,
                                                    approved,
                                                    company_id,
                                                    company_name,
                                                    company_avatar,
                                                    experience)

                processing_detail_datas.push(detail_data_temp)
            end

            return processing_detail_datas
        end
    end
end