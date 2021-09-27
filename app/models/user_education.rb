class UserEducation < ApplicationRecord
    belongs_to :user

    def self.search(search)
        if search
            search_result = UserEducation.where("school_name ILIKE? OR cert_type ILIKE?", 
                                            "%#{search}%",
                                            "%#{search}%")

            if(search_result)
                self.where(id: search_result)
            end
        end
    end
end
