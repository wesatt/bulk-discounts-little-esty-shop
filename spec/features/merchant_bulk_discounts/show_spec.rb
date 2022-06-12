require 'rails_helper'

RSpec.describe "bulk discounts show page" do
  describe "User Story: Merchant Bulk Discount Show" do
    let!(:merchant1) { create(:merchant, status: 1) }
    let!(:merchant2) { create(:merchant, status: 1) }

    let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
    let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.11, quantity_threshold: 11, merchant: merchant2) }
    let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant1) }
    let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.26, quantity_threshold: 21, merchant: merchant2) }
    # As a merchant
    # When I visit my bulk discount show page
    # Then I see the bulk discount's quantity threshold and percentage discount
    it "shows the bulk discount's quantity threshold and percentage discount" do
      visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount7.id}"

      expect(page).to have_content("Percentage Discount: 25%")
      expect(page).to have_content("Quantity Threshold: 20")
      expect(page).to_not have_content("Percentage Discount: 10%")
      expect(page).to_not have_content("Quantity Threshold: 10")
      expect(page).to_not have_content("11%")
      expect(page).to_not have_content("26%")
    end
  end
end
