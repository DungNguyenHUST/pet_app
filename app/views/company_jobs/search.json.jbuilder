json.suggest_jobs do
    json.array!(@suggest_jobs) do |company_job|
        json.title company_job.title
        json.url jobs_search_path(:search => company_job.title)
    end
end
