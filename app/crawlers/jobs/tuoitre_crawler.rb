module TuoitreCrawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_tuoitre(url, doc)
        job_items = doc.css("div.gird_standard dd.brief")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("h3.job a").present?
                    job_link = job_item.css("h3.job a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_tuoitre(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.top-job div.top-job-info div.tit_company").present?
                company_search_name = doc.css("div.top-job div.top-job-info div.tit_company").first.text.strip
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

            if doc.css("div.logocompany a img").present?
                company_avatar = doc.css("div.logocompany a img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.svg")
            end
                    
            if doc.css("div.top-job-info h1").present?
                title = doc.css("div.top-job-info h1").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("div.LeftJobCB").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.MarBot20")
                detail = ''
                next_step = 0
                loop do
                    break if next_step == 5 # stop before end_detail
                    if start_detail.present? && !start_detail.next_element.nil?
                        detail << start_detail.to_s
                        start_detail = start_detail.next_element
                    end
                    next_step += 1
                end
            end
            #######################job detail end##########################

            data_box1 = doc.css("ul.DetailJobNew li.bgLine1")[0]
            data_box2 = doc.css("ul.DetailJobNew li.bgLine2")[0]
            data_box3 = doc.css("ul.DetailJobNew li.bgLine1")[1]

            if data_box3.css("p.fl_right").present? # 6 items
                if data_box1.css("p.fl_left").present?
                    location = data_box1.css("p.fl_left").text.strip
                    location.gsub!(/Nơi làm việc: /, "")
                else
                    location = "Hà Nội"
                end

                address = location

                if data_box2.css("p.fl_right").present?
                    salary = data_box2.css("p.fl_right").text.strip
                    salary.gsub!(/Lương: /, "")
                else
                    salary = "Thương lượng"
                end

                if data_box3.css("p.fl_left").present?
                    category = data_box3.css("p.fl_left").text.strip.squish!
                    category.gsub!(/Ngành nghề: /, "")
                else
                    category = ""
                end

                if data_box1.css("p.fl_right").present?
                    level = data_box1.css("p.fl_right").text.strip
                    level.gsub!(/Cấp bậc: /, "")
                else
                    level = "Nhân viên"
                end

                if data_box2.css("p.fl_left").present?
                    experience = data_box2.css("p.fl_left").text.strip
                    experience.gsub!(/Kinh nghiệm: /, "")
                else
                    experience = "Không yêu cầu"
                end

                if data_box3.css("p.fl_right").present?
                    date_str = data_box3.css("p.fl_right").text.strip
                    date_str.gsub!(/Hết hạn nộp: /, "")
                    end_date = Date.parse(date_str)
                else
                    end_date = Time.now + 30.days
                end
            else # 5 items
                if data_box1.css("p.fl_left").present?
                    location = data_box1.css("p.fl_left").text.strip
                    location.gsub!(/Nơi làm việc: /, "")
                else
                    location = "Hà Nội"
                end

                address = location

                if data_box1.css("p.fl_right").present?
                    salary = data_box1.css("p.fl_right").text.strip
                    salary.gsub!(/Lương: /, "")
                else
                    salary = "Thương lượng"
                end

                if data_box2.css("p.fl_left").present?
                    category = data_box2.css("p.fl_left").text.strip.squish!
                    category.gsub!(/Ngành nghề: /, "")
                else
                    category = ""
                end

                if data_box3.css("p.fl_left").present?
                    level = data_box3.css("p.fl_left").text.strip
                    level.gsub!(/Cấp bậc: /, "")
                else
                    level = "Nhân viên"
                end

                # if data_box2.css("p.fl_left").present?
                #     experience = data_box2.css("p.fl_left").text.strip
                #     experience.gsub!(/Kinh nghiệm: /, "")
                # else
                #     experience = "Không yêu cầu"
                # end

                if data_box2.css("p.fl_right").present?
                    date_str = data_box2.css("p.fl_right").text.strip
                    date_str.gsub!(/Hết hạn nộp: /, "")
                    end_date = Date.parse(date_str)
                else
                    end_date = Time.now + 30.days
                end
            end

            quantity = 1

            typical = "Toàn thời gian"

            language = "Tùy chọn"

            dudate = Time.now

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