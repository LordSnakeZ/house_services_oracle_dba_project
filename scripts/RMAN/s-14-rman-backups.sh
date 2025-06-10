#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: dd/mm/yyyy                                           ║
# ║ @Descripción:    Wrapper para disparar ciclos de backup RMAN           ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# Variables de entorno y rutas
export ORACLE_SID=free                                                        # Instancia Oracle (usada en scripts previos)
export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1  # Revisa que coincida con la instalación real       #Revisar Ruta
export PATH=$ORACLE_HOME/bin:$PATH

SCRIPT_DIR=/home/oracle/scripts/rman              # Ubicación de scripts RMAN                            #Revisar Ruta
LOG_DIR=/unam/bda/logs                            # Base '/unam/bda' usado antes; carpeta 'logs' nueva   #Revisar Ruta

# Asegurar existencia del directorio de logs\mkdir -p "$LOG_DIR"
\# Selección de script RMAN según parámetro de entrada
case "$1" in
  weekly)
    FILE=rman_level0.rcv   # Backup nivel 0 semanal
    ;;
  daily)
    FILE=rman_level1.rcv   # Backup incremental diario
    ;;
  arch)
    FILE=rman_arch.rcv     # Backup de archivelogs cada 30 minutos
    ;;
  copy)
    FILE=rman_monthly_copy.rcv  # Backup completo mensual
    ;;
  *)
    echo "Uso: $0 weekly|daily|arch|copy"
    exit 2
    ;;
esac

# Generar prefijo de timestamp para el log
TIMESTAMP=$(date +%Y%m%d_%H%M)

# Ejecución de RMAN con archivo de comandos y log correspondiente
rman target / \
  log="$LOG_DIR/${1}_${TIMESTAMP}.log" \
  cmdfile="$SCRIPT_DIR/$FILE"
