class InvoicesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :mark_as_paid, :cancel]

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = 5
    
    # Calcular offset
    offset = (@page - 1) * @per_page
    
    @invoices = Invoice.recent
    
    # Filtros opcionales
    @invoices = @invoices.where('client_name ILIKE ?', "%#{params[:client_search]}%") if params[:client_search].present?
    @invoices = @invoices.where('invoice_number ILIKE ?', "%#{params[:invoice_search]}%") if params[:invoice_search].present?
    @invoices = @invoices.by_status(params[:status]) if params[:status].present?
    
    # Contar total para paginación
    @total_invoices = @invoices.count
    @total_pages = (@total_invoices.to_f / @per_page).ceil
    
    # Aplicar paginación
    @invoices = @invoices.limit(@per_page).offset(offset)
  end

  def show
    # Cargar items para mostrar los productos
    @invoice_items = @invoice.invoice_items.includes(:product, :tax_type)
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf_content = generate_invoice_pdf
        send_data pdf_content, 
                filename: "factura-#{@invoice.invoice_number}.pdf",
                type: "application/pdf",
                disposition: "inline"
      end
    end
  end

  def new
    @invoice = Invoice.new
    # Construir un item vacío para el formulario
    @invoice.invoice_items.build
    
    # Cargar datos para los selects
    @products = Product.available_for_sale.order(:name)
    @tax_types = TaxType.active.order(:name)
  end

  def create
    @invoice = Invoice.new(invoice_params)
    
    if @invoice.save
      process_invoice_items
      @invoice.calculate_totals!
      redirect_to @invoice, notice: 'Factura creada exitosamente.'
    else
      # Recargar datos para el formulario
      @products = Product.available_for_sale.order(:name)
      @tax_types = TaxType.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Por ahora solo permitimos cambios de estado, no de contenido
    if params[:action_type] == 'mark_as_paid'
      mark_as_paid
    elsif params[:action_type] == 'cancel'
      cancel
    else
      redirect_to @invoice, alert: 'Acción no válida.'
    end
  end

  def destroy
    # Si la factura no está anulada, primero la anulamos para restaurar stock
    if !@invoice.anulada? && !@invoice.cancel_and_restore_stock!
      redirect_to @invoice, alert: 'No se pudo anular la factura antes de eliminarla.'
      return
    end
    
    # Una vez anulada (o si ya estaba anulada), eliminar la factura
    if @invoice.destroy
      redirect_to invoices_url, notice: 'Factura eliminada exitosamente.'
    else
      redirect_to @invoice, alert: 'No se pudo eliminar la factura.'
    end
  end

  # Marcar como pagada
  def mark_as_paid
    if @invoice.can_be_paid?
      @invoice.update!(status: 'pagada')
      redirect_to @invoice, notice: 'Factura marcada como pagada exitosamente.'
    else
      redirect_to @invoice, alert: 'Esta factura no se puede marcar como pagada.'
    end
  end

  # Anular factura
  def cancel
    if @invoice.cancel_and_restore_stock!
      redirect_to @invoice, notice: 'Factura anulada y stock restaurado exitosamente.'
    else
      redirect_to @invoice, alert: 'No se pudo anular la factura. Intente nuevamente.'
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:client_name, :client_email)
  end

  def process_invoice_items
    return unless params[:items].present?
    
    params[:items].each do |item_data|
      next unless item_data[:product_id].present? && item_data[:quantity].present?
      
      product = Product.find(item_data[:product_id])
      tax_type = TaxType.find(item_data[:tax_type_id])
      quantity = item_data[:quantity].to_i
      
      # Validar stock disponible
      unless product.can_sell?(quantity)
        raise "No hay suficiente stock para #{product.name}"
      end
      
      # Crear item de factura
      @invoice.invoice_items.create!(
        product: product,
        tax_type: tax_type,
        quantity: quantity,
        unit_price: product.price
      )
      
      # Descontar del stock
      product.update!(stock: product.stock - quantity)
    end
  rescue => e
    @invoice.destroy if @invoice.persisted?
    raise e
  end

  def generate_invoice_pdf
    Prawn::Document.new do |pdf|
      pdf.text "SISTEMA DE FACTURACIÓN", size: 20, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "FACTURA #{@invoice.invoice_number}", size: 16, style: :bold, align: :center
      pdf.move_down 20
      
      pdf.text "Cliente: #{@invoice.client_name}", size: 12
      pdf.text "Email: #{@invoice.client_email}" if @invoice.client_email.present?
      pdf.text "Fecha: #{@invoice.issue_date.strftime('%d/%m/%Y')}", size: 12
      pdf.text "Estado: #{@invoice.status.capitalize}", size: 12
      pdf.move_down 20
      
      # Tabla de productos
      table_data = [["Producto", "Precio Unit.", "Cantidad", "Impuesto", "Subtotal", "Total"]]
      
      @invoice.invoice_items.each do |item|
        table_data << [
          item.product.name,
          "CRC #{number_with_delimiter(item.unit_price)}",
          item.quantity.to_s,
          item.tax_type.formatted_name,
          "CRC #{number_with_delimiter(item.subtotal)}",
          "CRC #{number_with_delimiter(item.total)}"
        ]
      end
      
      pdf.table(table_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        self.cell_style = { size: 10, padding: 5 }
      end
      
      pdf.move_down 20
      pdf.text "Subtotal: CRC #{number_with_delimiter(@invoice.subtotal)}", size: 12, align: :right
      pdf.text "Impuestos: CRC #{number_with_delimiter(@invoice.tax_amount)}", size: 12, align: :right
      pdf.text "TOTAL: CRC #{number_with_delimiter(@invoice.total)}", size: 14, style: :bold, align: :right
    end.render
  end
end