class CompanyApplyJob < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: :slugged
	
    belongs_to :company_jobs, optional: true
    # has_one_attached :cover_vitate
    mount_uploader :cover_vitate, FileUploader

    validates :cover_letter_rich_text, presence: true
    has_rich_text :cover_letter_rich_text
end
