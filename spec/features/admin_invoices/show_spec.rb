require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page', type: :feature do
  describe "Group Project Tests" do
    let!(:merchant1) { create(:merchant) }

    let!(:item1) { create(:item, merchant: merchant1) }
    let!(:item2) { create(:item, merchant: merchant1) }

    let!(:customer1) { create(:customer) }

    let!(:invoice1) { create(:invoice, customer: customer1, status: 0) }

    let!(:transaction1) { create(:transaction, invoice: invoice1, result: 1) }

    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011) }
    let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524) }
    it 'lists invoice attributes' do
      visit "/admin/invoices/#{invoice1.id}"
      # expect(page).to have_content("Status: #{invoice1.status}")
      expect(page).to have_content("Invoice ##{invoice1.id}")
      expect(page).to have_content("Created on: #{invoice1.created_at.strftime('%A, %B %d, %Y')}")
      expect(page).to have_content("#{invoice1.customer.first_name} #{invoice1.customer.last_name}")
    end

    it 'lists items on the invoice' do
      visit "/admin/invoices/#{invoice1.id}"
      within '#itemtable' do
        expect(page).to have_content('Item Name')
        expect(page).to have_content('Unit Price')
        expect(page).to have_content('Status')
        expect(page).to have_content('Quantity')
      end

      within "#invoice-item-#{invoice_item1.id}" do
        expect(page).to have_text(item1.name.to_s)
        expect(page).to have_text('$30.11')
        expect(page).to have_text(invoice_item1.quantity.to_s)
        expect(page).to have_text(invoice_item1.status.to_s)
      end
    end

    it 'shows total revenue that will be generated from this invoice' do
      visit "/admin/invoices/#{invoice1.id}"

      expect(page).to have_content('Total Revenue: $55.35')
    end

    it 'has a select field to update invoice status' do
      visit "/admin/invoices/#{invoice1.id}"

      expect(invoice1.status).to eq('in progress')

      have_select :status,
                  selected: 'in progress',
                  options: ['in progress', 'completed', 'cancelled']

      select 'completed', from: :status
      click_button 'Update Invoice Status'

      expect(current_path).to eq("/admin/invoices/#{invoice1.id}")
      invoice1.reload
      expect(invoice1.status).to eq('completed')

      have_select :status,
                  selected: 'completed',
                  options: ['in progress', 'completed', 'cancelled']
    end
  end

  describe "Solo Project Tests" do
    describe "Admin Invoice Show Page: Total Revenue and Discounted Revenue" do
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
      # As an admin
      # When I visit an admin invoice show page
      # Then I see the total revenue from this invoice (not including discounts)
      # And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
      it "shows the total non-discounted and discounted revenues for an entire invoice" do
        visit "/admin/invoices/#{invoice1.id}"

        expect(page).to have_content("Total Revenue (excluding discounts): $170.00")
        expect(page).to have_content("Total Adjusted Revenue (including discounts): $137.00")

        visit "/admin/invoices/#{invoice3.id}"

        expect(page).to have_content("Total Revenue (excluding discounts): $75.00")
        expect(page).to have_content("Total Adjusted Revenue (including discounts): $61.00")
      end
    end
  end
end
