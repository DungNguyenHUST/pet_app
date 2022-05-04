class DeletingJob < ApplicationJob
    @queue = :file_serve
	
    def perform(*args)
		CompanyJob.all.each do |company_job|
            unless find_employer_of_job(company_job)
                if company_job 
                    if company_job.end_date
                        if company_job.end_date < Time.now
                            company_job.delete
                        end
                    else
                        company_job.delete
                    end
                end
            end
        end
	end
end
