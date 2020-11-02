class CompanyApplyJob < ApplicationRecord
    belongs_to :company_jobs, optional: true
    has_rich_text :cover_letter_rich
end
