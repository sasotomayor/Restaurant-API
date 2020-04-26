class BurgersIngredients < ActiveRecord::Migration[6.0]
  def change
    create_join_table :burgers_ingredients do |t|
      t.index :burger_id, optional: true
      t.index :ingredient_id, optional: true
    end
  end
end
