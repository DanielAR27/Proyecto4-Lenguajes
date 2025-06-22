class StockHistory < ApplicationRecord
  belongs_to :product
  
  # Validaciones
  validates :old_stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :new_stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Scopes para consultas comunes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_product, ->(product) { where(product: product) }
  
  # Métodos de instancia
  def stock_change
    new_stock - old_stock
  end
  
  def stock_change_text
    change = stock_change
    if change > 0
      "+#{change}"
    elsif change < 0
      change.to_s
    else
      "Sin cambio"
    end
  end
  
  def stock_change_class
    change = stock_change
    if change > 0
      'text-success'
    elsif change < 0
      'text-danger'
    else
      'text-muted'
    end
  end
end