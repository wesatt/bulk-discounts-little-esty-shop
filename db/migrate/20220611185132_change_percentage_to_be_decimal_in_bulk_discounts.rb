class ChangePercentageToBeDecimalInBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :percentage, :decimal, :precision => 3, :scale => 2
  end
end
