# 1.3.12  Esquema de Respaldos y Recuperación – **House Services DB**
_Actualización: 11 Jun 2025_

Este documento formaliza la estrategia de respaldo‑recuperación solicitada en la sección **1.3.12 Planeación del esquema de respaldos**.

---

## 1  Área de Recuperación Flash (FRA) y parámetros globales

| Parámetro | Valor | Justificación |
|-----------|-------|---------------|
| **Ubicación FRA** | `/unam/bda/d11` | Mismo NVMe que los REDO → I/O rápido. |
| **Tamaño FRA** | **20 GB** | 10 × tamaño BD (≈ 2 GB) + holgura para 1 L0 + 6 L1 + 7 d de archivelogs. |
| `CONTROLFILE AUTOBACKUP` | **ON** | Permite restaurar sin catálogo RMAN. |
| `RETENTION POLICY` | **RECOVERY WINDOW OF 7 DÍAS** | Mantiene un ciclo completo. |
| Tipo de copia | **BACKUPSET COMPRIMIDO** | Ahorra ~40 % de disco con bajo impacto CPU. |

```sql
ALTER SYSTEM SET db_recovery_file_dest_size = 20G  SCOPE = BOTH;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET;
```

---

## 2  Calendario de respaldos

| Ciclo | Nivel RMAN | Frecuencia | Tag | Ruta / patrón |
|-------|------------|------------|-----|---------------|
| **Semanal** | Level 0 (full) | Dom 02:00 | `WEEKLY_L0` | `/unam/bda/d11/<DB>_L0_%T_%U.bkp` |
| **Diario** | Level 1 (dif.) | Lun–Sáb 02:00 | `DAILY_L1` | `/unam/bda/d11/<DB>_L1_%T_%U.bkp` |
| **Archivelog** | Solo redo | Cada 30 min | `ARCH_LOGS` | `/unam/bda/d11/<DB>_ARCH_%t_%s_%u.arc` |
| **Mensual** | Image copy | 1 de mes 02:00 | `MONTHLY_FULL` | `/unam/backups/monthly/<DB>_IMG_%T_%U` |

> La copia‑imagen mensual se guarda **fuera de la FRA** (`/unam/backups/monthly`) para no saturar los 20 GB.

---

## 3  Archivos de comandos RMAN (`scripts/rman/`)

### 3.1 `rman_level0.rcv`
```rman
RUN {
  CROSSCHECK ARCHIVELOG ALL;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 DATABASE
    TAG 'WEEKLY_L0'
  BACKUP CURRENT CONTROLFILE TAG 'CTL_L0';
  DELETE NOPROMPT OBSOLETE;
}
```

### 3.2 `rman_level1.rcv`
```rman
RUN {
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 DATABASE
    TAG 'DAILY_L1'
  BACKUP CURRENT CONTROLFILE TAG 'CTL_L1';
  DELETE NOPROMPT OBSOLETE;
}
```

### 3.3 `rman_arch.rcv`
```rman
BACKUP ARCHIVELOG ALL
  TAG 'ARCH_LOGS'
  DELETE INPUT;
```

### 3.4 `rman_monthly_copy.rcv`
```rman
RUN {
  BACKUP AS COPY DATABASE
    TAG 'MONTHLY_FULL'
  BACKUP CURRENT CONTROLFILE TAG 'CTL_MONTHLY';
  DELETE NOPROMPT OBSOLETE;
}
```

---

## 4  Script envoltorio (`scripts/s-14-rman-backups.sh`)

```bash
#!/usr/bin/env bash
export ORACLE_SID=free
export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

cd "$HOME/scripts/rman" || exit 1
case "$1" in
  weekly)  rman target / cmdfile=rman_level0.rcv        ;;
  daily)   rman target / cmdfile=rman_level1.rcv        ;;
  arch)    rman target / cmdfile=rman_arch.rcv          ;;
  copy)    rman target / cmdfile=rman_monthly_copy.rcv  ;;
  *) echo "Uso: $0 {weekly|daily|arch|copy}" ; exit 2 ;;
esac
```

> `chmod +x ~/scripts/s-14-rman-backups.sh`

---

## 5  Programación en cron

```cron
# MIN HORA DOM MES DOW  COMANDO
0   2    *   *   0   /home/oracle/scripts/s-14-rman-backups.sh weekly
0   2    *   *   1-6 /home/oracle/scripts/s-14-rman-backups.sh daily
*/30 *   *   *   *   /home/oracle/scripts/s-14-rman-backups.sh arch
0   3    1   *   *   /home/oracle/scripts/s-14-rman-backups.sh copy
```
---

## 6  Validación y monitoreo

1. **Verificar respaldos**
   ```rman
   LIST BACKUP SUMMARY;
   REPORT OBSOLETE;
   ```
2. **Uso de FRA**
   ```sql
   SELECT space_limit/1024/1024 MB_LIMIT,
          space_used/1024/1024 MB_USED,
          space_reclaimable/1024/1024 MB_RECLAIM
   FROM   v$recovery_file_dest;
   ```