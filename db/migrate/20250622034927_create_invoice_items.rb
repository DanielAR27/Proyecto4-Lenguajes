class CreateInvoiceItems < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true, index: true
      t.references :product, null: false, foreign_key: true, index: true
      t.references :tax_type, null: false, foreign_key: true, index: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :tax_amount, precision: 10, scale: 2, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
      t.timestamps
    end

    # Índice adicional
    add_index :invoice_items, :created_at
  end
end