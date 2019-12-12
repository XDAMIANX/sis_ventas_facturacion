CREATE OR REPLACE FUNCTION "vef"."ft_punto_venta_producto_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Ventas
 FUNCION: 		vef.ft_punto_venta_producto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'vef.tpunto_venta_producto'
 AUTOR: 		 (jrivera)
 FECHA:	        07-10-2015 21:02:03
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'vef.ft_punto_venta_producto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'VF_PUVEPRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		07-10-2015 21:02:03
	***********************************/

	if(p_transaccion='VF_PUVEPRO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						puvepro.id_punto_venta_producto,
						puvepro.estado_reg,
						puvepro.id_sucursal_producto,
						puvepro.id_punto_venta,
						puvepro.usuario_ai,
						puvepro.fecha_reg,
						puvepro.id_usuario_reg,
						puvepro.id_usuario_ai,
						puvepro.id_usuario_mod,
						puvepro.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cig.desc_ingas	
						from vef.tpunto_venta_producto puvepro
						inner join segu.tusuario usu1 on usu1.id_usuario = puvepro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = puvepro.id_usuario_mod
						inner join vef.tsucursal_producto sprod on sprod.id_sucursal_producto = puvepro.id_sucursal_producto
						inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sprod.id_concepto_ingas
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'VF_PUVEPRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		07-10-2015 21:02:03
	***********************************/

	elsif(p_transaccion='VF_PUVEPRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_punto_venta_producto)
					    from vef.tpunto_venta_producto puvepro
					    inner join segu.tusuario usu1 on usu1.id_usuario = puvepro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = puvepro.id_usuario_mod
						inner join vef.tsucursal_producto sprod on sprod.id_sucursal_producto = puvepro.id_sucursal_producto
						inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sprod.id_concepto_ingas
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "vef"."ft_punto_venta_producto_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
