class CompanyJob < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy

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

end
