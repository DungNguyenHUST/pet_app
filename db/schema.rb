# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_31_105433) do

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
  end

  create_table "company_dislike_reviews", force: :cascade do |t|
    t.bigint "company_review_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_review_id"], name: "index_company_dislike_reviews_on_company_review_id"
    t.index ["user_id"], name: "index_company_dislike_reviews_on_user_id"
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
  end

  create_table "company_like_reviews", force: :cascade do |t|
    t.bigint "company_review_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_review_id"], name: "index_company_like_reviews_on_company_review_id"
    t.index ["user_id"], name: "index_company_like_reviews_on_user_id"
  end

  create_table "company_reply_interviews", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "company_interview_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_reply_reviews", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "company_review_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
  end

  create_table "post_comments", force: :cascade do |t|
    t.string "user_name"
    t.text "comment_content"
    t.integer "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "post_reply_comments", force: :cascade do |t|
    t.string "user_name"
    t.text "reply_content"
    t.integer "post_comment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "username"
    t.text "content"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "problem_reply_solutions", force: :cascade do |t|
    t.string "user_name"
    t.string "reply_content"
    t.integer "problem_solution_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "problem_solutions", force: :cascade do |t|
    t.string "user_name"
    t.string "title"
    t.text "content"
    t.integer "vote"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "user_name"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "difficult"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_dislike_reviews", "company_reviews"
  add_foreign_key "company_dislike_reviews", "users"
  add_foreign_key "company_like_reviews", "company_reviews"
  add_foreign_key "company_like_reviews", "users"
end
