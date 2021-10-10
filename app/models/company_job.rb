class CompanyJob < ApplicationRecord
	extend FriendlyId
	friendly_id :title_converted, use: :slugged
    
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    # validates :description, presence: true
    # validates :requirement, presence: true
    # validates :benefit, presence: true

    def self.search(search, location)
        if search
            job_search = CompanyJob.where("title_converted ILIKE? OR company_name_converted ILIKE? OR skill_converted ILIKE? OR category_converted ILIKE?", 
                                        "%#{search}%", 
                                        "%#{search}%",
                                        "%#{search}%",
                                        "%#{search}%")
            if job_search && location
                job_search = job_search.where("location_converted ILIKE?",
                                            "%#{location}%")
            end

            if(job_search)
                self.where(id: job_search)
            end
        end
    end

    def self.filtered(filter_params)
        if filter_params.search
            job_filter = CompanyJob.search(filter_params.search, filter_params.location)
        end

        unless filter_params.category.nil?
            job_filter = job_filter.where("category_converted ILIKE?", "%#{filter_params.category}%")
        end

        unless filter_params.salary_min.nil?
            job_filter = job_filter.where("salary_min >= ?", filter_params.salary_min.to_i)
        end

        unless filter_params.salary_max.nil?
            job_filter = job_filter.where("salary_max <= ?", filter_params.salary_max.to_i)
        end

        unless filter_params.typical.nil?
            job_filter = job_filter.where("typical_converted ILIKE?", "%#{filter_params.typical}%")
        end

        unless filter_params.level.nil?
            job_filter = job_filter.where("level_converted ILIKE?", "%#{filter_params.level}%")
        end

        unless filter_params.post_date.nil?
            job_filter = job_filter.where("created_at >= ?", filter_params.post_date.day.ago.utc)
        end

        if(job_filter)
            self.where(id: job_filter)
        end
    end
	
	def self.approved
	    where(approved: :true)
	end

    def self.expire
        where("end_date >= ?", Time.now).approved
    end
end
