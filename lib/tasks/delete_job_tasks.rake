require "#{Rails.root}/app/helpers/company_jobs_helper"
include CompanyJobsHelper
namespace :delete_job_tasks do
    desc "Delete expire job"
    task job_delete: :environment do
        puts "Start delete old job"
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
        puts "End delete old job"
    end
end
