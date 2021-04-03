class CompanyJob < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged
	
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy
    has_many :company_save_jobs, dependent: :destroy

    validates :description, presence: true
    validates :requirement, presence: true
    validates :benefit, presence: true

    def self.search(search)
        if search
            job_type = CompanyJob.where("title ILIKE? OR location ILIKE?", "%#{search}%", "%#{search}%")
            if(job_type)
                self.where(id: job_type)
            else
                @company_jobs = CompanyJob.all
            end
        else
            @company_jobs = CompanyJob.all
        end
    end
	
	def self.approved
	  where(approved: :true)
	end

end
