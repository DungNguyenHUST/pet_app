class CompanyApplyJob < ApplicationRecord
    extend FriendlyId
    def convert_slug
        slug = name.downcase.to_s
        slug.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
        slug.gsub! /[đ]/, "d"
        slug.gsub! /[èéẹẽẻêềếệễể]/, "e"
        slug.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
        slug.gsub! /[úùụũủưứựừữử]/, "u"
        slug.gsub! /[íịìĩỉ]/, "i"
        slug.gsub! /[ýỵỹỳỷ]/, "y"
        return slug
    end
	friendly_id :convert_slug, use: :slugged
	
    belongs_to :company_jobs, optional: true
    # has_one_attached :cover_vitate
    mount_uploader :cover_vitate, FileUploader

    # validates :cover_letter, presence: true
end
