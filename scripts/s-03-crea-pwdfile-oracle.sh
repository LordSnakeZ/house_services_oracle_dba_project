#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 04/03/2025                                           ║
# ║ @Descripción:    Genera (o regenera) el archivo de contraseñas        ║
# ║                  "orapw<SID>" para la instancia Oracle señalada,      ║
# ║                  asegurando que el script se ejecute únicamente       ║
# ║                  con el usuario adecuado y validando el resultado.    ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# ---------------------------------------------------------------------------
# CONFIGURACIÓN
# ---------------------------------------------------------------------------
# Ruta completa del archivo de contraseñas que vamos a crear.
#   Nota: Reemplace el sufijo "free" por el ORACLE_SID correspondiente en
#         caso de usar una base de datos diferente.
archivoPwd="${ORACLE_HOME}/dbs/orapwfree"

# ---------------------------------------------------------------------------
# VALIDACIÓN DE USUARIO
# ---------------------------------------------------------------------------
# Para evitar problemas de permisos y consistencia, nos aseguramos de que el
# script sea ejecutado por el usuario UNIX "oracle" (propietario típico de
# la instalación de Oracle).
if [ "${USER}" != "oracle" ]; then
  echo "ERROR: el script debe ser ejecutado por el usuario oracle"
  exit 1
fi

# ---------------------------------------------------------------------------
# CREACIÓN DEL ARCHIVO DE PASSWORDS
# ---------------------------------------------------------------------------
# Utilizamos el utilitario "orapwd" para crear el archivo de passwords que
# almacena la contraseña del usuario SYS de la base de datos.  
#   - FILE   : Ruta de destino del archivo.
#   - FORMAT : Versión de formato del archivo; 12.2 es compatible con 12c y
#              versiones posteriores.
#   - SYS    : Indica que estableceremos la contraseña del usuario SYS.
#   - password: La contraseña en texto claro.  (¡Cámbiela en producción!)
#----------------------------------------------------------------------------

echo "Creando archivo de passwords en: ${archivoPwd}"
orapwd FILE="${archivoPwd}" \
       FORMAT=12.2 \
       SYS=password password=Hola123#

# ---------------------------------------------------------------------------
# VALIDACIÓN DE RESULTADOS
# ---------------------------------------------------------------------------
# Comprobamos la existencia del archivo recién generado para asegurar que el
# proceso finalizó satisfactoriamente.
# ---------------------------------------------------------------------------

echo "Validando la existencia del nuevo archivo de passwords..."
if [ -f "${archivoPwd}" ]; then
  echo "OK. Archivo de passwords generado satisfactoriamente."
else
  echo "ERROR: El archivo de passwords no ha sido generado."
  exit 1
fi
