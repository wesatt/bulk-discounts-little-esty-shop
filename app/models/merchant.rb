class Merchant < ApplicationRecord
  has_many :bulk_discounts
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name
  enum status: ["disabled", "enabled"]

  def self.top_5
    joins(:transactions)
    .where(transactions: {result: 0})
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group('merchants.id')
    .order(revenue: :desc)
    .limit(5)
  end

  def top_5_customers
    customers.top_five
    # .joins(:transactions)
    # .where("transactions.result = ?", 0)
    # .group("customers.id")
    # .select("customers.*, count(transactions) as transaction_count")
    # .order(transaction_count: :desc)
    # .order(:first_name)
    # .order(:last_name)
    # .limit(5)
  end

  def ordered_not_shipped
    invoice_items.joins(:invoice)
    .where.not(status: 2)
    .order("invoices.created_at asc")
  end


  def self.top_5_customers
    Customer.joins(:transactions)
    .where("transactions.result = ?", 0)
    .group("customers.id")
    .select("customers.*, count(transactions) as transaction_count")
    .order(transaction_count: :desc)
    .order(:first_name)
    .order(:last_name)
    .limit(5)
  end

  def best_day
    invoices
    .joins(:transactions)
    .select("invoices.created_at")
    .where("transactions.result = ?", 0)
    .order(Arel.sql("sum(invoice_items.quantity) desc, date_trunc('day', invoices.created_at) desc"))
    .group("invoices.created_at")
    .pluck("invoices.created_at")
    .first
    .strftime("%m/%d/%y")
  end

  def invoice(invoice_id)
    if invoices.ids.include?(invoice_id)
      invoices.find(invoice_id)
    else
      "This invoice does not belong to this merchant"
    end
  end

  def inv_items_on_invoice(invoice_id)
    invoice(invoice_id)
    .invoice_items
    .joins(:merchants)
    .where("merchants.id = #{self.id}")
  end

  def total_invoice_revenue(invoice_id)
    helpers.number_to_currency(
      inv_items_on_invoice(invoice_id)
      .sum("invoice_items.unit_price * invoice_items.quantity") / 100
    )
  end

  def total_discounted_revenue(invoice_id)
    total = inv_items_on_invoice(invoice_id).map do |inv_item|
      inv_item.adjusted_price * inv_item.quantity
    end.sum
    helpers.number_to_currency(total/100)
  end

  # def invoice_discounts(invoice_id)
  #   merch_inv_items = inv_items_on_invoice(invoice_id)
  #   if merch_inv_items == "This invoice does not belong to this merchant"
  #     "This invoice does not belong to this merchant"
  #   else
  #     merch_inv_items.map { |inv_item| inv_item.best_discount }
  #   end
  # end

private
  # Helper Methods
  def helpers
  ActionController::Base.helpers
  end
end
