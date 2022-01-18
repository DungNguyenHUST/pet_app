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
            company_job = CompanyJob.where(:employer_id => employer.id)
            return company_job
        end
    end

    def auth_post_job_of_employer(employer)
        auth = false
        if employer
            if find_company_of_employer(employer) != nil
                auth = true
            end
        end
        return auth
    end

    def auth_view_cv_of_employer(employer)
        auth = false
        if employer
            if find_company_of_employer(employer) != nil
                auth = true
            end
        end
        return auth
    end
end
