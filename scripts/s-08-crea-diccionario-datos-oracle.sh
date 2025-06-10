#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                              ║
# ║                 Sánchez Sánchez Santiago                               ║
# ║ @Fecha creación: 04/03/2025                                            ║
# ║ @Descripción:    Crea y valida el diccionario de datos para la nueva   ║
# ║                  CDB "FREE". El script compila los objetos del         ║
# ║                  diccionario mediante el utilitario Perl `catcdb.pl`   ║
# ║                  y posteriormente ejecuta `dbms_dictionary_check.full` ║
# ║                  para asegurar la consistencia.                        ║
# ╚═══════════════════════════════════════════════════════════════════════╝

###############################################################################
# 0. Verificación de pre‑requisitos                                          #
###############################################################################
# Este script debe ejecutarse con el usuario «oracle» y con ORACLE_HOME y     #
# ORACLE_SID correctamente exportados a la instancia que acaba de crearse.    #
###############################################################################

if [[ "$USER" != "oracle" ]]; then
  echo "ERROR: este script debe ser ejecutado como usuario 'oracle'." >&2
  exit 1
fi

###############################################################################
# 1. Preparar directorio de bitácoras                                         #
###############################################################################
LOG_DIR="/tmp/dd-logs"

echo "→ Creando directorio de logs en: $LOG_DIR"
mkdir -p "$LOG_DIR"            # -p evita error si ya existe
cd "$LOG_DIR" || exit 2        # Abortamos si no podemos cambiar de dir

###############################################################################
# 2. Compilar el diccionario de datos con catcdb.pl                           #
###############################################################################
# catcdb.pl recompila los objetos del diccionario para CDB y todas sus PDBs.  #
#   --logDirectory        Ruta donde guardar los archivos de bitácora         #
#   --logFilename         Nombre del log estándar                             #
#   --logErrorsFilename   Nombre para el log solo‑errores                     #
###############################################################################

perl -I "$ORACLE_HOME/rdbms/admin" \
  "$ORACLE_HOME/rdbms/admin/catcdb.pl" \
  --logDirectory "$LOG_DIR" \
  --logFilename dd.log \
  --logErrorsFilename dderror.log

###############################################################################
# 3. Validación del diccionario de datos                                      #
###############################################################################
# dbms_dictionary_check.full realiza una revisión de consistencia en los      #
# objetos del diccionario.                                                    #
###############################################################################

echo "→ Ejecutando validación de diccionario con DBMS_DICTIONARY_CHECK..."

sqlplus -s sys/system2 as sysdba <<EOF
SET SERVEROUTPUT ON
EXEC dbms_dictionary_check.full;
EXIT;
EOF

echo "✔ Diccionario de datos compilado y validado. Revisa $LOG_DIR para los logs."
