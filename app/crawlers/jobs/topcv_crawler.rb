module TopcvCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_topcv(url, doc)
        job_items = doc.css("div.job-item")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("h3.title a").present?
                    job_link = job_item.css("h3.title a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_topcv(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.box-info-job div.company-title a").present?
                company_search_name = doc.css("div.box-info-job div.company-title a").first.text.strip
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

            if doc.css("div.box-company-logo img").present?
                company_avatar = doc.css("div.box-company-logo img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end
                    
            if doc.css("div.box-info-job h1.job-title").present?
                title = doc.css("div.box-info-job h1.job-title").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.job-data").first
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

            if doc.css("div.box-address div.text-dark-gray")[0].present?
                location = doc.css("div.box-address div.text-dark-gray")[0].text.strip
                location.gsub!(/- Khu vực: /, "")
            else
                location = "Hà Nội"
            end

            if doc.css("div.box-address div.text-dark-gray")[1].present?
                address = doc.css("div.box-address div.text-dark-gray")[1].text.strip
                address.gsub!(/-/, "")
            else
                address = location
            end

            salary = "Thương lượng"

            if doc.css("div.box-main div.box-item")[1].present?
                quantity = doc.css("div.box-main div.box-item")[1].text.strip
                quantity.gsub!(/Số lượng tuyển /, "")
            else
                quantity = 1
            end

            if doc.css("div.box-keyword-job")[0].present?
                category = doc.css("div.box-keyword-job")[0].text.strip.squish!
                category.gsub!(/Ngành nghề/, "")
            else
                category = ""
            end

            if doc.css("div.box-main div.box-item")[3].present?
                level = doc.css("div.box-main div.box-item")[3].text.strip
                level.gsub!(/Cấp bậc /, "")
            else
                level = "Nhân viên"
            end

            if doc.css("div.box-main div.box-item")[5].present?
                experience = doc.css("div.box-main div.box-item")[5].text.strip
                experience.gsub!(/Kinh nghiệm /, "")
            else
                experience = "Không yêu cầu"
            end

            if doc.css("div.box-main div.box-item")[2].present?
                typical = doc.css("div.box-main div.box-item")[2].text.strip
                typical.gsub!(/Hình thức làm việc /, "")
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if doc.css("div.box-info-job div.job-deadline").present?
                date_str = doc.css("div.box-info-job div.job-deadline").text.strip
                end_date = Date.parse(date_str)
            else
                end_date = Time.now + 30.days
            end

            urgent = false
            apply_another_site_flag = true
            apply_site = url
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