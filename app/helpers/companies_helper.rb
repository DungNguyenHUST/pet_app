module CompaniesHelper
    def rating_total_score
        if(@company.company_reviews.count > 0)
            rate_work_env = @company.company_reviews.sum('work_env_score').to_f / @company.company_reviews.count
            rate_salary = @company.company_reviews.sum('salary_score').to_f / @company.company_reviews.count
            rate_ot = @company.company_reviews.sum('ot_score').to_f / @company.company_reviews.count
            rate_manager = @company.company_reviews.sum('manager_score').to_f / @company.company_reviews.count
            rate_career = @company.company_reviews.sum('career_score').to_f / @company.company_reviews.count

            total_rate = (rate_work_env + rate_salary + rate_ot + rate_manager + rate_career)/5
        else
            total_rate = 0
        end
    end

    def rating_work_env_score
        if(@company.company_reviews.count > 0)
            rate_work_env = @company.company_reviews.sum('work_env_score').to_f / @company.company_reviews.count
        else
            rate_work_env = 0
        end
    end

    def rating_salary_score
        if(@company.company_reviews.count > 0)
            rate_salary = @company.company_reviews.sum('salary_score').to_f / @company.company_reviews.count
        else
            rate_salary = 0
        end
    end

    def rating_ot_score
        if(@company.company_reviews.count > 0)
            rate_ot = @company.company_reviews.sum('ot_score').to_f / @company.company_reviews.count
        else
            rate_ot = 0
        end
    end

    def rating_manager_score
        if(@company.company_reviews.count > 0)
            rate_manager = @company.company_reviews.sum('manager_score').to_f / @company.company_reviews.count
        else
            rate_manager = 0
        end
    end

    def rating_career_score
        if(@company.company_reviews.count > 0)
            rate_career = @company.company_reviews.sum('career_score').to_f / @company.company_reviews.count
        else
            rate_career = 0
        end
    end
end
