
# Infrastructure Setup

## General Configuration

| Configuration | Description / Location |
|---------------|------------------------|
| Control files (3) | `/unam/bda/d11`, `/unam/bda/disks/d04`, `/unam/bda/disks/d05` |
| REDO groups (3×3 members) | FRA `/unam/bda/d11`, `/unam/bda/d12`, `/unam/bda/d13` |
| Character set | AL32UTF8 |
| Block size | 8 KB |
| Password files | `orapw` for SYS and SYSBACKUP |

## Modules

| Module | Description | Schema Owner |
|--------|-------------|--------------|
| USUARIOS | Manages suppliers, clients and supporting catalogs | `adminUsuario` |
| SERVICIO | Manages service lifecycle and payments | `adminServicios` |

## Table Distribution by Module

| Table | Module |
|-------|--------|
| PROVEEDOR | USUARIOS |
| NIVEL_ESTUDIO | USUARIOS |
| ENTIDAD_NACIMIENTO | USUARIOS |
| COMPROBANTE_EXP | USUARIOS |
| PROVEEDOR_SERVICIO | USUARIOS |
| TIPO_SERVICIO | USUARIOS |
| CUENTA_BANCARIA | USUARIOS |
| BANCO | USUARIOS |
| TARJETA | USUARIOS |
| CLIENTE | USUARIOS |
| EMPRESA | USUARIOS |
| PERSONA | USUARIOS |
| SERVICIO | SERVICIO |
| PAGO_SERVICIO | SERVICIO |
| SERVICIO_CONFIRMADO | SERVICIO |
| CALIFICACION_SERVICIO | SERVICIO |
| DEPOSITO | SERVICIO |
| EVIDENCIA | SERVICIO |
| STATUS_SERVICIO | SERVICIO |
| HISTORICO_STATUS_SERVICIO | SERVICIO |

## Next Steps

See each dedicated document for tablespaces, indexes, and backup strategy.
