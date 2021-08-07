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
        return salary_max.last * 1000000
    end

    def convert_skill_to_string(skill)
        skill_string = ""
        case skill.to_i
        when 0
            skill_string = "C,C++"
        when 1
            skill_string = "Java"
        when 2
            skill_string = "PHP"
        when 3
            skill_string = "Python"
        when 4
            skill_string = "C#"
        when 5
            skill_string = "Ruby"
        when 6
            skill_string = "Assembly"
        when 7
            skill_string = "Java script"
        when 8
            skill_string = "SQL Database"
        when 9
            skill_string = "Postgres Database"
        when 10
            skill_string = "Embedded"
        when 11
            skill_string = "Machine learning"
        when 12
            skill_string = "Sales"
        when 13
            skill_string = "Marketing"
        when 14
            skill_string = "Head hunter"
        when 15
            skill_string = "Bussiness Management"
        when 16
            skill_string = "Project Management"
        when 17
            skill_string = "Architecture Design"
        when 18
            skill_string = "Front End"
        when 19
            skill_string = "Back End"
        when 20
            skill_string = "Dev Ops"
        when 21
            skill_string = "Android"
        when 22
            skill_string = "iOS"
        when 23
            skill_string = "Hardware"
        when 24
            skill_string = "AI"
        else
            skill_string = "Đang cập nhật"
        end
        
        return skill_string
    end
end
