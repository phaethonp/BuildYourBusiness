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

ActiveRecord::Schema[7.0].define(version: 2023_08_20_123458) do
  create_table "contract_templates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "scope_of_work_template"
    t.text "payment_terms_template"
    t.text "deadlines_template"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "client_id"
    t.integer "freelancer_id"
    t.string "scope_of_work"
    t.string "payment_terms"
    t.string "deadlines"
    t.string "confidentiality"
    t.string "intellectual_property"
    t.string "communication"
    t.string "dispute_resolution"
    t.string "termination"
    t.date "signed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contracts_on_client_id"
    t.index ["freelancer_id"], name: "index_contracts_on_freelancer_id"
  end

  create_table "escrows", force: :cascade do |t|
    t.decimal "amount"
    t.string "status"
    t.integer "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_escrows_on_contract_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "status"
    t.integer "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_payments_on_contract_id"
  end

  add_foreign_key "contracts", "clients"
  add_foreign_key "contracts", "freelancers"
  add_foreign_key "escrows", "contracts"
  add_foreign_key "payments", "contracts"
end
