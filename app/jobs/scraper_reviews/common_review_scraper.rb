module CommonReviewScraper
    include ApplicationHelper
    include CompanyJobsHelper

    def review_params
        review_param = Struct.new(:company_name,
                                    :score,
                                    :company_id,
                                    :user_name,
                                    :review,
                                    :start_date,
                                    :end_date,
                                    :position,
                                    :pros,
                                    :cons,
                                    :review_title,
                                    :career_score,
                                    :manager_score,
                                    :ot_score,
                                    :salary_score,
                                    :work_env_score,
                                    :working_status,
                                    :average_score,
                                    :privacy,
                                    :working_time,
                                    :user_id,
                                    :recommend)
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

    def processing_review(review_datas)
        if review_datas.nil?
            return
        else
            review_datas.each do |review_data|
                if review_data.company_id.present?
                    @company = Company.friendly.find_by_id(review_data.company_id)
                    @company_review = @company.company_reviews.build(:companyName => review_data.company_name,
                                                                    :score => review_data.score,
                                                                    :company_id => review_data.company_id,
                                                                    :user_name => review_data.user_name,
                                                                    :review => review_data.review,
                                                                    :start_date => review_data.start_date,
                                                                    :end_date => review_data.end_date,
                                                                    :position => review_data.position,
                                                                    :pros => review_data.pros,
                                                                    :cons => review_data.cons,
                                                                    :review_title => review_data.review_title,
                                                                    :career_score => review_data.career_score,
                                                                    :manager_score => review_data.manager_score,
                                                                    :ot_score => review_data.ot_score,
                                                                    :salary_score => review_data.salary_score,
                                                                    :work_env_score => review_data.work_env_score,
                                                                    :working_status => review_data.working_status,
                                                                    :average_score => review_data.average_score,
                                                                    :privacy => review_data.privacy,
                                                                    :working_time => review_data.working_time,
                                                                    :user_id => review_data.user_id,
                                                                    :recommend => review_data.recommend)
                    @company_review.save!
                end
            end
        end
    end
end