class CreateBurgers < ActiveRecord::Migration[6.0]
  def change
    create_table :burgers do |t|
      t.string :nombre
      t.integer :precio
      t.text :descripcion
      t.string :imagen

      t.timestamps
    end
  end
end
