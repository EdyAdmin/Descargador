@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Se crea la carpeta 'Herramientas' para los programas necesarios.
set "DIR_REQ=Herramientas"
set "PROG=0"
if not exist "%DIR_REQ%" (
    mkdir "%DIR_REQ%"
    set "PROG=1"
)
set "PATH=%~dp0%DIR_REQ%;%PATH%"

:: Definición de colores ANSI
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "Magenta=!ESC![95m"
set "Cian=!ESC![96m"
set "Amarillo=!ESC![93m"
set "Rojo=!ESC![91m"
set "Reset=!ESC![0m"

title Descargador

echo !Magenta!=============================
echo     Descargador de vídeos 
echo =============================!Reset!!Cian!
echo.

:: Se anuncia la creación de la carpeta 'Herramientas'.
if "!PROG!"=="1" (
    echo [*] Se ha creado la carpeta 'Herramientas'.
    echo.
) 

:: Se comprueba si yt-dlp está descargado y si lo está se actualiza.
if not exist "%DIR_REQ%\yt-dlp.exe" (
    echo [*] No se ha encontrado yt-dlp.exe. Iniciando la descarga...
    echo.
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile '%DIR_REQ%\yt-dlp.exe'"
    echo [*] Descarga completada.
    echo.
) else (
    for /f "delims=" %%V in ('"%DIR_REQ%\yt-dlp.exe" -U 2^>^&1') do (
        echo %%V | findstr /i "Updating" >nul
        if not errorlevel 1 (
            echo !Amarillo![*] Se ha actualizado yt-dlp.!Reset!!Cian!
            echo.
        )
    )
)

:: Se comprueba si node está descargado.
if not exist "%DIR_REQ%\node.exe" (
    echo [*] No se ha encontrado node.exe. Iniciando la descarga...
    echo.
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest-v20.x/win-x64/node.exe' -OutFile '%DIR_REQ%\node.exe'"
    echo [*] Descarga completada.
    echo.
)

:: Se comprueba si ffmpeg está descargado.
if not exist "%DIR_REQ%\ffmpeg.exe" (
    echo [*] No se ha encontrado ffmpeg.exe. Iniciando la descarga...
    echo.
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip' -OutFile '%DIR_REQ%\ffmpeg.zip'; Expand-Archive -Path '%DIR_REQ%\ffmpeg.zip' -DestinationPath '%DIR_REQ%\ffmpeg_temp' -Force; Move-Item -Path '%DIR_REQ%\ffmpeg_temp\*\bin\ffmpeg.exe' -Destination '%DIR_REQ%\ffmpeg.exe' -Force; Move-Item -Path '%DIR_REQ%\ffmpeg_temp\*\bin\ffprobe.exe' -Destination '%DIR_REQ%\ffprobe.exe' -Force; Remove-Item '%DIR_REQ%\ffmpeg.zip' -Force; Remove-Item '%DIR_REQ%\ffmpeg_temp' -Recurse -Force"
    echo [*] Descarga completada.
    echo.
)

:: Se comprueba si existe 'enlaces.txt' y se crea si no.
set "nuevoEnl=0"
if not exist "enlaces.txt" (
    echo [*] No se ha encontrado el archivo 'enlaces.txt'. Creándolo...
    echo # Pega en este archivo los enlaces separados por un espacio y la opción. > enlaces.txt
    echo # Opciones: mp3, 1080p, calidad >> enlaces.txt
    echo # Ejemplo: https://www.youtube.com/watch?v=... mp3 >> enlaces.txt
    set "nuevoEnl=1"
    echo.
    echo [*] Enlaces.txt creado.
    echo.
)

set "actualizacion=0"

:MenuCarpetas
echo [*] Las carpetas disponibles son las siguientes:
echo.
set "contador=0"

:: Se buscan todas las carpetas creadas en el directorio actual ignorando 'Herramientas'.
for /d %%D in (*) do (
    if /I not "%%D"=="%DIR_REQ%" if not "%%D"=="U" if not "%%D"=="E" (
        set /a contador+=1
        set "carpeta_!contador!=%%D"
        echo   !Magenta![!contador!] %%D!Reset!!Cian!
    )
)

if "!contador!"=="0" (
    echo   [*] ^(No hay carpetas de vídeo creadas todavía^)
)

echo.
echo !Cian![*] Escribe el NÚMERO asociado a la carpeta.
echo [*] Escribe un NUEVO NOMBRE para crearla.
echo [*] Pulsa ENTER sin escribir nada para usar la carpeta predeterminada ^('Vídeos'^).
echo.
if "!actualizacion!"=="0" (
echo [*] Escribe una u mayúscula ^('U'^) para actualizar FFmpeg y Node.
echo [*] Si deseas cancelar la descarga, escribe una e mayúscula ^('E'^).
echo.
)
set /p "seleccion=!Amarillo![*] La carpeta a abrir es: "
echo.!Reset!!Cian!

:: Si el usuario escribe 'E', se cancela el proceso.
if "!seleccion!"=="E" (
    echo !Magenta!==================================
    echo     Cerrando el descargador...
    echo ==================================!Reset!
    echo.
    timeout /t 2 /nobreak >nul
    exit
)

:: Si el usuario escribe 'U', entra al proceso de actualización.
if "!seleccion!"=="U" (
    echo [*] Iniciando actualización de herramientas...
    echo.
    echo [*] Actualizando yt-dlp...
    echo.
    "%DIR_REQ%\yt-dlp.exe" -U >nul 2>&1
    echo !Amarillo![*] Yt-dlp actualizado.!Reset!!Cian!
    echo.
    echo [*] Actualizando node...
    echo.
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest-v20.x/win-x64/node.exe' -OutFile '%DIR_REQ%\node.exe'"
    echo !Amarillo![*] Node actualizado.!Reset!!Cian!
    echo.
    echo [*] Actualizando ffmpeg...
    echo.
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip' -OutFile '%DIR_REQ%\ffmpeg.zip'; Expand-Archive -Path '%DIR_REQ%\ffmpeg.zip' -DestinationPath '%DIR_REQ%\ffmpeg_temp' -Force; Move-Item -Path '%DIR_REQ%\ffmpeg_temp\*\bin\ffmpeg.exe' -Destination '%DIR_REQ%\ffmpeg.exe' -Force; Move-Item -Path '%DIR_REQ%\ffmpeg_temp\*\bin\ffprobe.exe' -Destination '%DIR_REQ%\ffprobe.exe' -Force; Remove-Item '%DIR_REQ%\ffmpeg.zip' -Force; Remove-Item '%DIR_REQ%\ffmpeg_temp' -Recurse -Force"
    echo !Amarillo![*] Ffmpeg actualizado.!Reset!!Cian!
    echo.
    echo !Amarillo![*] Herramientas actualizadas correctamente.!Reset!!Cian!
    set "actualizacion=1"
    echo.
    goto :MenuCarpetas
)

set "nombreCarpeta="

:: Se comprueba si la carpeta seleccionada está en la lista.
if not "!seleccion!"=="" (
    for /L %%I in (1,1,!contador!) do (
        if "!seleccion!"=="%%I" set "nombreCarpeta=!carpeta_%%I!"
    )
)

:: Si 'nombreCarpeta' sigue vacío se asigna la carpeta predeterminada o lo que se haya escrito.
set "carpetaPred=0"
if "!nombreCarpeta!"=="" (
    if "!seleccion!"=="" (
        set "nombreCarpeta=Vídeos"
        set "carpetaPred=1"
    ) else (
        set "nombreCarpeta=!seleccion!"
    )
    
    :: Se comprueba si ese texto es una carpeta que ya existía o si hay que crearla
    if exist "!nombreCarpeta!" (
        if "!carpetaPred!"=="1" (
            echo [*] Usando la carpeta predeterminada.
        ) else (
            echo [*] Usando la carpeta seleccionada: '!nombreCarpeta!'.
        )
    ) else (
        if "!carpetaPred!"=="1" (
            echo [*] Creando la carpeta predeterminada...
            echo.
            mkdir "!nombreCarpeta!"
            echo [*] Se ha creado carpeta predeterminada.
        ) else (
            echo [*] Creando la nueva carpeta '!nombreCarpeta!'...
            echo.
            mkdir "!nombreCarpeta!"
            echo [*] Se ha creado '!nombreCarpeta!'.
        )
    )
) else (
    echo [*] Usando la carpeta seleccionada: '!nombreCarpeta!'.
)
echo.

echo [*] Leyendo enlaces y comenzando la descarga...
echo.

set "esVacio=1"
set "cont=1"

:: Comienza el bucle de descarga que separa la URL de la opción de la descarga.
for /F "usebackq tokens=1,2" %%A in ("enlaces.txt") do (
    set "URL=%%A"
    set "OPCION=%%B"

    :: Ignorar los comentarios (comienzan por #).
    if /I not "!URL:~0,1!"=="#" (

        if "!esVacio!"=="1" set "esVacio=0"
        
        :: La opción "calidad" se asume en caso de que no se especifique la opción.
        if "!OPCION!"=="" set "OPCION=calidad"

        :: Se configuran los parámetros en base a las opciones elegidas por el usuario.
        if /I "!OPCION!"=="mp3" (
            set "MSG=AUDIO MP3 Nº !cont!"
            set "PARAMETROS=-x --audio-format mp3"
        ) else if /I "!OPCION!"=="1080p" (
            set "MSG=VÍDEO Nº !cont! 1080p"
            set "PARAMETROS=-S vcodec:h264,res:1080 --recode-video mp4"
        ) else (
            set "MSG=VÍDEO Nº !cont! MÁXIMA CALIDAD"
            set "PARAMETROS=-S vcodec:h264 --recode-video mp4"
        )

        :: Se ejecuta la descarga.
        echo !Amarillo! [--- Descargando !MSG!: !URL! ---]
        "%DIR_REQ%\yt-dlp.exe" --js-runtimes node --no-warnings --extractor-args "youtube:player_client=android,web" -P "!nombreCarpeta!" !PARAMETROS! --add-metadata "!URL!"
        echo.!Amarillo!
        set /a cont+=1
    )
)

:: Si no hay enlaces en "enlaces.txt" se recuerdan las opciones de descarga.
if "!esVacio!"=="1" (
    if "!nuevoEnl!"=="0" ( 
        echo !Rojo![AVISO] No hay enlaces en 'enlaces.txt'.!Reset!!Cian!
        echo.
        echo Recuerda cómo funciona:
    ) else (
        echo !Rojo![AVISO] Para comenzar a usar el programa, sigue las instrucciones:!Reset!!Cian!
        echo.
    )
    echo [1] Pega la URL del vídeo.
    echo [2] Deja un espacio en blanco.
    echo [3] Escribe la opción que quieras: mp3, 1080p o calidad.
    echo.
    echo [*] Ejemplo: https://www.youtube.com/watch?v=... mp3
    echo.
    pause
    exit
)

echo.
echo !Magenta!============================================
echo     ¡Todas las descargas han finalizado!
echo ============================================!Reset!
echo.
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Se han descargado los vídeos correctamente.', 'Descargas finalizadas', 'OK', 'Information')"
exit