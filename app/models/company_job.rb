class CompanyJob < ApplicationRecord
	extend FriendlyId
	friendly_id :title_converted, use: :slugged
	
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    # validates :description, presence: true
    # validates :requirement, presence: true
    # validates :benefit, presence: true

    def self.search(search)
        if search
            job_search = CompanyJob.where("title_converted ILIKE?", "%#{search}%")
            if(job_search)
                self.where(id: job_search)
            end
        end
    end
	
	def self.search_advance(search, location)
        if search && location
            job_search = CompanyJob.where("title_converted ILIKE? AND location_converted ILIKE?", "%#{search}%", "%#{location}%")
            if(job_search)
                self.where(id: job_search)
            end
        end
    end

    def self.filtered(filter_params)
        if filter_params.search
            job_filter = CompanyJob.where("title ILIKE?", "%#{filter_params.search}%")
        end

        if filter_params.location && filter_params.location != "Tất cả địa điểm"
            job_filter = job_filter.where("location ILIKE?", "%#{filter_params.location}%")
        end

        if filter_params.category
            job_filter = job_filter.where("category ILIKE?", "%#{filter_params.category}%")
        end

        if filter_params.salary
            job_filter = job_filter.where("salary ILIKE?", "%#{filter_params.salary}%")
        end

        if filter_params.job_type
            job_filter = job_filter.where("job_type ILIKE?", "%#{filter_params.job_type}%")
        end

        if filter_params.level
            job_filter = job_filter.where("level ILIKE?", "%#{filter_params.level}%")
        end

        if(job_filter)
            self.where(id: job_filter)
        end
    end
	
	def self.approved
	  where(approved: :true)
	end
end
