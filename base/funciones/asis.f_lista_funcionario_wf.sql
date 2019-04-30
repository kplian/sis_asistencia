CREATE OR REPLACE FUNCTION asis.f_lista_funcionario_wf (
  p_id_usuario integer,
  p_id_tipo_estado integer,
  p_fecha date = now(),
  p_id_estado_wf integer = NULL::integer,
  p_count boolean = false,
  p_limit integer = 1,
  p_start integer = 0,
  p_filtro varchar = '0=0'::character varying
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_lista_funcionario_wf
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2				30/04/2019 				kplian MMV			Validaciones y reporte
 ***************************************************************************/


DECLARE
	g_registros  				record;
    v_consulta 					varchar;
    v_nombre_funcion 			varchar;
    v_resp 						varchar;
    v_id_funcionario   			integer;
    v_id_mes_trabajo			integer;
    v_total_extras				numeric;
    v_total_nocturnos			numeric;
    v_id_funcionario_wf			integer;


BEGIN
    v_nombre_funcion ='asis.f_lista_funcionario_wf';
-----#2-------
          select mes.id_mes_trabajo,mes.id_funcionario
          into
          v_id_mes_trabajo,v_id_funcionario
          from asis.tmes_trabajo mes
          where mes.id_estado_wf = p_id_estado_wf;

          select 	sum(mde.total_extra) as total_extras,
          			sum(mde.total_nocturna) as total_nocturna
                    into
                    v_total_extras,
                    v_total_nocturnos
          from asis.tmes_trabajo_det mde
          where mde.id_mes_trabajo = v_id_mes_trabajo;

          select fun.id_funcionario
          into v_id_funcionario_wf
          from orga.vfuncionario fun
          where fun.id_funcionario = asis.f_get_funcionario_boss (v_id_funcionario,v_total_extras);
-----#2-------


    IF not p_count then

             v_consulta:='SELECT
                            fun.id_funcionario,
                            fun.desc_funcionario1 as desc_funcionario,
                            ''Gerente''::text  as desc_funcionario_cargo,
                            1 as prioridad
                         FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario_wf,0)::varchar||'
                         and '||p_filtro||'
                         limit '|| p_limit::varchar||' offset '||p_start::varchar;


                   FOR g_registros in execute (v_consulta)LOOP
                     RETURN NEXT g_registros;
                   END LOOP;

      ELSE
                  v_consulta='select
                                  COUNT(fun.id_funcionario) as total
                                 FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario_wf,0)::varchar||'
                                 and '||p_filtro;

                   FOR g_registros in execute (v_consulta)LOOP
                     RETURN NEXT g_registros;
                   END LOOP;


    END IF;



EXCEPTION

	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;