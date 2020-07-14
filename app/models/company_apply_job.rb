class CompanyApplyJob < ApplicationRecord
    belongs_to :company_jobs, optional: true
end
