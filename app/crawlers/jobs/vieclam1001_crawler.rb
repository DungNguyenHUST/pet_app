module Vieclam1001Crawler
    require_relative 'common_crawler.rb'
    include CommonCrawler
    include ActionView::Helpers::AssetUrlHelper

    def get_job_pre_data_vieclam1001(url, doc)
        job_items = doc.css("div.listing-section")
        job_pre_datas = []

        if job_items
            job_items.each do |job_item|
                company_name = ""

                company_avatar = ""

                job_location = ""

                job_salary = ""

                if job_item.css("div.listing-title h3 a").present?
                    job_link = job_item.css("div.listing-title h3 a").map { |link| link['href']}.first
                else
                    job_link = ""
                end

                pre_data_temp = job_pre_params.new(company_name, company_avatar, job_location, job_salary, job_link)
                job_pre_datas.push(pre_data_temp)
            end

            return job_pre_datas
        end
    end

    def get_job_data_vieclam1001(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            if doc.css("div.comp-profile-content span.company-name a").present?
                company_search_name = doc.css("div.comp-profile-content span.company-name a").first.text.strip
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

            if doc.css("div.comp-profile-content img").present?
                company_avatar = doc.css("div.comp-profile-content img").map { |img| img['src']}.first
            else
                company_avatar = image_url("defaults/company_avatar_default.png")
            end
                    
            if doc.css("div.listingInfo h1").present?
                title = doc.css("div.listingInfo h1").text.strip
            end

            #######################job detail start##########################
            detail_block = doc.css("fieldset.description-job").first
            if detail_block.present?
                start_detail = detail_block.at_css("div.displayFieldBlock")
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

            info_box_1 = doc.css("fieldset.sortable-column")[0]
            info_box_2 = doc.css("fieldset.sortable-column")[1]

            if info_box_1.present? && info_box_1.css("div.displayFieldBlock")[0].present?
                location = info_box_1.css("div.displayFieldBlock")[0].text.strip
                location.gsub!(/Nơi làm việc:/, "")
            else
                location = "Hà Nội"
            end

            address = location

            if info_box_1.present? && info_box_1.css("div.displayFieldBlock")[2].present?
                salary = info_box_1.css("div.displayFieldBlock")[2].text.strip
                salary.gsub!(/Lương:/, "")
            else
                salary = "Thương lượng"
            end

            quantity = 1

            if info_box_1.present? && info_box_1.css("div.displayFieldBlock")[1].present?
                category = info_box_1.css("div.displayFieldBlock")[1].text.strip.squish!
                category.gsub!(/Ngành:/, "")
            else
                category = ""
            end

            level = "Nhân viên"

            experience = "Không yêu cầu"

            if info_box_2.present? && info_box_2.css("div.displayFieldBlock")[0].present?
                typical = info_box_2.css("div.displayFieldBlock")[0].text.strip
                typical.gsub!(/Hình thức làm việc:/, "")
            else
                typical = "Toàn thời gian"
            end

            language = "Tùy chọn"
            dudate = Time.now

            if info_box_2.present? && info_box_2.css("div.displayFieldBlock")[2].present?
                date_str = info_box_2.css("div.displayFieldBlock")[2].text.strip
                date_str.gsub!(/Ngày hết hạn:/, "")
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