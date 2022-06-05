class Admin::MerchantsController < ApplicationController
  def index
    @merchant = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    # binding.pry
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    # if merchant.update(params[:name])
    # redirect_to "/admin/merchants/#{merchant.id}"
    # end
  end
end
