class CompanyApplyJob < ApplicationRecord
    belongs_to :company_jobs, optional: true
    has_one_attached :cover_vitate
    validates :cover_letter_rich_text, presence: true
    has_rich_text :cover_letter_rich_text
end
