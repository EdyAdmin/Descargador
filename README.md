# Descargador multimedia automatizado 

Script interactivo por lotes en Batch para Windows diseñado para gestionar descargas multimedia mediante `yt-dlp` y `ffmpeg` con aprovisionamiento automático de binarios.

---

### Características principales ⚡

* **Auto-bootstrap de dependencias:** Descarga y configura automáticamente en local (`Herramientas/`) las versiones portables de `yt-dlp`, `FFmpeg/FFprobe` y el runtime de `Node.js` vía PowerShell sin alterar variables de entorno globales. También las actualiza en caso de que sea necesario.
* **Bypass y optimización:** Configurado con `--js-runtimes node` y extractores móviles/web (`android,web`) para mitigar bloqueos o limitaciones de velocidad de YouTube.
* **Procesamiento de formatos y códecs:**
  * **Audio (`mp3`):** Extracción y remuestreo directo a MP3.
  * **Vídeo (`1080p`):** Descarga limitada a 1080p forzando transcodificación H.264 (`avc1`) en contenedor MP4.
  * **Máxima calidad (`calidad`):** Priorización de códec de compatibilidad máxima H.264 (`-S vcodec:h264`) y remux a MP4 con metadatos incrustados.
* **Gestor dinámico de rutas:** Detección de carpetas locales y entorno interactivo e intuitivo.

---

### Modo de empleo 🖥️

#### 1. Configuración inicial
En la primera ejecución se generará la carpeta `Herramientas/` con los binarios necesarios y la plantilla `enlaces.txt`. Tras crearse el archivo base, si todo se ha instalado correctamente, el script se cerrará de forma automática para poder editar `enlaces.txt`.

#### 2. Carga de URLs
En el archivo `enlaces.txt` deberán estar los enlaces de los vídeos con la posibilidad de especificar la opción deseada separada por un espacio:

```text
#   Enlace                                        Opción (opcional)
    https://www.youtube.com/watch?v=XXXXXXXXXXX   mp3
    https://www.youtube.com/watch?v=YYYYYYYYYYY   1080p
    https://www.youtube.com/watch?v=ZZZZZZZZZZZ   calidad
```

> **Nota:** Las líneas que comienzan por `#` se omiten automáticamente. Si no se especifica ninguna opción tras la URL, se aplica `calidad` por defecto.

#### 3. Ejecución y procesado
Una vez cargados los links vuelve a ejecutar el descargador y selecciona una carpeta existente mediante su índice numérico, escribe un nuevo nombre para crearla o presiona `Enter` para usar la carpeta predeterminada (`Vídeos`). El script procesará la cola de descargas y mostrará una ventana emergente nativa al concluir.
