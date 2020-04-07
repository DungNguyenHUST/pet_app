class CompanyInterview < ApplicationRecord
    belongs_to :company, optional: true
end
