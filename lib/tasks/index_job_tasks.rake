namespace :index_job_tasks do
    desc "Reindex all job"
    task job_indexing: :environment do
        puts "Start index all job"
        CompanyJob.reindex(mode: :async)
        Company.reindex(mode: :async)
        Problem.reindex(mode: :async)
        User.reindex(mode: :async)
        UserAdward.reindex(mode: :async)
        UserCertificate.reindex(mode: :async)
        UserEducation.reindex(mode: :async)
        UserExperience.reindex(mode: :async)
        UserSkill.reindex(mode: :async)
        puts "End index all job"
    end
end
