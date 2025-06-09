conn moduloUsuarios/password123@chsabda_s2;

CREATE TABLE BANCO(
    BANCO_ID    NUMBER(10, 0)    NOT NULL,
    NOMBRE      VARCHAR2(40)     NOT NULL,
    CONSTRAINT banco_pk PRIMARY KEY (BANCO_ID)
      USING INDEX TABLESPACE tbs_mod_usuario_indices
)
TABLESPACE tbs_banco;


