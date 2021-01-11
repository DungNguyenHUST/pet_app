class ProblemSolution < ApplicationRecord
    belongs_to :problem, optional: true
    has_many :problem_reply_solutions, dependent: :destroy
    has_many :problem_vote_solutions, dependent: :destroy
    has_many :problem_unvote_solutions, dependent: :destroy
    
    validates :content_rich_text, presence: true
    has_rich_text :content_rich_text
end
