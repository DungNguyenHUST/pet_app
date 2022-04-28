class CompanyJob < ApplicationRecord
	extend FriendlyId
	def convert_slug
        slug = title.downcase.to_s
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
    
    # For Search
    searchkick
    
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    def self.approving
	    where(approved: :false)
	end
	
	def self.approved
	    where(approved: :true)
	end

    def self.expire
        where("end_date >= ?", Time.now).approved
    end
end
