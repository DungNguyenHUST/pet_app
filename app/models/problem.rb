class Problem < ApplicationRecord
    has_many :problem_solutions, dependent: :destroy
    has_rich_text :problem_content

    def self.search(search)
        if search
            problem_type = Problem.where("title ILIKE ?", "%#{search}%")
            if(problem_type)
                self.where(id: problem_type)
            else
                @problems = Problem.all
            end
        else
            @problems = Problem.all
        end
    end
end
