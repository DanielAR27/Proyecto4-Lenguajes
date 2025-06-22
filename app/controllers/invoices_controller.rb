class InvoicesController < ApplicationController
  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = 10
    
    # Calcular offset
    offset = (@page - 1) * @per_page
    
    @invoices = Invoice.recent
    
    # Filtros opcionales
    @invoices = @invoices.where('client_name ILIKE ?', "%#{params[:client_search]}%") if params[:client_search].present?
    @invoices = @invoices.where('invoice_number ILIKE ?', "%#{params[:invoice_search]}%") if params[:invoice_search].present?
    
    # Contar total para paginación
    @total_invoices = @invoices.count
    @total_pages = (@total_invoices.to_f / @per_page).ceil
    
    # Aplicar paginación
    @invoices = @invoices.limit(@per_page).offset(offset)
  end

  def new
    # Por ahora solo redirigir de vuelta
    redirect_to invoices_path, notice: 'Funcionalidad en desarrollo'
  end

  def create
    # Por ahora solo redirigir de vuelta
    redirect_to invoices_path, notice: 'Funcionalidad en desarrollo'
  end
end