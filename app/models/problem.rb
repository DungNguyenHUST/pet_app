class Problem < ApplicationRecord
    include PgSearch::Model

	extend FriendlyId
	friendly_id :title_converted, use: :slugged
	
    has_many :problem_solutions, dependent: :destroy

    pg_search_scope :search_problem_by_title, 
                    against: :title,
                    using: {
                        tsearch: { prefix: true, dictionary: "english", any_word: true }
                    }
	
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

    # validates :content, presence: true
end
