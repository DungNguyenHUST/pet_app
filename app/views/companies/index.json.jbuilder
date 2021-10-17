json.suggest_companies do
    json.array!(@suggest_companies) do |company|
        json.name company.name
        json.url companies_path(:search => company.name)
    end
end