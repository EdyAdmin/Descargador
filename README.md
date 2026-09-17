# Descargador multimedia automatizado 

Script interactivo por lotes en Batch para Windows diseñado para gestionar descargas multimedia mediante `yt-dlp` y `ffmpeg` con aprovisionamiento automático de binarios.

---

### ⚡ Características principales

* **Auto-bootstrap de dependencias:** Descarga y configura automáticamente en local (`Herramientas/`) las versiones portables de `yt-dlp`, `FFmpeg/FFprobe` y el runtime de `Node.js` vía PowerShell sin alterar variables de entorno globales.
* **Auto-update:** Comprobación y actualización automática de `yt-dlp` en cada ejecución.
* **Bypass y optimización:** Configurado con `--js-runtimes node` y extractores móviles/web (`android,web`) para mitigar bloqueos o limitaciones de velocidad de YouTube.
* **Procesamiento de formatos y códecs:**
  * **Audio (`mp3`):** Extracción y remuestreo directo a MP3.
  * **Vídeo (`1080p`):** Descarga limitada a 1080p forzando transcodificación H.264 (`avc1`) en contenedor MP4.
  * **Máxima calidad (`calidad`):** Priorización de códec de compatibilidad máxima H.264 (`-S vcodec:h264`) y remux a MP4 con metadatos incrustados.
* **Gestor dinámico de rutas:** Detección interactiva de carpetas locales y creación bajo demanda sin hardcodear destinos.
* **Notificación nativa:** Alerta visual mediante el ensamblado `System.Windows.Forms` al concluir la cola de procesamiento.

---

### 📋 Requisitos del sistema

* **OS:** Windows 10 / 11.
* **Shell:** Consola de comandos estándar (`cmd.exe`) con permisos para ejecutar llamadas de PowerShell nativo (TLS 1.2 activado).

---

### 🚀 Modo de uso

#### 1. Configuración inicial
1. Ejecuta `descargador.bat`.
2. En la primera ejecución se generará la carpeta `Herramientas/` con los binarios necesarios y la plantilla `enlaces.txt`.
3. Tras crearse el archivo base, el script mostrará un aviso de uso y se cerrará automáticamente para permitir la edición de la lista.

#### 2. Carga de URLs
Abre el archivo `enlaces.txt` generado y pega los enlaces especificando la opción deseada separada por un espacio:

```text
# Enlace                                      Opción (opcional)
    https://www.youtube.com/watch?v=XXXXXXXXXXX   mp3
    https://www.youtube.com/watch?v=YYYYYYYYYYY   1080p
    https://www.youtube.com/watch?v=ZZZZZZZZZZZ   calidad
```

> **Nota:** Las líneas que comienzan por `#` se omiten automáticamente. Si no se especifica ninguna opción tras la URL, se aplica `calidad` por defecto.

#### 3. Ejecución y procesado
1. Vuelve a ejecutar `descargador.bat`.
2. Selecciona una carpeta existente mediante su índice numérico, escribe un nuevo nombre para crearla o presiona `Enter` para usar la carpeta predeterminada (`Vídeos`).
3. El script procesará la cola de descargas y mostrará una ventana emergente nativa al concluir.
