module CompanyJobsHelper
    def convert_salary_to_min(company_job)
		salary = company_job.salary.to_s
        salary_min = salary.scan(/\d+/).map(&:to_i)
        if salary_min.size > 1
            return salary_min.first * 1000000
        else
            return 0
        end
    end

    def convert_salary_to_max(company_job)
		salary = company_job.salary.to_s
        salary_max = salary.scan(/\d+/).map(&:to_i)
        if salary_max.size > 0
            return salary_max.last * 1000000
        else
            return 0
        end
    end
end
