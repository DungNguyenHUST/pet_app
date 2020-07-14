class CompanyJob < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy
end
