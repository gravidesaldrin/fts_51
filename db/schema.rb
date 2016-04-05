# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160404061507) do

  create_table "answers", force: :cascade do |t|
    t.integer  "exam_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.string   "text_answer"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["exam_id", "option_id"], name: "index_answers_on_exam_id_and_option_id"
  add_index "answers", ["exam_id", "question_id"], name: "index_answers_on_exam_id_and_question_id"
  add_index "answers", ["exam_id"], name: "index_answers_on_exam_id"
  add_index "answers", ["option_id"], name: "index_answers_on_option_id"
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "exams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "correct"
    t.integer  "total"
    t.datetime "finished_time"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "exams", ["category_id"], name: "index_exams_on_category_id"
  add_index "exams", ["user_id", "category_id"], name: "index_exams_on_user_id_and_category_id"
  add_index "exams", ["user_id"], name: "index_exams_on_user_id"

  create_table "options", force: :cascade do |t|
    t.integer  "question_id"
    t.string   "content"
    t.boolean  "correct",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "options", ["question_id", "content"], name: "index_options_on_question_id_and_content"
  add_index "options", ["question_id"], name: "index_options_on_question_id"

  create_table "questions", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "content"
    t.string   "question_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "questions", ["category_id", "content"], name: "index_questions_on_category_id_and_content", unique: true
  add_index "questions", ["category_id"], name: "index_questions_on_category_id"
  add_index "questions", ["content"], name: "index_questions_on_content"
  add_index "questions", ["question_type"], name: "index_questions_on_question_type"

  create_table "relationships", force: :cascade do |t|
    t.integer  "followed_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "role",                   default: "Normal"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
