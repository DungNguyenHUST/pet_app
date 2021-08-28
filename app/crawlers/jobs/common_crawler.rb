module CommonCrawler
    include ApplicationHelper
    include CompanyJobsHelper

    @PRO_COMPANY = nil

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
                :typical, 
                :urgent, 
                :apply_another_site_flag, 
                :apply_site, 
                :address,
                :user_id,
                :approved,
                :company_id,
                :company_name,
                :experience)
    end

    def job_summary_params
        job_summary_param = Struct.new(:company_name,
                                        :company_id,
                                        :job_location, 
                                        :job_salary,
                                        :job_link)
    end

    def split_company_name(name)
        if name.split.size > 1
            split_name_array = name.split(/\s/)
                                .each_cons(2)
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

    def check_exist_url(url)
        url = URI.parse(url) rescue false
        return url
        # if url
        #     req = Net::HTTP.new(url.host, url.port)
        #     res = req.request_head(url.path)
        # end
        
        # if res.present?
        #     return true
        # else
        #     return false
        # end
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
                    company_search_id = search_production_company_list(split_name)
                    if company_search_id.present?
                        return company_search_id
                    end
                end
            else
                # company_search = Company.friendly.search(new_name)
                # if company_search.present?
                #     return company_search.first.id
                # end
                company_search_id = search_production_company_list(new_name)
                if company_search_id.present?
                    return company_search_id
                end
            end

            return nil
        else
            return nil
        end
    end

    def search_production_company_list(search)
        if @PRO_COMPANY.nil?
            doc = Nokogiri::HTML(URI.open('https://www.firework.vn/companies'))

            company_id = doc.css("div.user_select_company option").map { |company| company['value']}
            company_name = doc.css("div.user_select_company option").map { |company| company.text.strip}

            @PRO_COMPANY = []
            company_id.each_with_index do |id, i|
                @PRO_COMPANY << {id: id, name: company_name[i]}
            end
            @PRO_COMPANY = @PRO_COMPANY.reject!{|h| h[:name] == "Chọn công ty" }
        end
        
        search_result = @PRO_COMPANY.find {|h| h[:name].include?(search) }

        if search_result
            return search_result[:id]
        else
            return nil
        end
    end

    def save_job_to_csv(job)
        CSV.open("tmp/jobs/jobs.csv", "a") do |csv|
            csv << job.attributes.values
        end
    end

    def processing_job(job_datas)
        if job_datas.nil?
            return
        else
            job_datas.each do |job_data|
                if job_data.apply_site.present? && job_data.company_id.present?
                    job_exsit = CompanyJob.find_by(company_id: job_data.company_id, apply_site: job_data.apply_site)
                    unless job_exsit.present?
                        @company_job = CompanyJob.new(:company_id => job_data.company_id,
                                                        :title => job_data.title,
                                                        :detail => job_data.detail,
                                                        :location => job_data.location,
                                                        :salary => job_data.salary,
                                                        :quantity => job_data.quantity,
                                                        :category => job_data.category,
                                                        :language => job_data.language,
                                                        :level => job_data.level,
                                                        :dudate => job_data.dudate,
                                                        :end_date => job_data.end_date,
                                                        :typical => job_data.typical,
                                                        :urgent => job_data.urgent,
                                                        :apply_another_site_flag => job_data.apply_another_site_flag,
                                                        :apply_site => job_data.apply_site,
                                                        :address => job_data.address,
                                                        :user_id => job_data.user_id,
                                                        :approved => job_data.approved,
                                                        :company_name => job_data.company_name,
                                                        :experience => job_data.experience)
                                                
                        @company_job = convert_job_param(@company_job)
                        save_job_to_csv(@company_job)
                        @company_job.save!
                    end
                end
            end
        end
    end
end