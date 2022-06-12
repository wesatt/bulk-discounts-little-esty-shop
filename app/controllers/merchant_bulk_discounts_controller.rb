class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    new_discount = BulkDiscount.new(bulk_discount_params)
    if new_discount.save
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/", notice: "Discount was created successfully."
    else
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/new", notice: "Necessary information was missing or invalid. Discount not created."
    end
  end

private
  def bulk_discount_params
    full_params = params.require(:bulk_discount).permit(
      :percentage,
      :quantity_threshold
    )
    full_params[:merchant_id] = params[:merchant_id]
    full_params
  end
end
