#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                              ║
# ║                 Sánchez Sánchez Santiago                               ║
# ║ @Fecha creación: 04/03/2025                                            ║
# ║ @Descripción:    Crea un PFILE (archivo de parámetros de arranque)     ║
# ║                  básico para la instancia ORACLE_SID=free.             ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# -----------------------------------------------------------------------
# 1. Mensaje inicial de contexto
# -----------------------------------------------------------------------

echo "1. Creación de un archivo de parámetros básicos"

# -----------------------------------------------------------------------
# 2. Definición de variables de entorno
# -----------------------------------------------------------------------

export ORACLE_SID=free                              # Nombre de la instancia
pfile="$ORACLE_HOME/dbs/init${ORACLE_SID}.ora"      # Ruta donde se guardará el nuevo PFILE

# -----------------------------------------------------------------------
# 3. Verificación de existencia del PFILE y confirmación de sobrescritura
# -----------------------------------------------------------------------

if [ -f "${pfile}" ]; then
  read -p "El archivo ${pfile} ya existe. Pulsa [Enter] para sobrescribir o Ctrl+C para cancelar."
fi

# -----------------------------------------------------------------------
# 4. Generación del PFILE con parámetros mínimos recomendados             
# -----------------------------------------------------------------------

cat > "$pfile" <<'EOF'
db_name=free
memory_target=768M

# Archivos de control redundantes (3 copias en discos distintos para alta disponibilidad)
control_files=(
  /unam/bda/d11/app/oracle/oradata/FREE/control01.ctl,
  /unam/bda/disks/d04/app/oracle/oradata/FREE/control02.ctl,
  /unam/bda/disks/d05/app/oracle/oradata/FREE/control03.ctl
)

# Configuración de red y habilitación de bases de datos pluggable (PDB)
db_domain=fi.unam
enable_pluggable_database=true

# Área de recuperación flash (FRA) y políticas de flashback/archivado
db_recovery_file_dest_size=20G
db_recovery_file_dest='/unam/bda/d11'
db_flashback_retention_target=1440   # Minutos (24 h)

# Ajustes de archivado
log_archive_max_processes=4
log_archive_format=arch_%t_%s_%r.arc
log_archive_dest_1='LOCATION=/unam/bda/d11 MANDATORY'
log_archive_dest_2='LOCATION=/unam/bda/d18'
EOF

# -----------------------------------------------------------------------
# 5. Validación final: mostrar el contenido del archivo generado
# -----------------------------------------------------------------------

echo "\nListo: PFILE creado en ${pfile}"

echo "----------------------------------------------"
echo "Contenido del PFILE:"
echo "----------------------------------------------"
cat "${pfile}"
