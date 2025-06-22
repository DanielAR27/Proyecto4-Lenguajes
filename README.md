# Sistema de Facturación - Ruby on Rails

Sistema completo de facturación desarrollado con Ruby on Rails para la gestión de inventario, emisión de facturas y reportes de ventas.

## Características Implementadas

- ✅ CRUD completo de productos
- ✅ Gestión de inventario con alertas de stock bajo
- ✅ Activar/Desactivar productos
- ✅ Filtros por nombre y categoría
- ✅ Paginación manual
- ✅ Interfaz Bootstrap responsiva
- ✅ Base de datos PostgreSQL

## Pendiente

- Sistema de facturación
- Cálculo de impuestos
- Generación de PDF
- Reportes

## Requisitos

- Ruby 3.x
- Rails 8.0.2
- PostgreSQL
- Node.js (para asset pipeline)

## Instalación

1. **Clonar el repositorio**
```bash
git clone [URL_DEL_REPOSITORIO]
cd sistema_facturacion
```

2. **Instalar dependencias**
```bash
bundle install
```

3. **Configurar variables de entorno**
Crear archivo `.env` en la raíz del proyecto:
```
POSTGRES_USER=tu_usuario
POSTGRES_PASSWORD=tu_contraseña
```

4. **Crear la base de datos**
```bash
dotenv rails db:create
```

5. **Ejecutar migraciones**
```bash
rails db:migrate
```
> Nota: En caso de equivocarse, puede utilizar el comando  `rails db:rollback`.

6. **Inicializar algunos datos**

```bash
rails db:seed
```

7. **Iniciar el servidor**
```bash
rails server
```

La aplicación estará disponible en `http://localhost:3000`

## Estructura del Proyecto

- **Productos**: Gestión completa de inventario con código único, precio, stock y categorías
- **Alertas**: Sistema de notificaciones para productos con stock bajo
- **Filtros**: Búsqueda por nombre y filtrado por categorías
- **Paginación**: Navegación eficiente a través de grandes listas de productos

## Tecnologías Utilizadas

- **Backend**: Ruby on Rails 8.0.2
- **Base de datos**: PostgreSQL
- **Frontend**: Bootstrap 5, Font Awesome
- **Paginación**: Implementación manual personalizada

## Diseño e Interfaz
El proyecto utiliza Bootstrap 5 como framework CSS para lograr una interfaz moderna y responsive. Se integra mediante CDN en el layout principal (app/views/layouts/application.html.erb), lo que proporciona:

- Componentes responsivos: Tablas, formularios, botones y navegación que se adaptan automáticamente a diferentes tamaños de pantalla
- Sistema de grid: Layout de 12 columnas que organiza el contenido de manera consistente
- Iconografía: Font Awesome para iconos intuitivos en botones y navegación
- Alertas y notificaciones: Sistema de mensajes flash estilizado con colores semánticos
- Formularios: Validación visual con estados de error/éxito
- Paginación: Controles de navegación estilizados para listas largas

La paleta de colores sigue las convenciones de Bootstrap (azul primario, verde éxito, rojo peligro, etc.) para mantener una experiencia de usuario familiar y profesional.

## Comandos Útiles

```bash
# Crear un nuevo producto desde consola
rails console
Product.create(name: "Producto Test", price: 1000, stock: 50)

# Ver rutas disponibles
rails routes

# Ejecutar tests (cuando estén implementados)
rails test
```

## Contribución

Este es un proyecto académico para el curso de Programación Orientada a Objetos.

## Licencia

Proyecto académico - TEC 2025