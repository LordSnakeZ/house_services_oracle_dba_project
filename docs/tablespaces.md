
    # Tablespace Design

    This document lists every tablespace defined for the **House Services** database, grouped by module.

    | Module   | Tablespace                  | Datafile(s)                                          | Initial Size   | Autoextend   | Type      |
|:---------|:----------------------------|:-----------------------------------------------------|:---------------|:-------------|:----------|
| USUARIOS | TBS_PROVEEDOR               | /unam/bda/d18/tbs_f01.dbf                            | 50m            | ON next 100k | Smallfile |
| USUARIOS | MODULO_USUARIOS_DEFAULT_TBS | /unam/bda/d18/tbs_f02.dbf                            | 100m           | ON           | Smallfile |
| USUARIOS | TBS_PROVEEDOR_LOB           | /unam/bda/d19/tbs_f01.dbf                            | 100m           | ON next 100m | Bigfile   |
| USUARIOS | TBS_CUENTA_BANCARIA         | /unam/bda/d20/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| USUARIOS | TBS_COMPROBANTE             | /unam/bda/d21/tbs_f01.dbf                            | 10m            | ON next 10m  | Smallfile |
| USUARIOS | TBS_COMPROBANTE_LOB         | /unam/bda/d22/tbs_f01.dbf                            | 100m           | ON next 100m | Bigfile   |
| USUARIOS | TBS_PROVEEDOR_SERVICIO      | /unam/bda/d23/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| USUARIOS | TBS_BANCO                   | /unam/bda/d24/tbs_f02.dbf                            | 100m           | OFF          | Smallfile |
| USUARIOS | TBS_PROVEEDOR_CATALOGO      | /unam/bda/d24/tbs_f01.dbf                            | 10m            | ON next 10m  | Smallfile |
| USUARIOS | TBS_CLIENTE                 | /unam/bda/d25/tbs_f01.dbf, /unam/bda/d26/tbs_f01.dbf | 2×100m         | ON next 100m | Smallfile |
| USUARIOS | TBS_CLIENTE_LOB             | /unam/bda/d27/tbs_f01.dbf                            | 100m           | ON next 100m | Bigfile   |
| USUARIOS | TBS_MOD_USUARIO_INDICES     | /unam/bda/d28/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | TBS_SERVICIO_1              | /unam/bda/d29/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | TBS_SERVICIO_2              | /unam/bda/d30/tbs_f02.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | TBS_SERVICIO_LOB            | /unam/bda/d31/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | TBS_HISTORICO               | /unam/bda/d32/tbs_f01.dbf, /unam/bda/d33/tbs_f01.dbf | 2×100m         | ON next 100m | Smallfile |
| SERVICIO | TBS_SERVICIO_CONFIRMADO     | /unam/bda/d34/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | TBS_SERVICIO_EVIDENCIA      | /unam/bda/d35/tbs_f01.dbf                            | 10m            | ON next 10m  | Smallfile |
| SERVICIO | TBS_SERVICIO_EVIDENCIA_LOB  | /unam/bda/d36/tbs_f01.dbf                            | 100m           | ON next 100m | Bigfile   |
| SERVICIO | TBS_PAGO_SERVICIO           | /unam/bda/d37/tbs_f01.dbf                            | 10m            | ON next 10m  | Smallfile |
| SERVICIO | TBS_MOD_SERVICIO_INDICES    | /unam/bda/d38/tbs_f01.dbf                            | 100m           | ON next 100m | Smallfile |
| SERVICIO | MODULO_SERVICIO_DEFAULT_TBS | /unam/bda/d37/tbs_f02.dbf                            | 100m           | ON next 10m  | Smallfile |

    **Conventions**

    - *Smallfile*: Regular tablespaces; may have multiple datafiles (unless noted with commas).  
    - *Bigfile*: Single-datafile tablespaces that can grow very large; ideal for LOB segments.  
    - *Autoextend*: `ON` columns include the NEXT increment; `OFF` means manual resizing.

    All tablespaces use `extent management local autoallocate` and `segment space management auto`.
