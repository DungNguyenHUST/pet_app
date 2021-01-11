class CompanyJob < ApplicationRecord
    belongs_to :company, optional: true
    has_many :company_apply_jobs, dependent: :destroy

    validates :description_rich_text, presence: true
    validates :requirement_rich_text, presence: true
    validates :benefit_rich_text, presence: true
    has_rich_text :benefit_rich_text
    has_rich_text :description_rich_text
    has_rich_text :requirement_rich_text

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
