#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 10/06/2025                                           ║
# ║ @Descripción:    Realiza complete media recovery usando Data Recovery   ║
# ║                  Advisor (DRA) vía RMAN                                ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# Configuración del entorno
ORACLE_HOME=/opt/oracle/product/21c/dbhome_1   # Revisar Ruta
PATH=$ORACLE_HOME/bin:$PATH

# Archivo de log para registrar salida de la prueba
LOG_FILE=/unam/bda/logs/media_recovery_dra_$(date +%Y%m%d_%H%M%S).log   # Revisar Ruta

# Obtener datafile dañado de la tabla de control de media recovery
DATAFILE_INFO=$(sqlplus -S / as sysdba <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT datafile_id || '|' || tablespace_name || '|' || datafile_name
  FROM sistema.control_media_recovery
 WHERE fecha_prueba = (SELECT MAX(fecha_prueba) FROM sistema.control_media_recovery);
EXIT;
EOF
)

# Extraer identificadores del datafile
datafile_id=$(echo $DATAFILE_INFO | cut -d'|' -f1)
tablespace=$(echo $DATAFILE_INFO | cut -d'|' -f2)
datafile_path=$(echo $DATAFILE_INFO | cut -d'|' -f3)

# Inicio de registro en el archivo de log
echo "=== Iniciando Media Recovery con DRA ===" > $LOG_FILE
echo "- Datafile ID: $datafile_id" >> $LOG_FILE
echo "- Tablespace: $tablespace" >> $LOG_FILE
echo "- Ruta: $datafile_path" >> $LOG_FILE
echo "- Hora inicio: $(date)" >> $LOG_FILE

# Medir tiempo de ejecución
start_time=$(date +%s.%N)

# Ejecutar recuperación usando Data Recovery Advisor
echo "RUN {" >> $LOG_FILE
rman target / >> $LOG_FILE <<EOF
RUN {
  SQL 'ALTER TABLESPACE $tablespace OFFLINE IMMEDIATE';    # Simula daño

  LIST FAILURE;      # Lista fallas detectadas
  ADVISE FAILURE;    # Recomienda reparación
  REPAIR FAILURE;    # Ejecuta reparación automática

  REPORT SCHEMA;     # Verifica consistencia del esquema
}
EXIT;
EOF

enRUNTIME=$(date +%s.%N)
recovery_time=$(echo "$enRUNTIME - $start_time" | bc)
# Registrar resultados en tabla de control
sqlplus -S / as sysdba <<EOF
UPDATE sistema.control_media_recovery
   SET recovery_dra_time_sec = $recovery_time,
       recovery_dra_result = 'COMPLETED',
       recovery_dra_log = '$LOG_FILE'
 WHERE fecha_prueba = (SELECT MAX(fecha_prueba)
                           FROM sistema.control_media_recovery);
COMMIT;
EXIT;
EOF

echo "=== Recovery con DRA completado ===" >> $LOG_FILE
echo "- Tiempo total: $recovery_time segundos" >> $LOG_FILE
echo "- Hora fin: $(date)" >> $LOG_FILE

# Mostrar contenido del log
cat $LOG_FILE
