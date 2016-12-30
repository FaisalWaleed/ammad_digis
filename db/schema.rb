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

ActiveRecord::Schema.define(version: 20161229105755) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_permissions", force: :cascade do |t|
    t.string   "name",            limit: 40
    t.text     "description"
    t.string   "protected_model", limit: 255
    t.integer  "admin_role_id"
    t.boolean  "can_read",                    default: true,  null: false
    t.boolean  "can_create",                  default: false, null: false
    t.boolean  "can_edit",                    default: false, null: false
    t.boolean  "can_delete",                  default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "admin_role_assignments", force: :cascade do |t|
    t.integer  "admin_role_id"
    t.integer  "admin_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "admin_role_assignments", ["admin_role_id", "admin_id"], name: "index_admin_role_assignments_on_admin_role_id_and_admin_id", using: :btree

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "firstname",           limit: 40
    t.string   "lastname",            limit: 40
    t.string   "email",               limit: 80
    t.boolean  "superadmin",                      default: false, null: false
    t.boolean  "active",                          default: true,  null: false
    t.string   "crypted_password",    limit: 255
    t.string   "password_salt",       limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token", limit: 255
    t.string   "perishable_token",    limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 40
    t.string   "last_login_ip",       limit: 40
    t.text     "avatar_file_name"
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "attachable_type",   limit: 40
    t.integer  "attachable_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "title",             limit: 255
  end

  create_table "authorizations", force: :cascade do |t|
    t.integer  "physician_id"
    t.integer  "patient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "common_allergies", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.text     "description"
    t.text     "aliases"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "common_drugs", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.text     "description"
    t.text     "aliases"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "common_illnesses", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.text     "aliases"
    t.text     "description"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "consignments", force: :cascade do |t|
    t.integer  "dispense_order_id"
    t.integer  "dispensable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "consultations", force: :cascade do |t|
    t.integer  "physician_id"
    t.integer  "consult_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "consultations", ["physician_id", "consult_id"], name: "index_consultations_on_physician_id_and_consult_id", using: :btree

  create_table "consults", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "physician_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "consults", ["patient_id", "physician_id"], name: "index_consults_on_patient_id_and_physician_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.decimal  "discount",              precision: 5, scale: 2
    t.string   "code",       limit: 20
    t.datetime "expire_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "diagnostics", force: :cascade do |t|
    t.integer  "patient_id"
    t.string   "verification_pin"
    t.integer  "laboratory_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "physician_id"
    t.text     "notes"
    t.string   "identifier",              limit: 40
    t.boolean  "commentable",                        default: true,  null: false
    t.boolean  "archived_for_physician",             default: false, null: false
    t.boolean  "archived_for_technician",            default: false, null: false
    t.boolean  "reviewed",                           default: false, null: false
    t.string   "last_modifier_type",      limit: 40
    t.integer  "last_modifier_id"
  end

  add_index "diagnostics", ["identifier"], name: "index_diagnostics_on_identifier", unique: true, using: :btree

  create_table "disbursements", force: :cascade do |t|
    t.integer  "pharmacist_id"
    t.text     "annotation"
    t.integer  "prescribed_drug_strength"
    t.string   "prescribed_drug_unit",     limit: 10
    t.integer  "filled_drug_strength"
    t.string   "filled_drug_unit",         limit: 10
    t.integer  "filled_drug_id"
    t.decimal  "filled_dose",                         precision: 6, scale: 2
    t.integer  "dispensable_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "pharmacy_id"
  end

  create_table "dispensables", force: :cascade do |t|
    t.integer  "dispense_order_id"
    t.integer  "prescript_id"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.decimal  "dose_filled",                   precision: 8, scale: 2, default: 0.0,   null: false
    t.string   "drug_filled",       limit: 255
    t.string   "strength_filled",   limit: 255
    t.boolean  "fully_filled",                                          default: false, null: false
  end

  create_table "dispensations", force: :cascade do |t|
    t.integer  "dispensable_id"
    t.decimal  "price",          precision: 10, scale: 2
    t.integer  "pharmacist_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "dispense_orders", force: :cascade do |t|
    t.integer  "prescription_id"
    t.integer  "pharmacy_id"
    t.integer  "transferer_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "processing_at"
    t.datetime "ready_at"
    t.datetime "delivered_at"
    t.boolean  "commentable",                   default: true,  null: false
    t.datetime "transferred_at"
    t.string   "last_modifier_type", limit: 40
    t.integer  "last_modifier_id"
    t.boolean  "ongoing",                       default: false, null: false
  end

  create_table "dosage_duration_units", force: :cascade do |t|
    t.string   "name",       limit: 20
    t.string   "code",       limit: 10
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "threshold",             default: 0, null: false
  end

  create_table "dosage_frequencies", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.string   "code",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "dosage_routes", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.string   "code",        limit: 20
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
  end

  create_table "dosage_units", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.string   "symbol",     limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "dr_office_administrations", force: :cascade do |t|
    t.integer  "dr_office_id"
    t.integer  "admin_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "dr_office_administrations", ["dr_office_id", "admin_id"], name: "index_dr_office_administrations_on_dr_office_id_and_admin_id", using: :btree

  create_table "dr_office_vocations", force: :cascade do |t|
    t.integer  "dr_office_id"
    t.integer  "physician_id"
    t.boolean  "primary",      default: false, null: false
    t.date     "begin_on"
    t.date     "end_on"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "dr_office_vocations", ["dr_office_id", "physician_id"], name: "index_dr_office_vocations_on_dr_office_id_and_physician_id", using: :btree

  create_table "dr_offices", force: :cascade do |t|
    t.string   "name",                 limit: 40
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 80
    t.string   "address_territory",    limit: 80
    t.string   "address_postal_code",  limit: 10
    t.string   "address_country",      limit: 40
    t.decimal  "latitude",                         precision: 16, scale: 12
    t.decimal  "longitude",                        precision: 16, scale: 12
    t.string   "email_primary",        limit: 80
    t.string   "email_secondary",      limit: 80
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "phone_mobile",         limit: 40
    t.string   "phone_alternate",      limit: 40
    t.string   "reg_num",              limit: 40
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "dr_offices", ["name"], name: "index_dr_offices_on_name", using: :btree

  create_table "drug_formats", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.string   "abbrev",     limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "drugs", force: :cascade do |t|
    t.text     "trade_name"
    t.text     "generic_name"
    t.integer  "drug_format_id"
    t.string   "dosages",        limit: 40
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "drugs", ["generic_name"], name: "index_drugs_on_generic_name", using: :btree
  add_index "drugs", ["trade_name"], name: "index_drugs_on_trade_name", using: :btree

  create_table "genders", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "insurances", force: :cascade do |t|
    t.integer  "insurable_id"
    t.string   "insurable_type"
    t.integer  "insurer_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "insurers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "invoice_line_items", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "unit_count",                                    default: 1,   null: false
    t.decimal  "unit_price",            precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "tax",                   precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "discount",              precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "subtotal",              precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "asset_id",                                                    null: false
    t.string   "asset_type", limit: 40,                                       null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal  "total",                    precision: 8, scale: 1, default: 0.0, null: false
    t.date     "due_on"
    t.integer  "customer_id"
    t.string   "customer_type", limit: 40
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  create_table "laboratories", force: :cascade do |t|
    t.string   "name",                 limit: 40
    t.string   "contact_firstname",    limit: 40
    t.string   "contact_lastname",     limit: 40
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 80
    t.string   "address_territory",    limit: 80
    t.string   "address_postal_code",  limit: 10
    t.string   "address_country",      limit: 40
    t.decimal  "latitude",                         precision: 16, scale: 12
    t.decimal  "longitude",                        precision: 16, scale: 12
    t.string   "email_primary",        limit: 80
    t.string   "email_secondary",      limit: 80
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "phone_mobile",         limit: 40
    t.string   "phone_alternate",      limit: 40
    t.string   "reg_num",              limit: 40
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.boolean  "active"
    t.string   "crypted_password",     limit: 255
    t.string   "password_salt",        limit: 255
    t.string   "persistence_token",    limit: 255
    t.string   "single_access_token",  limit: 255
    t.string   "perishable_token",     limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",     limit: 40
    t.string   "last_login_ip",        limit: 40
    t.text     "avatar_file_name"
    t.string   "avatar_content_type",  limit: 40
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "customer_id",          limit: 255
  end

  create_table "laboratory_test_types", force: :cascade do |t|
    t.integer  "laboratory_id"
    t.integer  "test_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "laboratory_vocations", force: :cascade do |t|
    t.integer  "laboratory_id"
    t.integer  "technician_id"
    t.boolean  "primary",       default: false, null: false
    t.date     "begin_on"
    t.date     "end_on"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "asset_type",           limit: 40
    t.integer  "asset_id"
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 255
    t.string   "address_territory",    limit: 255
    t.string   "address_postal_code",  limit: 40
    t.string   "address_country",      limit: 40
    t.decimal  "latitude",                         precision: 16, scale: 14
    t.decimal  "longitude",                        precision: 16, scale: 14
    t.string   "email_primary",        limit: 255
    t.string   "email_secondary",      limit: 255
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "fax_primary",          limit: 40
    t.string   "fax_secondary",        limit: 40
    t.string   "name",                 limit: 255
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "member_patients", force: :cascade do |t|
    t.string   "login",               limit: 40
    t.boolean  "active",                          default: true, null: false
    t.string   "crypted_password",    limit: 255
    t.string   "password_salt",       limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token", limit: 255
    t.string   "perishable_token",    limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 40
    t.string   "last_login_ip",       limit: 40
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject",          limit: 255
    t.text     "body"
    t.integer  "sender_id"
    t.string   "sender_type",      limit: 20
    t.integer  "asset_id"
    t.string   "asset_type",       limit: 20
    t.boolean  "read",                         default: false, null: false
    t.boolean  "urgent",                       default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "require_response",             default: true,  null: false
  end

  create_table "patient_note_types", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.string   "code",       limit: 20
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "patient_notes", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "patient_note_type_id"
    t.text     "note"
    t.string   "author_type",          limit: 40
    t.integer  "author_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string   "firstname",               limit: 40
    t.string   "lastname",                limit: 40
    t.string   "middlename",              limit: 40
    t.integer  "gender_id"
    t.date     "date_of_birth"
    t.text     "general_notes"
    t.text     "hx_notes"
    t.text     "surgical_history"
    t.integer  "physician_id"
    t.string   "address_street_1",        limit: 255
    t.string   "address_street_2",        limit: 255
    t.string   "address_municipality",    limit: 80
    t.string   "address_territory",       limit: 80
    t.string   "address_postal_code",     limit: 10
    t.string   "address_country",         limit: 40
    t.string   "email_primary",           limit: 80
    t.string   "email_secondary",         limit: 80
    t.string   "phone_primary",           limit: 40
    t.string   "phone_secondary",         limit: 40
    t.string   "phone_mobile",            limit: 40
    t.string   "phone_alternate",         limit: 40
    t.integer  "personal_id_type_id"
    t.string   "personal_id_code",        limit: 80
    t.text     "avatar_file_name"
    t.string   "avatar_content_type",     limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "active",                              default: true,  null: false
    t.string   "crypted_password",        limit: 255
    t.string   "password_salt",           limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token",     limit: 255
    t.string   "perishable_token",        limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",        limit: 40
    t.string   "last_login_ip",           limit: 40
    t.boolean  "email_verified",                      default: false, null: false
    t.boolean  "phone_verified",                      default: false, null: false
    t.string   "email_verification_code", limit: 10
    t.string   "phone_verification_code", limit: 10
    t.string   "customer_id",             limit: 255
  end

  add_index "patients", ["firstname"], name: "index_patients_on_firstname", using: :btree
  add_index "patients", ["lastname"], name: "index_patients_on_lastname", using: :btree

  create_table "payments", force: :cascade do |t|
    t.decimal  "amount",                                   precision: 8, scale: 2, default: 0.0,   null: false
    t.datetime "paid_at"
    t.integer  "customer_id",                                                                      null: false
    t.string   "customer_type",                limit: 40,                                          null: false
    t.boolean  "method_cc",                                                        default: false, null: false
    t.boolean  "method_ac",                                                        default: false, null: false
    t.boolean  "method_vc",                                                        default: false, null: false
    t.string   "method_type",                  limit: 40
    t.string   "method_currency",              limit: 8
    t.string   "merchant_response_order_id"
    t.string   "merchant_response_message"
    t.string   "merchant_response_status"
    t.string   "merchant_response_receiptcc"
    t.string   "merchant_response_auth_code"
    t.text     "note"
    t.string   "payer_name",                   limit: 100,                                         null: false
    t.string   "payer_email",                  limit: 255
    t.string   "payer_phone",                  limit: 40
    t.string   "payer_address_street_1",       limit: 100
    t.string   "payer_address_street_2",       limit: 100
    t.string   "payer_address_city",           limit: 100
    t.string   "payer_address_state",          limit: 100
    t.string   "payer_address_country",        limit: 40
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.integer  "subscription_id"
    t.string   "merchant_response_card_last4", limit: 4
  end

  create_table "personal_id_types", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.text     "description"
    t.string   "code",        limit: 10
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string   "name",                 limit: 40
    t.string   "contact_firstname",    limit: 40
    t.string   "contact_lastname",     limit: 40
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 80
    t.string   "address_territory",    limit: 80
    t.string   "address_postal_code",  limit: 10
    t.string   "address_country",      limit: 40
    t.decimal  "latitude",                         precision: 16, scale: 12
    t.decimal  "longitude",                        precision: 16, scale: 12
    t.string   "email_primary",        limit: 80
    t.string   "email_secondary",      limit: 80
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "phone_mobile",         limit: 40
    t.string   "phone_alternate",      limit: 40
    t.string   "reg_num",              limit: 40
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.boolean  "active"
    t.string   "crypted_password",     limit: 255
    t.string   "password_salt",        limit: 255
    t.string   "persistence_token",    limit: 255
    t.string   "single_access_token",  limit: 255
    t.string   "perishable_token",     limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",     limit: 40
    t.string   "last_login_ip",        limit: 40
    t.text     "avatar_file_name"
    t.string   "avatar_content_type",  limit: 40
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "customer_id",          limit: 255
  end

  add_index "pharmacies", ["contact_firstname", "contact_lastname"], name: "index_pharmacies_on_contact_firstname_and_contact_lastname", using: :btree
  add_index "pharmacies", ["name"], name: "index_pharmacies_on_name", using: :btree

  create_table "pharmacists", force: :cascade do |t|
    t.string   "firstname",            limit: 40
    t.string   "lastname",             limit: 40
    t.string   "middlename",           limit: 40
    t.integer  "gender_id"
    t.date     "date_of_birth"
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 80
    t.string   "address_territory",    limit: 80
    t.string   "address_postal_code",  limit: 10
    t.string   "address_country",      limit: 40
    t.string   "email_primary",        limit: 80
    t.string   "email_secondary",      limit: 80
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "phone_mobile",         limit: 40
    t.string   "phone_alternate",      limit: 40
    t.string   "reg_num",              limit: 40
    t.boolean  "active",                           default: false, null: false
    t.string   "crypted_password",     limit: 255
    t.string   "password_salt",        limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token",  limit: 255
    t.string   "perishable_token",     limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",     limit: 40
    t.string   "last_login_ip",        limit: 40
    t.text     "avatar_file_name"
    t.string   "avatar_content_type",  limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "admin",                            default: false, null: false
    t.string   "customer_id",          limit: 255
  end

  create_table "pharmacy_administrations", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.integer  "admin_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pharmacy_administrations", ["pharmacy_id", "admin_id"], name: "index_pharmacy_administrations_on_pharmacy_id_and_admin_id", using: :btree

  create_table "pharmacy_vocations", force: :cascade do |t|
    t.integer  "pharmacy_id"
    t.integer  "pharmacist_id"
    t.boolean  "primary",       default: false, null: false
    t.date     "begin_on"
    t.date     "end_on"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "pharmacy_vocations", ["pharmacy_id", "pharmacist_id"], name: "index_pharmacy_vocations_on_pharmacy_id_and_pharmacist_id", using: :btree

  create_table "physician_specializations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physicians", force: :cascade do |t|
    t.string   "firstname",              limit: 40
    t.string   "lastname",               limit: 40
    t.string   "middlename",             limit: 40
    t.integer  "gender_id"
    t.date     "date_of_birth"
    t.string   "address_street_1",       limit: 255
    t.string   "address_street_2",       limit: 255
    t.string   "address_municipality",   limit: 80
    t.string   "address_territory",      limit: 80
    t.string   "address_postal_code",    limit: 10
    t.string   "address_country",        limit: 40
    t.string   "email_primary",          limit: 80
    t.string   "email_secondary",        limit: 80
    t.string   "phone_primary",          limit: 40
    t.string   "phone_secondary",        limit: 40
    t.string   "phone_mobile",           limit: 40
    t.string   "phone_alternate",        limit: 40
    t.string   "reg_num",                limit: 40
    t.boolean  "active",                             default: false, null: false
    t.string   "crypted_password",       limit: 255
    t.string   "password_salt",          limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token",    limit: 255
    t.string   "perishable_token",       limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",       limit: 40
    t.string   "last_login_ip",          limit: 40
    t.text     "avatar_file_name"
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "notify_via_email",                   default: true,  null: false
    t.boolean  "notify_via_sms",                     default: true,  null: false
    t.string   "customer_id",            limit: 255
    t.integer  "specialization_id"
    t.string   "signature_file_name"
    t.string   "signature_content_type"
    t.integer  "signature_file_size"
    t.datetime "signature_updated_at"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",                       limit: 40,                                          null: false
    t.text     "description"
    t.boolean  "available_to_physician",                                         default: false, null: false
    t.boolean  "available_to_pharmacy",                                          default: false, null: false
    t.boolean  "available_to_patient",                                           default: false, null: false
    t.decimal  "price",                                  precision: 8, scale: 2
    t.integer  "subscription_period_amount"
    t.string   "subscription_period_unit",   limit: 10
    t.integer  "trial_period_amount"
    t.string   "trial_period_unit",          limit: 10
    t.integer  "grace_period_amount"
    t.string   "grace_period_unit",          limit: 10
    t.boolean  "renew_notify",                                                   default: false, null: false
    t.boolean  "auto_renew",                                                     default: false, null: false
    t.boolean  "published",                                                      default: false, null: false
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
    t.boolean  "default",                                                        default: false, null: false
    t.integer  "subscriber_limit",                                               default: 0,     null: false
    t.integer  "organization_limit",                                             default: 0,     null: false
    t.string   "currency",                                                       default: "usd", null: false
    t.boolean  "available_to_technician",                                        default: false, null: false
    t.string   "publish_id",                 limit: 255
  end

  create_table "prescribed_drugs", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "common_drug_id"
    t.boolean  "current",        default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "prescription_transfers", force: :cascade do |t|
    t.integer  "prescription_id"
    t.integer  "transferer_id"
    t.integer  "transferee_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "prescriptions", force: :cascade do |t|
    t.string   "identifier",       limit: 40
    t.integer  "patient_id"
    t.integer  "pharmacy_id"
    t.datetime "issued_at"
    t.datetime "filled_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "physician_id"
    t.text     "note"
    t.string   "verification_pin", limit: 10
    t.boolean  "allow_generic",               default: false, null: false
    t.boolean  "printed",                     default: false, null: false
  end

  add_index "prescriptions", ["identifier"], name: "index_prescriptions_on_identifier", unique: true, using: :btree

  create_table "prescripts", force: :cascade do |t|
    t.integer  "drug_id"
    t.integer  "prescription_id"
    t.datetime "filled_at"
    t.decimal  "dose",                    precision: 10, scale: 2
    t.integer  "dosage_unit_id"
    t.integer  "dosage_route_id"
    t.integer  "dosage_frequency_id"
    t.decimal  "dosage_duration",         precision: 6,  scale: 2
    t.integer  "dosage_duration_unit_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.text     "note"
    t.integer  "repeat_max",                                       default: 0,     null: false
    t.integer  "repeat_count",                                     default: 0,     null: false
    t.boolean  "free_flow",                                        default: false, null: false
    t.text     "free_flow_details"
    t.boolean  "semi_free_flow",                                   default: false, null: false
  end

  add_index "prescripts", ["drug_id", "prescription_id"], name: "index_prescripts_on_drug_id_and_prescription_id", using: :btree

  create_table "profiled_testings", force: :cascade do |t|
    t.integer  "test_id"
    t.integer  "diagnostic_id"
    t.integer  "test_profile_id"
    t.boolean  "completed",       default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "quantifications", force: :cascade do |t|
    t.integer  "dosage_unit_id"
    t.integer  "drug_format_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "quantifications", ["dosage_unit_id", "drug_format_id"], name: "index_quantifications_on_dosage_unit_id_and_drug_format_id", using: :btree

  create_table "routabilities", force: :cascade do |t|
    t.integer  "dosage_route_id"
    t.integer  "drug_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "settlements", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "payment_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "specializations", force: :cascade do |t|
    t.integer  "specialty_id"
    t.integer  "physician_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "specializations", ["specialty_id", "physician_id"], name: "index_specializations_on_specialty_id_and_physician_id", using: :btree

  create_table "specialties", force: :cascade do |t|
    t.text     "name"
    t.string   "code",       limit: 40
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.integer  "plan_id",                                                                        null: false
    t.datetime "expire_at",                                                                      null: false
    t.decimal  "price",                                  precision: 8, scale: 2
    t.integer  "subscription_period_amount"
    t.string   "subscription_period_unit",   limit: 10
    t.integer  "trial_period_amount"
    t.string   "trial_period_unit",          limit: 10
    t.integer  "grace_period_amount"
    t.string   "grace_period_unit",          limit: 10
    t.boolean  "renew_notify",                                                   default: false, null: false
    t.boolean  "auto_renew",                                                     default: false, null: false
    t.integer  "coupon_id"
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
    t.integer  "subscriber_limit",                                               default: 0,     null: false
    t.integer  "organization_limit",                                             default: 0,     null: false
    t.boolean  "active",                                                         default: false, null: false
    t.string   "currency",                   limit: 10
    t.string   "plan_publish_id",            limit: 255
    t.string   "merchant_id",                limit: 255
    t.string   "merchant_customer_id",       limit: 255
  end

  create_table "suffered_allergies", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "common_allergy_id"
    t.boolean  "current",           default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "suffered_illnesses", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "common_illness_id"
    t.boolean  "current",           default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "technicians", force: :cascade do |t|
    t.string   "firstname",            limit: 40
    t.string   "lastname",             limit: 40
    t.string   "middlename",           limit: 40
    t.integer  "gender_id"
    t.date     "date_of_birth"
    t.string   "address_street_1",     limit: 255
    t.string   "address_street_2",     limit: 255
    t.string   "address_municipality", limit: 80
    t.string   "address_territory",    limit: 80
    t.string   "address_postal_code",  limit: 10
    t.string   "address_country",      limit: 40
    t.string   "email_primary",        limit: 80
    t.string   "email_secondary",      limit: 80
    t.string   "phone_primary",        limit: 40
    t.string   "phone_secondary",      limit: 40
    t.string   "phone_mobile",         limit: 40
    t.string   "phone_alternate",      limit: 40
    t.string   "reg_num",              limit: 40
    t.boolean  "active",                           default: false, null: false
    t.string   "crypted_password",     limit: 255
    t.string   "password_salt",        limit: 255
    t.string   "persistence_token"
    t.string   "single_access_token",  limit: 255
    t.string   "perishable_token",     limit: 255
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",     limit: 40
    t.string   "last_login_ip",        limit: 40
    t.boolean  "admin",                            default: false, null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "customer_id",          limit: 255
    t.integer  "location_id"
  end

  create_table "test_profiles", force: :cascade do |t|
    t.string   "name",         limit: 40
    t.integer  "test_type_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "test_profilings", force: :cascade do |t|
    t.integer  "test_profile_id"
    t.integer  "test_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "test_results", force: :cascade do |t|
    t.integer  "diagnostic_id"
    t.text     "notes"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "title",                   limit: 255
    t.text     "description"
    t.boolean  "archived_for_physician",              default: false, null: false
    t.boolean  "archived_for_technician",             default: false, null: false
    t.boolean  "viewed",                              default: false, null: false
  end

  create_table "test_taggings", force: :cascade do |t|
    t.integer  "test_id"
    t.integer  "test_tag_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "test_tags", force: :cascade do |t|
    t.string   "name",         limit: 40
    t.integer  "test_type_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "test_types", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.text     "description"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "testings", force: :cascade do |t|
    t.integer  "test_id"
    t.integer  "diagnostic_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "completed",     default: false, null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "test_type_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
