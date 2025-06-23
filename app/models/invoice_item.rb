class InvoiceItem < ApplicationRecord
  # Relaciones
  belongs_to :invoice
  belongs_to :product
  belongs_to :tax_type
  
  # Validaciones
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :subtotal, :tax_amount, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Callbacks para cálculos automáticos
  before_validation :calculate_amounts
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  
  # Métodos de instancia
  def calculate_amounts
    return unless quantity.present? && unit_price.present? && tax_type.present?
    
    self.subtotal = quantity * unit_price
    self.tax_amount = subtotal * tax_type.percentage
    self.total = subtotal + tax_amount
  end
  
  def formatted_unit_price
    "₡#{unit_price.to_f.round(2)}"
  end
  
  def formatted_subtotal
    "₡#{subtotal.to_f.round(2)}"
  end
  
  def formatted_tax_amount
    "₡#{tax_amount.to_f.round(2)}"
  end
  
  def formatted_total
    "₡#{total.to_f.round(2)}"
  end
  
  # Información del impuesto aplicado
  def tax_description
    "#{tax_type.name} (#{tax_type.percentage_text})"
  end
end