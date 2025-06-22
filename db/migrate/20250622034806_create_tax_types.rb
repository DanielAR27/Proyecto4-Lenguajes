class CreateTaxTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :tax_types do |t|
      t.string :name, null: false
      t.decimal :percentage, precision: 5, scale: 4, null: false # Ej: 0.1300 para 13%
      t.boolean :active, default: true
      t.timestamps
    end

    # Índices
    add_index :tax_types, :active
  end
end