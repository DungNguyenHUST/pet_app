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

    def auth_find_personal_plan_of_employer(employer)
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
    
end
