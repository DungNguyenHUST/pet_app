class DeleteLikeSystem < ActiveRecord::Migration[6.1]
  def change
    if table_exists? :company_like_reviews
      drop_table :company_like_reviews
    end
    if table_exists? :company_like_interviews
      drop_table :company_like_interviews
    end
    if table_exists? :company_dislike_reviews
      drop_table :company_dislike_reviews
    end
    if table_exists? :company_dislike_interviews
      drop_table :company_dislike_interviews
    end
    if table_exists? :problem_vote_solutions
      drop_table :problem_vote_solutions
    end
    if table_exists? :problem_unvote_solutions
      drop_table :problem_unvote_solutions
    end
  end
end
