class Problem < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged
	
    has_many :problem_solutions, dependent: :destroy

    def self.search(search)
        if search
            problem_search = Problem.where("title ILIKE ?", "%#{search}%")
            if(problem_search)
                self.where(id: problem_search)
            end
        end
    end
	
	def self.approved
	  where(approved: :true)
	end

    # def self.sort(soft_type)
    #     if soft_type
    #         problem_search = Problem.all(:order => 'DATE(updated_at), difficult')
    #         if (problem_search)
    #             self.where(id: problem_search)
    #         else
    #             @problems = Problem.all
    #         end
    #     else
    #         @problems = Problem.all
    #     end
    # end

    validates :content, presence: true
end
