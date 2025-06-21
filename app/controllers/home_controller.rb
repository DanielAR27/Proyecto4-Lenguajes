class HomeController < ApplicationController
  def index
    # Método para la página principal
    @mensaje = "¡Hola Mundo! - Sistema de Facturación"
    @descripcion = "Bienvenido al proyecto de facturación con Ruby on Rails"
  end
end