class Problem < ApplicationRecord
    has_many :problem_solutions, dependent: :destroy
end
