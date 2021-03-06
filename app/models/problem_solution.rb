class ProblemSolution < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged
	
    belongs_to :problem, optional: true
    has_many :problem_reply_solutions, dependent: :destroy
    has_many :problem_vote_solutions, dependent: :destroy
    has_many :problem_unvote_solutions, dependent: :destroy
    
    # validates :content, presence: true
end
