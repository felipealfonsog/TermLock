#!/bin/bash

# Ruta al script personalizado de lock
LOCK_SCRIPT="/home/felipe/matrix.sh"

# Ruta a la imagen a mostrar con i3lock (si existe)
CUSTOM_IMAGE="/home/felipe/Wallpapers/wallpaper_archblack2.jpg"

# Función para intentar diferentes métodos de bloqueo
function intentar_lock {
    for metodo in "$@"; do
        if command -v "$metodo" &> /dev/null; then
            echo "Intentando bloqueo con $metodo..."
            if [ "$metodo" == "i3lock" ] && [ -f "$CUSTOM_IMAGE" ]; then
                $metodo -i "$CUSTOM_IMAGE"
            else
                $metodo
            fi
            if [ $? -eq 0 ] && [ -x "$LOCK_SCRIPT" ]; then
                sudo -u tu_usuario "$LOCK_SCRIPT"
                echo "Bloqueo exitoso con $metodo y ejecución del script personalizado."
                return 0
            else
                echo "Falló el bloqueo con $metodo o el script no es ejecutable."
            fi
        else
            echo "$metodo no encontrado en el sistema."
        fi
    done

    echo "No se pudo bloquear el sistema con ningún método o ejecutar el script personalizado."
    return 1
}

# Mensaje de pregunta
echo "¿Qué acción quieres realizar?"
echo "1. Suspender"
echo "2. Dejar en lock"
echo "3. Apagar"
read -p "Selecciona una opción (1/2/3): " opcion

# Verifica la opción seleccionada
case $opcion in
    1)
        # Suspender
        sudo systemctl suspend
        ;;
    2)
        # Dejar en lock con diferentes métodos
        intentar_lock \
            "enlightenment_remote -lock" \
            "xlock -mode blank" \
            "i3lock -c 000000" \
            # Agrega más métodos de bloqueo según tu configuración
        ;;
    3)
        # Apagar
        sudo systemctl poweroff
        ;;
    *)
        # Opción no válida
        echo "Opción no válida. Saliendo."
        ;;
esac

# Fin del script

