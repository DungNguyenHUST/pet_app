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

    def auth_used_cost_of_employer(employer)
        auth = false
        used_cost = 0
        if employer
            if employer.use_cost_seq.to_i == 0
                @employer_costs = employer.employer_costs.where("created_at >= ?", 1.day.ago.utc)
            elsif employer.use_cost_seq.to_i == 1
                @employer_costs = employer.employer_costs.where("created_at >= ?", 30.day.ago.utc)
            end
            
            if @employer_costs
                @employer_costs.each do |employer_cost|
                    used_cost += employer_cost.cost.to_i
                end
            end
            
            if used_cost <= employer.limit_cost && employer.remain_cost > 0
                auth = true
            end
        end
        return auth
    end

    def cal_used_cost_daily_of_employer(employer)
        used_cost = 0
        if employer
            @employer_cost_lists = employer.employer_costs.where("created_at >= ?", 1.day.ago.utc)
            
            if @employer_cost_lists
                @employer_cost_lists.each do |employer_cost|
                    used_cost += employer_cost.cost.to_i
                end
            end
        end
        return used_cost
    end
end
