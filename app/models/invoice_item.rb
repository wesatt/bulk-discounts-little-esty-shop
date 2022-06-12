class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  belongs_to :invoice
  has_many :customers, through: :invoice
  has_many :transactions, through: :invoice


  validates_numericality_of :quantity
  validates_numericality_of :unit_price
  enum status:["pending", "packaged", "shipped"]

  def unit_price_converted
    helpers.number_to_currency(self.unit_price.to_f/100)
  end

  def best_discount
    bulk_discounts
    .where("#{self.quantity} >= bulk_discounts.quantity_threshold")
    .order(quantity_threshold: :desc)
    .first
  end

  def adjusted_price
    if best_discount.nil?
      unit_price
    else
      unit_price - (unit_price * best_discount.percentage)
    end
  end

private
  # Helper Methods
  def helpers
  ActionController::Base.helpers
  end
end
