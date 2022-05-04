namespace :index_job_tasks do
    desc "Reindex all job"
    task job_indexing: :environment do
        puts "Start index all job"
        IndexingJob.perform_later
        puts "End index all job"
    end
end
