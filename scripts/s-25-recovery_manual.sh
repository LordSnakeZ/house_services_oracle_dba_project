#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 10/06/2025                                           ║
# ║ @Descripción:    Realiza complete media recovery manual vía RMAN       ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# Configuración del entorno
ORACLE_HOME=/opt/oracle/product/21c/dbhome_1   # Revisar Ruta
PATH=$ORACLE_HOME/bin:$PATH

# Archivo de log para registrar la ejecución de media recovery manual
LOG_FILE=/unam/bda/logs/media_recovery_manual_$(date +%Y%m%d_%H%M%S).log   # Revisar Ruta
mkdir -p "$(dirname "$LOG_FILE")"  # Asegura existencia del directorio de logs

# Obtener información del datafile dañado desde la tabla de control
DATAFILE_INFO=$(sqlplus -S / as sysdba <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
-- Selecciona el último registro de daño simulado
SELECT datafile_id || '|' || tablespace_name || '|' || datafile_name
  FROM sistema.control_media_recovery
 WHERE fecha_prueba = (
   SELECT MAX(fecha_prueba) FROM sistema.control_media_recovery
 );
EXIT;
EOF
)

# Extraer componentes de la línea resultante
DATAFILE_ID=$(echo "$DATAFILE_INFO" | cut -d'|' -f1)
TABLESPACE=$(echo "$DATAFILE_INFO" | cut -d'|' -f2)
DATAFILE_PATH=$(echo "$DATAFILE_INFO" | cut -d'|' -f3)

# Inicio del proceso y registro en log
echo "=== Iniciando Media Recovery Manual ===" > "$LOG_FILE"
echo "- Datafile ID: $DATAFILE_ID" >> "$LOG_FILE"
echo "- Tablespace: $TABLESPACE" >> "$LOG_FILE"
echo "- Ruta: $DATAFILE_PATH" >> "$LOG_FILE"
echo "- Hora inicio: $(date)" >> "$LOG_FILE"

# Medición de tiempo de recuperación
echo ">>> Ejecutando RMAN" >> "$LOG_FILE"
START_TIME=$(date +%s.%N)

# Ejecución de RMAN para restore, recover y online
rman target / >> "$LOG_FILE" <<EOF
RUN {
  -- Asegura el tablespace offline antes de recovery
  SQL 'ALTER TABLESPACE $TABLESPACE OFFLINE IMMEDIATE';

  -- Restaura el datafile dañado
  RESTORE DATAFILE $DATAFILE_ID;
  -- Aplica los redo necesarios
  RECOVER DATAFILE $DATAFILE_ID;

  -- Vuelve a poner online el tablespace
  SQL 'ALTER TABLESPACE $TABLESPACE ONLINE';

  -- Reporta el estado del esquema
  REPORT SCHEMA;
}
EXIT;
EOF

END_TIME=$(date +%s.%N)
# Cálculo del tiempo de recovery en segundos
RECOVERY_TIME=$(echo "$END_TIME - $START_TIME" | bc)
echo "- Tiempo total de recovery: $RECOVERY_TIME segundos" >> "$LOG_FILE"

# Actualizar registro en tabla de control con resultados
sqlplus -S / as sysdba <<EOF
-- Registra resultados de la recuperación manual
UPDATE sistema.control_media_recovery
   SET recovery_manual_time_sec = $RECOVERY_TIME,
       recovery_manual_result = 'COMPLETED',
       recovery_manual_log = '$LOG_FILE'
 WHERE fecha_prueba = (
   SELECT MAX(fecha_prueba) FROM sistema.control_media_recovery
 );
COMMIT;
EXIT;
EOF

# Finalización y mostrar log
echo "=== Recovery completo ===" >> "$LOG_FILE"
echo "- Hora fin: $(date)" >> "$LOG_FILE"
cat "$LOG_FILE"
