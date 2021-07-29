class ProblemSolution < ApplicationRecord
	extend FriendlyId
    def convert_slug
        slug = title.downcase.to_s
        slug.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
        slug.gsub! /[đ]/, "d"
        slug.gsub! /[èéẹẽẻêềếệễể]/, "e"
        slug.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
        slug.gsub! /[úùụũủưứựừữử]/, "u"
        slug.gsub! /[íịìĩỉ]/, "i"
        slug.gsub! /[ýỵỹỳỷ]/, "y"
        return slug
    end
	friendly_id :convert_slug, use: :slugged
	
    belongs_to :problem, optional: true
    has_many :problem_reply_solutions, dependent: :destroy
    has_many :problem_vote_solutions, dependent: :destroy
    has_many :problem_unvote_solutions, dependent: :destroy
    
    # validates :content, presence: true
end
