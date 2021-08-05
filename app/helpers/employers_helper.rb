module EmployersHelper
    def find_owner_company_for_employer(employer)
        @owner_company = nil
        if employer.present?
            @owner_company = Company.all.find{ |company| company.employer_id == employer.id}
        end
        return @owner_company
    end
end
