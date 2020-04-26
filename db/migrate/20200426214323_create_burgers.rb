class CreateBurgers < ActiveRecord::Migration[6.0]
  def change
    create_table :burgers do |t|
      t.string :name
      t.integer :price
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
