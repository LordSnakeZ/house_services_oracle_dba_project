
# Backup & Recovery Strategy

## Flash Recovery Area (FRA)

- **Location**: `/unam/bda/d11`
- **Size**: 10 GB (adjust via `db_recovery_file_dest_size`)
- Contains archive logs, backups and control file copies.

## ARCHIVELOG Mode

```sql
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
archive log list;
```

## RMAN Policy

| Item | Setting |
|------|---------|
| Retention | `RECOVERY WINDOW OF 7 DAYS` |
| Compression | `BASIC` |
| Controlfile autobackup | ON |

### Backup Schedule

| Frequency | RMAN Command | Notes |
|-----------|--------------|-------|
| Weekly (Sun 02:00) | `BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 0 DATABASE PLUS ARCHIVELOG;` | Level 0 full |
| Daily (Mon–Sat 02:00) | `BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 DATABASE;` | Differential |
| Every 30 min | `BACKUP ARCHIVELOG ALL DELETE INPUT;` | Archive logs |

Use `cron` or `systemd timer` to invoke `rman @/opt/house_services/scripts/rman_weekly.rcv`.

## Validation

- **Instance recovery**: `shutdown abort` then `startup`.
- **Media recovery**: Remove a datafile, restore with RMAN:

```bash
rman target /
RMAN> RESTORE DATAFILE 4;
RMAN> RECOVER DATABASE;
```

Document MTTR and recovery steps in this file after tests.
