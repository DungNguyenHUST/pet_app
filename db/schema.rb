# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_15_094135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "location"
    t.string "website"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "size"
    t.text "overview"
    t.datetime "time_establish"
    t.string "field_operetion"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string "country"
    t.string "address"
    t.text "policy"
    t.string "phone"
    t.string "values"
    t.boolean "approved", default: false
    t.string "slug"
    t.string "wall_picture"
    t.string "avatar"
    t.string "working_time"
    t.string "working_date"
    t.string "company_type"
    t.text "benefit", default: [], array: true
    t.integer "employer_id"
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "company_apply_jobs", force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.integer "company_job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "cover_letter"
    t.integer "user_id"
    t.string "slug"
    t.string "cover_vitate"
    t.string "phone"
    t.string "address"
    t.index ["slug"], name: "index_company_apply_jobs_on_slug", unique: true
  end

  create_table "company_follows", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "user_id"
  end

  create_table "company_images", force: :cascade do |t|
    t.integer "company_id"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_interviews", force: :cascade do |t|
    t.string "user_name"
    t.string "position"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "difficultly"
    t.integer "satisfied"
    t.integer "process"
    t.boolean "offer"
    t.string "get_interview"
    t.string "companyName"
    t.boolean "privacy", default: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_company_interviews_on_slug", unique: true
  end

  create_table "company_jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "requirement"
    t.text "benefit"
    t.string "salary"
    t.string "quantity"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.string "location"
    t.string "level"
    t.string "language"
    t.integer "date"
    t.datetime "dudate"
    t.datetime "end_date"
    t.string "typical"
    t.boolean "approved", default: false
    t.string "slug"
    t.boolean "apply_another_site_flag", default: false
    t.string "apply_site"
    t.string "address"
    t.text "skill", default: [], array: true
    t.integer "admin_id"
    t.string "detail"
    t.integer "salary_min"
    t.integer "salary_max"
    t.string "company_name"
    t.string "experience"
    t.string "policy"
    t.string "company_avatar"
    t.integer "employer_id"
    t.integer "view_count"
    t.integer "sponsor", default: 0
    t.integer "urgent", default: 0
    t.index ["slug"], name: "index_company_jobs_on_slug", unique: true
  end

  create_table "company_questions", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.string "slug"
    t.integer "user_id"
    t.string "user_name"
    t.index ["slug"], name: "index_company_questions_on_slug", unique: true
  end

  create_table "company_react_interviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "react_type", default: -1
    t.bigint "company_interview_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_interview_id"], name: "index_company_react_interviews_on_company_interview_id"
  end

  create_table "company_react_reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "react_type", default: -1
    t.bigint "company_review_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_review_id"], name: "index_company_react_reviews_on_company_review_id"
  end

  create_table "company_reply_interviews", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "company_interview_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_company_reply_interviews_on_slug", unique: true
  end

  create_table "company_reply_questions", force: :cascade do |t|
    t.integer "company_question_id"
    t.text "reply_content"
    t.integer "user_id"
    t.string "user_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["slug"], name: "index_company_reply_questions_on_slug", unique: true
  end

  create_table "company_reply_reviews", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "company_review_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_company_reply_reviews_on_slug", unique: true
  end

  create_table "company_reviews", force: :cascade do |t|
    t.string "companyName"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.string "user_name"
    t.string "review"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "position"
    t.text "pros"
    t.text "cons"
    t.text "review_title"
    t.integer "career_score"
    t.integer "manager_score"
    t.integer "ot_score"
    t.integer "salary_score"
    t.integer "work_env_score"
    t.boolean "working_status"
    t.integer "average_score"
    t.boolean "privacy", default: false
    t.string "working_time"
    t.string "slug"
    t.integer "user_id"
    t.boolean "recommend"
    t.index ["slug"], name: "index_company_reviews_on_slug", unique: true
  end

  create_table "company_salaries", force: :cascade do |t|
    t.integer "company_id"
    t.integer "salary"
    t.string "salary_currency"
    t.string "salary_job"
    t.string "salary_experience"
    t.boolean "salary_working_status"
    t.integer "user_id"
    t.string "user_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.boolean "privacy", default: false
    t.integer "salary_bonus"
    t.integer "level"
    t.integer "position"
    t.integer "locate"
    t.index ["slug"], name: "index_company_salaries_on_slug", unique: true
  end

  create_table "company_save_jobs", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "company_job_id"
  end

  create_table "cover_vitaes", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "detail"
    t.string "category"
    t.string "language"
    t.string "style"
    t.string "avatar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "sample", default: false
    t.integer "user_id"
    t.integer "origin_id"
    t.boolean "primary", default: false
    t.string "slug"
    t.index ["slug"], name: "index_cover_vitaes_on_slug", unique: true
  end

  create_table "employer_notifications", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "original_url"
    t.integer "trigger_user_id"
    t.boolean "readed", default: false
    t.string "noti_type"
    t.bigint "employer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_id"], name: "index_employer_notifications_on_employer_id"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.string "phone"
    t.string "address"
    t.string "company_name"
    t.string "company_field"
    t.integer "company_id"
    t.boolean "approved", default: false
    t.string "slug"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "plan"
    t.datetime "start_plan"
    t.datetime "end_plan"
    t.index ["confirmation_token"], name: "index_employers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_employers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employers_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_employers_on_unlock_token", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "post_comments", force: :cascade do |t|
    t.string "user_name"
    t.text "comment_content"
    t.integer "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_post_comments_on_slug", unique: true
  end

  create_table "post_reply_comments", force: :cascade do |t|
    t.string "user_name"
    t.text "reply_content"
    t.integer "post_comment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_post_reply_comments_on_slug", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "username"
    t.text "content"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approved", default: false
    t.string "slug"
    t.string "avatar"
    t.string "wall_picture"
    t.integer "category"
    t.integer "user_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "problem_react_solutions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "react_type", default: -1
    t.bigint "problem_solution_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_solution_id"], name: "index_problem_react_solutions_on_problem_solution_id"
  end

  create_table "problem_reply_solutions", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "problem_solution_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_problem_reply_solutions_on_slug", unique: true
  end

  create_table "problem_solutions", force: :cascade do |t|
    t.string "user_name"
    t.string "title"
    t.text "content"
    t.integer "vote"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "problem_id"
    t.integer "user_id"
    t.string "slug"
    t.index ["slug"], name: "index_problem_solutions_on_slug", unique: true
  end

  create_table "problems", force: :cascade do |t|
    t.string "user_name"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "difficult"
    t.string "category"
    t.boolean "approved", default: false
    t.string "slug"
    t.integer "user_id"
    t.index ["slug"], name: "index_problems_on_slug", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id"
    t.string "target_type"
    t.integer "target_id"
    t.integer "report_type"
    t.text "report_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scrap_jobs", force: :cascade do |t|
    t.integer "company_id"
    t.string "company_name"
    t.string "location"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "page_num"
    t.boolean "proxy", default: false
  end

  create_table "scrap_reviews", force: :cascade do |t|
    t.integer "company_id"
    t.string "company_name"
    t.string "url"
    t.text "raw_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_adwards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "adward_name"
    t.string "adward_summary"
    t.datetime "receive_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_adwards_on_user_id"
  end

  create_table "user_certificates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "cert_name"
    t.string "cert_summary"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_certificates_on_user_id"
  end

  create_table "user_educations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "cert_level"
    t.string "cert_type"
    t.string "school_level"
    t.string "school_name"
    t.string "school_location"
    t.string "school_field"
    t.boolean "enrolled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_educations_on_user_id"
  end

  create_table "user_experiences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "company_name"
    t.string "company_location"
    t.string "job_level"
    t.string "job_summary"
    t.boolean "enrolled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_experiences_on_user_id"
  end

  create_table "user_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "content"
    t.string "original_url"
    t.integer "trigger_user_id"
    t.boolean "readed", default: false
    t.string "noti_type"
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "skill_name"
    t.string "skill_summary"
    t.string "skill_level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.string "address"
    t.text "cover_letter"
    t.boolean "approved", default: false
    t.string "slug"
    t.string "wall_picture"
    t.string "avatar"
    t.string "cover_letter_attach"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider", limit: 50, default: "", null: false
    t.string "uid", limit: 500, default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "birthday"
    t.string "sex"
    t.string "matrimony"
    t.string "headline"
    t.text "summary"
    t.string "highest_education"
    t.string "highest_career"
    t.boolean "public", default: true
    t.boolean "finding_job", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_react_interviews", "company_interviews"
  add_foreign_key "company_react_reviews", "company_reviews"
  add_foreign_key "employer_notifications", "employers"
  add_foreign_key "problem_react_solutions", "problem_solutions"
  add_foreign_key "user_adwards", "users"
  add_foreign_key "user_certificates", "users"
  add_foreign_key "user_educations", "users"
  add_foreign_key "user_experiences", "users"
  add_foreign_key "user_notifications", "users"
  add_foreign_key "user_skills", "users"
end
