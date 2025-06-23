class Invoice < ApplicationRecord
  # Relaciones
  has_many :invoice_items, dependent: :destroy
  
  # Validaciones
  validates :invoice_number, presence: true, uniqueness: true
  validates :client_name, presence: true
  validates :issue_date, presence: true
  validates :subtotal, :tax_amount, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[emitida pagada anulada] }
  
  # Callbacks
  before_validation :generate_invoice_number, if: :new_record?
  before_validation :set_issue_date, if: :new_record?
  after_update :handle_stock_changes, if: :saved_change_to_status?
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :emitidas, -> { where(status: 'emitida') }
  scope :pagadas, -> { where(status: 'pagada') }
  scope :anuladas, -> { where(status: 'anulada') }
  
  # Métodos de estado
  def emitida?
    status == 'emitida'
  end
  
  def pagada?
    status == 'pagada'
  end
  
  def anulada?
    status == 'anulada'
  end
  
  def can_be_edited?
    false # Por ahora no se pueden editar
  end
  
  def can_be_paid?
    emitida?
  end
  
  def can_be_cancelled?
    emitida? || pagada?
  end
  
  # Métodos de cálculo
  def calculate_totals!
    self.subtotal = invoice_items.sum(:subtotal)
    self.tax_amount = invoice_items.sum(:tax_amount)
    self.total = invoice_items.sum(:total)
    save!
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
  
  # Método para anular y devolver stock
  def cancel_and_restore_stock!
    return false unless can_be_cancelled?
    
    transaction do
      # Devolver stock de todos los items
      invoice_items.each do |item|
        product = item.product
        product.update!(stock: product.stock + item.quantity)
      end
      
      # Cambiar estado
      update!(status: 'anulada')
    end
  rescue => e
    Rails.logger.error "Error al anular factura #{invoice_number}: #{e.message}"
    false
  end
  
  private
  
  def generate_invoice_number
    return if invoice_number.present?
    
    # Generar número secuencial FAC-001, FAC-002, etc.
    last_invoice = Invoice.order(:id).last
    next_number = last_invoice ? last_invoice.id + 1 : 1
    self.invoice_number = "FAC-#{next_number.to_s.rjust(3, '0')}"
  end
  
  def set_issue_date
    self.issue_date = Date.current if issue_date.blank?
  end
  
  def handle_stock_changes
    # Solo necesario si implementamos lógica adicional al cambiar estados
    # Por ahora el stock se maneja manualmente en cancel_and_restore_stock!
  end
end