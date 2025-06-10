#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                              ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 04/03/2025                                           ║
# ║ @Descripción:    Crea una serie de directorios numerados que          ║
# ║                  simulan dispositivos de almacenamiento para          ║
# ║                  prácticas de administración de bases de datos.       ║
# ╚═══════════════════════════════════════════════════════════════════════╝
#
# Este script automatiza la creación de un conjunto de directorios en la
# ruta especificada por $base_path. Cada directorio representa un
# dispositivo de almacenamiento lógico que se utilizará en las prácticas
# de la asignatura de Bases de Datos Avanzada. Además, asigna permisos
# de lectura, escritura y ejecución para "otros" y "grupo", de forma que
# todos los miembros del equipo puedan acceder a ellos sin problemas.
#
# ──────────────────────────── Variables ────────────────────────────────
# base_path:        Ruta base donde se crearán los directorios.
# num_directorios:  Número total de directorios a crear.
# inicio:           Identificador inicial (se concatenará al prefijo 'd').
# ───────────────────────────────────────────────────────────────────────

# Directorio base para la creación de los directorios
base_path="/unam/bda"

# Cantidad de directorios a crear
num_directorios=8

# Número inicial para la numeración de los directorios (d31, d32, ...)
inicio=31

# Mensaje informativo de inicio
echo "Creando $num_directorios directorios..."
echo

# Bucle para la creación secuencial de directorios
a=1
for ((i=inicio; i<inicio+num_directorios; i++)); do
    # Ruta completa del directorio actual
    dir="${base_path}/d${i}"

    # Retroalimentación al usuario
    echo "➤ Directorio $a: $dir"

    # Creación del directorio (incluye cualquier subruta necesaria)
    mkdir -p "$dir"

    # Asignación de permisos (lectura, escritura y ejecución) para grupo y otros
    chmod og+rwx "$dir"

    ((a++))
done
