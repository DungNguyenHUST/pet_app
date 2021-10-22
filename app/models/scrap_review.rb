class ScrapReview < ApplicationRecord
    def self.approved
        where(approved: :true)
    end
end
