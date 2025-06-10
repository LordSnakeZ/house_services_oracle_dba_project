
# 1.3.12  Backup‑and‑Recovery Scheme – **House Services DB**
_Last updated: June 10, 2025_

This document formalises the backup, retention, and recovery strategy required by section **1.3.12 Planeación del esquema de respaldos**.

---
## 1  Recovery Area & Global Settings

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| **FRA location** | `/unam/bda/d11` | Same NVMe mount used for redo; fast writes. |
| **FRA size** | **30 GB** | ≈ 15× estimated DB size (2 GB) → 2 weekly L0 + 7 days of archives. |
| `controlfile autobackup` | **ON** | Ensures restore without RMAN catalog. |
| `retention policy` | **RECOVERY WINDOW OF 14 DAYS** | Two weekly cycles kept. |
| `device type disk backup type` | **COMPRESSED BACKUPSET** | Saves ≈40 % disk with minimal CPU. |

```sql
ALTER SYSTEM SET db_recovery_file_dest_size = 30G SCOPE=BOTH;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 14 DAYS;
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET;
```

---
## 2  Backup Calendar

| Cycle | RMAN Level | Frequency | Tag | Output pattern |
|-------|------------|-----------|-----|----------------|
| **Weekly** | Level 0 (full) | Sun 02:00 | `WEEKLY_L0` | `/unam/bda/d11/<DB>_L0_%T_%U.bkp` |
| **Daily** | Level 1 (diff) | Mon–Sat 02:00 | `DAILY_L1` | `/unam/bda/d11/<DB>_L1_%T_%U.bkp` |
| **Archive** | Redo only | Every 30 min | `ARCH_LOGS` | `/unam/bda/d11/<DB>_ARCH_%t_%s_%u.arc` |
| **Monthly** | Image copy | 1st day 03:00 | `MONTHLY_FULL` | `/unam/bda/d11/<DB>_IMG_%T_%U` |

---
## 3  RMAN Command Files (`scripts/rman/`)

### 3.1 `rman_level0.rcv`
```rman
RUN {
  CROSSCHECK ARCHIVELOG ALL;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 DATABASE
    TAG 'WEEKLY_L0'
    FORMAT '/unam/bda/d11/%d_L0_%T_%U.bkp';
  BACKUP CURRENT CONTROLFILE TAG 'CTL_L0';
  DELETE NOPROMPT OBSOLETE;
}
```

### 3.2 `rman_level1.rcv`
```rman
RUN {
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 DATABASE
    TAG 'DAILY_L1'
    FORMAT '/unam/bda/d11/%d_L1_%T_%U.bkp';
  BACKUP CURRENT CONTROLFILE TAG 'CTL_L1';
  DELETE NOPROMPT OBSOLETE;
}
```

### 3.3 `rman_arch.rcv`
```rman
BACKUP ARCHIVELOG ALL
  TAG 'ARCH_LOGS'
  FORMAT '/unam/bda/d11/%d_ARCH_%t_%s_%u.arc'
  DELETE INPUT;
```

### 3.4 `rman_monthly_copy.rcv`
```rman
RUN {
  BACKUP AS COPY DATABASE
    TAG 'MONTHLY_FULL'
    FORMAT '/unam/bda/d11/%d_IMG_%T_%U';
  BACKUP CURRENT CONTROLFILE TAG 'CTL_MONTHLY';
  DELETE NOPROMPT OBSOLETE;
}
```

---
## 4  Wrapper Script (`scripts/s-14-rman-backups.sh`)

```bash
#!/usr/bin/env bash
# Wrapper to trigger RMAN cycles via cron
export ORACLE_SID=free
export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

cd "$HOME/scripts/rman" || exit 1
case "$1" in
  weekly)  rman target / cmdfile=rman_level0.rcv  ;;
  daily)   rman target / cmdfile=rman_level1.rcv  ;;
  arch)    rman target / cmdfile=rman_arch.rcv    ;;
  copy)    rman target / cmdfile=rman_monthly_copy.rcv ;;
  *) echo "Usage: $0 weekly|daily|arch|copy" ; exit 2 ;;
esac
```

Make it executable:
```bash
chmod +x ~/scripts/s-14-rman-backups.sh
```

---
## 5  Cron Schedule

```cron
# MIN HOUR DOM MON DOW  COMMAND
0   2    *   *   0   /home/oracle/scripts/s-14-rman-backups.sh weekly
0   2    *   *   1-6 /home/oracle/scripts/s-14-rman-backups.sh daily
*/30 *   *   *   *   /home/oracle/scripts/s-14-rman-backups.sh arch
0   3    1   *   *   /home/oracle/scripts/s-14-rman-backups.sh copy
```

Logs can be redirected by appending `>> /unam/bda/logs/rman_$(date +\%Y\%m\%d).log 2>&1` to each line.

---
## 6  Validation & Monitoring

1. **Backup presence**
   ```rman
   LIST BACKUP SUMMARY;
   REPORT OBSOLETE;
   ```
2. **FRA usage**
   ```sql
   SELECT SPACE_LIMIT/1024/1024 MB_LIMIT,
          SPACE_USED/1024/1024 MB_USED,
          SPACE_RECLAIMABLE/1024/1024 MB_RECLAIM
   FROM   V$RECOVERY_FILE_DEST;
   ```
3. **Throughput** – query `V$SESSION_LONGOPS` while backups run.

---
## 7  Restore Scenarios to Test

| Scenario | Procedure | Expected |
|----------|-----------|----------|
| **Instance failure** | `shutdown abort` → `startup` | DB opens; redo applied automatically < 2 min |
| **Datafile loss** | `rm datafile` → `RESTORE DATAFILE n; RECOVER DATABASE;` | Tablespace online with zero data loss |
| **Point‑in‑time** | `SET UNTIL TIME '…'` → `RUN { RESTORE DB; RECOVER DB; }` | DB consistent at requested PIT |

---
## 8  Next Steps

* Add the `.rcv` and wrapper scripts into `scripts/` and commit.
* Configure cron; verify first archive‑backup run.
* After the first weekly cycle, capture `LIST BACKUP TAG 'WEEKLY_L0';` output and include it in the final PDF.
