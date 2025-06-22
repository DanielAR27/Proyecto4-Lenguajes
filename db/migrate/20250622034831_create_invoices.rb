class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false
      t.string :client_name, null: false
      t.string :client_email
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :total, precision: 10, scale: 2, default: 0.0
      t.date :issue_date, null: false
      t.string :status, default: 'emitida'
      t.timestamps
    end

    # Índices
    add_index :invoices, :invoice_number, unique: true
    add_index :invoices, :issue_date
    add_index :invoices, :status
  end
end