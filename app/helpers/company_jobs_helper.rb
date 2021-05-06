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
        	salary_string = "Thương lượng"
        end
    end
end
