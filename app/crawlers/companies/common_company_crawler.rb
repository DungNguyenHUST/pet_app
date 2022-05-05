module CommonCompanyCrawler
    include ApplicationHelper
    include CompaniesHelper

    def company_params
        company_param = Struct.new(:name,
                                    :image,
                                    :location,
                                    :website,
                                    :size,
                                    :overview,
                                    :time_establish,
                                    :field_operetion,
                                    :time_start,
                                    :time_end,
                                    :country,
                                    :address,
                                    :policy,
                                    :phone,
                                    :values,
                                    :approved,
                                    :wall_picture,
                                    :avatar,
                                    :working_time,
                                    :working_date,
                                    :company_type,
                                    :benefit,
                                    :employer_id)
    end

    def company_pre_params
        company_pre_param = Struct.new(:company_name,
                                        :company_avatar,
                                        :company_location,
                                        :company_link)
    end

    def split_company_name(name)
        if name.split.size > 1
            split_name_array = name.split(/\s/)
                                .each_cons(3)
                                .map { |str| str.join(" ") }
            return split_name_array
        else
            return nil
        end
    end

    def split_domain_name(url)
        uri = url.split("/")[2].sub(/^www./,'').downcase
        return uri.to_s
    end

    def rotate_url(url)
        # api_token = '3E293888640B9883DEB34D96F4C4B62A'
        # rotate_url = 'https://api.scraperbox.com/scrape?token=' + api_token + '&url=' + url + '&javascript_enabled=true'
        # return rotate_url.to_s
        return url
    end

    def get_company_id_by_name(name)
        new_name = convert_vie_to_eng(name)
        new_name.sub!("ct", "")
        new_name.sub!("cong ty", "")
        new_name.sub!("tong cong ty", "")
        new_name.sub!("company", "")
        new_name.sub!("limited", "")
        new_name.sub!("tap doan", "")
        new_name.sub!("group", "")
        new_name.sub!("vn", "")
        new_name.sub!("viet nam", "")
        new_name.sub!("vietnam", "")
        new_name.sub!("vi na", "")
        new_name.sub!("vina", "")
        new_name.sub!("cp", "")
        new_name.sub!("co phan", "")
        new_name.sub!("tnhh", "")
        new_name.sub!("trach nhiem huu han", "")
        new_name.sub!("mtv", "")
        new_name.sub!("mot thanh vien", "")
        new_name.sub!("thuong mai", "")
        new_name.sub!("dich vu", "")
        new_name.sub!("tm", "")
        new_name.sub!("san xuat", "")
        new_name.sub!("va", "")
        new_name.sub!("co ltd", "")
        new_name.sub!("co.,ltd", "")
        new_name.sub!("co., ltd", "")
        new_name.sub!("chi nhanh", "")
        new_name.sub!("trung tam", "")
        new_name.sub!("ngan hang", "")
        new_name.sub!("nghien cuu", "")
        new_name.sub!("phat trien", "")
        new_name.sub!("rnd", "")
        new_name.sub!("tai chinh", "")
        new_name.sub!("bao hiem", "")
        new_name.sub!("xay dung", "")
        new_name.sub!("nong nghiep", "")
        new_name.sub!("dau tu", "")
        new_name.sub!("chung khoan", "")
        new_name.sub!("kinh doanh", "")
        new_name.sub!("cong nghe", "")
        new_name.sub!("thong tin", "")
        new_name.sub!("giao duc", "")
        new_name.sub!("sai gon", "")
        new_name.sub!("ha noi", "")
        new_name.gsub!(/[!@#$%^&*({]>?/, "")
        new_name.gsub!(/[-_+=)}|<.,;:]/, "")
        new_name.squish!

        unless new_name.empty?
            if split_name_array = split_company_name(new_name)
                # Find company by each 2 word
                split_name_array.each do |split_name|
                    # company_search = Company.friendly.search(split_name)
                    # if company_search.present?
                    #     return company_search.first.id
                    # end
                    company_search = search_production_company_list(split_name)
                    if company_search.present?
                        return company_search
                    end
                end
            else
                # company_search = Company.friendly.search(new_name)
                # if company_search.present?
                #     return company_search.first.id
                # end
                company_search = search_production_company_list(new_name)
                if company_search.present?
                    return company_search
                end
            end

            return nil
        else
            return nil
        end
    end

    def search_production_company_list(search)
        company_list = get_company_production_list
        
        unless company_list.nil?
            search_result = company_list.find {|h| h["name"].include?(search) }
        end

        if search_result.present?
            return search_result
        else
            return nil
        end
    end

    def get_company_production_list
        company_list = []
        filepath = "tmp/companies/company_list.csv"

        # Delete old data each day
        if File.exist?(filepath) 
            if File.mtime(filepath) < 1.day.ago.utc
                File.delete(filepath)
            end
        end
        
        # Push data in csv file
        unless File.exist?(filepath)
            doc = Nokogiri::HTML(URI.open('https://www.firework.vn/companies'))

            company_id = doc.css("div.user_select_company option").map { |company| company['value']}
            company_name = doc.css("div.user_select_company option").map { |company| convert_vie_to_eng(company.text.strip)}
            
            data = []
            company_id.each_with_index do |id, i|
                data << {id: id, name: company_name[i]}
            end

            column_names = data.first.keys
            CSV.open(filepath, "a", :headers => true) do |csv|
                csv << column_names
                data.each do |hash|
                    csv << hash.values
                end
            end
        end

        # Read data into hash
        if File.exist?(filepath)
            CSV.foreach(filepath, :headers => true) do |row|
                company_list << Hash[row.headers.zip(row.fields)]
            end
        end

        return company_list
    end

    @@FILE_COUNT = 0
    def save_company_to_csv(company_data)
        filepath = "tmp/companies/companies_#{@@FILE_COUNT}.csv"

        if File.exist?(filepath)
            if CSV.read(filepath).length > 1000 # split each 1000 record
                @@FILE_COUNT += 1
            end
        end
        
        CSV.open(filepath, "a", :headers => true) do |csv|
            # Write header if file empty
            if File.zero?(filepath)
                csv << Company.attribute_names
            end
            csv << company_data.attributes.values
        end
    end

    def processing_company(company_datas)
        if company_datas.nil?
            return
        else
            company_datas.each do |company_data|

                @company = Company.new(:name => company_data.name,
                                        :image => company_data.image,
                                        :location => company_data.location,
                                        :website => company_data.website,
                                        :size => company_data.size,
                                        :overview => company_data.overview,
                                        :time_establish => company_data.time_establish,
                                        :field_operetion => company_data.field_operetion,
                                        :time_start => company_data.time_start,
                                        :time_end => company_data.time_end,
                                        :country => company_data.country,
                                        :address => company_data.address,
                                        :policy => company_data.policy,
                                        :phone => company_data.phone,
                                        :values => company_data.values,
                                        :approved => company_data.approved,
                                        :wall_picture => company_data.wall_picture,
                                        :working_time => company_data.working_time,
                                        :working_date => company_data.working_date,
                                        :company_type => company_data.company_type,
                                        :benefit => company_data.benefit,
                                        :employer_id => company_data.employer_id)

                company_exsit = Company.find_by(name: company_data.name, address: company_data.address) # remove duplicate name

                unless company_exsit
                    # if company_data.image
                    #     tempfile = MiniMagick::Image.open(company_data.image)

                    #     @company.avatar = tempfile
                    # end

                    save_company_to_csv(@company)
                    
                    # @company.save!
                # else
                #     save_company_to_csv(@company)

                #     @company_exsit .update!(:name => company_data.name,
                #                             :image => company_data.image,
                #                             :location => company_data.location,
                #                             :website => company_data.website,
                #                             :size => company_data.size,
                #                             :overview => company_data.overview,
                #                             :time_establish => company_data.time_establish,
                #                             :field_operetion => company_data.field_operetion,
                #                             :time_start => company_data.time_start,
                #                             :time_end => company_data.time_end,
                #                             :country => company_data.country,
                #                             :address => company_data.address,
                #                             :policy => company_data.policy,
                #                             :phone => company_data.phone,
                #                             :values => company_data.values,
                #                             :approved => company_data.approved,
                #                             :wall_picture => company_data.wall_picture,
                #                             :working_time => company_data.working_time,
                #                             :working_date => company_data.working_date,
                #                             :company_type => company_data.company_type,
                #                             :benefit => company_data.benefit,
                #                             :employer_id => company_data.employer_id)
                end
            end
        end
    end
end