class CompanyApplyJob < ApplicationRecord
    belongs_to :company_jobs, optional: true
    has_one_attached :cover_vitate
end
