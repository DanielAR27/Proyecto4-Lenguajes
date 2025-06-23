class TaxType < ApplicationRecord
  # Relaciones
  has_many :invoice_items, dependent: :restrict_with_error
  
  # Validaciones
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
  validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  
  # Métodos de instancia
  def percentage_text
    "#{(percentage * 100).round(2)}%"
  end
  
  def formatted_name
    "#{name} (#{percentage_text})"
  end

  def can_be_deleted?
    invoice_items.empty?
  end

  def invoices_count
    invoice_items.joins(:invoice).distinct.count('invoices.id')
  end
end