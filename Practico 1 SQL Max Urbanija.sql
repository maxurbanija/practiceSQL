--31/10/18 15:00hs maxurbanija

--1 todos los articulos de la tabla articulos
select * from articulos;

--2 id_articulos, de_articulos, id_negocio, id_segmento, 
-- id_subrubro de la tabla articulos
select id_articulos, de_articulos, id_negocio, id_segmento,id_subrubro
from articulos;

--3 id_articulos, de_articulos, id_negocio, id_segmento,
-- id_subrubro, pr_costo_neto de articulos donde pr costo neto
-- sea mayor a 10
select id_articulos, de_articulos, id_negocio, id_segmento,id_subrubro, pr_costo_neto 
from articulos
where pr_costo_neto > 10;

--4 id_sucursal, id_cliente,de_organizacion,fe_alta 
--donde la fecha de alta > '01-01-2005'
select id_sucursal, id_cliente,de_organizacion,fe_alta
from clientes
where fe_alta > '01-01-2005';

--5 todos los datos de los clientes cuyo dni sea nulo
select *
from clientes
where id_nrodoc is null;

--6
select * 
from ventas
where sn_anulo='n' and (fe_venta between '20080101' and '20081201') 
and id_sucursal = 1 and pr_subtotal <= 50;

--7
select *
from clientes
where ti_contribuyente = 'IN' and sn_habilitado = 'S' and id_cuit is not null 
and (fe_aperturacta between '20080301' and '20090301');


--
update ventas_detalle 
set pr_costo = articulos.pr_costo
from articulos
where articulos.id_articulos = ventas_detalle.id_articulos;

--8
select id_articulos,comision= (pr_arcor_a*ta_comision)
from articulos
where YEAR(fe_ingreso)<2009
order by fe_ingreso;


--2/11/18 02:48hs maxurbanija

--9. Realizar un análisis de la rentabilidad estimada para cada artículo 
--(pr_arcor_a – pr_costo)/pr_arcor_a cuyo precio de venta haya sido actualizado (fe_act_preciovta) en el año 2007 . 
--Mostrar la información de la siguiente manera: id_articulos, rentabilidad: “calculo”. 
--Ordenar por rentabilidad de menor a mayor y por fecha de actualización de precio.
select id_articulos, rentabilidad = (pr_arcor_a - pr_costo)/pr_arcor_a
from articulos
where year(fe_act_preciovta)=2007 and pr_arcor_a > 0
order by rentabilidad,fe_act_preciovta;
--revisar el calculo, pr_arcor_a puede contener 0 y esta dividiendo, que significan esas columnas ???

--10. Mostrar los totales de las ventas de la siguiente manera. 
--Si es una nota de crédito id_fcnc = ‘NC’ mostrar en valor negativo, caso contrario mostrar positivo.
SELECT CASE 
            WHEN id_fcnc = 'NC' 
	        THEN pr_total * -1 
               ELSE pr_total
       END as total
FROM ventas;






