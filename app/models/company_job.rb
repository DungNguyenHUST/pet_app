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
    def search_data
        {
            title: title,
            company_name: company_name,
            category: category,
            skill: skill,
            location: location,
            address: address,
            level: level,
            typical: typical,
            salary_min: salary_min,
            salary_max: salary_max,
            salary: salary,
            company_id: company_id,
            end_date: end_date,
            dudate: dudate,
            approved: approved,
            sponsor: sponsor,
            urgent: urgent,
            created_at: created_at,
            updated_at: updated_at
        }
    end
    
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
