#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                              ║
# ║                 Sánchez Sánchez Santiago                               ║
# ║ @Fecha creación: 04/03/2025                                            ║
# ║ @Descripción:    Crea la estructura de directorios necesaria para una  ║
# ║                  nueva Base de Datos Contenedora (CDB) en Oracle.      ║
# ║                  - Genera carpetas para datafiles, redo logs y control ║
# ║                    files distribuidas en varios discos.               ║
# ║                  - Asigna permisos y propietario al usuario 'oracle'.  ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# ---------------------------------------------------------------------------
# VARIABLES DE CONFIGURACIÓN                                                  
# ---------------------------------------------------------------------------

inicio=12                 # Primer identificador numérico de disco (d12)
num_directorios=5          # Cantidad de discos a preparar (d12...d16)
base_path="/unam/bda"     # Ruta raíz donde se ubican los discos simulados

# Nota: Suponemos que las variables de entorno ORACLE_SID y ORACLE_HOME ya
#       están definidas en el shell del usuario 'oracle'.

# ---------------------------------------------------------------------------
# A. DIRECTORIOS PARA LOS DATAFILES DEL CONTENEDOR CDB$ROOT                   
# ---------------------------------------------------------------------------

for ((i=inicio; i<inicio+num_directorios; i++)); do
  dir="${base_path}/d${i}"
  echo "Creando estructura base en: $dir"
  mkdir -p "$dir/oracle"                 # Directorio /oracle dentro del disco
  chown -R oracle:oinstall "$dir/oracle" # Propietario y grupo
  chmod -R 750 "$dir/oracle"             # Permisos (rwx para propietario, rx para grupo)
done

# ---------------------------------------------------------------------------
# Dentro de cada disco, crear directorio oradata/<SID> para los datafiles     
# ---------------------------------------------------------------------------

for ((i=inicio; i<inicio+num_directorios; i++)); do
  dir="${base_path}/d${i}/oracle"
  echo "Creando oradata para el SID ${ORACLE_SID^^} en: $dir"
  mkdir -p "$dir/oradata/${ORACLE_SID^^}"
  chown -R oracle:oinstall "$dir/oradata"
  chmod -R 750 "$dir/oradata"
done

# ---------------------------------------------------------------------------
# B. DIRECTORIO DEDICADO PARA LA PDB SEED (pdb$seed)                          
# ---------------------------------------------------------------------------

dir="${base_path}/d17/pdbseed"
echo "Creando directorio PDB Seed en: $dir"
mkdir -p "$dir"
chown oracle:oinstall "$dir"
chmod 750 "$dir"

# ---------------------------------------------------------------------------
# C. DIRECTORIOS PARA REDO LOGS Y CONTROL FILES                               
# ---------------------------------------------------------------------------
# 1) Estructura en la FRA (Fast Recovery Area)                                
# ---------------------------------------------------------------------------

fra_dir="/unam/bda/d11/app/oracle/oradata/${ORACLE_SID^^}"
echo "Creando FRA en: $fra_dir"
mkdir -p "$fra_dir"
chown -R oracle:oinstall "/unam/bda/d11/app"
chmod -R 750 "/unam/bda/d11/app"

# ---------------------------------------------------------------------------
# 2) Segunda y tercera estructura distribuida (d04 y d05)                     
# ---------------------------------------------------------------------------

for disk in d04 d05; do
  path="/unam/bda/disks/${disk}/app/oracle/oradata/${ORACLE_SID^^}"
  echo "Creando estructura adicional en: $path"
  mkdir -p "$path"
  chown -R oracle:oinstall "/unam/bda/disks/${disk}/app"
  chmod -R 750 "/unam/bda/disks/${disk}/app"
done

# ---------------------------------------------------------------------------
# D. (OPCIONAL) MOSTRAR RESULTADOS                                            
# ---------------------------------------------------------------------------
# Descomentar las siguientes líneas para listar los directorios creados.      
#
# echo "\nContenido de /unam/bda/disks/d0*/app/oracle/oradata:" 
# ls -l /unam/bda/disks/d0*/app/oracle/oradata
#
# echo "\nContenido de FRA:" 
# ls -l "$fra_dir"

# ---------------------------------------------------------------------------
# FIN DEL SCRIPT                                                              
# ---------------------------------------------------------------------------
