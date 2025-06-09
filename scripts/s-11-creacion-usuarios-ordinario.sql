
connect sys/system2@chsabda_s2 as sysdba;


----------------------------------------------------
----------Usuario para modulo de usuarios----------
----------------------------------------------------

create user moduloUsuarios identified by password123;
alter user moduloUsuarios default tablespace modulo_usuarios_default_tbs;
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
grant create session, create table, create sequence, create view, create procedure to moduloUsuarios;

----------------------------------------------------
----------Usuario para modulo de servicios----------
----------------------------------------------------

create user moduloServicios identified by password123;
alter user moduloServicios default tablespace modulo_servicio_default_tbs;
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
grant create session, create table, create sequence, create view, create procedure to moduloServicios;


