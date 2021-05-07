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
