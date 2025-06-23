class HomeController < ApplicationController
  def index
    # Estadísticas básicas
    @total_products = Product.count
    @active_products = Product.active.count
    @low_stock_products = Product.low_stock.count
    
    @total_invoices = Invoice.count
    @invoices_emitidas = Invoice.emitidas.count
    @invoices_pagadas = Invoice.pagadas.count
    @invoices_anuladas = Invoice.anuladas.count
    
    @total_tax_types = TaxType.count
    @active_tax_types = TaxType.active.count
    
    # Estadísticas de facturación
    @total_sales = Invoice.where.not(status: 'anulada').sum(:total)
    @sales_this_month = Invoice.where(
      issue_date: Date.current.beginning_of_month..Date.current.end_of_month
    ).where.not(status: 'anulada').sum(:total)
    
    # Productos más vendidos (top 5)
    @top_products = Product.joins(:invoice_items)
                           .joins("JOIN invoices ON invoice_items.invoice_id = invoices.id")
                           .where("invoices.status != 'anulada'")
                           .group("products.id, products.name")
                           .order("SUM(invoice_items.quantity) DESC")
                           .limit(5)
                           .sum("invoice_items.quantity")
    
    # Valor total del inventario
    @inventory_value = Product.active.sum("price * stock")
    
    # Facturas recientes (últimas 5)
    @recent_invoices = Invoice.recent.limit(5)
  end
end