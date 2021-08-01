class CompanyApplyJob < ApplicationRecord
    belongs_to :company_jobs, optional: true
    # has_one_attached :cover_vitate
    mount_uploader :cover_vitate, FileUploader

    # validates :cover_letter, presence: true
end
