--09/11/18 00:45hs maxurbanija

--1) Crear una consulta que devuelva los siguientes datos: c ódigo de artículo, nombre de artículo, stock en 
--unidades (tabla stock_sucursal),stock valorizado al costo (ca_stkdeposito * pr_costo_neto), promedio de venta 
--diario en unidades, promedio de venta diario valorizado al costo. (promedio * pr_costo) disponibilidad de stock 
--en días (ca_stkdeposito / promedio). El análisis de promedios hacerlo desde 01.07.2008 al 31.07.2008. El campo 
--pr_costo_neto está en la tabla artículos y el campo pr_costo está en la tabla ventas_detalle
SELECT a.id_articulos, 
       a.de_articulos, 
       sg.cantidad, 
       stk_val_costo = ( sg.cantidad * a.pr_costo_neto ), 
       prom_cant_vendidaxdia=promedioxdia.promedioxdia, 
       promedio_valorizadoxdia=promedioxdia.prom_valorizado 
FROM   articulos a 
       JOIN (SELECT vd.id_articulos, 
                    promedioxdia = Sum(vd.ca_articulos) / 31, --calculo el promedio de unidades vendidas por dia en el periodo dado 
                    prom_valorizado = 
                    ( Sum(vd.ca_articulos) / 31 ) * vd.pr_costo 
             FROM   ventas v 
                    JOIN ventas_detalle vd 
                      ON v.id_fcnc = vd.id_fcnc 
                         AND vd.id_numdoc = v.id_numdoc 
                         AND vd.id_ptovta = v.id_ptovta 
                         AND vd.id_tipoab = v.id_tipoab 
             WHERE  v.fe_venta BETWEEN '20080701' AND '20080731' 
             GROUP  BY vd.id_articulos, 
                       vd.pr_costo) AS promedioxdia 
         ON promedioxdia.id_articulos = a.id_articulos 
       JOIN (SELECT sc.id_articulos, --calculo el stock de todas las sucursales
                    cantidad = Sum(ca_stkdeposito) 
             FROM   stock_sucursal sc 
             GROUP  BY sc.id_articulos) AS sg --sg = stock general 
         ON sg.id_articulos = a.id_articulos 
GROUP  BY a.id_articulos, 
          a.de_articulos, 
          sg.cantidad, 
          a.pr_costo_neto, 
          promedioxdia.promedioxdia, 
          promedioxdia.prom_valorizado 
	     
--2) Mostrar las ventas en el periodo 01.01.2008 a 01.07.2008 presentadas por segmento del producto, se deben 
--proyectar los campos código de segmento, descripción del segmento, cantidad vendida, importe sin impuestos. 
--Incluir los comprobantes, ‘FC’,’NC’,’ND’. Sólo se deben mostrar los comprobantes no anulados. Se deben incluir 
--todos los segmentos existentes, aunque los mismos no tengan ventas.
SELECT s.id_segmento,
       s.de_segmento,
       cantidad = Isnull(Sum(sc.cant_vendida), 0),
       importe_simpuestos = Isnull(Sum(sc.importe_simpuestos), 0)
FROM   segmento s
       LEFT JOIN articulos a
              ON a.id_segmento = s.id_segmento
       LEFT JOIN (SELECT vd.id_articulos,
                         importe_simpuestos =
                         Sum(vd.ca_articulos * vd.pr_unitario_siva),
                         cant_vendida = Sum(vd.ca_articulos)
                  FROM   ventas v
                         JOIN ventas_detalle vd
                           ON v.id_fcnc = vd.id_fcnc
                              AND vd.id_numdoc = v.id_numdoc
                              AND vd.id_ptovta = v.id_ptovta
                              AND vd.id_tipoab = v.id_tipoab
                  WHERE  v.fe_venta BETWEEN '20080101' AND '20080701'
                         AND v.id_fcnc IN ( 'FC', 'NC', 'ND' )
                         AND v.sn_anulo = 'N'
                  GROUP  BY vd.id_articulos) AS sc
              ON a.id_articulos = sc.id_articulos
GROUP  BY s.id_segmento,
          s.de_segmento 

--3) Presentar un listado que muestre todos los artículos en las distintas listas de precios. Mostrar: id_articulo, 
--de_artículo, id_lista, de_lista y el precio que resulta de aplicar los descuentos de la lista (ta_dto1, 
--ta_dto2) al precio del artículo (pr_arcor_a)
SELECT l.id_lista,
       l.de_lista,
       sc.id_articulos,
       sc.de_articulos,
       precio1=sc.pr_arcor_a * ( 1 - l.ta_dto1 / 100 ),
       precio2=sc.pr_arcor_a * ( 1 - l.ta_dto2 / 100 )
FROM   listas l
       JOIN (SELECT DISTINCT a.id_articulos,
                             de_articulos,
                             vd.id_lista,
                             a.pr_arcor_a
             FROM   articulos a
                    JOIN ventas_detalle vd
                      ON a.id_articulos = vd.id_articulos) AS sc
         ON sc.id_lista = l.id_lista 

--4) Mostrar un listado de clientes Monotributistas habilitados que no 
--compraron durante el periodo 01.07.2008 al 31.07.2008.
SELECT v.id_cliente,
       v.de_cliente,
       v.fe_venta
FROM   ventas v
       JOIN clientes c
         ON v.id_sucursal = c.id_sucursal
            AND v.id_cliente = c.id_cliente
WHERE  v.fe_venta NOT BETWEEN '20080701' AND '20080731'
       AND v.ti_contribuyente = 'MT'
       AND c.sn_habilitado = 'S'
ORDER  BY v.fe_venta 



	

	