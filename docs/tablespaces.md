
# Tablespace Catalogue

| Module | Tablespace | Purpose | Size & Datafile(s) / Autoextend |
|--------|------------|---------|---------------------------------|
| USUARIOS | TBS_PROVEEDOR | Supplier master data | 50 MB | /unam/bda/d18/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 K |
| USUARIOS | MODULO_USUARIOS_DEFAULT_TBS | Default segment allocation | 100 MB | /unam/bda/d18/tbs_f02.dbf | AUTOEXTEND ON |
| USUARIOS | TBS_PROVEEDOR_LOB | Supplier LOBs | 100 MB | /unam/bda/d19/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB (BIGFILE) |
| USUARIOS | TBS_CUENTA_BANCARIA | Bank account data | 100 MB | /unam/bda/d20/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| USUARIOS | TBS_COMPROBANTE | Comprobante core data | 10 MB | /unam/bda/d21/tbs_f01.dbf | AUTOEXTEND ON NEXT 10 MB |
| USUARIOS | TBS_COMPROBANTE_LOB | Comprobante documents | 100 MB | /unam/bda/d22/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB (BIGFILE) |
| USUARIOS | TBS_PROVEEDOR_SERVICIO | Proveedor–Servicio join | 100 MB | /unam/bda/d23/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| USUARIOS | TBS_BANCO | Bank catalog | 100 MB | /unam/bda/d24/tbs_f02.dbf | AUTOEXTEND **OFF** |
| USUARIOS | TBS_PROVEEDOR_CATALOGO | Service & education catalogs | 10 MB | /unam/bda/d24/tbs_f01.dbf | AUTOEXTEND ON NEXT 10 MB |
| USUARIOS | TBS_CLIENTE | Client master data | 2×100 MB | /unam/bda/d25/d26 | AUTOEXTEND ON NEXT 100 MB |
| USUARIOS | TBS_CLIENTE_LOB | Client photos & logos | 100 MB | /unam/bda/d27/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB (BIGFILE) |
| USUARIOS | TBS_MOD_USUARIO_INDICES | Indexes for USUARIOS | 100 MB | /unam/bda/d28/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_SERVICIO_1 | Service data partition Q1 | 100 MB | /unam/bda/d29/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_SERVICIO_2 | Service data partition Q2 | 100 MB | /unam/bda/d30/tbs_f02.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_SERVICIO_LOB | Service documents | 100 MB | /unam/bda/d31/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_HISTORICO | Historic status | 2×100 MB | /unam/bda/d32/d33 | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_SERVICIO_CONFIRMADO | Confirmed service docs | 100 MB | /unam/bda/d34/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | TBS_SERVICIO_EVIDENCIA | Evidence metadata | 10 MB | /unam/bda/d35/tbs_f01.dbf | AUTOEXTEND ON NEXT 10 MB |
| SERVICIO | TBS_SERVICIO_EVIDENCIA_LOB | Evidence LOBs | 100 MB | /unam/bda/d36/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB (BIGFILE) |
| SERVICIO | TBS_PAGO_SERVICIO | Payments | 10 MB | /unam/bda/d37/tbs_f01.dbf | AUTOEXTEND ON NEXT 10 MB |
| SERVICIO | TBS_MOD_SERVICIO_INDICES | Indexes for SERVICIO | 100 MB | /unam/bda/d38/tbs_f01.dbf | AUTOEXTEND ON NEXT 100 MB |
| SERVICIO | MODULO_SERVICIO_DEFAULT_TBS | Default tablespace for module | 100 MB | /unam/bda/d37/tbs_f02.dbf | AUTOEXTEND ON NEXT 10 MB |
