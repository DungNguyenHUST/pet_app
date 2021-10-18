json.suggest_problems do
    json.array!(@suggest_problems) do |problem|
        json.title problem.title
        json.url problems_path(:search => problem.title)
    end
end