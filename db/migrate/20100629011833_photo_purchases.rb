class PhotoPurchases < ActiveRecord::Migration
  def self.up
    add_column :photos, :style, :string
    add_column :photos, :product, :string
    add_column :photos, :comments, :string
  end

  def self.down
    remove_column :photos, :style
    remove_column :photos, :product
    remove_column :photos, :comments
  end
end
