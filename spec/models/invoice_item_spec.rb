require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_many(:merchants).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchants) }
    it { should have_many(:customers).through(:invoice) }
    it { should have_many(:transactions).through(:invoice) }

  end

  describe 'validations' do
    it { should validate_numericality_of :quantity}
    it { should validate_numericality_of :unit_price}
    it { should define_enum_for(:status).with_values(["pending", "packaged", "shipped"])}
  end

  describe "Group Project Methods" do
    let!(:merchant1) { create(:merchant) }

    let!(:item1) { create(:item, merchant: merchant1) }
    let!(:item2) { create(:item, merchant: merchant1) }

    let!(:customer1) { create(:customer) }

    let!(:invoice1) { create(:invoice, customer: customer1) }

    let!(:transaction1) { create(:transaction, invoice: invoice1, result: 1) }

    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011) }
    let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524) }

    describe "#instance methods" do
      it "#unit_price_converted shows unit price as a currency format" do
        expect(invoice_item1.unit_price_converted).to eq("$30.11")
      end
    end
  end

  describe "Solo Project Methods" do
    let!(:merchant1) { create(:merchant, status: 1) }
    let!(:merchant2) { create(:merchant, status: 1) }

    let!(:item1) { create(:item, unit_price: 100, status: 1, merchant: merchant1) }
    let!(:item2) { create(:item, unit_price: 200, status: 1, merchant: merchant2) }
    let!(:item7) { create(:item, unit_price: 300, status: 1, merchant: merchant1) }
    let!(:item8) { create(:item, unit_price: 400, status: 1, merchant: merchant2) }

    let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
    let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.15, quantity_threshold: 10, merchant: merchant2) }
    let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.15, quantity_threshold: 20, merchant: merchant1) }
    let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant2) }

    let!(:customer1) { create(:customer) }

    # invoice status:["in progress", "completed", "cancelled"] no default
    let!(:invoice1) { create(:invoice, status: 0, customer: customer1) }
    let!(:invoice2) { create(:invoice, status: 0, customer: customer1) }
    let!(:invoice3) { create(:invoice, status: 0, customer: customer1) }
    let!(:invoice4) { create(:invoice, status: 0, customer: customer1) }

    #  transaction result:["success", "failed"] no default
    let!(:transaction1) { create(:transaction, invoice: invoice1, result: 0) }
    let!(:transaction2) { create(:transaction, invoice: invoice2, result: 0) }
    let!(:transaction3) { create(:transaction, invoice: invoice3, result: 0) }
    let!(:transaction4) { create(:transaction, invoice: invoice1, result: 0) }
    let!(:transaction5) { create(:transaction, invoice: invoice2, result: 0) }
    let!(:transaction6) { create(:transaction, invoice: invoice3, result: 0) }

    # invoice_item status:["pending", "packaged", "shipped"] no default
    let!(:invoice_item1) { create(:invoice_item, unit_price: 100, quantity: 10, status: 0, item: item1, invoice: invoice1) }
    let!(:invoice_item2) { create(:invoice_item, unit_price: 200, quantity: 10, status: 0, item: item2, invoice: invoice1) }
    let!(:invoice_item3) { create(:invoice_item, unit_price: 300, quantity: 20, status: 0, item: item7, invoice: invoice1) }
    let!(:invoice_item4) { create(:invoice_item, unit_price: 400, quantity: 20, status: 0, item: item8, invoice: invoice1) }

    let!(:invoice_item5) { create(:invoice_item, unit_price: 100, quantity: 20, status: 0, item: item1, invoice: invoice2) }
    let!(:invoice_item6) { create(:invoice_item, unit_price: 200, quantity: 20, status: 0, item: item2, invoice: invoice2) }
    let!(:invoice_item7) { create(:invoice_item, unit_price: 300, quantity: 10, status: 0, item: item7, invoice: invoice2) }
    let!(:invoice_item8) { create(:invoice_item, unit_price: 400, quantity: 10, status: 0, item: item8, invoice: invoice2) }

    let!(:invoice_item9) { create(:invoice_item, unit_price: 100, quantity: 10, status: 0, item: item1, invoice: invoice3) }
    let!(:invoice_item10) { create(:invoice_item, unit_price: 200, quantity: 10, status: 0, item: item2, invoice: invoice3) }
    let!(:invoice_item11) { create(:invoice_item, unit_price: 300, quantity: 5, status: 0, item: item7, invoice: invoice3) }
    let!(:invoice_item12) { create(:invoice_item, unit_price: 400, quantity: 5, status: 0, item: item8, invoice: invoice3) }

    let!(:invoice_item13) { create(:invoice_item, unit_price: 400, quantity: 5, status: 0, item: item2, invoice: invoice4) }
    let!(:invoice_item14) { create(:invoice_item, unit_price: 400, quantity: 5, status: 0, item: item8, invoice: invoice4) }
    it "#best_discount returns the best discount" do
      expect(invoice_item1.best_discount).to eq(bulk_discount1)
      expect(invoice_item4.best_discount).to eq(bulk_discount8)
      expect(invoice_item14.best_discount).to eq(nil)
    end

    it "#discounted_price returns the discounted price or the original price" do
      expect(invoice_item1.adjusted_price).to eq(90)
      expect(invoice_item4.adjusted_price).to eq(300)
      expect(invoice_item14.adjusted_price).to eq(400)
    end
  end
end
