class ProblemReplySolution < ApplicationRecord
	extend FriendlyId
	friendly_id :user_name, use: :slugged
	
    belongs_to :problem_solutions, optional: true
end
