module CompaniesHelper
    def cal_rating_review_total_score(company)
        total_rate_score = 0
        work_env_score = 0
        salary_score = 0
        ot_score = 0
        manager_score = 0
        career_score = 0
        average_score = 0
        count = 0

        company.company_reviews.each do |company_review|
            count += 1
            if company_review.score.present?
                total_rate_score += company_review.score
            else
                if company_review.work_env_score.present?
                    work_env_score = company_review.work_env_score
                end

                if company_review.salary_score.present?
                    salary_score = company_review.salary_score
                end

                if company_review.ot_score.present?
                    ot_score = company_review.ot_score
                end

                if company_review.manager_score.present?
                    manager_score = company_review.manager_score
                end

                if company_review.career_score.present?
                    career_score = company_review.career_score
                end

                average_score = ((work_env_score + salary_score + ot_score + manager_score + career_score) / 5).to_f.round(1)
                total_rate_score += average_score
            end
        end

        if (count > 0)
            total_rate_score = (total_rate_score / count).to_f.round(1)
        else
            total_rate_score = 0
        end

        return total_rate_score
    end

    def cal_rating_review_score(company_review)
        work_env_score = 0
        salary_score = 0
        ot_score = 0
        manager_score = 0
        career_score = 0
        average_score = 0

        if company_review.score.present?
            average_score += company_review.score
        else
            if company_review.work_env_score.present?
                work_env_score = company_review.work_env_score
            end

            if company_review.salary_score.present?
                salary_score = company_review.salary_score
            end

            if company_review.ot_score.present?
                ot_score = company_review.ot_score
            end

            if company_review.manager_score.present?
                manager_score = company_review.manager_score
            end

            if company_review.career_score.present?
                career_score = company_review.career_score
            end

            average_score = ((work_env_score + salary_score + ot_score + manager_score + career_score) / 5).to_f.round(1)
        end

        return average_score
    end

    def cal_rating_interview_total_score(company)
        total_rate = 0
        if(company.company_interviews.count > 0)
            rate_difficultly = company.company_interviews.sum('difficultly').to_f / company.company_interviews.count
            rate_satisfied = company.company_interviews.sum('satisfied').to_f / company.company_interviews.count

            total_rate = (rate_difficultly + rate_satisfied)/2
        else
            total_rate = 0
        end

        return total_rate
    end

    def cal_rating_review_work_env_score(company)
        rate_work_env = 0
        if(company.company_reviews.count > 0)
            rate_work_env = company.company_reviews.sum('work_env_score').to_f / company.company_reviews.count
        else
            rate_work_env = 0
        end

        return rate_work_env
    end

    def cal_rating_review_salary_score(company)
        rate_salary = 0
        if(company.company_reviews.count > 0)
            rate_salary = company.company_reviews.sum('salary_score').to_f / company.company_reviews.count
        else
            rate_salary = 0
        end

        return rate_salary
    end

    def cal_rating_review_ot_score(company)
        rate_ot = 0
        if(company.company_reviews.count > 0)
            rate_ot = company.company_reviews.sum('ot_score').to_f / company.company_reviews.count
        else
            rate_ot = 0
        end

        return rate_ot
    end

    def cal_rating_review_manager_score(company)
        rate_manager = 0
        if(company.company_reviews.count > 0)
            rate_manager = company.company_reviews.sum('manager_score').to_f / company.company_reviews.count
        else
            rate_manager = 0
        end

        return rate_manager
    end

    def cal_rating_review_career_score(company)
        rate_career = 0
        if(company.company_reviews.count > 0)
            rate_career = company.company_reviews.sum('career_score').to_f / company.company_reviews.count
        else
            rate_career = 0
        end

        return rate_career
    end

    def cal_rating_interview_difficultly_score(company)
        rate_difficultly = 0
        if(company.company_interviews.count > 0)
            rate_difficultly = company.company_interviews.sum('difficultly').to_f / company.company_interviews.count
        else
            rate_difficultly = 0
        end

        return rate_difficultly
    end

    def cal_rating_interview_satisfied_score(company)
        rate_satisfied = 0
        if(company.company_interviews.count > 0)
            rate_satisfied = company.company_interviews.sum('satisfied').to_f / company.company_interviews.count
        else
            rate_satisfied = 0
        end

        return rate_satisfied
    end

    def cal_rating_interview_process_score(company)
        rate_process = 0
        if(company.company_interviews.count > 0)
            rate_process = company.company_interviews.sum('process').to_f / company.company_interviews.count
        else
            rate_process = 0
        end

        return rate_process
    end

    def cal_rating_interview_offer_score(company)
        rate_offer = 0
        offer_count = CompanyInterview.where(offer: true).count
        if(company.company_interviews.count > 0)
            rate_offer = (offer_count / company.company_interviews.count)
        else
            rate_offer = 0
        end

        return rate_offer
    end

    def find_top_company
    end

    def convert_benefit_to_string(benefit)
        benefit_string = ""
        case benefit.to_i
        when 0
            benefit_string = "Lương thưởng hấp dẫn"
        when 1
            benefit_string = "Bảo hiểm cho nhân viên"
        when 2
            benefit_string = "Bảo hiểm cho người thân"
        when 3
            benefit_string = "Team building"
        when 4
            benefit_string = "Nghỉ phép"
        when 5
            benefit_string = "Kiểm tra sức khỏe"
        when 6
            benefit_string = "Review lương hàng năm"
        when 7
            benefit_string = "Môi trường quốc tế"
        when 8
            benefit_string = "Flexible time"
        when 9
            benefit_string = "Nghỉ hè"
        when 10
            benefit_string = "Onsite nước ngoài"
        when 11
            benefit_string = "Thử việc 100% lương"
        when 12
            benefit_string = "Hỗ trợ gửi xe, ăn trưa"
        when 13
            benefit_string = "CLB thể thao"
        when 14
            benefit_string = "Câu lạc bộ âm nhạc"
        when 15
            benefit_string = "Laptop, màn hình xịn"
        else
            benefit_string = "Đang cập nhật"
        end
    end

    def convert_benefit_to_icon(benefit)
        benefit_icon = ""
        case benefit.to_i
        when 0
            benefit_icon = "paid"
        when 1
            benefit_icon = "settings_accessibility"
        when 2
            benefit_icon = "people_alt"
        when 3
            benefit_icon = "villa"
        when 4
            benefit_icon = "night_shelter"
        when 5
            benefit_icon = "health_and_safety"
        when 6
            benefit_icon = "history_edu"
        when 7
            benefit_icon = "emoji_flags"
        when 8
            benefit_icon = "tune"
        when 9
            benefit_icon = "beach_access"
        when 10
            benefit_icon = "airplane_ticket"
        when 11
            benefit_icon = "paid"
        when 12
            benefit_icon = "paid"
        when 13
            benefit_icon = "sports_soccer"
        when 14
            benefit_icon = "headphones"
        when 15
            benefit_icon = "laptop"
        else
            benefit_icon = "scatter_plot"
        end
    end
end
