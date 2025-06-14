-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║ @Autores:       Chávez Mejía Luis Héctor                              ║
-- ║                 Sánchez Sánchez Santiago                              ║
-- ║ @Fecha creación: 09/03/2025                                           ║
-- ║ @Descripción:    Define las tablas y restricciones principales del    ║
-- ║                  módulo de *Servicios* en la PDB `CHSABDA_S2`.        ║
-- ║                  Incluye particionamiento por rango, LOBs externos,   ║
-- ║                  manejo de evidencias, históricos y pagos.            ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

-------------------------------------------------------------------------------
-- Conectar al schema de trabajo                                              --
-------------------------------------------------------------------------------
conn moduloServicios/password123@chsabda_s2;

-------------------------------------------------------------------------------
-- TABLA: STATUS_SERVICIO                                                    --
-- Catálogo de estados (Creado, En‑proceso, Entregado, etc.)                 --
-------------------------------------------------------------------------------
CREATE TABLE STATUS_SERVICIO(
    STATUS_SERVICIO_ID       NUMBER(10, 0)    NOT NULL,
    FECHA_STATUS_SERVICIO    DATE,
    CLAVE                    VARCHAR2(40)     NOT NULL,
    CONSTRAINT status_servicio_pk PRIMARY KEY (STATUS_SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES
)
TABLESPACE TBS_SERVICIO_1;

-------------------------------------------------------------------------------
-- TABLA: SERVICIO                                                           --
-- Registro maestro de cada servicio solicitado por un cliente.             --
-- * Usa particiones anuales por FECHA_SERVICIO.                             --
-- * Almacena documentos (solicitud formal, etc.) en un LOB.                 --
-------------------------------------------------------------------------------
CREATE TABLE SERVICIO(
    SERVICIO_ID                 NUMBER(10, 0)     NOT NULL,
    FECHA_SERVICIO              DATE              NOT NULL,
    DESCRIPCION                 VARCHAR2(1000)    NOT NULL,
    DOCUMENTO                   BLOB,
    TARJETA_ID_FK               NUMBER(10, 0)     NOT NULL,
    PROVEEDOR_SERVICIO_ID_FK    NUMBER(10, 0)     NOT NULL,
    STATUS_SERVICIO_ID          NUMBER(10, 0)     NOT NULL,
    CONSTRAINT servicio_pk PRIMARY KEY (SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT servicio_status_id_fk FOREIGN KEY (STATUS_SERVICIO_ID)
        REFERENCES STATUS_SERVICIO(STATUS_SERVICIO_ID)
)
PARTITION BY RANGE(FECHA_SERVICIO) (
    PARTITION p2025 VALUES LESS THAN (TO_DATE('2025-12-31', 'YYYY-MM-DD')) TABLESPACE TBS_SERVICIO_1
        LOB (DOCUMENTO) STORE AS servicio_doc_lob (
            TABLESPACE TBS_SERVICIO_LOB
            DISABLE STORAGE IN ROW
        ),
    PARTITION p2026 VALUES LESS THAN (TO_DATE('2026-12-31', 'YYYY-MM-DD')) TABLESPACE TBS_SERVICIO_2
        LOB (DOCUMENTO) STORE AS servicio_doc_lob_2 (
            TABLESPACE TBS_SERVICIO_LOB
            DISABLE STORAGE IN ROW
        )
);

-------------------------------------------------------------------------------
-- TABLA: SERVICIO_CONFIRMADO                                                --
-- Detalle de los servicios ya confirmados (precio, instrucciones, etc.)     --
-------------------------------------------------------------------------------
CREATE TABLE SERVICIO_CONFIRMADO(
    SERVICIO_ID      NUMBER(10, 0)    NOT NULL,
    PRECIO           NUMBER(10, 2)    NOT NULL,
    INSTRUCCIONES    VARCHAR2(40)     NOT NULL,
    MESUALIDADES     NUMBER(5, 0),
    DOCUMENTO        BLOB,
    CONSTRAINT servicio_confirmado_pk PRIMARY KEY (SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT serv_confirmado_servicio_id_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO(SERVICIO_ID)
)
TABLESPACE TBS_SERVICIO_CONFIRMADO
LOB (DOCUMENTO) STORE AS servicio_conf_doc_lob (
    TABLESPACE TBS_SERVICIO_LOB
    DISABLE STORAGE IN ROW
);

-------------------------------------------------------------------------------
-- TABLA: CALIFICACION_SERVICIO                                              --
-- Valoración de los servicios por parte del cliente (1‑5 estrellas, etc.)   --
-------------------------------------------------------------------------------
CREATE TABLE CALIFICACION_SERVICIO(
    SERVICIO_ID     NUMBER(10, 0)    NOT NULL,
    COMENTARIO      VARCHAR2(40),
    CALIFICACION    NUMBER(1, 0)     NOT NULL,
    CONSTRAINT calificacion_servicio_pk PRIMARY KEY (SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT calificacion_servicio_id_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO_CONFIRMADO(SERVICIO_ID)
)
TABLESPACE TBS_SERVICIO_CONFIRMADO;

-------------------------------------------------------------------------------
-- TABLA: DEPOSITO                                                           --
-- Registro del depósito realizado al proveedor tras servicio confirmado.    --
-------------------------------------------------------------------------------
CREATE TABLE DEPOSITO(
    SERVICIO_ID       NUMBER(10, 0)    NOT NULL,
    IMPORTE           NUMBER(10, 2)    NOT NULL,
    FECHA_DEPOSITO    DATE             NOT NULL,
    COMPROBANTE       BLOB             NOT NULL,
    CONSTRAINT deposito_pk PRIMARY KEY (SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT deposito_servicio_conf_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO_CONFIRMADO(SERVICIO_ID)
)
TABLESPACE TBS_SERVICIO_CONFIRMADO
LOB (COMPROBANTE) STORE AS deposito_comprobante_lob (
    TABLESPACE TBS_SERVICIO_LOB
    DISABLE STORAGE IN ROW
    INDEX deposito_comprobante_lob_index
);

-------------------------------------------------------------------------------
-- TABLA: EVIDENCIA                                                          --
-- Evidencias multimedia (fotos, etc.) asociadas a un servicio confirmado.   --
-------------------------------------------------------------------------------
CREATE TABLE EVIDENCIA(
    EVIDENCIA_ID       NUMBER(10, 0)    NOT NULL,
    NUM_CONSECUTIVO    NUMBER(3, 0)     NOT NULL,
    IMAGEN             BLOB             NOT NULL,
    DESCRIPCION        VARCHAR2(500),
    SERVICIO_ID        NUMBER(10, 0)    NOT NULL,
    CONSTRAINT evidencia_pk PRIMARY KEY (EVIDENCIA_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT evidencia_servicio_conf_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO_CONFIRMADO(SERVICIO_ID),
    CONSTRAINT evidencia_servicio_numconsec_uk UNIQUE (SERVICIO_ID, NUM_CONSECUTIVO)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES
)
TABLESPACE TBS_SERVICIO_EVIDENCIA
LOB (IMAGEN) STORE AS evidencia_imagen_lob (
    TABLESPACE TBS_SERVICIO_EVIDENCIA_LOB
    DISABLE STORAGE IN ROW
    INDEX evidencia_imagen_lob_index
);

-------------------------------------------------------------------------------
-- TABLA: HISTORICO_STATUS_SERVICIO                                          --
-- Bitácora de los cambios de estado sufridos por un servicio.               --
-------------------------------------------------------------------------------
CREATE TABLE HISTORICO_STATUS_SERVICIO(
    HISTORICO_STATUS_SERVICIO_ID    NUMBER(10, 0)    NOT NULL,
    FECHA_STATUS                    DATE             NOT NULL,
    STATUS_SERVICIO_ID              NUMBER(10, 0)    NOT NULL,
    SERVICIO_ID                     NUMBER(10, 0)    NOT NULL,
    CONSTRAINT historico_status_pk PRIMARY KEY (HISTORICO_STATUS_SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT historico_status_servicio_fk FOREIGN KEY (STATUS_SERVICIO_ID)
        REFERENCES STATUS_SERVICIO(STATUS_SERVICIO_ID),
    CONSTRAINT historico_status_servicio_id_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO(SERVICIO_ID)
)
TABLESPACE TBS_HISTORICO;

-------------------------------------------------------------------------------
-- TABLA: PAGO_SERVICIO                                                      --
-- Pagos parciales o totales realizados por el cliente al servicio.          --
-------------------------------------------------------------------------------
CREATE TABLE PAGO_SERVICIO(
    NUM_PAGO       NUMBER(10, 0)    NOT NULL,
    SERVICIO_ID    NUMBER(10, 0)    NOT NULL,
    FECHA_PAGO     DATE             NOT NULL,
    IMPORTE        NUMBER(10, 2)    NOT NULL,
    COMISION       NUMBER(10, 2)    NOT NULL,
    CONSTRAINT pago_servicio_pk PRIMARY KEY (NUM_PAGO, SERVICIO_ID)
        USING INDEX TABLESPACE TBS_MOD_SERVICIO_INDICES,
    CONSTRAINT pago_servicio_servicio_fk FOREIGN KEY (SERVICIO_ID)
        REFERENCES SERVICIO(SERVICIO_ID)
)
TABLESPACE TBS_PAGO_SERVICIO;

-- Fin del script                                                            
