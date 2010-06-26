class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :customer_id, :null => false
      t.string :file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
