class Problem < ApplicationRecord
    has_many :problem_solutions, dependent: :destroy

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

    # def self.sort(soft_type)
    #     if soft_type
    #         problem_type = Problem.all(:order => 'DATE(updated_at), difficult')
    #         if (problem_type)
    #             self.where(id: problem_type)
    #         else
    #             @problems = Problem.all
    #         end
    #     else
    #         @problems = Problem.all
    #     end
    # end

    validates :content_rich_text, presence: true
    has_rich_text :content_rich_text
end
