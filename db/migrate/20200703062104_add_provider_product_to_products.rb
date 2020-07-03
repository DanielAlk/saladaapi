class AddProviderProductToProducts < ActiveRecord::Migration
  def change
    add_column :products, :provider_product, :boolean, default: false
  end
end
