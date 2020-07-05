class Problem < ApplicationRecord
    has_many :problem_solutions, dependent: :destroy
    has_rich_text :problem_content
end
