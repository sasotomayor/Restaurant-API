class BurgersIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :burgers_ingredients, :id => false do |t|
      t.integer :burger_id
      t.integer :ingredient_id
    end
  end
end
