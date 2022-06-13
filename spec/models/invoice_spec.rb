require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values(['in progress', 'completed', 'cancelled']) }
  end

  describe "Group Project Methods" do

    let!(:merchant1) { create(:merchant) }
    let!(:customer1) { create(:customer) }

    let!(:item1) { create(:item, merchant: merchant1) }
    let!(:item2) { create(:item, merchant: merchant1) }

    let!(:invoices) { create_list(:invoice, 4, customer: customer1, created_at: "2022-03-10 00:54:09 UTC") }

    let!(:transaction1) { create(:transaction, invoice: invoices[0], result: 1) }

    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 20, status: 2) }
    let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 20, status: 1) }
    let!(:invoice_item3) { create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 20, status: 0) }
    let!(:invoice_item4) { create(:invoice_item, item: item2, invoice: invoices[2], unit_price: 2524, quantity: 20, status: 1) }
    let!(:invoice_item5) { create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 20, status: 2) }

    describe '#instance methods' do
      it '#total_revenue returns total revenue of an invoice' do
        expect(invoices[0].total_revenue).to eq('$1,107.00')
      end

      it 'formats the date correctly' do
        expect(invoices[0].formatted_date).to eq('Thursday, March 10, 2022')
      end
    end

    describe ".class methods" do
      it 'returns all invoices without a shipped status' do
        expect(Invoice.not_shipped).to eq([invoices[0], invoices[1], invoices[2]])
        expect(Invoice.not_shipped).to_not eq(invoices[3])
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
    
    it "#total_discounted_revenue returns the revenue of the whole invoice with discounts as applicable" do
      expect(invoice1.total_discounted_revenue).to eq("$137.00")
    end
  end
end
