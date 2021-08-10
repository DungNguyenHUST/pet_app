module CompanyJobsHelper
    def convert_salary_to_min(salary)
        salary_min = salary.scan(/\d+/).map(&:to_i)
        if salary_min.size > 1
            if salary_min.first >= 1000
                return salary_min.first
            else
                return salary_min.first * 1000000
            end
        else
            return 0
        end
    end

    def convert_salary_to_max(salary)
        salary_max = salary.scan(/\d+/).map(&:to_i)
        if salary_max.size > 0
            if salary_max.last >= 1000
                return salary_max.last
            else
                return salary_max.last * 1000000
            end
        else
            return 0
        end
    end

    def convert_job_param(company_job)
        if company_job
            company = company_job.company

            if company_job.title
                company_job.title_converted = convert_vie_to_eng(company_job.title)
            end

            if company_job.location
                company_job.location_converted = convert_vie_to_eng(company_job.location)
            end

            if company_job.salary
                company_job.salary_min = convert_salary_to_min(company_job.salary)
                company_job.salary_max = convert_salary_to_max(company_job.salary)
            end

            if company_job.category
                company_job.category_converted = convert_vie_to_eng(company_job.category)
            end

            if company && company.name
                company_job.company_name = company.name
                company_job.company_name_converted = convert_vie_to_eng(company_job.company_name)
            end

            if company_job.level
                company_job.level_converted = convert_vie_to_eng(company_job.level)
            end

            if company_job.typical
                company_job.typical_converted = convert_vie_to_eng(company_job.typical)
            end

            if company_job.skill
                data_temp = ''
                company_job.skill.each do |skill|
                    data_temp += convert_vie_to_eng(skill)
                end
                company_job.skill_converted = data_temp
            end

            if company_job.experience
                company_job.experience_converted = convert_vie_to_eng(company_job.experience)
            end
            return company_job
        else
            return nil
        end
    end
end
