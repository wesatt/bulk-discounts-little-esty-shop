class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status:["in progress", "completed", "cancelled"]

  def total_revenue
    helpers
    .number_to_currency(
      invoice_items
      .sum("unit_price * quantity") / 100
    )
  end

  def total_discounted_revenue
    total = invoice_items.map do |inv_item|
      inv_item.adjusted_price * inv_item.quantity
    end.sum
    helpers.number_to_currency(total / 100)
  end

  def self.not_shipped
    # binding.pry
    all
    .joins(:invoice_items)
    .where.not("invoice_items.status = ?", 2)
    .order(created_at: :desc)
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

private
# Helper Methods
  def helpers
  ActionController::Base.helpers
  end
end
