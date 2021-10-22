class ScrapJob < ApplicationRecord
    def self.approved
        where(approved: :true)
    end
end
