class CompanyJob < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy

    has_rich_text :content_rich
    has_rich_text :description_rich
    has_rich_text :requirement_rich
    has_rich_text :benefit_rich

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
