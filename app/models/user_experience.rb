class UserExperience < ApplicationRecord
    belongs_to :user

    def self.search(search)
        if search
            search_result = UserExperience.where("job_level ILIKE?", 
                                            "%#{search}%")

            if(search_result)
                self.where(id: search_result)
            end
        end
    end
end
