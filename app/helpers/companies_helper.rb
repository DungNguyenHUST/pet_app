module CompaniesHelper
    def rating_review_total_score
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

    def rating_interview_total_score
        if(@company.company_interviews.count > 0)
            rate_difficultly = @company.company_interviews.sum('difficultly').to_f / @company.company_interviews.count
            rate_satisfied = @company.company_interviews.sum('satisfied').to_f / @company.company_interviews.count

            total_rate = (rate_difficultly + rate_satisfied)/2
        else
            total_rate = 0
        end
    end

    def rating_review_work_env_score
        if(@company.company_reviews.count > 0)
            rate_work_env = @company.company_reviews.sum('work_env_score').to_f / @company.company_reviews.count
        else
            rate_work_env = 0
        end
    end

    def rating_review_salary_score
        if(@company.company_reviews.count > 0)
            rate_salary = @company.company_reviews.sum('salary_score').to_f / @company.company_reviews.count
        else
            rate_salary = 0
        end
    end

    def rating_review_ot_score
        if(@company.company_reviews.count > 0)
            rate_ot = @company.company_reviews.sum('ot_score').to_f / @company.company_reviews.count
        else
            rate_ot = 0
        end
    end

    def rating_review_manager_score
        if(@company.company_reviews.count > 0)
            rate_manager = @company.company_reviews.sum('manager_score').to_f / @company.company_reviews.count
        else
            rate_manager = 0
        end
    end

    def rating_review_career_score
        if(@company.company_reviews.count > 0)
            rate_career = @company.company_reviews.sum('career_score').to_f / @company.company_reviews.count
        else
            rate_career = 0
        end
    end

    def rating_interview_difficultly_score
        if(@company.company_interviews.count > 0)
            rate_difficultly = @company.company_interviews.sum('difficultly').to_f / @company.company_interviews.count
        else
            rate_difficultly = 0
        end
    end

    def rating_interview_satisfied_score
        if(@company.company_interviews.count > 0)
            rate_satisfied = @company.company_interviews.sum('satisfied').to_f / @company.company_interviews.count
        else
            rate_satisfied = 0
        end
    end

    def rating_interview_process_score
        if(@company.company_interviews.count > 0)
            rate_process = @company.company_interviews.sum('process').to_f / @company.company_interviews.count
        else
            rate_process = 0
        end
    end

    def rating_interview_offer_score
        rate_offer = 0
        offer_count = CompanyInterview.where(offer: true).count
        if(@company.company_interviews.count > 0)
            rate_offer = (offer_count / @company.company_interviews.count)
        else
            rate_offer = 0
        end
    end

    def find_top_company
    end

end
