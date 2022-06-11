require 'rails_helper'

RSpec.describe "bulk discounts index page" do
  describe "User story: Merchant Bulk Discounts Index" do
    let!(:merchant1) { create(:merchant, status: 1) }
    let!(:merchant2) { create(:merchant, status: 1) }
    let!(:merchant3) { create(:merchant, status: 1) }
    let!(:merchant4) { create(:merchant, status: 1) }
    let!(:merchant5) { create(:merchant, status: 1) }
    let!(:merchant6) { create(:merchant, status: 1) }

    let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
    let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.11, quantity_threshold: 11, merchant: merchant2) }
    let!(:bulk_discount3) { BulkDiscount.create(percentage: 0.12, quantity_threshold: 12, merchant: merchant3) }
    let!(:bulk_discount4) { BulkDiscount.create(percentage: 0.13, quantity_threshold: 13, merchant: merchant4) }
    let!(:bulk_discount5) { BulkDiscount.create(percentage: 0.14, quantity_threshold: 14, merchant: merchant5) }
    let!(:bulk_discount6) { BulkDiscount.create(percentage: 0.15, quantity_threshold: 15, merchant: merchant6) }
    let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant1) }
    let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.26, quantity_threshold: 21, merchant: merchant2) }
    let!(:bulk_discount9) { BulkDiscount.create(percentage: 0.27, quantity_threshold: 22, merchant: merchant3) }
    let!(:bulk_discount10) { BulkDiscount.create(percentage: 0.28, quantity_threshold: 23, merchant: merchant4) }
    let!(:bulk_discount11) { BulkDiscount.create(percentage: 0.29, quantity_threshold: 24, merchant: merchant5) }
    let!(:bulk_discount12) { BulkDiscount.create(percentage: 0.30, quantity_threshold: 25, merchant: merchant6) }
    # As a merchant
    # When I visit my merchant dashboard
    # Then I see a link to view all my discounts
    # When I click this link
    # Then I am taken to my bulk discounts index page
    # Where I see all of my bulk discounts including their
    # percentage discount and quantity thresholds
    # And each bulk discount listed includes a link to its show page
    it "is linked to from the merchant dashboard" do
      visit "/merchants/#{merchant1.id}/dashboard"

      click_link "View All Discounts"

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts")
    end

    it "shows all discounts for this merchant" do
      visit "/merchants/#{merchant1.id}/bulk_discounts"

      expect(page).to have_content("Percentage Discount")
      expect(page).to have_content("Quantity Threshold")
      expect(page).to_not have_content(11)
      expect(page).to_not have_content(30)

      within "#discount-#{bulk_discount1.id}" do
        expect(page).to have_link("##{bulk_discount1.id}")
        expect(page).to have_content("10%")
        expect(page).to have_content("10")
        expect(page).to_not have_content("25%")
        expect(page).to_not have_content("20")
      end

      within "#discount-#{bulk_discount7.id}" do
        expect(page).to have_link("##{bulk_discount7.id}")
        expect(page).to have_content("25%")
        expect(page).to have_content("20")
        expect(page).to_not have_content("10%")
        expect(page).to_not have_content("10")
      end
    end

    it "has links to each discount's show page" do
      visit "/merchants/#{merchant1.id}/bulk_discounts"
      click_link "##{bulk_discount1.id}"
      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}")

      visit "/merchants/#{merchant2.id}/bulk_discounts"
      click_link "##{bulk_discount8.id}"
      expect(current_path).to eq("/merchants/#{merchant2.id}/bulk_discounts/#{bulk_discount8.id}")
    end
  end
end
