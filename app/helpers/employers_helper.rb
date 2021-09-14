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
end
