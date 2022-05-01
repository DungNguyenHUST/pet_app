namespace :index_job_tasks do
    desc "Reindex all job"
    task job_indexing: :environment do
        puts "Start index all job"
        CompanyJob.reindex
        Company.reindex
        Problem.reindex
        User.reindex
        UserAdward.reindex
        UserCertificate.reindex
        UserEducation.reindex
        UserExperience.reindex
        UserSkill.reindex
        puts "End index all job"
    end
end
