class UserCertificate < ApplicationRecord
    belongs_to :user

    def self.search(search)
        if search
            search_result = UserCertificate.where("cert_name ILIKE?", 
                                            "%#{search}%")

            if(search_result)
                self.where(id: search_result)
            end
        end
    end
end
