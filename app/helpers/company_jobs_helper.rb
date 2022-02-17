module CompanyJobsHelper
    def convert_salary_to_min(salary)
        if salary
            salary_min = salary.scan(/\d+/).map(&:to_i)
            salary_min = salary_min.reject{|i| i <= 0}
            if salary_min.size > 0
                if salary_min.first >= 1000
                    return salary_min.first
                else
                    return salary_min.first * 1000000
                end
            else
                return 0
            end
        else
            return 0
        end
    end

    def convert_salary_to_max(salary)
        if salary
            salary_max = salary.scan(/\d+/).map(&:to_i)
            salary_max = salary_max.reject{|i| i <= 0}
            if salary_max.size > 1
                if salary_max.last >= 1000
                    return salary_max.last
                else
                    return salary_max.last * 1000000
                end
            else
                return 0
            end
        else
            return 0
        end
    end

    def find_company_of_job(company_job)
        company = nil
        if company_job.present?
            company = Company.find_by_id(company_job.company_id)
        end
        return company
    end

    def verified_job(company_job)
        verified = false
        if company_job.present?
            if find_company_of_job(company_job) && company_job.employer_id.present?
                verified = true
            end
        end

        return verified
    end

    def find_job_location(address)
        location_array = ['Hà Nội','TP Hồ Chí Minh','Hồ Chí Minh','HCM','Sài Gòn','Đà Nẵng','An Giang','Bà Rịa Vũng Tàu','Bạc Liêu','Bắc Kạn','Bắc Giang',
                        'Bắc Ninh','Bến Tre','Bình Dương','Bình Định','Bình Phước',
                        'Bình Thuận','Cà Mau','Cao Bằng','Cần Thơ','Đắk Lắk','Đắc Lắc','Đắk Nông','Đắc Nông','Điện Biên',
                        'Đồng Nai','Đồng Tháp','Gia Lai','Hà Giang','Hà Nam','Hà Tây','Hà Tĩnh',
                        'Hải Dương','Hải Phòng','Hòa Bình','Hậu Giang','Hưng Yên','Khánh Hòa',
                        'Kiên Giang','Kon Tum','Lai Châu','Lào Cai',
                        'Lạng Sơn','Lâm Đồng','Long An','Nam Định','Nghệ An',
                        'Ninh Bình','Ninh Thuận','Phú Thọ','Phú Yên','Quảng Bình',
                        'Quảng Nam','Quảng Ngãi','Quảng Ninh','Quảng Trị',
                        'Sóc Trăng','Sơn La','Tây Ninh','Thái Bình','Thái Nguyên' ,
                        'Thanh Hóa','Thừa Thiên Huế','Tiền Giang','Trà Vinh',
                        'Tuyên Quang','Vĩnh Long','Vĩnh Phúc','Yên Bái' ]

        location = location_array.find {|h| convert_vie_to_eng(address).include?(convert_vie_to_eng(h)) }

        if location
            return location
        else
            return address
        end
    end

    def find_employer_of_job(company_job)
        if company_job.present?
            employer = Employer.find_by_id(company_job.employer_id)
            return employer
        end
    end

    def promote_ads_job(search_results)
        if search_results
            # Show 3 ads job first and order search result by created date
            search_results = search_results.reorder('created_at DESC').expire
            @sponsor_jobs = search_results.where(:sponsor => 1).first(3) # get 3 job with ads
            if @sponsor_jobs
                @sponsor_jobs.each do |sponsor_job| # remove ads job in current list
                    search_results = search_results.where.not(:id => sponsor_job.id)
                end
                search_results = @sponsor_jobs + search_results # put 3 ads job in begin of array
            end
        end
    end
end
