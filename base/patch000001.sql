/***********************************I-SCP-RAC-ASIS-1-30/01/2019****************************************/


--------------- SQL ---------------

CREATE TABLE asis.tmes_trabajo (
  id_mes_trabajo SERIAL NOT NULL,
  id_planilla INTEGER,
  id_funcionario INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_gestion INTEGER NOT NULL,
  id_periodo INTEGER NOT NULL,
  estado VARCHAR(100),
  obs VARCHAR,
  PRIMARY KEY(id_mes_trabajo)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tmes_trabajo
  ALTER COLUMN id_funcionario SET STATISTICS 0;
  
  
ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_periodo_fk FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_gestion_fk FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_planilla_fk FOREIGN KEY (id_planilla)
    REFERENCES plani.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_funcionario_fk FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_estado_wffk FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    --------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_proceso_wf_fk FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    --------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo
  ADD COLUMN id_funcionario_apro INTEGER;

COMMENT ON COLUMN asis.tmes_trabajo.id_funcionario_apro
IS 'funcionario que aprueba las hojas de tiempo';


ALTER TABLE asis.tmes_trabajo
  ADD CONSTRAINT tmes_trabajo__id_funcionario_aprofk FOREIGN KEY (id_funcionario_apro)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    --------------- SQL ---------------

CREATE TABLE asis.ttipo_aplicacion (
  id_tipo_aplicacion SERIAL NOT NULL,
  id_tipo_columna INTEGER,
  codigo_aplicacion VARCHAR(20) NOT NULL,
  nombre VARCHAR(300),
  descripcion VARCHAR,
  consolidable VARCHAR(2) DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_tipo_aplicacion)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON COLUMN asis.ttipo_aplicacion.id_tipo_columna
IS 'en la mayoria de los casos la plaicacion se realiza sobre una columna de planilla';

COMMENT ON COLUMN asis.ttipo_aplicacion.consolidable
IS 'si es migra a planillas, por ejemplo, horas normales si migras,  horas de vacacion no se migra';

--------------- SQL ---------------

ALTER TABLE asis.ttipo_aplicacion
  ADD CONSTRAINT ttipo_aplicacion__id_tipo_columna_fk FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    
 --------------- SQL ---------------

CREATE TABLE asis.tmes_trabajo_det (
  id_mes_trabajo_det SERIAL NOT NULL,
  id_mes_trabajo INTEGER NOT NULL,
  id_centro_costo INTEGER NOT NULL,
  dia INTEGER NOT NULL,
  ingreso_manana TIME WITHOUT TIME ZONE UNIQUE,
  salida_manana TIME WITHOUT TIME ZONE NOT NULL,
  ingreso_tarde TIME WITHOUT TIME ZONE,
  salida_tarde TIME WITHOUT TIME ZONE,
  ingreso_noche TIME WITHOUT TIME ZONE,
  salida_noche TIME WITHOUT TIME ZONE,
  justificacion_extra VARCHAR,
  total_normal NUMERIC(100,2) DEFAULT 0 NOT NULL,
  total_nocturna NUMERIC(100,2) DEFAULT 0 NOT NULL,
  total_extra NUMERIC(100,2) DEFAULT 0 NOT NULL,
  extra_autorizada NUMERIC(100,2) DEFAULT 0 NOT NULL,
  PRIMARY KEY(id_mes_trabajo_det)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tmes_trabajo_det
  ALTER COLUMN total_normal SET STATISTICS 0;

COMMENT ON COLUMN asis.tmes_trabajo_det.dia
IS 'dia de registro';

COMMENT ON COLUMN asis.tmes_trabajo_det.ingreso_manana
IS 'hora de ingreso mañana';


--------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo_det
  ADD CONSTRAINT tmes_trabajo_det__id_mes_trabajo_fk FOREIGN KEY (id_mes_trabajo)
    REFERENCES asis.tmes_trabajo(id_mes_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo_det
  ADD CONSTRAINT tmes_trabajo_det__id_centro_costo_fk FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;   
    
    
 --------------- SQL ---------------

CREATE TABLE asis.tmes_trabajo_con (
  id_mes_trabajo_con SERIAL NOT NULL,
  id_mes_trabajo INTEGER NOT NULL,
  id_centro_costo INTEGER,
  id_tipo_aplicacion INTEGER,
  total_horas NUMERIC(100,2) DEFAULT 0 NOT NULL,
  factor NUMERIC DEFAULT 0 NOT NULL,
  PRIMARY KEY(id_mes_trabajo_con)
) INHERITS (pxp.tbase)
WITH (oids = false);


--------------- SQL ---------------

ALTER TABLE asis.tmes_trabajo_det
  ADD COLUMN tipo VARCHAR(6) NOT NULL;

COMMENT ON COLUMN asis.tmes_trabajo_det.tipo
IS 'HRN, horas normales, LPV Licen por vacacion, LPC Licencia por compensacion , FER Feriado, CDV  Compensacion por discapcidad, LMP Licencia por maternidad';       




/***********************************F-SCP-RAC-ASIS-1-30/01/2019****************************************/

/***********************************I-SCP-MMV-ASIS-1-11/03/2019****************************************/
ALTER TABLE asis.tmes_trabajo_con
  ADD COLUMN calculado_resta VARCHAR(5);

ALTER TABLE asis.tmes_trabajo_con
  ALTER COLUMN calculado_resta SET DEFAULT 'no';
/***********************************F-SCP-MMV-ASIS-1-11/03/2019****************************************/

/***********************************I-SCP-JDJ-ASIS-1-14/08/2019****************************************/
CREATE TABLE asis.tingreso_salida (
  ingreso_salida INTEGER NOT NULL,
  id_funcionario INTEGER,
  fecha DATE,
  hora TIME WITHOUT TIME ZONE,
  tipo VARCHAR(50),
  PRIMARY KEY(ingreso_salida)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tingreso_salida
  ALTER COLUMN fecha SET STATISTICS 0;


ALTER TABLE asis.tingreso_salida
  RENAME COLUMN ingreso_salida TO id_ingreso_salida;


--------------- SQL ---------------

CREATE SEQUENCE asis.tingreso_salida_id_ingreso_salida_seq
MAXVALUE 2147483647;

ALTER TABLE asis.tingreso_salida
  ALTER COLUMN id_ingreso_salida TYPE INTEGER;

ALTER TABLE asis.tingreso_salida
  ALTER COLUMN id_ingreso_salida SET DEFAULT nextval('asis.tingreso_salida_id_ingreso_salida_seq'::text);
/***********************************F-SCP-JDJ-ASIS-1-14/08/2019****************************************/
/***********************************I-SCP-MMV-ASIS-15-02/09/2019****************************************/
---creacion de foreign
CREATE SERVER mssql_zka
  FOREIGN DATA WRAPPER tds_fdw
  OPTIONS (
    port '1433',
    servername '172.18.79.22');
-- creacion de usuario remoto
CREATE USER MAPPING FOR public
  SERVER mssql_zka
  OPTIONS (
    password 'usrZKAccess2KK7prod',
    username 'usrZKAccess');

ALTER SERVER mssql_zka
  OWNER TO postgres;
---cracion de la tabla
CREATE FOREIGN TABLE asis.ttranscc_zka (
  id INTEGER,
  unique_key VARCHAR(100),
  log_id INTEGER,
  create_operator VARCHAR(30),
  create_time TIMESTAMP WITHOUT TIME ZONE,
  event_time TIMESTAMP WITHOUT TIME ZONE,
  pin VARCHAR(30),
  name VARCHAR(50),
  last_name VARCHAR(50),
  dept_name VARCHAR(100),
  area_name VARCHAR(100),
  card_no VARCHAR(50),
  dev_id INTEGER,
  dev_sn VARCHAR(30),
  dev_alias VARCHAR(100),
  verify_mode_no SMALLINT,
  verify_mode_name VARCHAR(100),
  event_no SMALLINT,
  event_name VARCHAR(100),
  event_point_type SMALLINT,
  event_point_id INTEGER,
  event_point_name VARCHAR(100),
  reader_state SMALLINT,
  reader_name VARCHAR(100),
  trigger_cond SMALLINT,
  description VARCHAR(200),
  vid_linkage_handle VARCHAR(256),
  acc_zone VARCHAR(30),
  event_addr SMALLINT
)
SERVER mssql_zka -- conexicon al servidor
OPTIONS (query 'SELECT [id]
      ,[unique_key]
      ,[log_id]
      ,[create_operator]
      ,[create_time]
      ,[event_time]
      ,[pin]
      ,[name]
      ,[last_name]
      ,[dept_name]
      ,[area_name]
      ,[card_no]
      ,[dev_id]
      ,[dev_sn]
      ,[dev_alias]
      ,[verify_mode_no]
      ,[verify_mode_name]
      ,[event_no]
      ,[event_name]
      ,[event_point_type]
      ,[event_point_id]
      ,[event_point_name]
      ,[reader_state]
      ,[reader_name]
      ,[trigger_cond]
      ,[description]
      ,[vid_linkage_handle]
      ,[acc_zone]
      ,[event_addr]
  FROM [ACCESO_ZKBIOSEC].[dbo].[acc_transaction]');

ALTER TABLE asis.ttranscc_zka
  OWNER TO postgres;
/***********************************F-SCP-MMV-ASIS-15-02/09/2019****************************************/
/***********************************I-SCP-MMV-ASIS-18-26/09/2019****************************************/
ALTER TABLE asis.tmes_trabajo_det
  ADD COLUMN id_centro_costo_anterior INTEGER;
/***********************************F-SCP-MMV-ASIS-18-26/09/2019****************************************/

