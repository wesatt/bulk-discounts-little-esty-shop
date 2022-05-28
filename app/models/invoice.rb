class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  belongs_to :customer

  enum status:["in progress", "completed", "cancelled"]
end