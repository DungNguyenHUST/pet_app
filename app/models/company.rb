class Company < ApplicationRecord
    has_many :company_reviews, dependent: :destroy
    has_many :company_interviews, dependent: :destroy
end
