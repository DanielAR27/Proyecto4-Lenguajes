class Product < ApplicationRecord
  # Relaciones
  has_many :stock_histories, dependent: :destroy
  # has_many :invoice_items, dependent: :restrict_with_error
  
  # Validaciones
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :code, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :min_stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes para consultas comunes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :low_stock, -> { where('stock <= min_stock') }
  scope :by_category, ->(category) { where(category: category) }

  # Callbacks
  before_validation :generate_code, if: :new_record?
  before_validation :normalize_name
  after_update :record_stock_change, if: :saved_change_to_stock?

  # Métodos de instancia
  def low_stock?
    stock <= min_stock
  end

  def stock_status
    return 'Sin stock' if stock == 0
    return 'Stock bajo' if low_stock?
    'Stock normal'
  end

  def stock_status_class
    return 'text-danger' if stock == 0
    return 'text-warning' if low_stock?
    'text-success'
  end

  def formatted_price
    "₡#{price.to_f.round(2)}"
  end

  def total_value
    price * stock
  end

  private

  def generate_code
    return if code.present?
    
    # Generar código basado en el nombre si no se proporciona
    base_code = name.to_s.upcase.gsub(/[^A-Z0-9]/, '')[0..5]
    counter = 1
    
    loop do
      potential_code = "#{base_code}#{counter.to_s.rjust(3, '0')}"
      break self.code = potential_code unless Product.exists?(code: potential_code)
      counter += 1
    end
  end

  def normalize_name
    self.name = name.to_s.strip.titleize if name.present?
  end
  
  def record_stock_change
    # Solo registrar si realmente cambió el stock
    old_stock_value = saved_change_to_stock[0] # Valor anterior
    new_stock_value = saved_change_to_stock[1] # Valor nuevo
    
    if old_stock_value != new_stock_value
      stock_histories.create!(
        old_stock: old_stock_value,
        new_stock: new_stock_value
      )
    end
  end
end