/***********************************I-SCP-RAC-ASIS-1-30/01/2019****************************************/


--------------- SQL ---------------

CREATE TABLE asis.tmes_trabajo (
  id_mes_trabajo SERIAL NOT NULL,
  id_planilla INTEGER,
  id_funcionario INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_gestion INTEGER NOT NULL;
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
  ADD CONSTRAINT tmes_trabajo__id_estado_wffk FOREIGN KEY (id_funcionario_apro)
    REFERENCES orga.tfuncionario(id_funcionario_apro)
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
/***********************************I-SCP-MMV-ASIS-1-16/03/2019****************************************/
ALTER TABLE asis.tmes_trabajo_det
  ADD COLUMN tipo_dos VARCHAR(6);
ALTER TABLE asis.tmes_trabajo_det
  ADD COLUMN tipo_tres VARCHAR(6);
  ALTER TABLE asis.tmes_trabajo
  ADD COLUMN nro_tramite VARCHAR(200);
/***********************************F-SCP-MMV-ASIS-1-16/03/2019****************************************/
