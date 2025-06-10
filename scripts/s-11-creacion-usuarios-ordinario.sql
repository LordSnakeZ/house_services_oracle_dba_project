-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 09/03/2025                                            ║
-- ║ @Descripción:    Crea dos cuentas (schemas) en la PDB "CHSABDA_S2"     ║
-- ║                  asignando cuotas ilimitadas y privilegios básicos    ║
-- ║                  para los módulos de *Usuarios* y *Servicios*.         ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-------------------------------------------------------------------------------
-- Conexión a la PDB "CHSABDA_S2" como SYSDBA                               --
-------------------------------------------------------------------------------
connect sys/system2@chsabda_s2 as sysdba;

-------------------------------------------------------------------------------
--  Sección A: Usuario y cuotas para el Módulo de Usuarios                  --
-------------------------------------------------------------------------------
create user moduloUsuarios identified by password123;

-- Tablespace por defecto donde se crearán los objetos si no se especifica
alter user moduloUsuarios default tablespace modulo_usuarios_default_tbs;

-- Asignar cuotas ilimitadas en los tablespaces relevantes ------------------
alter user moduloUsuarios quota unlimited on tbs_proveedor;
alter user moduloUsuarios quota unlimited on modulo_usuarios_default_tbs;
alter user moduloUsuarios quota unlimited on tbs_proveedor_lob;
alter user moduloUsuarios quota unlimited on tbs_cuenta_bancaria;
alter user moduloUsuarios quota unlimited on tbs_comprobante;
alter user moduloUsuarios quota unlimited on tbs_comprobante_lob;
alter user moduloUsuarios quota unlimited on tbs_proveedor_servicio;
alter user moduloUsuarios quota unlimited on tbs_banco;
alter user moduloUsuarios quota unlimited on tbs_proveedor_catalogo;
alter user moduloUsuarios quota unlimited on tbs_cliente;
alter user moduloUsuarios quota unlimited on tbs_cliente_lob;
alter user moduloUsuarios quota unlimited on tbs_mod_usuario_indices;

-- Privilegios mínimos de desarrollo ---------------------------------------
grant create session,
      create table,
      create sequence,
      create view,
      create procedure
  to moduloUsuarios;

-------------------------------------------------------------------------------
--  Sección B: Usuario y cuotas para el Módulo de Servicios                 --
-------------------------------------------------------------------------------
create user moduloServicios identified by password123;

-- Tablespace por defecto
alter user moduloServicios default tablespace modulo_servicio_default_tbs;

-- Cuotas ilimitadas para tablespaces del módulo de servicios --------------
alter user moduloServicios quota unlimited on tbs_servicio_1;
alter user moduloServicios quota unlimited on tbs_servicio_2;
alter user moduloServicios quota unlimited on tbs_servicio_lob;
alter user moduloServicios quota unlimited on tbs_historico;
alter user moduloServicios quota unlimited on tbs_servicio_confirmado;
alter user moduloServicios quota unlimited on tbs_servicio_evidencia;
alter user moduloServicios quota unlimited on tbs_servicio_evidencia_lob;
alter user moduloServicios quota unlimited on tbs_pago_servicio;
alter user moduloServicios quota unlimited on tbs_mod_servicio_indices;
alter user moduloServicios quota unlimited on modulo_servicio_default_tbs;

-- Privilegios mínimos de desarrollo ---------------------------------------
grant create session,
      create table,
      create sequence,
      create view,
      create procedure
  to moduloServicios;
