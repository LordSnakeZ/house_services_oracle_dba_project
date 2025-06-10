#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 10/06/2025                                           ║
# ║ @Descripción:    Programa ejecución diaria de simulación de carga y   ║
# ║                  monitoreo de REDO                                    ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# --- Configuración ---
export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1  # Ruta de ORACLE_HOME (revisada previamente)
export PATH=$ORACLE_HOME/bin:$PATH
LOG_DIR=/unam/bda/logs/carga_diaria              #Revisar Ruta: subcarpeta carga_diaria no especificada antes
FECHA=$(date +%Y%m%d)

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

enable_logging() {
  # Función para medir tamaño de REDO (MB)
  sqlplus -S / as sysdba <<EOF
    SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
    SELECT value/1024/1024 FROM v\$sysstat WHERE name='redo size';
    EXIT;
EOF
}

# Inicio del proceso
echo "$(date) - Iniciando simulación de carga diaria" >> "$LOG_DIR/carga_\$FECHA.log"

# Medir REDO inicial
REDO_INICIAL=$(enable_logging)
echo "$(date) - REDO inicial: \$REDO_INICIAL MB" >> "$LOG_DIR/carga_\$FECHA.log"

# Ejecutar simulación de carga diaria
sqlplus moduloUsuarios/password123@chsabda_s2 @/unam/bda/scripts/s-16-simulacion_carga_diaria.sql >> "$LOG_DIR/carga_\$FECHA.log"  #Revisar Ruta: carpeta scripts no definida antes

# Medir REDO final\REDO_FINAL=$(enable_logging)
echo "$(date) - REDO final: \$REDO_FINAL MB" >> "$LOG_DIR/carga_\$FECHA.log"

# Calcular diferencia de REDO
REDO_DIF=$(echo "\$REDO_FINAL - \$REDO_INICIAL" | bc)
echo "$(date) - REDO generado: \$REDO_DIF MB" >> "$LOG_DIR/carga_\$FECHA.log"

# Registrar en tabla de control (opcional)
sqlplus -S / as sysdba <<EOF
INSERT INTO sistema.control_carga (
  fecha_ejecucion,
  operaciones,
  redo_generado_mb,
  tiempo_segundos
) VALUES (
  SYSDATE,
  -- Extrae número de operaciones del log
  TO_NUMBER(REGEXP_SUBSTR('$(grep 'Operaciones realizadas' "$LOG_DIR/carga_\$FECHA.log")','\d+')),
  \$REDO_DIF,
  -- Extrae tiempo transcurrido del log
  TO_NUMBER(REGEXP_SUBSTR('$(grep 'Tiempo transcurrido' "$LOG_DIR/carga_\$FECHA.log")','\d+'))
);
COMMIT;
EXIT;
EOF

echo "$(date) - Simulación completada" >> "$LOG_DIR/carga_\$FECHA.log"
