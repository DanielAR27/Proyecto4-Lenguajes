class TaxTypesController < ApplicationController
  before_action :set_tax_type, only: [:show, :edit, :update, :destroy, :toggle_status]

  # GET /tax_types
  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = 10
    
    # Calcular offset
    offset = (@page - 1) * @per_page
    
    @tax_types = TaxType.all.order(:name)
    
    # Filtro opcional por nombre
    @tax_types = @tax_types.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    
    # Contar total para paginación
    @total_tax_types = @tax_types.count
    @total_pages = (@total_tax_types.to_f / @per_page).ceil
    
    # Aplicar paginación
    @tax_types = @tax_types.limit(@per_page).offset(offset)
  end

  # GET /tax_types/1
  def show
  end

  # GET /tax_types/new
  def new
    @tax_type = TaxType.new
  end

  # GET /tax_types/1/edit
  def edit
  end

  # POST /tax_types
  def create
    @tax_type = TaxType.new(tax_type_params)

    if @tax_type.save
      redirect_to @tax_type, notice: 'Tipo de impuesto creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tax_types/1
  def update
    if @tax_type.update(tax_type_params)
      redirect_to @tax_type, notice: 'Tipo de impuesto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tax_types/1
  def destroy
    @tax_type.destroy
    redirect_to tax_types_url, notice: 'Tipo de impuesto eliminado exitosamente.'
  end

  # PATCH /tax_types/1/toggle_status
  def toggle_status
    @tax_type.update(active: !@tax_type.active)
    status_text = @tax_type.active? ? "activado" : "desactivado"
    redirect_to @tax_type, notice: "Tipo de impuesto #{status_text} exitosamente."
  end

  private

  def set_tax_type
    @tax_type = TaxType.find(params[:id])
  end

  def tax_type_params
    params.require(:tax_type).permit(:name, :percentage, :active)
  end
end