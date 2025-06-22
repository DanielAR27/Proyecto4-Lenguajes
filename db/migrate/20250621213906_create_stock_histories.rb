class CreateStockHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_histories do |t|
      t.references :product, null: false, foreign_key: true, index: true
      t.integer :old_stock, null: false
      t.integer :new_stock, null: false
      t.timestamps
    end

    # Índice adicional para created_at (el de product_id ya se crea automáticamente)
    add_index :stock_histories, :created_at
  end
end