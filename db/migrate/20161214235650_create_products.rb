class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :code
      t.string :keyword
      t.string :department

      t.timestamps null: false
    end
  end
end
