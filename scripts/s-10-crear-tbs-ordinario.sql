-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 09/03/2025                                            ║
-- ║ @Descripción:    Crea la estructura de TABLESPACES necesaria para      ║
-- ║                  los módulos de *Usuarios* y *Servicios* dentro de la  ║
-- ║                  PDB `CHSABDA_S2`. Incluye datafiles distribuidos en   ║
-- ║                  múltiples discos para balancear I/O y facilitar la   ║
-- ║                  administración de LOBs e índices.                     ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

----------------------------------------------------------------------------
-- 1. Conexión a la PDB como usuario SYSDBA                                --
----------------------------------------------------------------------------
-- Nos aseguramos de ejecutar la creación de tablespaces dentro de la       --
-- PDB `CHSABDA_S2` y no en la raíz CDB.                                    --
connect sys/system2@chsabda_s2 as sysdba;

----------------------------------------------------------------------------
-- 2. TABLESPACES para el **Módulo de Usuarios**                           --
--    Cada tablespace se crea con configuración *LOCAL* y *AUTOALLOCATE*    --
--    para la gestión de extents, y *SEGMENT SPACE MANAGEMENT AUTO* para    --
--    habilitar ASSM (Automatic Segment Space Management).                  --
----------------------------------------------------------------------------

-- Datos maestros de proveedores
create tablespace tbs_proveedor
  datafile '/unam/bda/d18/tbs_f01.dbf'
    size 50m
    autoextend on next 100k
  extent management local autoallocate
  segment space management auto;

-- Tablespace por defecto del esquema de usuarios (tablas relacionales)
create tablespace modulo_usuarios_default_tbs
  datafile '/unam/bda/d18/tbs_f02.dbf'
    size 100m
    autoextend on
  extent management local autoallocate
  segment space management auto;

-- ALMACÉN LOB para documentos de proveedores (BLOB/CLOB de gran tamaño)
create bigfile tablespace tbs_proveedor_lob
  datafile '/unam/bda/d19/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Información bancaria de los proveedores
create tablespace tbs_cuenta_bancaria
  datafile '/unam/bda/d20/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Comprobantes fiscales (PDF/XML); tamaño inicial pequeño
create tablespace tbs_comprobante
  datafile '/unam/bda/d21/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

-- LOBs asociados a comprobantes (archivos grandes)
create bigfile tablespace tbs_comprobante_lob
  datafile '/unam/bda/d22/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Relación proveedor‑servicio (tablas puente)
create tablespace tbs_proveedor_servicio
  datafile '/unam/bda/d23/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Catálogo de bancos (catálogos pequeños, sin autoextend)
create tablespace tbs_banco
  datafile '/unam/bda/d24/tbs_f02.dbf'
    size 100m
    autoextend off
  extent management local autoallocate
  segment space management auto;

-- Catálogo de proveedores (tablas de referencia)
create tablespace tbs_proveedor_catalogo
  datafile '/unam/bda/d24/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

-- Información de clientes (particionado horizontal en dos discos)
create tablespace tbs_cliente
  datafile '/unam/bda/d25/tbs_f01.dbf'
    size 100m
    autoextend on next 100m,
           '/unam/bda/d26/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- LOBs de clientes (contratos, imágenes, etc.)
create bigfile tablespace tbs_cliente_lob
  datafile '/unam/bda/d27/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Tablespace exclusivo para índices del módulo de usuarios
create tablespace tbs_mod_usuario_indices
  datafile '/unam/bda/d28/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

----------------------------------------------------------------------------
-- 3. TABLESPACES para el **Módulo de Servicios**                          --
----------------------------------------------------------------------------

-- Datos principales del servicio (distribuidos en dos disks)
create tablespace tbs_servicio_1
  datafile '/unam/bda/d29/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_servicio_2
  datafile '/unam/bda/d30/tbs_f02.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- LOBs asociados (evidencias fotográficas, documentos grandes)
create tablespace tbs_servicio_lob
  datafile '/unam/bda/d31/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Histórico de servicios (dos datafiles en discos distintos)
create tablespace tbs_historico
  datafile '/unam/bda/d32/tbs_f01.dbf'
    size 100m
    autoextend on next 100m,
           '/unam/bda/d33/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Servicios confirmados (crecimiento controlado)
create tablespace tbs_servicio_confirmado
  datafile '/unam/bda/d34/tbs_f01.dbf'
    size 100m 
    autoextend on next 100
  extent management local autoallocate
  segment space management auto;

-- Evidencia en tamaño medio (imágenes comprimidas, etc.)
create tablespace tbs_servicio_evidencia
  datafile '/unam/bda/d35/tbs_f01.dbf'
    size 10m 
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

-- LOBs de evidencia (archivos de gran tamaño)
create bigfile tablespace tbs_servicio_evidencia_lob
  datafile '/unam/bda/d36/tbs_f01.dbf'
    size 100m
    autoextend on next 100m 
  extent management local autoallocate
  segment space management auto;

-- Pagos asociados a servicios
create tablespace tbs_pago_servicio
  datafile '/unam/bda/d37/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

-- Índices del módulo de servicios
create tablespace tbs_mod_servicio_indices
  datafile '/unam/bda/d38/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-- Tablespace por defecto para las nuevas tablas del módulo de servicios
create tablespace modulo_servicio_default_tbs
  datafile '/unam/bda/d37/tbs_f02.dbf'
    size 100m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;
