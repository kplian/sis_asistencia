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




/***********************************I-SCP-MAM-ASIS-20-21/10/2019****************************************/
CREATE TABLE asis.tmovimiento_vacacion (
  id_movimiento_vacacion SERIAL,
  id_funcionario INTEGER,
  desde DATE,
  hasta DATE,
  dias_actual NUMERIC,
  activo VARCHAR(10) DEFAULT 'no'::character varying,
  codigo VARCHAR(50),
  dias NUMERIC,
  tipo VARCHAR(15),
  CONSTRAINT tmovimiento_vacacion_pkey PRIMARY KEY(id_movimiento_vacacion)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tmovimiento_vacacion
  ALTER COLUMN id_movimiento_vacacion SET STATISTICS 0;

ALTER TABLE asis.tmovimiento_vacacion
  ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.tmovimiento_vacacion
  ALTER COLUMN desde SET STATISTICS 0;

ALTER TABLE asis.tmovimiento_vacacion
  ALTER COLUMN hasta SET STATISTICS 0;

ALTER TABLE asis.tmovimiento_vacacion
  ALTER COLUMN dias_actual SET STATISTICS 0;

ALTER TABLE asis.tmovimiento_vacacion
  OWNER TO dbaamamani;

CREATE TABLE asis.ttransaccion_bio (
  id_transaccion_bio SERIAL,
  fecha_marcado DATE,
  hora TIME WITHOUT TIME ZONE,
  id_funcionario INTEGER,
  id_periodo INTEGER,
  obs TEXT,
  id_rango_horario INTEGER,
  evento VARCHAR(50),
  tipo_verificacion VARCHAR(100),
  area VARCHAR(100),
  codigo_evento VARCHAR(10),
  codigo_verificacion VARCHAR(10),
  acceso VARCHAR(50),
  rango VARCHAR(5) DEFAULT 'no'::character varying,
  pivot INTEGER DEFAULT 0,
  event_time TIMESTAMP WITHOUT TIME ZONE,
  registro VARCHAR(10) DEFAULT 'automatico'::character varying,
  CONSTRAINT ttransaccion_bio_pkey PRIMARY KEY(id_transaccion_bio)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.ttransaccion_bio
  ALTER COLUMN id_transaccion_bio SET STATISTICS 0;

ALTER TABLE asis.ttransaccion_bio
  ALTER COLUMN hora SET STATISTICS 0;

ALTER TABLE asis.ttransaccion_bio
  ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.ttransaccion_bio
  OWNER TO dbaamamani;

  CREATE TABLE asis.ttipo_permiso (
  id_tipo_permiso SERIAL,
  codigo VARCHAR(20) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  tiempo TIME WITHOUT TIME ZONE DEFAULT '00:00:00'::time without time zone,
  documento VARCHAR(5) DEFAULT 'no'::character varying,
  asignar_rango VARCHAR(5) DEFAULT 'no'::character varying,
  CONSTRAINT ttipo_permiso_pkey PRIMARY KEY(id_tipo_permiso)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.ttipo_permiso
  OWNER TO postgres;

  CREATE TABLE asis.tpermiso (
  id_permiso SERIAL,
  id_funcionario INTEGER NOT NULL,
  fecha_solicitud DATE NOT NULL,
  motivo TEXT,
  id_tipo_permiso INTEGER NOT NULL,
  estado VARCHAR(50),
  id_estado_wf INTEGER,
  id_proceso_wf INTEGER,
  nro_tramite VARCHAR(100),
  hro_desde TIME WITHOUT TIME ZONE,
  hro_hasta TIME WITHOUT TIME ZONE,
  CONSTRAINT tpermiso_pkey PRIMARY KEY(id_permiso)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tpermiso
  ALTER COLUMN id_permiso SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN fecha_solicitud SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN motivo SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN id_tipo_permiso SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN estado SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN id_estado_wf SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN id_proceso_wf SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  ALTER COLUMN nro_tramite SET STATISTICS 0;

ALTER TABLE asis.tpermiso
  OWNER TO dbaamamani;

CREATE TABLE asis.tpares (
  id_pares SERIAL,
  id_transaccion_ini INTEGER,
  id_transaccion_fin INTEGER,
  fecha_marcado DATE,
  id_funcionario INTEGER,
  id_licencia INTEGER,
  id_vacacion INTEGER,
  id_viatico INTEGER,
  id_pares_entrada INTEGER,
  lector VARCHAR(100),
  evento VARCHAR(100),
  rango VARCHAR(5) DEFAULT 'no'::character varying,
  id_periodo INTEGER,
  CONSTRAINT tpares_pkey PRIMARY KEY(id_pares)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE asis.tpares
  OWNER TO dbaamamani;

  CREATE TABLE asis.trango_horario (
  id_rango_horario SERIAL,
  codigo VARCHAR(5) NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  hora_entrada TIME(6) WITHOUT TIME ZONE NOT NULL,
  hora_salida TIME(6) WITHOUT TIME ZONE NOT NULL,
  rango_entrada_ini TIME(6) WITHOUT TIME ZONE NOT NULL,
  rango_entrada_fin TIME(6) WITHOUT TIME ZONE NOT NULL,
  rango_salida_ini TIME(6) WITHOUT TIME ZONE NOT NULL,
  rango_salida_fin TIME(6) WITHOUT TIME ZONE NOT NULL,
  fecha_desde DATE DEFAULT now() NOT NULL,
  fecha_hasta DATE,
  tolerancia_retardo INTEGER,
  jornada_laboral INTEGER,
  lunes VARCHAR(5) DEFAULT 'no'::character varying,
  martes VARCHAR(5) DEFAULT 'no'::character varying,
  miercoles VARCHAR(5) DEFAULT 'no'::character varying,
  jueves VARCHAR(5) DEFAULT 'no'::character varying,
  viernes VARCHAR(5) DEFAULT 'no'::character varying,
  sabado VARCHAR(5) DEFAULT 'no'::character varying,
  CONSTRAINT trango_horario_codigo_key UNIQUE(codigo),
  CONSTRAINT trango_horario_pkey PRIMARY KEY(id_rango_horario)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON TABLE asis.trango_horario
IS 'Tabla paramétrica que define el rango de horarios considerados como entradas o salidas';

COMMENT ON COLUMN asis.trango_horario.id_rango_horario
IS 'Identificador numérico de la tabla';

COMMENT ON COLUMN asis.trango_horario.codigo
IS 'Código del horario definido
HNM: Horario Normal Mañana
HNT: Horario Normal Tarde
HC: Horario Continuo
HNO: Horario Nocturno
HE: Horario Especial';

COMMENT ON COLUMN asis.trango_horario.descripcion
IS 'Descripción del horario definido
HNM: Horario Normal Mañana
HNT: Horario Normal Tarde
HC: Horario Continuo
HNO: Horario Nocturno
HE: Horario Especial';

COMMENT ON COLUMN asis.trango_horario.hora_entrada
IS 'Hora de entrada oficial definida por recursos humanos';

COMMENT ON COLUMN asis.trango_horario.hora_salida
IS 'Hora de salida oficial definida por recursos humanos';

COMMENT ON COLUMN asis.trango_horario.rango_entrada_ini
IS 'Rango de hora inicial del horario de entrada';

COMMENT ON COLUMN asis.trango_horario.rango_entrada_fin
IS 'Rango de hora final del horario de entrada';

COMMENT ON COLUMN asis.trango_horario.rango_salida_ini
IS 'Rango de hora inicial del horario de salida';

COMMENT ON COLUMN asis.trango_horario.rango_salida_fin
IS 'Rango de hora final del horario de salida';

COMMENT ON COLUMN asis.trango_horario.fecha_desde
IS 'Fecha desde que esta en uso el registro';

COMMENT ON COLUMN asis.trango_horario.fecha_hasta
IS 'Fecha de corte donde el registro ya no esta en uso';

COMMENT ON COLUMN asis.trango_horario.tolerancia_retardo
IS 'Cantidad de minutos de tolerancia para marcar la entrada';

COMMENT ON COLUMN asis.trango_horario.jornada_laboral
IS 'Cantidad de horas de la jornada laboral';

COMMENT ON COLUMN asis.trango_horario.lunes
IS 'Si el valor es verdadero, el horario considera el día lunes';

COMMENT ON COLUMN asis.trango_horario.martes
IS 'Si el valor es verdadero, el horario considera el día martes';

COMMENT ON COLUMN asis.trango_horario.miercoles
IS 'Si el valor es verdadero, el horario considera el día miercoles';

COMMENT ON COLUMN asis.trango_horario.jueves
IS 'Si el valor es verdadero, el horario considera el día jueves';

COMMENT ON COLUMN asis.trango_horario.viernes
IS 'Si el valor es verdadero, el horario considera el día viernes';

COMMENT ON COLUMN asis.trango_horario.sabado
IS 'Si el valor es verdadero, el horario considera el día sábado';

ALTER TABLE asis.trango_horario
  OWNER TO dbaamamani;
/***********************************F-SCP-MAM-ASIS-20-21/10/2019****************************************/

/***********************************I-SCP-AUG-ASIS-1-23/10/2019****************************************/

CREATE TABLE asis.tvacacion (
  id_vacacion SERIAL,
  id_funcionario INTEGER,
  fecha_inicio DATE,
  fecha_fin DATE,
  dias NUMERIC,
  descripcion TEXT,
  id_proceso_wf INTEGER,
  id_estado_wf INTEGER,
  estado VARCHAR(50),
  nro_tramite VARCHAR(100),
  solicitud DATE DEFAULT now()::date,
  id_gestion INTEGER,
  medio_dia BOOLEAN,
  CONSTRAINT tvacacion_id_proceso_wf_key UNIQUE(id_proceso_wf),
  CONSTRAINT tvacacion_pkey PRIMARY KEY(id_vacacion)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE asis.tvacacion
  ALTER COLUMN fecha_inicio SET STATISTICS 0;

ALTER TABLE asis.tvacacion
  ALTER COLUMN fecha_fin SET STATISTICS 0;

ALTER TABLE asis.tvacacion
  ALTER COLUMN dias SET STATISTICS 0;

ALTER TABLE asis.tvacacion
  ALTER COLUMN descripcion SET STATISTICS 0;

/***********************************F-SCP-AUG-ASIS-1-23/10/2019****************************************/

