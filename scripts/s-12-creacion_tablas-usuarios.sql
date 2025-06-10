-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                               ║
-- ║ @Fecha creación: 09/03/2025                                            ║
-- ║ @Descripción:    Define la estructura de tablas, restricciones         ║
-- ║                  (PK/FK/CHK) y LOBs requeridas por el módulo de        ║
-- ║                  *Usuarios* dentro de la PDB "CHSABDA_S2". Incluye     ║
-- ║                  catálogos de referencia, entidades principales,       ║
-- ║                  relaciones y tablas auxiliares.                       ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

----------------------------------------------------------------------------
--                                   PREÁMBULO                            --
----------------------------------------------------------------------------
-- Conéctate como el esquema de negocio encargado del módulo de usuarios.  
-- Este script asume que el esquema y los TABLESPACES fueron creados con    
-- `s-11-creacion-usuarios-ordinario.sql` y que las cuotas/grants están     
-- configurados.                                                            
----------------------------------------------------------------------------

CONNECT moduloUsuarios/password123@chsabda_s2;

----------------------------------------------------------------------------
-- TABLA: BANCO                                                            --
----------------------------------------------------------------------------
-- Catálogo de bancos disponibles para asociar cuentas o tarjetas.         --
----------------------------------------------------------------------------
CREATE TABLE BANCO (
    BANCO_ID NUMBER(10)      NOT NULL,
    NOMBRE   VARCHAR2(40)    NOT NULL,
    CONSTRAINT banco_pk PRIMARY KEY (BANCO_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices
) TABLESPACE tbs_banco;

----------------------------------------------------------------------------
-- TABLA: CLIENTE                                                          --
----------------------------------------------------------------------------
-- Registro maestro para CLIENTES (Empresas o Personas).                   --
-- * TIPO: 'E' = Empresa, 'P' = Persona                                    --
----------------------------------------------------------------------------
CREATE TABLE CLIENTE (
    CLIENTE_ID     NUMBER(10)    NOT NULL,
    TIPO           CHAR(1)       NOT NULL,
    NOMBRE_USUARIO VARCHAR2(40)  NOT NULL,
    PASSWORD       VARCHAR2(40)  NOT NULL,
    FECHA_REGISTRO DATE          NOT NULL,
    EMAIL_USUARIO  VARCHAR2(40)  NOT NULL,
    TELEFONO       VARCHAR2(40)  NOT NULL,
    DIRECCION      VARCHAR2(40)  NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (CLIENTE_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT cliente_tipo_chk CHECK (TIPO IN ('E','P'))
) TABLESPACE tbs_cliente;

----------------------------------------------------------------------------
-- TABLA: ENTIDAD_NACIMIENTO                                               --
----------------------------------------------------------------------------
-- Catálogo de entidades federativas de nacimiento para el proveedor.      --
----------------------------------------------------------------------------
CREATE TABLE ENTIDAD_NACIMIENTO (
    ENTIDAD_NACIMIENTO_ID NUMBER(5)   NOT NULL,
    NOMBRE                VARCHAR2(40) NOT NULL,
    CONSTRAINT entidad_nacimiento_pk PRIMARY KEY (ENTIDAD_NACIMIENTO_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices
) TABLESPACE tbs_proveedor_catalogo;

----------------------------------------------------------------------------
-- TABLA: NIVEL_ESTUDIO                                                    --
----------------------------------------------------------------------------
-- Catálogo de niveles de estudio para proveedores.                        --
----------------------------------------------------------------------------
CREATE TABLE NIVEL_ESTUDIO (
    NIVEL_ESTUDIO_ID NUMBER(10)   NOT NULL,
    NOMBRE           VARCHAR2(40) NOT NULL,
    CONSTRAINT nivel_estudio_pk PRIMARY KEY (NIVEL_ESTUDIO_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices
) TABLESPACE tbs_proveedor_catalogo;

----------------------------------------------------------------------------
-- TABLA: PROVEEDOR                                                        --
----------------------------------------------------------------------------
-- Información completa del proveedor. Incluye LOBs para foto e            
-- identificaciones. Se auto‑relaciona para distinguir representante.       
----------------------------------------------------------------------------
CREATE TABLE PROVEEDOR (
    PROVEEDOR_ID          NUMBER(10)  NOT NULL,
    NOMBRE                VARCHAR2(20) NOT NULL,
    AP_PATERNO            VARCHAR2(40) NOT NULL,
    AP_MATERNO            VARCHAR2(40) NOT NULL,
    FOTO                  BLOB         NOT NULL,
    F_NACIMIENTO          DATE         NOT NULL,
    DIRECCION             VARCHAR2(40) NOT NULL,
    EMAIL                 VARCHAR2(40) NOT NULL,
    TEL_MOVIL             VARCHAR2(10) NOT NULL,
    TEL_CASA              VARCHAR2(10) NOT NULL,
    IDENTIFICACION        BLOB         NOT NULL,
    C_DOMICILIO           BLOB         NOT NULL,
    ENTIDAD_NACIMIENTO_ID NUMBER(5)    NOT NULL,
    NIVEL_ESTUDIO_ID      NUMBER(10)   NOT NULL,
    PROV_REPRESENTANTE_ID NUMBER(10),
    CONSTRAINT proveedor_pk PRIMARY KEY (PROVEEDOR_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT proveedor_entidad_nacimiento_fk FOREIGN KEY (ENTIDAD_NACIMIENTO_ID)
        REFERENCES ENTIDAD_NACIMIENTO (ENTIDAD_NACIMIENTO_ID),
    CONSTRAINT proveedor_nivel_estudio_fk FOREIGN KEY (NIVEL_ESTUDIO_ID)
        REFERENCES NIVEL_ESTUDIO (NIVEL_ESTUDIO_ID),
    CONSTRAINT proveedor_representante_fk FOREIGN KEY (PROV_REPRESENTANTE_ID)
        REFERENCES PROVEEDOR (PROVEEDOR_ID)
) TABLESPACE tbs_proveedor
  LOB (FOTO) STORE AS proveedor_foto_lob (
        TABLESPACE tbs_proveedor_lob DISABLE STORAGE IN ROW
        INDEX proveedor_foto_lob_index
      )
  LOB (IDENTIFICACION) STORE AS proveedor_ident_lob (
        TABLESPACE tbs_proveedor_lob DISABLE STORAGE IN ROW
        INDEX proveedor_ident_lob_index
      )
  LOB (C_DOMICILIO) STORE AS proveedor_cdomicilio_lob (
        TABLESPACE tbs_proveedor_lob DISABLE STORAGE IN ROW
        INDEX proveedor_cdomicilio_lob_index
      );

----------------------------------------------------------------------------
-- TABLA: TIPO_SERVICIO                                                   --
----------------------------------------------------------------------------
-- Catálogo de servicios disponibles.                                     --
----------------------------------------------------------------------------
CREATE TABLE TIPO_SERVICIO (
    TIPO_SERVICIO_ID NUMBER(10)  NOT NULL,
    NOMBRE_SERVICIO  VARCHAR2(6) NOT NULL,
    DESCRIPCION      VARCHAR2(40) NOT NULL,
    CONSTRAINT tipo_servicio_pk PRIMARY KEY (TIPO_SERVICIO_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices
) TABLESPACE tbs_proveedor_catalogo;

----------------------------------------------------------------------------
-- TABLA: PROVEEDOR_SERVICIO                                              --
----------------------------------------------------------------------------
-- Relación N‑N entre PROVEEDOR y TIPO_SERVICIO con atributos propios.     --
----------------------------------------------------------------------------
CREATE TABLE PROVEEDOR_SERVICIO (
    PROVEEDOR_SERVICIO_ID NUMBER(10) NOT NULL,
    EXPERIENCIA           NUMBER(2)  NOT NULL, -- años
    PROVEEDOR_ID          NUMBER(10) NOT NULL,
    TIPO_SERVICIO_ID      NUMBER(10) NOT NULL,
    CONSTRAINT proveedor_servicio_pk PRIMARY KEY (PROVEEDOR_SERVICIO_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT prov_servicio_proveedor_fk FOREIGN KEY (PROVEEDOR_ID)
        REFERENCES PROVEEDOR (PROVEEDOR_ID),
    CONSTRAINT prov_servicio_tipo_servicio_fk FOREIGN KEY (TIPO_SERVICIO_ID)
        REFERENCES TIPO_SERVICIO (TIPO_SERVICIO_ID)
) TABLESPACE tbs_proveedor_servicio;

----------------------------------------------------------------------------
-- TABLA: COMPROBANTE_EXP                                                 --
----------------------------------------------------------------------------
-- Evidencia documentada de la experiencia del proveedor. LOB para PDF.    --
----------------------------------------------------------------------------
CREATE TABLE COMPROBANTE_EXP (
    COMPROBANTE_EXP_ID    NUMBER(10) NOT NULL,
    DOCUMENTO_EXP         BLOB       NOT NULL,
    PROVEEDOR_SERVICIO_ID NUMBER(10) NOT NULL,
    CONSTRAINT comprobante_exp_pk PRIMARY KEY (COMPROBANTE_EXP_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT comprobante_exp_ps_fk FOREIGN KEY (PROVEEDOR_SERVICIO_ID)
        REFERENCES PROVEEDOR_SERVICIO (PROVEEDOR_SERVICIO_ID)
) TABLESPACE tbs_comprobante
  LOB (DOCUMENTO_EXP) STORE AS comprobante_exp_lob (
        TABLESPACE tbs_comprobante_lob DISABLE STORAGE IN ROW
        INDEX comprobante_exp_lob_index
      );

----------------------------------------------------------------------------
-- TABLA: CUENTA_BANCARIA                                                --
----------------------------------------------------------------------------
-- Cuentas bancarias de los proveedores para pagos.                       --
----------------------------------------------------------------------------
CREATE TABLE CUENTA_BANCARIA (
    CUENTA_BANCARIA_ID NUMBER(10) NOT NULL,
    BANCO_ID           NUMBER(10) NOT NULL,
    CLABE              NUMBER(18) NOT NULL,
    PROVEEDOR_ID       NUMBER(10) NOT NULL,
    CONSTRAINT cuenta_bancaria_pk PRIMARY KEY (CUENTA_BANCARIA_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT cuenta_bancaria_banco_fk FOREIGN KEY (BANCO_ID)
        REFERENCES BANCO (BANCO_ID),
    CONSTRAINT cuenta_bancaria_proveedor_fk FOREIGN KEY (PROVEEDOR_ID)
        REFERENCES PROVEEDOR (PROVEEDOR_ID)
) TABLESPACE tbs_cuenta_bancaria;

----------------------------------------------------------------------------
-- TABLA: EMPRESA                                                         --
----------------------------------------------------------------------------
-- Detalles específicos cuando el CLIENTE es de tipo Empresa.             --
----------------------------------------------------------------------------
CREATE TABLE EMPRESA (
    CLIENTE_ID      NUMBER(10)  NOT NULL,
    NOMBRE_EMPRESA  VARCHAR2(40) NOT NULL,
    DESCRIPCION     VARCHAR2(40) NOT NULL,
    LOGOTIPO        BLOB         NOT NULL,
    NUM_EMPLEADOS   NUMBER(10)   NOT NULL,
    CONSTRAINT empresa_pk PRIMARY KEY (CLIENTE_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT empresa_cliente_fk FOREIGN KEY (CLIENTE_ID)
        REFERENCES CLIENTE (CLIENTE_ID)
) TABLESPACE tbs_cliente
  LOB (LOGOTIPO) STORE AS empresa_logo_lob (
        TABLESPACE tbs_cliente_lob DISABLE STORAGE IN ROW
        INDEX empresa_logo_lob_index
      );

----------------------------------------------------------------------------
-- TABLA: PERSONA                                                         --
----------------------------------------------------------------------------
-- Detalles cuando el CLIENTE es una persona física. Incluye foto.        --
----------------------------------------------------------------------------
CREATE TABLE PERSONA (
    CLIENTE_ID   NUMBER(10)  NOT NULL,
    NOMBRE       VARCHAR2(40) NOT NULL,
    FOTO         BLOB         NOT NULL,
    CURP         VARCHAR2(18) NOT NULL,
    F_NACIMIENTO DATE         NOT NULL,
    CONSTRAINT persona_pk PRIMARY KEY (CLIENTE_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT persona_cliente_fk FOREIGN KEY (CLIENTE_ID)
        REFERENCES CLIENTE (CLIENTE_ID)
) TABLESPACE tbs_cliente
  LOB (FOTO) STORE AS persona_foto_lob (
        TABLESPACE tbs_cliente_lob DISABLE STORAGE IN ROW
        INDEX persona_foto_lob_index
      );

----------------------------------------------------------------------------
-- TABLA: TARJETA                                                         --
----------------------------------------------------------------------------
-- Tarjetas de crédito/débito asociadas a un CLIENTE.                     --
----------------------------------------------------------------------------
CREATE TABLE TARJETA (
    TARJETA_ID      NUMBER(10) NOT NULL,
    NUMERO          NUMBER(10) NOT NULL,
    ANIO_EXP        NUMBER(2)  NOT NULL,
    MES_EXP         NUMBER(2)  NOT NULL,
    NUM_SEGURIDAD   NUMBER(3)  NOT NULL,
    CLIENTE_ID      NUMBER(10) NOT NULL,
    BANCO_ID        NUMBER(10) NOT NULL,
    CONSTRAINT tarjeta_pk PRIMARY KEY (TARJETA_ID)
        USING INDEX TABLESPACE tbs_mod_usuario_indices,
    CONSTRAINT tarjeta_cliente_fk FOREIGN KEY (CLIENTE_ID)
        REFERENCES CLIENTE (CLIENTE_ID),
    CONSTRAINT tarjeta_banco_fk FOREIGN KEY (BANCO_ID)
        REFERENCES BANCO (BANCO_ID)
) TABLESPACE tbs_tarjeta;

-- Fin de script
