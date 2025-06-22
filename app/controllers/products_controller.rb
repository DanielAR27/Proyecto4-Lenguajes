class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle_status, :stock_history]

  # GET /products
  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = 1
    
    # Calcular offset
    offset = (@page - 1) * @per_page
    
    @products = Product.all.order(:name)
    
    # Filtros opcionales
    @products = @products.where('name ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    @products = @products.by_category(params[:category]) if params[:category].present?
    
    # Contar total para paginación
    @total_products = @products.count
    @total_pages = (@total_products.to_f / @per_page).ceil
    
    # Aplicar paginación
    @products = @products.limit(@per_page).offset(offset)
    
    @categories = Product.active.distinct.pluck(:category).compact.sort
    @low_stock_count = Product.low_stock.count
  end

  # GET /products/1/stock_history
  def stock_history
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = 1
    
    # Calcular offset
    offset = (@page - 1) * @per_page
    
    # Obtener historial del producto específico
    @stock_histories = @product.stock_histories.recent
    
    # Contar total para paginación
    @total_histories = @stock_histories.count
    @total_pages = (@total_histories.to_f / @per_page).ceil
    
    # Aplicar paginación
    @stock_histories = @stock_histories.limit(@per_page).offset(offset)
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Producto creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Producto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url,  notice: 'Se ha borrado el producto exitosamente.'
  end

  # GET /products/low_stock
  def low_stock
    @products = Product.low_stock.active.order(:stock, :name)
  end

  # PATCH /products/1/toggle_status
  def toggle_status
    @product = Product.find(params[:id])
    @product.update(active: !@product.active)

    status_text = @product.active? ? "activado" : "desactivado"
    redirect_to @product, notice: "Producto #{status_text} exitosamente."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :code, :price, :stock, :min_stock, :description, :category, :active)
  end
end