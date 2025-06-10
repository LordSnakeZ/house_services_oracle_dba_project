#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 10/06/2025                                           ║
# ║ @Descripción:    Ejecuta prueba de instance recovery tras shutdown    ║
# ║                  abort, mide tiempos y registra métricas              ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# Configuración del entorno
ORACLE_HOME=/opt/oracle/product/21c/dbhome_1   # Revisar Ruta
PATH=$ORACLE_HOME/bin:$PATH
# Archivo de log para registrar salida de la prueba
LOG_FILE=/unam/bda/logs/recovery_test_$(date +%Y%m%d_%H%M%S).log   

# Función para obtener métricas de recovery y estado de instancia
get_recovery_metrics() {
  sqlplus -S / as sysdba <<EOF
  SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
  -- Consulta métricas de recuperación
  SELECT name, value FROM v\$recovery_progress \
    WHERE name IN ('Active Apply Rate','Estimated Recovery Time');
  -- Consulta estado de la instancia
  SELECT 'STATUS: ' || status FROM v\$instance;
  EXIT;
EOF
}

# Iniciar registro en archivo de log
echo "Inicio de prueba de Instance Recovery: $(date)" > $LOG_FILE

# 1. Obtener estado inicial de recovery
echo -e "\n=== Estado inicial ===" >> $LOG_FILE
get_recovery_metrics >> $LOG_FILE

# 2. Ejecutar SHUTDOWN ABORT para simular fallo abrupto
echo -e "\nEjecutando SHUTDOWN ABORT..." >> $LOG_FILE
sqlplus / as sysdba <<EOF >> $LOG_FILE
SHUTDOWN ABORT;
EXIT;
EOF

# 3. Medir tiempo de startup y recovery
echo -e "\nIniciando instancia..." >> $LOG_FILE
START_TIME=$(date +%s.%N)
sqlplus / as sysdba <<EOF >> $LOG_FILE
STARTUP;
EXIT;
EOF
END_TIME=$(date +%s.%N)
# Cálculo del tiempo de recovery en segundos
RECOVERY_TIME=$(echo "$END_TIME - $START_TIME" | bc)
echo -e "\nTiempo de recovery: $RECOVERY_TIME segundos" >> $LOG_FILE

# 4. Métricas posteriores al recovery
echo -e "\n=== Estado posterior ===" >> $LOG_FILE
get_recovery_metrics >> $LOG_FILE

# 5. Insertar métricas en tabla de control de recovery
sqlplus -S / as sysdba <<EOF
INSERT INTO sistema.control_recovery (
  fecha_prueba, recovery_time_sec, redo_generado_mb, fast_start_mttr_target
) VALUES (
  SYSDATE,
  $RECOVERY_TIME,
  (SELECT ROUND(value/1024/1024,2) FROM v\$sysstat WHERE name = 'redo size'),
  (SELECT value FROM v\$parameter WHERE name = 'fast_start_mttr_target')
);
COMMIT;
EXIT;
EOF

echo -e "\nPrueba completada. Ver detalles en $LOG_FILE" >> $LOG_FILE
# Mostrar contenido del log
cat $LOG_FILE
