class AdminMerchantsController < ApplicationController
  def index
    @merchant = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    if merchant.update(params[:name])
    redirect_to "/admin/merchants/#{merchant.id}"
    end
  end
end
