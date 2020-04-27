class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :nombre
      t.text :descripcion

      t.timestamps
    end
  end
end
