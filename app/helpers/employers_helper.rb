module EmployersHelper
    def find_company_of_employer(employer)
        company = nil
        if employer.present?
            company = Company.find_by(:employer_id => employer.id)
        end
        return company
    end

    def find_job_of_employer(employer)
        if employer.present?
            company_job = CompanyJob.where(:employer_id => employer.id).expire
            return company_job
        end
    end

    def find_job_remain_of_employer(employer)
        job_remain = -1
        if employer
            if employer.plan == "F-Basic" || employer.plan == "F-Eco" || employer.plan == "F-Pro"
                job_remain = -1
            else
                company_job = CompanyJob.where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
                company_job = CompanyJob.where(:employer_id => employer.id).expire
                if company_job && company_job.count > 0
                    job_remain = 0
                else
                    job_remain = 1
                end
            end
        end
        return job_remain
    end

    def auth_cv_search_plan_of_employer(employer)
        auth = false
        if employer
            if employer.plan == "F-Pro"
                if Time.now - employer.start_plan <= 30
                    auth = true
                end
            else
            end
        end
        return auth
    end

    def auth_urgent_plan_of_employer(employer)
        auth = false
        if employer
            if employer.plan == "F-Pro" || employer.plan == "F-Eco"
                if Time.now - employer.start_plan <= 30
                    auth = true
                end
            else
            end
        end
        return auth
    end

    def auth_sponsor_plan_of_employer(employer)
        auth = false
        if employer
            if employer.plan == "F-Pro" || employer.plan == "F-Eco"
                if Time.now - employer.start_plan <= 30
                    auth = true
                end
            else
            end
        end
        return auth
    end

    def auth_post_job_of_employer(employer)
        auth = false
        if employer
            if employer.approved == true && find_company_of_employer(employer) != nil
                auth = true
            end
        end
        return auth
    end

    def search_cv(params)
        @cv_searchs = []

        unless params.location.empty?
            @user_searchs = User.public.friendly.search(params.location)
            @user_searchs.each do |user|
                @cv_searchs.push(user)
            end
        end

        @skill_searchs = UserSkill.search(params.search)
        @skill_searchs.each do |skill|
            @cv_searchs.push(skill.user)
        end

        @edu_searchs = UserEducation.search(params.search)
        @edu_searchs.each do |edu|
            @cv_searchs.push(edu.user)
        end

        @exp_searchs = UserExperience.search(params.search)
        @exp_searchs.each do |exp|
            @cv_searchs.push(exp.user)
        end

        @cert_searchs = UserCertificate.search(params.search)
        @cert_searchs.each do |cert|
            @cv_searchs.push(cert.user)
        end

        @adward_searchs = UserAdward.search(params.search)
        @adward_searchs.each do |adward|
            @cv_searchs.push(adward.user)
        end

        return @cv_searchs
    end

    def filter_cv(filter_datas, params)
        if filter_datas.present?
            unless params.post_date.nil?
                date = params.post_date.to_i
                filter_datas = filter_datas.delete_if{|a| a.updated_at <= date.day.ago.utc}
            end

            unless params.sex.empty?
                filter_datas = filter_datas.delete_if{|a| a.sex != params.sex}
            end

            unless filter_datas.nil?
                result_filters = nil
                filter_datas.each do |filter_data|
                    unless params.edu.empty?
                        edu_datas = filter_data.user_educations.where("cert_level ILIKE?", "%#{params.edu}%")
                        edu_datas.each do |edu|
                            result_filters.push(edu.user)
                        end
                    end
                    unless params.level.empty?
                        exp_datas= filter_data.user_experiences.where("job_level ILIKE?", "%#{params.level}%")
                        exp_datas.each do |exp|
                            result_filters.push(exp.user)
                        end
                    end
                    unless params.experience.empty?
                        exp_datas = filter_data.user_experiences.map{|m| num_of_experience(m) >= params.experience.to_i}
                        exp_datas.each do |exp|
                            result_filters.push(exp.user)
                        end
                    end

                    unless result_filters.nil?
                        return result_filters
                    end
                end
            end
        end

        return filter_datas
    end
end
