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
/***********************************I-SCP-MMV-ASIS-1-22/19/2020****************************************/
CREATE TABLE asis.ttipo_permiso (
                                    id_tipo_permiso SERIAL,
                                    codigo VARCHAR(20) NOT NULL,
                                    nombre VARCHAR(100) NOT NULL,
                                    tiempo TIME WITHOUT TIME ZONE DEFAULT '00:00:00'::time without time zone,
                                    documento VARCHAR(5) DEFAULT 'no'::character varying,
                                    reposcion VARCHAR(5) DEFAULT 'no'::character varying,
                                    rango VARCHAR(5) DEFAULT 'no'::character varying,
                                    CONSTRAINT ttipo_permiso_pkey PRIMARY KEY(id_tipo_permiso)
) INHERITS (pxp.tbase)
  WITH (oids = false);

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
                               fecha_reposicion DATE,
                               hro_desde_reposicion TIME WITHOUT TIME ZONE,
                               hro_hasta_reposicion TIME WITHOUT TIME ZONE,
                               reposicion VARCHAR(20),
                               hro_total_permiso TIME WITHOUT TIME ZONE,
                               hro_total_reposicion TIME WITHOUT TIME ZONE,
                               jornada VARCHAR(10),
                               id_responsable INTEGER,
                               id_funcionario_sol INTEGER,
                               observaciones TEXT,
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

CREATE TABLE asis.treposicion (
                                  id_reposicion SERIAL,
                                  id_permiso INTEGER NOT NULL,
                                  fecha_reposicion DATE NOT NULL,
                                  id_funcionario INTEGER,
                                  evento VARCHAR(30),
                                  tiempo VARCHAR(20),
                                  id_transacion_zkb INTEGER,
                                  CONSTRAINT treposicion_pkey PRIMARY KEY(id_reposicion)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.treposicion
    ALTER COLUMN id_reposicion SET STATISTICS 0;

ALTER TABLE asis.treposicion
    ALTER COLUMN id_permiso SET STATISTICS 0;

ALTER TABLE asis.treposicion
    ALTER COLUMN fecha_reposicion SET STATISTICS 0;

ALTER TABLE asis.treposicion
    ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.treposicion
    ALTER COLUMN evento SET STATISTICS 0;

ALTER TABLE asis.treposicion
    ALTER COLUMN tiempo SET STATISTICS 0;

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
                                medio_dia INTEGER,
                                dias_efectivo NUMERIC,
                                prestado VARCHAR(5) DEFAULT 'no'::character varying,
                                id_responsable INTEGER,
                                id_funcionario_sol INTEGER,
                                observaciones TEXT,
                                saldo NUMERIC DEFAULT 0,
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

COMMENT ON COLUMN asis.tvacacion.prestado
    IS 'bandera para sabe si la vacacion ya no tiene salgo y se puede prestar dias su proxima vacaciones';

CREATE TABLE asis.tvacacion_det (
                                    id_vacacion_det SERIAL,
                                    id_vacacion INTEGER NOT NULL,
                                    fecha_dia DATE NOT NULL,
                                    tiempo VARCHAR(20) DEFAULT 'completo'::character varying NOT NULL,
                                    CONSTRAINT tvacacion_det_pkey PRIMARY KEY(id_vacacion_det)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tvacacion_det
    ALTER COLUMN fecha_dia SET STATISTICS 0;

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
                                           dias_calendario INTEGER,
                                           id_vacacion INTEGER,
                                           id_gestion INTEGER,
                                           tipo_contrato VARCHAR(100),
                                           ci VARCHAR(100),
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

/***********************************F-SCP-MMV-ASIS-1-22/19/2020****************************************/

/***********************************I-SCP-MMV-ASIS-2-22/12/2020****************************************/
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
                                     domingo VARCHAR(5) DEFAULT 'no'::character varying,
                                     jornada VARCHAR(10),
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

CREATE TABLE asis.tasignar_rango (
                                     asignar_rango SERIAL,
                                     id_rango_horario INTEGER NOT NULL,
                                     id_funcionario INTEGER,
                                     id_uo SERIAL,
                                     desde DATE,
                                     hasta DATE,
                                     id_grupo_asig INTEGER,
                                     CONSTRAINT tasignar_rango_pkey PRIMARY KEY(asignar_rango)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tasignar_rango
    ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.tasignar_rango
    ALTER COLUMN id_uo SET STATISTICS 0;

ALTER TABLE asis.tasignar_rango
    ALTER COLUMN desde SET STATISTICS 0;
/***********************************F-SCP-MMV-ASIS-2-22/12/2020****************************************/
/***********************************I-SCP-MMV-ASIS-2-18/01/2021****************************************/
CREATE TABLE asis.tprogramacion (
                                    id_programacion SERIAL,
                                    id_periodo INTEGER,
                                    fecha_programada DATE NOT NULL,
                                    id_funcionario INTEGER,
                                    estado VARCHAR(50),
                                    tiempo VARCHAR(30),
                                    valor NUMERIC,
                                    id_vacacion_det INTEGER,
                                    CONSTRAINT tprogramacion_pkey PRIMARY KEY(id_programacion)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tprogramacion
    ALTER COLUMN id_programacion SET STATISTICS 0;

ALTER TABLE asis.tprogramacion
    ALTER COLUMN id_periodo SET STATISTICS 0;

ALTER TABLE asis.tprogramacion
    ALTER COLUMN fecha_programada SET STATISTICS 0;

ALTER TABLE asis.tprogramacion
    ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.tprogramacion
    ALTER COLUMN estado SET STATISTICS 0;

ALTER TABLE asis.tprogramacion
    ALTER COLUMN tiempo SET STATISTICS 0;

/***********************************F-SCP-MMV-ASIS-2-18/01/2021****************************************/
/***********************************I-SCP-MMV-ASIS-0-26/01/2021****************************************/

ALTER TABLE asis.tvacacion
    ADD COLUMN programacion VARCHAR(5) DEFAULT 'no' NOT NULL;
/***********************************F-SCP-MMV-ASIS-0-26/01/2021****************************************/
/***********************************I-SCP-MMV-ASIS-SDA-54-02/02/2021****************************************/
CREATE TABLE asis.ttele_trabajo (
                                    id_tele_trabajo SERIAL,
                                    id_funcionario INTEGER,
                                    id_responsable INTEGER,
                                    fecha_inicio DATE,
                                    fecha_fin DATE,
                                    justificacion TEXT,
                                    estado VARCHAR(50),
                                    nro_tramite VARCHAR(100),
                                    id_proceso_wf INTEGER,
                                    id_estado_wf INTEGER,
                                    CONSTRAINT ttele_trabajo_pkey PRIMARY KEY(id_tele_trabajo)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN id_tele_trabajo SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN id_responsable SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN fecha_inicio SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN fecha_fin SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo
    ALTER COLUMN justificacion SET STATISTICS 0;
/***********************************F-SCP-MMV-ASIS-SDA-54-02/02/2021****************************************/

/***********************************I-SCP-MMV-ASIS-SDA-55-05/02/2021****************************************/

CREATE TABLE asis.ttipo_bm (
                               id_tipo_bm SERIAL,
                               nombre VARCHAR(100) NOT NULL,
                               descripcion VARCHAR(20),
                               CONSTRAINT ttipo_bm_pkey PRIMARY KEY(id_tipo_bm)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.ttipo_bm
    ALTER COLUMN id_tipo_bm SET STATISTICS 0;

ALTER TABLE asis.ttipo_bm
    ALTER COLUMN nombre SET STATISTICS 0;

ALTER TABLE asis.ttipo_bm
    ALTER COLUMN descripcion SET STATISTICS 0;



CREATE TABLE asis.tbaja_medica (
                                   id_baja_medica SERIAL,
                                   id_funcionario INTEGER NOT NULL,
                                   id_tipo_bm INTEGER NOT NULL,
                                   fecha_inicio DATE,
                                   fecha_fin DATE,
                                   dias_efectivo NUMERIC,
                                   id_proceso_wf INTEGER,
                                   id_estado_wf INTEGER,
                                   estado VARCHAR(100),
                                   nro_tramite VARCHAR(200),
                                   documento VARCHAR(10) DEFAULT 'no'::character varying NOT NULL,
                                   CONSTRAINT tbaja_medica_pkey PRIMARY KEY(id_baja_medica)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN id_baja_medica SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN id_funcionario SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN id_tipo_bm SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN fecha_inicio SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN fecha_fin SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN dias_efectivo SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN id_proceso_wf SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN id_estado_wf SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN estado SET STATISTICS 0;

ALTER TABLE asis.tbaja_medica
    ALTER COLUMN nro_tramite SET STATISTICS 0;

/***********************************F-SCP-MMV-ASIS-SDA-55-05/02/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-2911-19/02/2021****************************************/
ALTER TABLE asis.tbaja_medica
    ADD COLUMN observaciones TEXT;
/***********************************F-SCP-MMV-ASIS-ETR-2911-19/02/2021****************************************/


/***********************************I-SCP-MMV-ASIS-SDA-70-11/03/2021****************************************/
CREATE TABLE asis.ttele_trabajo_det (
                                        id_tele_trabajo_det SERIAL,
                                        id_tele_trabajo INTEGER NOT NULL,
                                        fecha DATE NOT NULL,
                                        CONSTRAINT ttele_trabajo_det_pkey PRIMARY KEY(id_tele_trabajo_det)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.ttele_trabajo_det
    ALTER COLUMN id_tele_trabajo_det SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo_det
    ALTER COLUMN id_tele_trabajo SET STATISTICS 0;

ALTER TABLE asis.ttele_trabajo_det
    ALTER COLUMN fecha SET STATISTICS 0;
/***********************************F-SCP-MMV-ASIS-SDA-70-11/03/2021****************************************/

/***********************************I-SCP-MMV-ASIS-SDA-70-1-11/03/2021****************************************/
ALTER TABLE asis.ttele_trabajo
    ADD COLUMN tipo_teletrabajo VARCHAR(50);

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN motivo VARCHAR;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN tipo_temporal VARCHAR;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN lunes BOOLEAN DEFAULT false;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN martes BOOLEAN DEFAULT false;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN miercoles BOOLEAN DEFAULT false;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN jueves BOOLEAN DEFAULT false;

ALTER TABLE asis.ttele_trabajo
    ADD COLUMN viernes BOOLEAN DEFAULT false;

/***********************************F-SCP-MMV-ASIS-SDA-70-1-11/03/2021****************************************/

/***********************************I-SCP-MMV-ASIS-SDA-71-1-23/03/2021****************************************/
CREATE TABLE asis.tdetalle_tipo_permiso (
                                            id_detalle_tipo_permiso SERIAL,
                                            nombre VARCHAR(100) NOT NULL,
                                            descripcion VARCHAR(500),
                                            dias NUMERIC,
                                            id_tipo_permiso INTEGER NOT NULL,
                                            CONSTRAINT tdetalle_tipo_permiso_pkey PRIMARY KEY(id_detalle_tipo_permiso)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tdetalle_tipo_permiso
    ALTER COLUMN id_detalle_tipo_permiso SET STATISTICS 0;

ALTER TABLE asis.tdetalle_tipo_permiso
    ALTER COLUMN nombre SET STATISTICS 0;

ALTER TABLE asis.tdetalle_tipo_permiso
    ALTER COLUMN descripcion SET STATISTICS 0;

ALTER TABLE asis.tdetalle_tipo_permiso
    ALTER COLUMN dias SET STATISTICS 0;


ALTER TABLE asis.ttipo_permiso
    ADD COLUMN detalle VARCHAR(10) DEFAULT 'no' NOT NULL;

ALTER TABLE asis.tpermiso
    ADD COLUMN id_tipo_licencia INTEGER;

ALTER TABLE asis.tpermiso
    ADD COLUMN fecha_inicio DATE;

ALTER TABLE asis.tpermiso
    ADD COLUMN fecha_fin DATE;

ALTER TABLE asis.tpermiso
    ADD COLUMN dias NUMERIC;
/***********************************F-SCP-MMV-ASIS-SDA-71-1-23/03/2021****************************************/
/***********************************I-SCP-MMV-ASIS-SDA-71-1-30/04/2021****************************************/
CREATE TABLE asis.tgrupo_asig (
                                  id_grupo_asig SERIAL,
                                  codigo VARCHAR(20),
                                  descripcion VARCHAR(100),
                                  id_rango_horario INTEGER NOT NULL,
                                  CONSTRAINT tgrupo_asig_tgrupo_pkey PRIMARY KEY(id_grupo_asig)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tgrupo_asig
    ALTER COLUMN id_grupo_asig SET STATISTICS 0;

ALTER TABLE asis.tgrupo_asig
    ALTER COLUMN codigo SET STATISTICS 0;

ALTER TABLE asis.tgrupo_asig
    ALTER COLUMN descripcion SET STATISTICS 0;

CREATE TABLE asis.tgrupo_asig_det (
                                      id_id_grupo_asig_det SERIAL,
                                      id_funcionario INTEGER,
                                      id_grupo_asig INTEGER NOT NULL,
                                      CONSTRAINT tgrupo_asig_det_tid_grupo_det_pkey PRIMARY KEY(id_id_grupo_asig_det)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tgrupo_asig_det
    ALTER COLUMN id_id_grupo_asig_det SET STATISTICS 0;

ALTER TABLE asis.tgrupo_asig_det
    ALTER COLUMN id_funcionario SET STATISTICS 0;
/***********************************F-SCP-MMV-ASIS-SDA-71-1-30/04/2021****************************************/
/***********************************I-SCP-MMV-ASIS-SDA-71-1-03/05/2021****************************************/
alter table asis.trango_horario
    add desde date;

alter table asis.trango_horario
    add hasta date;
/***********************************F-SCP-MMV-ASIS-SDA-71-1-03/05/2021****************************************/


/***********************************I-SCP-MMV-ASIS-SDA-78-1-17/05/2021****************************************/
alter table asis.ttipo_permiso
    add rango_fecha varchar(5) default 'no';

alter table asis.ttipo_permiso
    add compensacion_fecha varchar(5) default 'no';

alter table asis.ttipo_permiso alter column compensacion_fecha set not null;


alter table asis.tpermiso
    add inicio_comp date;

alter table asis.tpermiso
    add fin_comp date;
/***********************************F-SCP-MMV-ASIS-SDA-78-1-17/05/2021****************************************/


/***********************************I-SCP-MMV-ASIS-ETR-4007-1-18/05/2021****************************************/
CREATE TABLE asis.tcompensacion (
                                    id_compensacion SERIAL,
                                    id_funcionario INTEGER NOT NULL,
                                    id_responsable INTEGER NOT NULL,
                                    desde DATE NOT NULL,
                                    hasta DATE NOT NULL,
                                    dias NUMERIC DEFAULT 0 NOT NULL,
                                    desde_comp DATE NOT NULL,
                                    hasta_comp DATE NOT NULL,
                                    dias_comp NUMERIC DEFAULT 0 NOT NULL,
                                    justificacion VARCHAR(500) NOT NULL,
                                    id_procesos_wf INTEGER NOT NULL,
                                    id_estado_wf INTEGER NOT NULL,
                                    estado VARCHAR(100) NOT NULL,
                                    nro_tramite VARCHAR(100) NOT NULL,
                                    CONSTRAINT tcompensacion_pk PRIMARY KEY(id_compensacion)
) INHERITS (pxp.tbase)
  WITH (oids = false);

CREATE UNIQUE INDEX tcompensacion_id_compensacion_uindex ON asis.tcompensacion
    USING btree (id_compensacion);


CREATE TABLE asis.tcompensacion_det (
                                        id_compensacion_det SERIAL,
                                        fecha DATE NOT NULL,
                                        id_compensacion INTEGER NOT NULL,
                                        tiempo VARCHAR(100) DEFAULT 'no'::character varying,
                                        CONSTRAINT tcompensacion_det_pk PRIMARY KEY(id_compensacion_det)
) INHERITS (pxp.tbase)
  WITH (oids = false);

CREATE UNIQUE INDEX tcompensacion_det_id_compensacion_det_uindex ON asis.tcompensacion_det
    USING btree (id_compensacion_det);

/***********************************F-SCP-MMV-ASIS-ETR-4007-1-18/05/2021****************************************/
/***********************************I-SCP-MMV-ASIS-ETR-4007-1-19/05/2021****************************************/
ALTER TABLE asis.tcompensacion_det
    ADD COLUMN fecha_comp DATE;

ALTER TABLE asis.tcompensacion_det
    ADD COLUMN tiempo_num NUMERIC;
/***********************************F-SCP-MMV-ASIS-ETR-4007-1-19/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-1-21/05/2021****************************************/
CREATE TABLE asis.tcompensacion_det_com (
                                            id_compensacion_det_com SERIAL,
                                            fecha_comp DATE,
                                            tiempo_comp VARCHAR(100),
                                            id_compensacion_det INTEGER,
                                            CONSTRAINT tcompensacion_det_com_pkey PRIMARY KEY(id_compensacion_det_com)
) INHERITS (pxp.tbase)
  WITH (oids = false);

ALTER TABLE asis.tcompensacion_det_com
    ALTER COLUMN id_compensacion_det_com SET STATISTICS 0;

ALTER TABLE asis.tcompensacion_det_com
    ALTER COLUMN fecha_comp SET STATISTICS 0;

ALTER TABLE asis.tcompensacion_det_com
    ALTER COLUMN tiempo_comp SET STATISTICS 0;

ALTER TABLE asis.tcompensacion_det_com
    ALTER COLUMN id_compensacion_det SET STATISTICS 0;

/***********************************F-SCP-MMV-ASIS-ETR-4007-1-21/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-2-21/05/2021****************************************/

ALTER TABLE asis.tcompensacion_det
    ADD COLUMN tiempo_comp VARCHAR(20);

/***********************************F-SCP-MMV-ASIS-ETR-4007-2-21/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-2-25/05/2021****************************************/
alter table asis.ttele_trabajo_det
    add tiempo_tele varchar(20) default 'completo' not null;
/***********************************F-SCP-MMV-ASIS-ETR-4007-2-25/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-2-28/05/2021****************************************/
ALTER TABLE asis.tcompensacion
    ADD COLUMN social_forestal BOOLEAN DEFAULT FALSE NOT NULL;
/***********************************F-SCP-MMV-ASIS-ETR-4007-2-28/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-2-31/05/2021****************************************/
ALTER TABLE asis.tcompensacion
    RENAME COLUMN id_procesos_wf TO id_proceso_wf;
/***********************************F-SCP-MMV-ASIS-ETR-4007-2-31/05/2021****************************************/

/***********************************I-SCP-MMV-ASIS-ETR-4007-3-31/05/2021****************************************/
ALTER TABLE asis.tcompensacion_det
    ALTER COLUMN id_compensacion DROP NOT NULL;
/***********************************F-SCP-MMV-ASIS-ETR-4007-3-31/05/2021****************************************/
