class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :email, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
