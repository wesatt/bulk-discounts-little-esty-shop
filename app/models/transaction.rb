class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :customers, through: :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  validates_presence_of :credit_card_number
  enum result:["success", "failed"]
end
