class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :code, null: false # Identificador único 
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0
      t.integer :min_stock, default: 5 # Para alertas de stock bajo
      t.text :description
      t.boolean :active, default: true
      t.string :category # Para organizar productos

      t.timestamps
    end

    # Índices para mejor rendimiento
    add_index :products, :code, unique: true
    add_index :products, :active
    add_index :products, :category
  end
end