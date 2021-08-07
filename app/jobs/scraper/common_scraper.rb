module CommonScraper
    include ApplicationHelper
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
                :job_type, 
                :urgent, 
                :apply_another_site_flag, 
                :apply_site, 
                :address,
                :user_id,
                :approved,
                :company_id)
    end

    def job_summary_params
        job_summary_param = Struct.new(:company_name,
                                        :company_id,
                                        :job_location, 
                                        :job_salary,
                                        :job_link)
    end

    def get_company_by_name(name)
        name = convert_vie_to_eng(name)
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
                job_exsit = CompanyJob.find_by(apply_site: job_data.apply_site)
                unless job_exsit.present?
                    @company = Company.friendly.find_by_id(job_data.company_id)
                    @company_job = @company.company_jobs.create!(:title => job_data.title,
                                            :title_converted => convert_vie_to_eng(job_data.title),
                                            :detail => job_data.detail,
                                            :location => job_data.location,
                                            :location_converted => convert_vie_to_eng(job_data.location),
                                            :salary => job_data.salary,
                                            :quantity => job_data.quantity,
                                            :category => job_data.category,
                                            :language => job_data.language,
                                            :level => job_data.level,
                                            :dudate => job_data.dudate,
                                            :end_date => job_data.end_date,
                                            :job_type => job_data.job_type,
                                            :urgent => job_data.urgent,
                                            :apply_another_site_flag => job_data.apply_another_site_flag,
                                            :apply_site => job_data.apply_site,
                                            :address => job_data.address,
                                            :user_id => job_data.user_id,
                                            :approved => job_data.approved)
                    @company_job.save!
                end
            end
        end
    end
end