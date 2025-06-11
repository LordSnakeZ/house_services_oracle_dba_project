# Catálogo de Tablespaces

| Módulo | Tablespace | Propósito | Configuración | Datafile(s) |
|--------|------------|-----------|---------------|-------------|
| USUARIOS | TBS_PROVEEDOR | Datos maestros de proveedores | Smallfile 50M, autoextend 100K | /unam/bda/d18/tbs_f01.dbf |
| USUARIOS | MODULO_USUARIOS_DEFAULT_TBS | Default para módulo | Smallfile 100M, autoextend ON | /unam/bda/d18/tbs_f02.dbf |
| USUARIOS | TBS_PROVEEDOR_LOB | LOBs de proveedor | Bigfile 100M, autoextend 100M | /unam/bda/d19/tbs_f01.dbf |
| USUARIOS | TBS_CUENTA_BANCARIA | Cuentas bancarias | Smallfile 100M, autoextend 100M | /unam/bda/d20/tbs_f01.dbf |
| USUARIOS | TBS_COMPROBANTE | Datos comprobantes | Smallfile 10M, autoextend 10M | /unam/bda/d21/tbs_f01.dbf |
| USUARIOS | TBS_COMPROBANTE_LOB | LOBs comprobante | Bigfile 100M, autoextend 100M | /unam/bda/d22/tbs_f01.dbf |
| USUARIOS | TBS_PROVEEDOR_SERVICIO | Relación proveedor-servicio | Smallfile 100M, autoextend 100M | /unam/bda/d23/tbs_f01.dbf |
| USUARIOS | TBS_BANCO | Catálogo bancos | Smallfile 100M, autoextend OFF | /unam/bda/d24/tbs_f02.dbf |
| USUARIOS | TBS_PROVEEDOR_CATALOGO | Catálogos proveedor | Smallfile 10M, autoextend 10M | /unam/bda/d24/tbs_f01.dbf |
| USUARIOS | TBS_CLIENTE | Datos clientes | Smallfile 2×100M, autoextend 100M | /unam/bda/d25/tbs_f01.dbf /d26/tbs_f01.dbf |
| USUARIOS | TBS_CLIENTE_LOB | LOBs cliente | Bigfile 100M, autoextend 100M | /unam/bda/d27/tbs_f01.dbf |
| USUARIOS | TBS_MOD_USUARIO_INDICES | Índices módulo usuarios | Smallfile 100M, autoextend 100M | /unam/bda/d28/tbs_f01.dbf |
| USUARIOS | TBS_TARJETA | Tarjetas de cliente | Smallfile 10M, autoextend 10M | /unam/bda/d39/tbs_f01.dbf |
| SERVICIO | TBS_SERVICIO_1 | Partición servicio Q1 | Smallfile 100M, autoextend 100M | /unam/bda/d29/tbs_f01.dbf |
| SERVICIO | TBS_SERVICIO_2 | Partición servicio Q2 | Smallfile 100M, autoextend 100M | /unam/bda/d30/tbs_f02.dbf |
| SERVICIO | TBS_SERVICIO_LOB | LOBs servicio | Smallfile 100M, autoextend 100M | /unam/bda/d31/tbs_f01.dbf |
| SERVICIO | TBS_HISTORICO | Histórico estatus | Smallfile 2×100M, autoextend 100M | /unam/bda/d32/tbs_f01.dbf /d33/tbs_f01.dbf |
| SERVICIO | TBS_SERVICIO_CONFIRMADO | Documentos confirmación | Smallfile 100M, autoextend 100 | /unam/bda/d34/tbs_f01.dbf |
| SERVICIO | TBS_SERVICIO_EVIDENCIA | Metadatos evidencias | Smallfile 10M, autoextend 10M | /unam/bda/d35/tbs_f01.dbf |
| SERVICIO | TBS_SERVICIO_EVIDENCIA_LOB | LOBs evidencias | Bigfile 100M, autoextend 100M | /unam/bda/d36/tbs_f01.dbf |
| SERVICIO | TBS_PAGO_SERVICIO | Pagos de servicio | Smallfile 10M, autoextend 10M | /unam/bda/d37/tbs_f01.dbf |
| SERVICIO | TBS_MOD_SERVICIO_INDICES | Índices módulo servicio | Smallfile 100M, autoextend 100M | /unam/bda/d38/tbs_f01.dbf |
| SERVICIO | MODULO_SERVICIO_DEFAULT_TBS | Default módulo servicio | Smallfile 100M, autoextend 10M | /unam/bda/d37/tbs_f02.dbf |