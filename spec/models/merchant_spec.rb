require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:bulk_discounts) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it {should define_enum_for(:status).with_values(["disabled", "enabled"])}
  end

  describe "group project methods" do
    let!(:merchants)  { create_list(:merchant, 6, status: 1) }
    let!(:merchants2) { create_list(:merchant, 2, status: 0)}

    let!(:customer1) { create(:customer, first_name: 'Luke', last_name: 'Skywalker')}
    let!(:customer2) { create(:customer, first_name: 'Padme', last_name: 'Amidala')}
    let!(:customer3) { create(:customer, first_name: 'Boba', last_name: 'Fett')}
    let!(:customer4) { create(:customer, first_name: 'Baby', last_name: 'Yoda')}
    let!(:customer5) { create(:customer, first_name: 'Darth', last_name: 'Vader')}
    let!(:customer6) { create(:customer, first_name: 'Obi', last_name: 'Wan Kenobi')}

    let!(:item1) { create(:item, merchant: merchants[0], status: 1) }
    let!(:item2) { create(:item, merchant: merchants[1], status: 1) }
    let!(:item3) { create(:item, merchant: merchants[2], status: 1) }
    let!(:item4) { create(:item, merchant: merchants[3], status: 1) }
    let!(:item5) { create(:item, merchant: merchants[4], status: 1) }
    let!(:item6) { create(:item, merchant: merchants[5], status: 1) }

    let!(:invoice1) { create(:invoice, customer: customer1, created_at: "2012-03-10 00:54:09 UTC") }
    let!(:invoice2) { create(:invoice, customer: customer2, created_at: "2013-03-10 00:54:09 UTC") }
    let!(:invoice3) { create(:invoice, customer: customer3, created_at: "2014-03-10 00:54:09 UTC") }
    let!(:invoice4) { create(:invoice, customer: customer4, created_at: "2014-03-10 00:54:09 UTC") }
    let!(:invoice5) { create(:invoice, customer: customer5, created_at: "2014-03-10 00:54:09 UTC") }
    let!(:invoice6) { create(:invoice, customer: customer6, created_at: "2014-03-10 00:54:09 UTC") }

    let!(:transaction1) { create(:transaction, invoice: invoice1, result: 0) }
    let!(:transaction2) { create(:transaction, invoice: invoice1, result: 0) }
    let!(:transaction3) { create(:transaction, invoice: invoice2, result: 1) }
    let!(:transaction4) { create(:transaction, invoice: invoice2, result: 0) }
    let!(:transaction5) { create(:transaction, invoice: invoice3, result: 1) }
    let!(:transaction6) { create(:transaction, invoice: invoice3, result: 1) }
    let!(:transaction7) { create(:transaction, invoice: invoice4, result: 0) }
    let!(:transaction8) { create(:transaction, invoice: invoice5, result: 0) }
    let!(:transaction9) { create(:transaction, invoice: invoice6, result: 0) }
    let!(:transaction10) { create(:transaction, invoice: invoice6, result: 0) }
    let!(:transaction11) { create(:transaction, invoice: invoice6, result: 0) }

    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, quantity: 12, unit_price: 100, status: 2) }
    let!(:invoice_item2) { create(:invoice_item, item: item1, invoice: invoice3, quantity: 6, unit_price: 4, status: 1) }
    let!(:invoice_item3) { create(:invoice_item, item: item2, invoice: invoice1, quantity: 3, unit_price: 200, status: 0) }
    let!(:invoice_item4) { create(:invoice_item, item: item2, invoice: invoice2, quantity: 22, unit_price: 200, status: 2) }
    let!(:invoice_item5) { create(:invoice_item, item: item3, invoice: invoice3, quantity: 5, unit_price: 300, status: 1) }
    let!(:invoice_item6) { create(:invoice_item, item: item3, invoice: invoice1, quantity: 63, unit_price: 400, status: 0) }
    let!(:invoice_item7) { create(:invoice_item, item: item4, invoice: invoice2, quantity: 16, unit_price: 500, status: 2) }
    let!(:invoice_item8) { create(:invoice_item, item: item4, invoice: invoice3, quantity: 1, unit_price: 500, status: 1) }
    let!(:invoice_item9) { create(:invoice_item, item: item5, invoice: invoice2, quantity: 2, unit_price: 500, status: 0) }
    let!(:invoice_item10) { create(:invoice_item, item: item5, invoice: invoice1, quantity: 7, unit_price: 200, status: 2) }
    let!(:invoice_item11) { create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 100, status: 1) }
    let!(:invoice_item12) { create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 250, status: 0) }
    let!(:invoice_item13) { create(:invoice_item, item: item3, invoice: invoice1, quantity: 0, unit_price: 0, status: 0) }
    let!(:invoice_item14) { create(:invoice_item, item: item3, invoice: invoice2, quantity: 0, unit_price: 0, status: 1) }
    let!(:invoice_item15) { create(:invoice_item, item: item3, invoice: invoice3, quantity: 0, unit_price: 0, status: 1) }
    let!(:invoice_item16) { create(:invoice_item, item: item3, invoice: invoice4, quantity: 0, unit_price: 0, status: 0) }
    let!(:invoice_item17) { create(:invoice_item, item: item3, invoice: invoice5, quantity: 0, unit_price: 0, status: 0) }
    let!(:invoice_item18) { create(:invoice_item, item: item3, invoice: invoice6, quantity: 0, unit_price: 0, status: 1) }

    describe ".class methods" do
      it ".enabled returns only merchants with an enabled status" do
        # enums method
        expect(Merchant.enabled).to include(merchants[0])
        expect(Merchant.enabled).to include(merchants[1])
        expect(Merchant.enabled).to include(merchants[2])
        expect(Merchant.enabled).to include(merchants[3])
        expect(Merchant.enabled).to include(merchants[4])
        expect(Merchant.enabled).to include(merchants[5])
        expect(Merchant.enabled).to_not include(merchants2[0])
        expect(Merchant.enabled).to_not include(merchants2[1])
      end

      it ".disabled returns only merchants with a disabled status" do
        # enums method
        expect(Merchant.disabled).to include(merchants2[0])
        expect(Merchant.disabled).to include(merchants2[1])
        expect(Merchant.disabled).to_not include(merchants[0])
        expect(Merchant.disabled).to_not include(merchants[1])
        expect(Merchant.disabled).to_not include(merchants[2])
        expect(Merchant.disabled).to_not include(merchants[3])
        expect(Merchant.disabled).to_not include(merchants[4])
        expect(Merchant.disabled).to_not include(merchants[5])
      end

      it 'returns top five merchants by revenue' do
        expect(Merchant.top_5).to eq([merchants[2], merchants[3], merchants[1], merchants[4], merchants[0]])
        expect(Merchant.top_5).to_not eq(merchants[6])
      end

      it "returns the top 5 customers that have made the most purchases with successful transactions" do
        expected = [
          customer6,
          customer1,
          customer4,
          customer5,
          customer2
        ]
        expect(Merchant.top_5_customers).to eq(expected)
      end
    end

    describe '#instance methods' do
      it 'returns top 5 customers' do
        expect(merchants[2].top_5_customers).to eq([customer1, customer6, customer4, customer5, customer2])
      end

      it 'returns item names ordered, not shipped' do
        expect(merchants[0].ordered_not_shipped).to eq([invoice_item2])
        expect(merchants[5].ordered_not_shipped).to match_array([invoice_item11, invoice_item12])
      end
    end

    it "#best_day returns the merchants best selling day" do
      expect(merchants[0].best_day).to eq(invoice1.created_at.strftime("%m/%d/%y"))
      expect(merchants[1].best_day).to eq(invoice2.created_at.strftime("%m/%d/%y"))
      expect(merchants[2].best_day).to eq(invoice1.created_at.strftime("%m/%d/%y"))
      expect(merchants[3].best_day).to eq(invoice2.created_at.strftime("%m/%d/%y"))
      expect(merchants[4].best_day).to eq(invoice1.created_at.strftime("%m/%d/%y"))
    end
  end

  describe "solo project methods" do
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

    it "#invoice(invoice_id) can find a specific invoice by ID if it belongs to a merchant" do
      expect(merchant1.invoice(invoice1.id)).to eq(invoice1)
      expect(merchant1.invoice(invoice4.id)).to eq("This invoice does not belong to this merchant")
    end

    it "#inv_items_on_invoice(invoice_id) will only return invoice items on an invoice that match the merchant" do
      expect(merchant1.inv_items_on_invoice(invoice1.id)).to eq([invoice_item1, invoice_item3])
      # expect(merchant1.inv_items_on_invoice(invoice4.id)).to eq("This invoice does not belong to this merchant")
    end

    it "#total_invoice_revenue(invoice_id) returns the total revenue for a specific invoice" do
      expect(merchant1.total_invoice_revenue(invoice1.id)).to eq("$70.00")
      # expect(merchant1.total_invoice_revenue(invoice4.id)).to eq("This invoice does not belong to this merchant")
    end

    # it "#discounted_revenue(invoice_id) returns only the revenue discounted from this invoice" do
    #   expect(merchant1.discounted_revenue(invoice1.id)).to eq("$10.00")
    #   expect(merchant1.discounted_revenue(invoice4.id)).to eq("This invoice does not belong to this merchant")
    # end

    it "#total_discounted_revenue(invoice_id) returns the total discounted revenue for a specific invoice" do
      expect(merchant1.total_discounted_revenue(invoice1.id)).to eq("$60.00")
      # expect(merchant1.total_discounted_revenue(invoice4.id)).to eq("This invoice does not belong to this merchant")
    end

    # it "#invoice_discounts(invoice_id) returns all the discounts eligible for an invoice" do
    #   expect(merchant1.invoice_discounts(invoice1.id)).to eq([bulk_discount1, bulk_discount7])
    #   expect(merchant1.invoice_discounts(invoice4.id)).to eq("This invoice does not belong to this merchant")
    # end
  end
end
