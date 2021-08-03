module EmployersHelper
    def find_owner_company_for_employer(company_id)
        @owner_company = nil
        if company_id.present?
            @owner_company = Company.find_by_id(company_id)
        end
        return @owner_company
    end
end
