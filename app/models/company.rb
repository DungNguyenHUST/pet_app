class Company < ApplicationRecord
    has_many :company_reviews, dependent: :destroy
end
