connect sys/system2@chsabda_s2 as sysdba;

-----------------------------------------------------------
----------Tablespaces para el modulo de usuarios-----------
-----------------------------------------------------------
create tablespace tbs_proveedor
  datafile '/unam/bda/d18/tbs_f01.dbf'
    size 50m
    autoextend on next 100k
  extent management local autoallocate
  segment space management auto;

create tablespace modulo_usuarios_default_tbs
  datafile '/unam/bda/d18/tbs_f02.dbf'
    size 100m
    autoextend on
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace tbs_proveedor_lob
  datafile '/unam/bda/d19/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_cuenta_bancaria
  datafile '/unam/bda/d20/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_comprobante
  datafile '/unam/bda/d21/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace tbs_comprobante_lob
  datafile '/unam/bda/d22/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_proveedor_servicio
  datafile '/unam/bda/d23/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_banco
  datafile '/unam/bda/d24/tbs_f02.dbf'
    size 100m
    autoextend off
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_proveedor_catalogo
  datafile '/unam/bda/d24/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_cliente
  datafile '/unam/bda/d25/tbs_f01.dbf'
    size 100m
    autoextend on next 100m,
           '/unam/bda/d26/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace tbs_cliente_lob
  datafile '/unam/bda/d27/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_mod_usuario_indices
  datafile '/unam/bda/d28/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

-----------------------------------------------------------
----------Tablespaces para el modulo de servicios----------
-----------------------------------------------------------

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

create tablespace tbs_servicio_lob
  datafile '/unam/bda/d31/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_historico
  datafile '/unam/bda/d32/tbs_f01.dbf'
    size 100m
    autoextend on next 100m,
           '/unam/bda/d33/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_servicio_confirmado
  datafile '/unam/bda/d34/tbs_f01.dbf'
    size 100m 
    autoextend on next 100
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_servicio_evidencia
  datafile '/unam/bda/d35/tbs_f01.dbf'
    size 10m 
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace tbs_servicio_evidencia_lob
  datafile '/unam/bda/d36/tbs_f01.dbf'
    size 100m
    autoextend on next 100m 
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_pago_servicio
  datafile '/unam/bda/d37/tbs_f01.dbf'
    size 10m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;

create tablespace tbs_mod_servicio_indices
  datafile '/unam/bda/d38/tbs_f01.dbf'
    size 100m
    autoextend on next 100m
  extent management local autoallocate
  segment space management auto;

create tablespace modulo_servicio_default_tbs
  datafile '/unam/bda/d37/tbs_f02.dbf'
    size 100m
    autoextend on next 10m
  extent management local autoallocate
  segment space management auto;
