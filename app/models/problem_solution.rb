class ProblemSolution < ApplicationRecord
    belongs_to :problem, optional: true
    has_many :problem_reply_solutions, dependent: :destroy
end
