class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates :percentage, numericality: { greater_than: 0.01, less_than: 0.99 }
  validates_numericality_of :quantity_threshold
end
