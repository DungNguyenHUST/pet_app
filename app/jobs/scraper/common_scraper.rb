module CommonScraper
    include ApplicationHelper
    include CompanyJobsHelper

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

    def get_company_by_name(name)
        new_name = convert_vie_to_eng(name)
        new_name.sub!("ct", "")
        new_name.sub!("cong ty", "")
        new_name.sub!("company", "")
        new_name.sub!("limited", "")
        new_name.sub!("tap doan", "")
        new_name.sub!("vn", "")
        new_name.sub!("viet nam", "")
        new_name.sub!("vietnam", "")
        new_name.sub!("cp", "")
        new_name.sub!("co phan", "")
        new_name.sub!("tnhh", "")
        new_name.sub!("trach nhiem huu han", "")
        new_name.sub!("mtv", "")
        new_name.sub!("mot thanh vien", "")
        new_name.sub!("thuong mai", "")
        new_name.sub!("san xuat", "")
        new_name.sub!("va", "")
        new_name.sub!("co.,ltd", "")
        new_name.sub!("co., ltd", "")
        new_name.sub!("chi nhanh", "")
        new_name.gsub!(/[!@#$%^&*({]>?/, "")
        new_name.gsub!(/[-_+=)}|<.,;:]/, "")
        new_name.squish!
        return new_name
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

    def processing_job(job_datas)
        if job_datas.nil?
            return
        else
            job_datas.each do |job_data|
                if job_data.apply_site.present? && job_data.company_id.present?
                    job_exsit = CompanyJob.find_by(company_id: job_data.company_id, apply_site: job_data.apply_site)
                    unless job_exsit.present?
                        @company = Company.friendly.find_by_id(job_data.company_id)
                        @company_job = @company.company_jobs.build(:title => job_data.title,
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
                        @company_job.save!
                    end
                end
            end
        end
    end
end