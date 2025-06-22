class Invoice < ApplicationRecord
  # Relaciones
  has_many :invoice_items, dependent: :destroy
  
  # Validaciones
  validates :invoice_number, presence: true, uniqueness: true
  validates :client_name, presence: true
  validates :issue_date, presence: true
  validates :subtotal, :tax_amount, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Callbacks
  before_validation :generate_invoice_number, if: :new_record?
  before_validation :set_issue_date, if: :new_record?
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  
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
end