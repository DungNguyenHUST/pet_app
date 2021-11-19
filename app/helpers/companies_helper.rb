module CompaniesHelper
    # For review
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

                average_score = ((work_env_score + salary_score + ot_score + manager_score + career_score) / 5).to_f
                total_rate_score += average_score
            end
        end

        if (count > 0)
            total_rate_score = (total_rate_score / count).to_f
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

            average_score = ((work_env_score + salary_score + ot_score + manager_score + career_score) / 5).to_f
        end

        return average_score
    end

    def cal_rating_review_work_env_score(company)
        rate_work_env = 0
        count = 0
        company.company_reviews.each do |company_review|
            if company_review.work_env_score.to_i > 0
                count += 1
                rate_work_env += company_review.work_env_score
            end
        end
        
        if count > 0
            rate_work_env = (rate_work_env/count).to_f
        end

        return rate_work_env
    end

    def cal_rating_review_salary_score(company)
        rate_salary = 0
        count = 0
        company.company_reviews.each do |company_review|
            if company_review.salary_score.to_f > 0
                count += 1
                rate_salary += company_review.salary_score
            end
        end
        
        if count > 0
            rate_salary = (rate_salary/count).to_f
        end

        return rate_salary
    end

    def cal_rating_review_ot_score(company)
        rate_ot = 0
        count = 0
        company.company_reviews.each do |company_review|
            if company_review.ot_score.to_f > 0
                count += 1
                rate_ot += company_review.ot_score
            end
        end
        
        if count > 0
            rate_ot = (rate_ot/count).to_f
        end

        return rate_ot
    end

    def cal_rating_review_manager_score(company)
        rate_manager = 0
        count = 0
        company.company_reviews.each do |company_review|
            if company_review.manager_score.to_f > 0
                count += 1
                rate_manager += company_review.manager_score
            end
        end
        
        if count > 0
            rate_manager = (rate_manager/count).to_f
        end

        return rate_manager
    end

    def cal_rating_review_career_score(company)
        rate_career = 0
        count = 0
        company.company_reviews.each do |company_review|
            if company_review.career_score.to_f > 0
                count += 1
                rate_career += company_review.career_score
            end
        end
        
        if count > 0
            rate_career = (rate_career/count).to_f
        end

        return rate_career
    end

    def cal_rating_review_recommend(company)
        recommend = 0
        count = 0
        
        company.company_reviews.each do |company_review|
            if company_review.recommend == true
                count += 1
            end
        end
        
        if count > 0
            recommend = ((count  * 100)/company.company_reviews.count).to_i
        end

        return recommend
    end

    def count_rating_category(category, company)
        count = 0
        if category == "work_env_score"
            count = company.company_reviews.where.not(work_env_score: 0).count
        elsif category == "salary_score"
            count = company.company_reviews.where.not(salary_score: 0).count
        elsif category == "ot_score"
            count = company.company_reviews.where.not(ot_score: 0).count
        elsif category == "manager_score"
            count = company.company_reviews.where.not(manager_score: 0).count
        elsif category == "career_score"
            count = company.company_reviews.where.not(career_score: 0).count
        elsif category == "overall"
            count = company.company_reviews.where.not(score: 0).count
        end

        return count
    end

    def cal_rating_category_percent(company, category, star)
        average = 0
        count = count_rating_category(category, company)

        if count > 0
            if category == "work_env_score"
                average = company.company_reviews.where(work_env_score: star).count.to_i * 100 / count
            elsif category == "salary_score"
                average = company.company_reviews.where(salary_score: star).count.to_i * 100 / count
            elsif category == "ot_score"
                average = company.company_reviews.where(ot_score: star).count.to_i * 100 / count
            elsif category == "manager_score"
                average = company.company_reviews.where(manager_score: star).count.to_i * 100 / count
            elsif category == "career_score"
                average = company.company_reviews.where(career_score: star).count.to_i * 100 / count
            elsif category == "overall"
                average = company.company_reviews.where(score: star).count.to_i * 100 / count
            end
        end

        return average
    end

    # For interview
    def cal_rating_interview_total_score(company)
        total_rate = 0
        total_rate = (cal_rating_interview_difficultly_score(company) + cal_rating_interview_satisfied_score(company))/2
        return total_rate
    end

    def cal_rating_interview_difficultly_score(company)
        rate_difficultly = 0
        count = 0
        company.company_interviews.each do |company_interview|
            if company_interview.difficultly.to_f > 0
                count += 1
                rate_difficultly += company_interview.difficultly
            end
        end
        
        if count > 0
            rate_difficultly = (rate_difficultly/count).to_f
        end

        return rate_difficultly
    end

    def cal_rating_interview_satisfied_score(company)
        rate_satisfied = 0
        count = 0
        company.company_interviews.each do |company_interview|
            if company_interview.satisfied.to_f > 0
                count += 1
                rate_satisfied += company_interview.satisfied
            end
        end
        
        if count > 0
            rate_satisfied = (rate_satisfied/count).to_f
        end

        return rate_satisfied
    end

    def cal_rating_interview_process_score(company)
        rate_process = 0
        count = 0
        company.company_interviews.each do |company_interview|
            if company_interview.process.to_f > 0
                count += 1
                rate_process += company_interview.process
            end
        end
        
        if count > 0
            rate_process = (rate_process/count).to_i
        end

        return rate_process
    end

    def cal_rating_interview_offer_score(company)
        rate_offer = 0
        count = 0
        
        company.company_interviews.each do |company_interview|
            if company_interview.offer == true
                count += 1
            end
        end
        
        if count > 0
            rate_offer = ((count  * 100)/company.company_interviews.count).to_i
        end

        return rate_offer
    end

    def find_top_company
    end

    def convert_benefit_to_string(benefit)
        benefit_string = ""
        case benefit.to_i
        when 0
            benefit_string = t(:benefit_1)
        when 1
            benefit_string = t(:benefit_2)
        when 2
            benefit_string = t(:benefit_3)
        when 3
            benefit_string = t(:benefit_4)
        when 4
            benefit_string = t(:benefit_5)
        when 5
            benefit_string = t(:benefit_6)
        when 6
            benefit_string = t(:benefit_7)
        when 7
            benefit_string = t(:benefit_8)
        when 8
            benefit_string = t(:benefit_9)
        when 9
            benefit_string = t(:benefit_10)
        when 10
            benefit_string = t(:benefit_11)
        when 11
            benefit_string = t(:benefit_12)
        when 12
            benefit_string = t(:benefit_13)
        when 13
            benefit_string = t(:benefit_14)
        when 14
            benefit_string = t(:benefit_15)
        when 15
            benefit_string = t(:benefit_16)
        when 16
            benefit_string = t(:benefit_17)
        when 17
            benefit_string = t(:benefit_18)
        else
            benefit_string = t(:benefit_19)
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
        when 16
            benefit_icon = "school"
        when 17
            benefit_icon = "child_care"
        else
            benefit_icon = "scatter_plot"
        end
    end

    # for salary
    def cal_intern_salary_by_type(company, locate_type, level_type)
        count = 0
        average = 0
        buffer = 0
        company.company_salaries.each do |company_salary|
            if company_salary.locate.to_i == locate_type
                if company_salary.level.to_i == level_type
                    count += 1
                    buffer = company_salary.salary + company_salary.salary_bonus
                    if company_salary.salary_currency.to_s == "USD"
                        average += (company_salary.salary + company_salary.salary_bonus) * 23
                    else
                        average += company_salary.salary + company_salary.salary_bonus
                    end
                end
            end
        end

        if count > 0
            average = average /count
        end

        if average > 0
            return number_with_delimiter(average, delimiter: ".")
        else
            return "---"
        end
    end

    def count_salary_category(company, locate_type, level_type)
        count = 0
        count = company.company_salaries.where(level: level_type, locate: locate_type).count
        return convert_number_to_human(count)
    end

    def find_job_of_company(company)
        if company.present?
            company_job = CompanyJob.where(:company_id => company.id).expire
        end
    end
end
