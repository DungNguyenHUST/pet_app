class ProblemVoteSolution < ApplicationRecord
  belongs_to :user
  belongs_to :problem_solution
end
