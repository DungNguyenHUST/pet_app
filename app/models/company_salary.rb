class CompanySalary < ApplicationRecord
    extend FriendlyId
	friendly_id :salary_job, use: :slugged
    belongs_to :company, optional: true
end
