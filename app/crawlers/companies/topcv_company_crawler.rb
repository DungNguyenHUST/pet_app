module TopcvCompanyCrawler
    require_relative 'common_company_crawler.rb'
    include CommonCompanyCrawler
    include CompanyJobsHelper
    include ActionView::Helpers::AssetUrlHelper

    def get_company_pre_data_topcv(url, doc)
        company_items = doc.css("div.result-search-company")
        company_pre_datas = []

        if company_items
            company_items.each do |company_item|
                company_name = ""

                company_avatar = ""

                company_location = ""

                if company_item.css("div.title a.company-name").present?
                    company_link = company_item.css("div.title a.company-name").map { |link| link['href']}.first
                else
                    company_link = ""
                end

                pre_data_temp = company_pre_params.new(company_name, company_avatar, company_location, company_link)
                company_pre_datas.push(pre_data_temp)
            end

            return company_pre_datas
        end
    end

    def get_company_data_topcv(url, doc, pre_data)
        if doc.present?
            processing_detail_datas = []

            name = nil
            image = nil
            location = nil
            website = nil
            size = nil
            overview = nil
            time_establish = nil
            field_operetion = nil
            time_start = nil
            time_end = nil
            country = nil
            address = nil
            policy = nil
            phone = nil
            values = nil
            approved = true
            wall_picture = nil
            avatar = nil
            working_time = nil
            working_date = nil
            company_type = nil
            benefit = nil
            employer_id = nil


            if doc.css("div.company-info h1.company-detail-name").present?
                name = doc.css("div.company-info h1.company-detail-name").first.text.strip
            end

            if doc.css("div.company-image-logo img").present?
                logo_url = doc.css("div.company-image-logo img").map { |img| img['src']}.first
                unless logo_url.include?("topcv-logo-gray")
                    image = logo_url
                end
            end
                    
            if doc.css("div.company-info p.website a").present?
                website = doc.css("div.company-info p.website a").text.strip
            end

            if doc.css("div.company-info p.company-size").present?
                size = doc.css("div.company-info p.company-size").text.strip
            end

            if doc.css("div.detail div.box-address div.box-body p.text-dark-gray").present?
                address = doc.css("div.detail div.box-address div.box-body p.text-dark-gray").text.strip
                location = find_job_location(address)
            end

            if doc.css("div.company-info div.box-body").present?
                overview = doc.css("div.company-info div.box-body")
            end
            
            if name.present?
                detail_data_temp = company_params.new(name,
                                                    image,
                                                    location,
                                                    website,
                                                    size,
                                                    overview,
                                                    time_establish,
                                                    field_operetion,
                                                    time_start,
                                                    time_end,
                                                    country,
                                                    address,
                                                    policy,
                                                    phone,
                                                    values,
                                                    approved,
                                                    wall_picture,
                                                    avatar,
                                                    working_time,
                                                    working_date,
                                                    company_type,
                                                    benefit,
                                                    employer_id)

                processing_detail_datas.push(detail_data_temp)
            end

            return processing_detail_datas
        end
    end
end