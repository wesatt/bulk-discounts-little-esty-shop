require 'rails_helper'

RSpec.describe 'Merchant_Invoices Show Page', type: :feature do
  describe "Little Esty Shop group tests" do
    let!(:merchants) { create_list(:merchant, 2) }
    let!(:customers) { create_list(:customer, 6) }

    before :each do
      @items = merchants.flat_map do |merchant|
        create_list(:item, 2, merchant: merchant)
      end

      @invoices = customers.flat_map do |customer|
        create_list(:invoice, 2, customer: customer)
      end

      @transactions = @invoices.each_with_index.flat_map do |invoice, index|
        if index < 2
          create_list(:transaction, 2, invoice: invoice, result: 1)
        else
          create_list(:transaction, 2, invoice: invoice, result: 0)
        end
      end

    end
    let!(:invoice_item1) { create(:invoice_item, item: @items[0], invoice: @invoices[0], status: 0) }
    let!(:invoice_item2) { create(:invoice_item, item: @items[1], invoice: @invoices[1], status: 1) }
    let!(:invoice_item3) { create(:invoice_item, item: @items[0], invoice: @invoices[2], status: 1) }
    let!(:invoice_item4) { create(:invoice_item, item: @items[1], invoice: @invoices[3], status: 0) }
    let!(:invoice_item5) { create(:invoice_item, item: @items[0], invoice: @invoices[4], status: 0) }
    let!(:invoice_item6) { create(:invoice_item, item: @items[1], invoice: @invoices[5], status: 1) }
    let!(:invoice_item7) { create(:invoice_item, item: @items[0], invoice: @invoices[6], status: 1) }
    let!(:invoice_item8) { create(:invoice_item, item: @items[1], invoice: @invoices[7], status: 1) }
    let!(:invoice_item9) { create(:invoice_item, item: @items[0], invoice: @invoices[8], status: 1) }
    let!(:invoice_item10) { create(:invoice_item, item: @items[1], invoice: @invoices[9], status: 0) }
    let!(:invoice_item11) { create(:invoice_item, item: @items[0], invoice: @invoices[10], status: 2) }
    let!(:invoice_item12) { create(:invoice_item, item: @items[2], invoice: @invoices[11], status: 1) }
    let!(:invoice_item13) { create(:invoice_item, item: @items[2], invoice: @invoices[0], status: 1) }

    describe 'Merchant_Invoices User Story 2' do
      it "can display all information related to an invoice" do
        visit "/merchants/#{merchants[0].id}/invoices/#{@invoices[0].id}"

        expect(page).to have_content("Invoice: #{@invoices[0].id}")
        expect(page).to have_content("Status: #{@invoices[0].status}")
        expect(page).to have_content("Created on: #{@invoices[0].created_at.strftime("%A, %B %d, %Y")}")

        expect(page).to have_content("#{customers[0].first_name} #{customers[0].last_name}")
        expect(page).to_not have_content("#{customers[1].first_name} #{customers[1].last_name}")
      end
    end

    describe 'Merchant_Invoices User Story 3' do
      it 'can display items attributes that belongs to an invoice' do
        visit "/merchants/#{merchants[0].id}/invoices/#{@invoices[0].id}"

        within '#itemtable' do
          expect(page).to have_content("Item Name")
          expect(page).to have_content("Quantity")
          expect(page).to have_content("Unit Price")
          expect(page).to have_content("Status")
          expect(page).to have_content(@items[0].name)
          expect(page).to_not have_content(@items[3].name)
          expect(page).to have_content(invoice_item1.quantity)
          expect(page).to have_content(invoice_item1.unit_price_converted)
          expect(page).to_not have_content(invoice_item2.unit_price_converted)
          expect(page).to have_content(invoice_item1.status)
        end
      end
    end

    describe "User Story 4 - Merchant Invoice Show Page: Total Revenue" do
      it "shows the total revenue of all items on the invoice" do
        visit "/merchants/#{merchants[0].id}/invoices/#{@invoices[0].id}"

        expect(page).to have_content("Total Revenue: #{@invoices[0].total_revenue}")
      end
    end

    describe "User Story 5 - Merchant Invoice Show Page: Update Item Status" do
      it "has a select field button for invoice item's status and has a button to update the status" do
        visit "/merchants/#{merchants[0].id}/invoices/#{@invoices[0].id}"

        expect(invoice_item1.status).to eq("pending")

        within "#invoiceItem-#{invoice_item1.id}" do
          have_select :status,
          selected: "pending",
          options: ["pending", "packaged", "shipped"]

          select "packaged", from: :status
          click_button "Update Item Status"
        end

        expect(current_path).to eq("/merchants/#{merchants[0].id}/invoices/#{@invoices[0].id}")
        invoice_item1.reload
        expect(invoice_item1.status).to eq("packaged")

        within "#invoiceItem-#{invoice_item1.id}" do
          have_select :status,
          selected: "packaged",
          options: ["pending", "packaged", "shipped"]
        end
      end
    end
  end

  describe "User Story - Merchant Invoice Show Page: Total Revenue and Discounted Revenue" do
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
    # As a merchant
    # When I visit my merchant invoice show page
    # Then I see the total revenue for my merchant from this invoice (not including discounts)
    # And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
    it "shows the total non-discounted and discounted revenues for an invoice" do
      visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Total Revenue (excluding discounts): $7,000.00")
      expect(page).to have_content("Total Adjusted Revenue (including discounts): $6,000.00")

      visit "/merchants/#{merchant2.id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Total Revenue (excluding discounts): $10,000.00")
      expect(page).to have_content("Total Adjusted Revenue (including discounts): $7,700.00")
    end
  end
end
