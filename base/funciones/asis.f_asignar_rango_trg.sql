CREATE OR REPLACE FUNCTION asis.f_asignar_rango_trg (
)
RETURNS trigger AS
$body$
DECLARE
  v_nombre_funcion 			varchar;
  v_id_funicionario			integer;
  v_hora					time;
  v_rango					varchar[];
  v_id_gestion 				integer;
  v_id_periodo				integer;
  v_evento					varchar;

BEGIN
	v_nombre_funcion = 'asis.f_asignar_rango_trg';

      IF TG_OP = 'INSERT' THEN

      --Obtener la gestion
       select g.id_gestion into v_id_gestion
       from param.tgestion g
       where g.gestion = EXTRACT(YEAR FROM NEW.event_time::date);
      --Obtener el periodo

      select pe.id_periodo into v_id_periodo
      from param.tperiodo pe
      where pe.id_gestion = v_id_gestion
      and pe.periodo = EXTRACT(MONTH FROM NEW.event_time::date);
   	  --Extraemos la hora
        v_hora = to_char(NEW.event_time, 'HH24:MI'::text);
      --Obtener el evento
    -- v_evento = asis.f_estraer_palabra(p_lectora,'Entrada','Salida');
      --Obtenemos el rango asignado
      v_rango =  asis.f_obtener_rango_trg ( NEW.pin::varchar,
      										v_hora::time,
                                            NEW.event_time::timestamp,
                                            NEW.reader_name::varchar);

      --Insertar con rango asignado
        	insert into asis.ttransaccion_trg(	obs,
                                                estado_reg,
                                                evento,
                                                id_periodo,
                                                hora,
                                                id_funcionario,
                                                area,
                                                tipo_verificacion,
                                                fecha_marcado,
                                                id_rango_horario,
                                                id_usuario_reg,
                                                usuario_ai,
                                                fecha_reg,
                                                id_usuario_ai,
                                                id_usuario_mod,
                                                fecha_mod,
                                                acceso,
                                                pin,
                                                mensaje_migra
                                                )values(
                                                v_rango[2]::varchar,
                                                'activo',
                                                v_rango[3]::varchar,
                                                v_id_periodo,
                                                v_hora,
                                                v_rango[4]::integer,--
                                                NEW.area_name,
                                                NEW.event_name,
                                                NEW.event_time::date,
                                                v_rango[1]::integer,
                                                1,
                                                null,
                                                now(),
                                                null,
                                                null,
                                                null,
                                                NEW.verify_mode_name,
                                                NEW.pin,
                                                '');

  END IF;
   RETURN NULL;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.f_asignar_rango_trg ()
  OWNER TO dbaamamani;