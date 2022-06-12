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
      redirect_to merchant_bulk_discounts_path, notice: "Discount was created successfully."
    else
      redirect_to new_merchant_bulk_discount_path, notice: "Necessary information was missing or invalid. Discount not created."
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    if discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path, notice: "Discount was updated successfully."
    else
      redirect_to edit_merchant_bulk_discount_path, notice: "Necessary information was missing or invalid. Discount not updated."
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
