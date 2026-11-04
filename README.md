# Playas Canarias - My Portfolio

Aplicación Flutter desarrollada para la asignatura **Programación Multimedia y Dispositivos Móviles (PGL)**. Portfolio personal con navegación mediante menú lateral (Drawer) y gestión de rutas con `go_router`.

## Características

- **Menú lateral (Drawer)** - Navegación entre las distintas pantallas de la aplicación
- **Pantalla de Bienvenida** - Pantalla principal con imagen de fondo, saludo personalizado, buscador y barra de navegación inferior
- **Pantalla de Portfolio** - Sección personal con información del alumno, lista de hobbies interactivos y repositorio GitHub
- **Hobbies interactivos** - Grid con 8 hobbies diferentes; al pulsar "Los gatos" accede a una galería de memes
- **Galería de memes** - Pantalla con gifs de gatos programadores cargados desde Giphy
- **Código QR** - Generado con `qr_flutter` que enlaza al perfil de GitHub
- **CRUD de playas** - Lista dinámica con alta desde un `Dialog`, imagen por URL o galería, categoría, limpieza, aforo aproximado, borrado individual, borrado total protegido y contador
- **Navegación con GoRouter** - Rutas centralizadas (`/bienvenida`, `/portfolio` y `/elementos`)

## Tecnologías utilizadas

- [Flutter](https://flutter.dev/) - SDK ^3.13.5
- [Material Design 3](https://m3.material.io/)
- [go_router](https://pub.dev/packages/go_router) ^16.2.1 - Navegación declarativa
- [qr_flutter](https://pub.dev/packages/qr_flutter) ^4.1.0 - Generación de códigos QR
- [image_picker](https://pub.dev/packages/image_picker) ^1.2.4 - Selección segura de imágenes

## Estructura del proyecto

```text
lib/
├── main.dart                # Punto de entrada y configuración de la app
├── router/
│   └── app_router.dart      # Configuración de rutas con go_router
├── widgets/
│   └── app_drawer.dart      # Menú lateral de navegación
└── pages/
    ├── welcome_page.dart     # Pantalla de bienvenida
    ├── portfolio_page.dart   # Pantalla de portfolio (perfil, hobbies, repositorio y memes)
    └── crud_playas_page.dart # CRUD de playas y formulario modal
```

## Recursos

### Imágenes locales

- `assets/images/home_bg.jpg` - Imagen de fondo de la pantalla de bienvenida
- `assets/images/Sandi_proto.jpg` - Imagen de Sandi Proto en la sección de repositorio

### Datos

- Avatar cargado desde `https://github.com/Catsandi06.png`
- Código QR apunta a `https://github.com/Catsandi06/`
- Memes cargados desde [Giphy](https://giphy.com/)

## Pantallas

### Pantalla de Bienvenida

Pantalla principal con fondo de playa, menú hamburguesa para abrir el drawer, tarjeta "Limpieza", saludo, buscador de playas y barra de navegación inferior.

### Menú Lateral (Drawer)

Muestra información del usuario (Nichel Morales Hernández - USR3742), avatar de GitHub e icono de la app. Permite navegar entre "Bienvenida", "Portfolio" y "Mis elementos".

### Pantalla de Mis playas

La opción **Mis elementos** del Drawer abre una lista dinámica construida con
`ListView.builder`. El botón **Añadir playa** muestra un `showDialog` con un
`Form` que valida nombre, descripción breve, categoría, URL de imagen o imagen
seleccionada desde la galería, limpieza y aforo aproximado. Las imágenes
seleccionadas se limitan a 10 MB y se validan por firma binaria para aceptar
solo JPEG, PNG o WebP; se guardan en memoria, sin usar rutas o nombres
controlados por el usuario. Al guardar, el diálogo devuelve una instancia de
`Beach` con `Navigator.pop` y la pantalla la añade al estado mediante
`setState`. Cada fila muestra la imagen, el estado de limpieza y el número de
personas aproximado, además de tener un botón de borrado y un marcador con el
total de playas.

### Pantalla de Portfolio

- **Cabecera**: Título "Portfolio"
- **Perfil**: Avatar y descripción del alumno
- **Pestañas**: "Mis hobbies" y "Mi repositorio" con `NavigationBar`
- **Hobbies**: Grid con 8 hobbies diferentes (Informática, Música, Gatos, Consolas retro, Furry, Coches, Impresión 3D, Viajes)
- **Repositorio**: Imagen de Sandi Proto, descripción y código QR hacia GitHub
- **Memes de gatos**: Pantalla secundaria accesible desde el hobby "Los gatos"

### Pantalla de Mis playas

La opción **Mis elementos** del Drawer gestiona playas con una lista dinámica
construida mediante `ListView.builder`. El botón **Añadir playa** abre un
`showDialog` con un `Form` validado para introducir nombre, descripción breve,
categoría, URL de imagen, número aproximado de personas y un `Checkbox` que
indica si la playa está limpia. Si no se proporciona una URL, se utiliza una
imagen local de respaldo según la categoría. Al guardar, el diálogo devuelve
una instancia de `Beach` mediante `Navigator.pop`; `setState` la incorpora a
la lista. Cada tarjeta muestra toda la información y permite borrar la playa.
El botón **Borrar toda la lista** solicita confirmación y mantiene su acción
desactivada durante 10 segundos para evitar eliminaciones accidentales.

## Capturas de pantalla

### Android

<p align="center">
  <img src="docs/screenshots/bienvenida.png" width="200" alt="Pantalla de Bienvenida" />
  <img src="docs/screenshots/drawer.png" width="200" alt="Drawer abierto" />
  <img src="docs/screenshots/portfolio_hobbies.png" width="200" alt="Portfolio - Mis hobbies" />
  <img src="docs/screenshots/portfolio_repositorio.png" width="200" alt="Portfolio - Mi repositorio" />
  <img src="docs/screenshots/memes_gatos.png" width="200" alt="Memes de gatos" />
</p>

| Pantalla | Descripción |
| --- | --- |
| Bienvenida | Pantalla principal con imagen de fondo de playa |
| Drawer abierto | Menú lateral con información del usuario |
| Portfolio - Mis hobbies | Pestaña de hobbies del portfolio |
| Portfolio - Mi repositorio | Pestaña de repositorio con QR de GitHub |
| Memes de gatos | Pantalla de memes de gatos programadores (accesible desde el hobby "Los gatos") |

## Instalación y ejecución

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.13.5
- Android Studio / VS Code
- Emulador Android o dispositivo físico

### Pasos

1. **Clonar el repositorio**
```bash
git clone https://github.com/Catsandi06/PGL-P2-MyPortfolio.git
cd PGL-P2-MyPortfolio
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
# En emulador/dispositivo conectado
flutter run

# O seleccionar dispositivo específico
flutter run -d <device_id>
```

## Autor

**Nichel Morales Hernández** (USR3742)  
[GitHub](https://github.com/Catsandi06)

## Licencia

Este proyecto es únicamente con fines educativos.