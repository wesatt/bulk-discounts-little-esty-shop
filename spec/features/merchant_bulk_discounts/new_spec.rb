require 'rails_helper'

RSpec.describe "bulk discounts new (create) page" do
  describe "User story: Merchant Bulk Discount Create" do
    let!(:merchant1) { create(:merchant, status: 1) }
    let!(:merchant2) { create(:merchant, status: 1) }

    let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
    let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.11, quantity_threshold: 11, merchant: merchant2) }
    let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant1) }
    let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.26, quantity_threshold: 21, merchant: merchant2) }
    # As a merchant
    # When I visit my bulk discounts index
    # Then I see a link to create a new discount
    # When I click this link
    # Then I am taken to a new page where I see a form to add a new bulk discount
    # When I fill in the form with valid data
    # Then I am redirected back to the bulk discount index
    # And I see my new bulk discount listed
    it "is linked from the bulk discounts index page" do
      visit "/merchants/#{merchant1.id}/bulk_discounts"

      click_link "Create A New Discount"

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/new")
    end

    it "can create a new discount" do
      visit "/merchants/#{merchant1.id}/bulk_discounts"
      expect(page).to_not have_content("15%")
      expect(page).to_not have_content(15)
      click_link "Create A New Discount"

      fill_in('bulk_discount[percentage]', with: 0.15)
      fill_in('bulk_discount[quantity_threshold]', with: 15)
      click_on 'Create Discount'

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts")
      expect(page).to have_content("15%")
      expect(page).to have_content(15)
    end

    it "returns an error if necessary info is missing" do
      visit "/merchants/#{merchant1.id}/bulk_discounts/new"
      expect(page).to have_content("For percentage, please enter a number between 0.01(1%) and 0.99(99%)")
      expect(page).to_not have_content("Necessary information was missing or invalid. Discount not created.")

      fill_in('bulk_discount[percentage]', with: 0.15)
      fill_in('bulk_discount[quantity_threshold]', with: "")
      click_on 'Create Discount'

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/new")
      expect(page).to have_content("Necessary information was missing or invalid. Discount not created.")
    end

    it "returns an error if necessary info is invalid" do
      visit "/merchants/#{merchant1.id}/bulk_discounts/new"
      expect(page).to have_content("For percentage, please enter a number between 0.01(1%) and 0.99(99%)")
      expect(page).to_not have_content("Necessary information was missing or invalid. Discount not created.")

      fill_in('bulk_discount[percentage]', with: 15)
      fill_in('bulk_discount[quantity_threshold]', with: 20)
      click_on 'Create Discount'

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/new")
      expect(page).to have_content("Necessary information was missing or invalid. Discount not created.")
    end
  end
end
