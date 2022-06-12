require 'rails_helper'

RSpec.describe "bulk discounts edit page" do
  describe "User Story: Merchant Bulk Discount Edit" do
    let!(:merchant1) { create(:merchant, status: 1) }
    let!(:merchant2) { create(:merchant, status: 1) }

    let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
    let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.11, quantity_threshold: 11, merchant: merchant2) }
    let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant1) }
    let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.26, quantity_threshold: 21, merchant: merchant2) }
    # As a merchant
    # When I visit my bulk discount show page
    # Then I see a link to edit the bulk discount
    # When I click this link
    # Then I am taken to a new page with a form to edit the discount
    # And I see that the discounts current attributes are pre-poluated in the form
    # When I change any/all of the information and click submit
    # Then I am redirected to the bulk discount's show page
    # And I see that the discount's attributes have been updated
    it "is linked from the bulk discounts show page" do
      visit "/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}"
      click_link("Change This Discount")

      expect(current_path).to eq("/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}/edit")
    end

    it "has an editable form with fields pre-poluated with current data" do
      visit "/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}"
      expect(page).to_not have_content("Percentage Discount: 30%")
      expect(page).to_not have_content("Quantity Threshold: 20")
      click_link("Change This Discount")

      expect(page).to have_field(:percentage, with: 0.26)
      expect(page).to have_field(:quantity_threshold, with: 21)
      expect(page).to have_content("For percentage, please enter a number between 0.01(1%) and 0.99(99%)")

      fill_in('bulk_discount[percentage]', with: 0.30)
      fill_in('bulk_discount[quantity_threshold]', with: 20)
      click_on 'Update Discount'

      expect(current_path).to eq("/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}")
      expect(page).to have_content("Percentage Discount: 30%")
      expect(page).to have_content("Quantity Threshold: 20")
    end

    it "returns an error if necessary info is missing" do
      visit "/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}/edit"
      expect(page).to have_content("For percentage, please enter a number between 0.01(1%) and 0.99(99%)")
      expect(page).to_not have_content("Necessary information was missing or invalid. Discount not updated.")

      fill_in('bulk_discount[percentage]', with: 0.15)
      fill_in('bulk_discount[quantity_threshold]', with: "")
      click_on 'Update Discount'

      expect(current_path).to eq("/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}/edit")
      expect(page).to have_content("Necessary information was missing or invalid. Discount not updated.")
    end

    it "returns an error if necessary info is invalid" do
      visit "/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}/edit"
      expect(page).to have_content("For percentage, please enter a number between 0.01(1%) and 0.99(99%)")
      expect(page).to_not have_content("Necessary information was missing or invalid. Discount not updated.")

      fill_in('bulk_discount[percentage]', with: 0.15)
      fill_in('bulk_discount[quantity_threshold]', with: 1.20)
      click_on 'Update Discount'

      expect(current_path).to eq("/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}/edit")
      expect(page).to have_content("Necessary information was missing or invalid. Discount not updated.")
    end
  end
end
