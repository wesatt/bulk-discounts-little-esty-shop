require 'rails_helper'

RSpec.describe 'Update Merchant form' do
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

  describe 'edit form' do
    it "can fill out form and update merchant information" do
        visit edit_merchant_path(merchants[0].id)
        save_and_open_page
        fill_in('name', with: 'Cheese Fruit Cake')
        click_on('Submit')
        expect(current_path).to eq("/admin/merchants/#{merchants[0].id}")
        expect(page).to have_content("Cheese Fruit Cake")
    end
  end
end
