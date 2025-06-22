# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Crear tipos de impuestos básicos para Costa Rica
puts "Creando tipos de impuestos..."

tax_types = [
  { name: "Exento", percentage: 0.0000 },
  { name: "IVA", percentage: 0.1300 },  # 13%
  { name: "Impuesto Selectivo", percentage: 0.2500 }  # 25% (ejemplo)
]

tax_types.each do |tax_type_data|
  tax_type = TaxType.find_or_create_by(name: tax_type_data[:name]) do |tt|
    tt.percentage = tax_type_data[:percentage]
    tt.active = true
  end
  
  puts "✓ #{tax_type.name}: #{(tax_type.percentage * 100).round(2)}%"
end

puts "Tipos de impuestos creados exitosamente!"
puts ""

# Crear algunos productos de ejemplo si no existen
if Product.count == 0
  puts "Creando productos de ejemplo..."
  
  products = [
    { name: "Laptop", code: "LAPTOP001", price: 500000, stock: 10, category: "Electrónicos" },
    { name: "Mouse", code: "MOUSE001", price: 15000, stock: 50, category: "Electrónicos" },
    { name: "Medicamento Genérico", code: "MED001", price: 3000, stock: 100, category: "Medicamentos" }
  ]
  
  products.each do |product_data|
    product = Product.create!(product_data)
    puts "✓ #{product.name} - #{product.formatted_price}"
  end
  
  puts "Productos de ejemplo creados!"
end