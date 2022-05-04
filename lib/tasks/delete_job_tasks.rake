require "#{Rails.root}/app/helpers/company_jobs_helper"
include CompanyJobsHelper
namespace :delete_job_tasks do
    desc "Delete expire job"
    task job_delete: :environment do
        puts "Start delete old job"
        DeletingJob.perform_later
        puts "End delete old job"
    end
end
