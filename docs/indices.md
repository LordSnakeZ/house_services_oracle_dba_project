
# Index Strategy

| Module | Table | Index | Type | Purpose |
|--------|-------|-------|------|---------|
| USUARIOS | PROVEEDOR | PROVEEDOR_NOMBRE_IFX | Function-based | Case-insensitive search by name |
| USUARIOS | PROVEEDOR | PROVEEDOR_AP_PATERNO_IFX | Function-based | Search by paternal surname |
| USUARIOS | PROVEEDOR | PROVEEDOR_AP_MATERNO_IFX | Function-based | Search by maternal surname |
| USUARIOS | PROVEEDOR | PROVEEDOR_IDENTIFICACION_LOBI | LOB | Secure document storage |
| USUARIOS | PROVEEDOR_SERVICIO | PROVEEDOR_SERVICIO_PROVEEDOR_ID_IX | Non‑unique | Foreign key lookup acceleration |
| USUARIOS | COMPROBANTE_EXP | COMPROBANTE_EXP_DOCUMENTO_LOBI | LOB | Attachment storage |
| USUARIOS | CUENTA_BANCARIA | C_BANCARIA_CLABE_IUK | Unique | Avoid duplicated CLABE numbers |
| USUARIOS | CLIENTE | CLIENTE_NOMBRE_USUARIO_IUK | Unique | Prevent duplicate usernames |
| USUARIOS | CLIENTE | CLIENTE_EMAIL_IUK | Unique | Email uniqueness |
| USUARIOS | TARJETA | NUMERO_CLIENTE_ID_IX | Non‑unique | FK lookup |
| USUARIOS | EMPRESA | EMPRESA_NOMBRE_IFX | Function-based | Case‑insensitive search |
| USUARIOS | PERSONA | PERSONA_CURP_IUK | Unique | Prevent duplicate CURP |
| SERVICIO | SERVICIO | SERVICIO_DOCUMENTO_LOBI | LOB | Files and notes |
| SERVICIO | SERVICIO_CONFIRMADO | SER_CONFIRMADO_DOCUMENTO_LOBI | LOB | Files and notes |
| SERVICIO | DEPOSITO | DEPOSITO_COMPROBANTE_LOBI | LOB | Proof of deposit |
| SERVICIO | EVIDENCIA | EVIDENCIA_IMAGE_LOBI | LOB | Images |

> LOB indexes will be created with `TABLESPACE ..._LOB` so that LOB segments stay on dedicated bigfile tablespaces.
