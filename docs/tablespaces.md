
# Tablespace Design

| Tablespace | Purpose | File Type | Initial Size | Autosize | Datafile example |
|------------|---------|-----------|--------------|----------|------------------|
| TBS_PROVEEDOR | Supplier master data | Smallfile | 50 MB | YES | `/unam/bda/d18/tbs_f01.dbf` |
| TBS_PROVEEDOR_LOB | Supplier LOBs | Bigfile | 1 GB | YES | `/unam/bda/d19/tbs_f01.dbf` |
| TBS_CUENTA_BANCARIA | Account data | Smallfile | 20 MB | YES | `/unam/bda/d20/tbs_f01.dbf` |
| TBS_SERVICIO | Service core data | Smallfile | 50 MB | YES | `/unam/bda/d18/tbs_f02.dbf` |
| TBS_SERVICIO_LOB | Service LOBs | Bigfile | 2 GB | YES | `/unam/bda/d19/tbs_f02.dbf` |
| TBS_INDICES | Global indexes | Smallfile | 50 MB | YES | `/unam/bda/d21/tbs_f01.dbf` |
| TBS_TEMP_01 | Temporary operations | TEMP | 100 MB | YES | `/unam/bda/d22/tbs_temp01.dbf` |

> **Note**: Sizes taken from script `s-10-crear-tbs-ordinario.sql`. Adjust to match actual usage and growth projections.
