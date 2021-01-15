CREATE OR REPLACE FUNCTION asis.ft_vacacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_vacacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion_det'
 AUTOR: 		 (admin.miguel)
 FECHA:	        30-12-2019 13:41:59
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				30-12-2019 13:41:59								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion_det'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion vacaciones

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_vacacion_det		integer;
    v_tiempo            	varchar;
    v_id_vacacion			integer;
    v_dias					numeric;
    v_dias_efectivo			numeric;
    --v_id_funcionario		integer;
    v_saldo					numeric;
	v_vacacion 				record;
    v_movimiento_vacacion	record;
    v_saldo_ant				numeric;
    v_saldo_anterior		numeric;
BEGIN

    v_nombre_funcion = 'asis.ft_vacacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_VDE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin.miguel
 	#FECHA:		30-12-2019 13:41:59
	***********************************/

	if(p_transaccion='ASIS_VDE_INS')then

        begin
        	--Sentencia de la insercion
            
            v_saldo = 0;
            
        	select va.tiempo, va.id_vacacion into v_tiempo, v_id_vacacion
        	from asis.tvacacion_det va
        	where va.id_vacacion_det = v_parametros.id_vacacion_det;


            if v_tiempo = 'completo' then
                update asis.tvacacion_det set
                tiempo = 'mañana'
                where id_vacacion_det = v_parametros.id_vacacion_det;
            end if;

        	if v_tiempo =  'mañana' then
                update asis.tvacacion_det set
                tiempo = 'tarde'
        	    where id_vacacion_det = v_parametros.id_vacacion_det;
            end if;

            if v_tiempo =  'tarde' then
                update asis.tvacacion_det set
                tiempo = 'completo'
        	    where id_vacacion_det = v_parametros.id_vacacion_det;
            end if;


          --

            select sum(d.dias_efectico) into v_dias_efectivo
        	from (
            select
            	    (case
                    				when vd.tiempo  = 'completo' then
                                     1
                                    when vd.tiempo  = 'mañana' then
                                    0.5
                                    when vd.tiempo  = 'tarde' then
                                    0.5
                                    else
                                    0
                                    end ::numeric )  as dias_efectico

            from asis.tvacacion_det vd
            where vd.id_vacacion = v_id_vacacion) d;
            
           
          
           
           select v.id_funcionario, v.estado, v.id_funcionario into v_vacacion
           from asis.tvacacion v
           where v.id_vacacion = v_id_vacacion;
           
           
           if (v_vacacion.estado = 'aprobado')then
           			if exists (	select 1
                            from asis.tmovimiento_vacacion mo 
                            where mo.id_vacacion = v_id_vacacion
                            and mo.id_funcionario = v_vacacion.id_funcionario)then
                            
                        select mm.id_movimiento_vacacion,
                               mm.dias,
                               mm.dias_actual into v_movimiento_vacacion
                        from asis.tmovimiento_vacacion mm
                        where mm.id_vacacion = v_id_vacacion
                        	and mm.estado_reg = 'activo' and mm.activo='activo'
                            and mm.id_funcionario = v_vacacion.id_funcionario;    
                            
                            
                            
                            select ma.dias_actual into v_saldo_anterior
                            from asis.tmovimiento_vacacion ma
                            where ma.id_funcionario =  v_vacacion.id_funcionario
                            	and ma.estado_reg = 'activo'
                            		and ma.fecha_reg = (select max(m.fecha_reg)
                                                        from asis.tmovimiento_vacacion m
                                                        where m.id_funcionario = v_vacacion.id_funcionario
                                                            and m.estado_reg = 'activo'
                                                             and m.id_movimiento_vacacion != v_movimiento_vacacion.id_movimiento_vacacion);
                            
                            v_saldo = v_saldo_anterior - v_dias_efectivo;
                            
                            update asis.tmovimiento_vacacion set
                            dias = -1*v_dias_efectivo,
                            dias_actual = v_saldo
                            where id_movimiento_vacacion = v_movimiento_vacacion.id_movimiento_vacacion;
                            
                           
                else
                	
                	raise exception 'Comuníquese con el administrador.';
                
                end if;
           end if;
           
           
           
          	if (v_saldo = 0) then
           
               select mo.dias_actual into v_saldo_ant
               from asis.tmovimiento_vacacion mo
               where mo.id_funcionario = v_vacacion.id_funcionario and 
                    mo.estado_reg= 'activo' and activo = 'activo';
                    
               v_saldo = v_saldo_ant - v_dias_efectivo;
     
			end if;



            update asis.tvacacion  set
            dias_efectivo = v_dias_efectivo,
            dias = v_dias_efectivo,
            saldo = v_saldo
            where  id_vacacion  = v_id_vacacion;

            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación detalle almacenado(a) con exito (id_vacacion_det'||v_id_vacacion_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion_det',v_id_vacacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************
 	#TRANSACCION:  'ASIS_VDE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VDE_ELI')then

		begin
        
			--Sentencia de la eliminacion
            
            select va.id_vacacion into v_id_vacacion
            from asis.tvacacion_det va
            where va.id_vacacion_det = v_parametros.id_vacacion_det;
            
            
            select c.dias_efectivo, c.dias  into v_dias, v_dias_efectivo
            from asis.tvacacion c
            where c.id_vacacion = v_id_vacacion;
            
            update asis.tvacacion set
            dias_efectivo =  v_dias - 1,
            dias = v_dias_efectivo - 1
            where id_vacacion = v_id_vacacion;
            
            
            delete from asis.tvacacion_det
			where id_vacacion_det = v_parametros.id_vacacion_det;

		
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion_det',v_parametros.id_vacacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;



	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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
PARALLEL UNSAFE
COST 100;