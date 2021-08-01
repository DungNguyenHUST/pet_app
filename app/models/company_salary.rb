class CompanySalary < ApplicationRecord
    belongs_to :company, optional: true
end
