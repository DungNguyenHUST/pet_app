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
	
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    # validates :description, presence: true
    # validates :requirement, presence: true
    # validates :benefit, presence: true

    def self.search(search)
        if search
            job_search = CompanyJob.where("title ILIKE? OR location ILIKE?", "%#{search}%", "%#{search}%")
            if(job_search)
                self.where(id: job_search)
            end
        end
    end
	
	def self.search_advance(search, location)
        if search && location
            job_search = CompanyJob.where("title ILIKE? AND location ILIKE?", "%#{search}%", "%#{location}%")
            if(job_search)
                self.where(id: job_search)
            end
        end
    end
	
	def self.approved
	  where(approved: :true)
	end
end
