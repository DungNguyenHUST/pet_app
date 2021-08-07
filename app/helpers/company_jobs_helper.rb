module CompanyJobsHelper
	def convert_salary_to_string(company_job)
		salary_string = ""
        case company_job.salary.to_i
        when 0
        	salary_string = "Thương lượng"
        when 1
        	salary_string = "1000000đ-5000000đ"
        when 2
        	salary_string = "5000000đ-10000000đ"
        when 3
        	salary_string = "10000000đ-15000000đ"
        when 4
        	salary_string = "15000000đ-200000000đ"
        when 5
        	salary_string = "20000000đ-25000000đ"
        when 6
        	salary_string = "25000000đ-30000000đ"
        when 7
        	salary_string = "30000000đ-35000000đ"
        when 8
        	salary_string = "35000000đ-40000000đ"
        when 9
        	salary_string = "40000000đ-50000000đ"
        when 10
        	salary_string = "50000000đ-60000000đ"
        when 11
        	salary_string = "60000000đ-70000000đ"
        when 12
        	salary_string = "70000000đ-80000000đ"
        when 13
        	salary_string = "80000000đ-90000000đ"
        when 14
        	salary_string = "90000000đ-100000000đ"
        when 15
        	salary_string = ">100000000đ"
        else
        	salary_string = company_job.salary.to_s
        end

        return salary_string
    end

    def convert_salary_to_min(company_job)
		min = 0
        case company_job.salary.to_i
        when 0
        	min = 0
        when 1
        	min = 1000000
        when 2
        	min = 5000000
        when 3
        	min = 10000000
        when 4
        	min = 15000000
        when 5
        	min = 20000000
        when 6
        	min = 25000000
        when 7
        	min = 30000000
        when 8
        	min = 35000000
        when 9
        	min = 40000000
        when 10
        	min = 50000000
        when 11
        	min = 60000000
        when 12
        	min = 70000000
        when 13
        	min = 80000000
        when 14
        	min = 90000000
        when 15
        	min = 100000000
        else
        	min = 0
        end

        return min
    end

    def convert_salary_to_max(company_job)
		max = 0
        case company_job.salary.to_i
        when 0
        	max = 0
        when 1
        	max = 5000000
        when 2
        	max = 10000000
        when 3
        	max = 15000000
        when 4
        	max = 20000000
        when 5
        	max = 25000000
        when 6
        	max = 30000000
        when 7
        	max = 35000000
        when 8
        	max = 40000000
        when 9
        	max = 50000000
        when 10
        	max = 60000000
        when 11
        	max = 70000000
        when 12
        	max = 80000000
        when 13
        	max = 90000000
        when 14
        	max = 100000000
        when 15
        	max = 0
        else
        	max = 0
        end
        
        return max
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
