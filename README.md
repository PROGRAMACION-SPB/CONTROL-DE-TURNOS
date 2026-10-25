# Control de Turnos SPB (PWA)

Aplicación web instalable para consultar y controlar los turnos del personal – Sociedad Portuaria Buenaventura.
Los datos dinámicos (novedades, personal agregado, mínimos por turno) se guardan en Supabase.

## Archivos
- `index.html` – la aplicación
- `manifest.webmanifest` – datos de instalación (nombre, colores, íconos)
- `sw.js` – funcionamiento sin conexión y actualizaciones
- `icons/` – íconos de la app
- `.nojekyll` – evita el procesamiento de Jekyll en GitHub Pages

## Publicar en GitHub Pages
1. Sube **el contenido** de esta carpeta a la raíz del repositorio (incluido `.nojekyll`).
2. En GitHub: *Settings → Pages → Build and deployment → Deploy from a branch* → rama `main`, carpeta `/ (root)` → *Save*.
3. En 1–2 minutos queda en `https://TU-USUARIO.github.io/NOMBRE-DEL-REPO/`.

## Instalar
- **Android / Chrome / Edge:** menú ⋮ → *Instalar aplicación*.
- **iPhone / iPad (Safari):** Compartir → *Agregar a pantalla de inicio*.

## Base de datos
Ejecuta `supabase_schema.sql` una vez en Supabase (*SQL Editor*).

## Publicar cambios
Cambia `VERSION` en `sw.js` (`v1` → `v2`…) cada vez que subas una nueva versión de `index.html`,
para que los dispositivos descarguen la actualización.
