--1) Obtener el listado de clientes que poseen comprobantes tanto en 
--ventas como en h_ventas. Mostrar id_sucursal, id_cliente, de_organizacion
use CursoSQL_2016
SELECT DISTINCT clientes.id_cliente, 
                clientes.id_sucursal, 
                de_organizacion 
FROM   ventas 
       JOIN clientes 
         ON ventas.id_cliente = clientes.id_cliente 
            AND clientes.id_sucursal = ventas.id_sucursal 
UNION 
SELECT DISTINCT clientes.id_cliente, 
                clientes.id_sucursal, 
                de_organizacion 
FROM   clientes 
       JOIN h_ventas 
         ON h_ventas.id_cliente = clientes.id_cliente 
            AND h_ventas.id_sucursal = clientes.id_sucursal


--08/11/2018 17:00hs maxurbanija

--2) Obtener el listado de todos los Clientes mostrando el id_sucursal, 
--id_cliente, de_organización, tipo de contribuyente (Mostrar "Inscripto" 
--si es 'IN', "Consumidor Final" si es 'CF', "Monotributista" si es'MT' y 
--"Exento" si es 'EX') y aclarar en una quinta columna si tuvo ventas o no 
--en el período del '01.05.2008' al '31.08.2008' (considerar como ventas solo a las 'FC')
SELECT distinct c.id_cliente, 
       c.id_sucursal, 
       c.de_organizacion, 
       tipoContribuyente = CASE c.ti_contribuyente 
                             WHEN 'MT' THEN 'Monotributista' 
                             WHEN 'IN' THEN 'Inscripto' 
                             WHEN 'CF' THEN 'Consumidor Final' 
                             WHEN 'EX' THEN 'Exento' 
                             WHEN null then 'No Especificado' 
                           END, 
       tuvoVentas = CASE 
                      WHEN NOT EXISTS(SELECT 1 
                                      FROM   ventas v1 
                                      WHERE  v1.id_fcnc = 'FC' 
                                             AND v1.fe_venta BETWEEN 
                                                 '20080501' AND '20080831' 
                                             AND v1.id_cliente = c.id_cliente 
                                             AND v1.id_sucursal = c.id_sucursal) 
                    THEN 
                      'no' 
                      ELSE 'si' 
                    END 
FROM   clientes c  

--3) Obtener los comprobantes en los cuales la cantidad de articulos (ca_articulos de ventas_detalle) 
--incluidos en el comprobante sea mayor a 90. Mostrar la clave de la tabla ventas y además la clave del 
--cliente + de_cliente. Usar una subconsulta para resolver este ejercicio.
--opcion 1 (cada ventas_detalle >90)
SELECT sc.id_fcnc, 
       sc.id_tipoab, 
       sc.id_ptovta, 
       sc.id_numdoc, 
       v.id_cliente, 
       v.de_cliente 
FROM   (SELECT vd.id_fcnc, 
               vd.id_tipoab, 
               vd.id_ptovta, 
               vd.id_numdoc,
			   vd.id_secuencia 
        FROM   ventas_detalle vd 
        WHERE  vd.ca_articulos > 90) AS sc 
       JOIN ventas v 
         ON sc.id_fcnc = v.id_fcnc 
            AND sc.id_numdoc = v.id_numdoc 
            AND sc.id_ptovta = v.id_ptovta 
            AND sc.id_tipoab = v.id_tipoab 
--opcion 2 (suma de las ventas_detalle >90)
SELECT sc.id_fcnc, 
       sc.id_tipoab, 
       sc.id_ptovta, 
       sc.id_numdoc, 
       v.id_cliente, 
       v.de_cliente
FROM   (SELECT vd.id_fcnc, 
               vd.id_tipoab, 
               vd.id_ptovta, 
               vd.id_numdoc, 
               vd.id_secuencia, 
               vd.ca_articulos 
        FROM   ventas_detalle vd) AS sc 
       JOIN ventas v 
         ON sc.id_fcnc = v.id_fcnc 
            AND sc.id_numdoc = v.id_numdoc 
            AND sc.id_ptovta = v.id_ptovta 
            AND sc.id_tipoab = v.id_tipoab 
GROUP  BY sc.id_fcnc, 
          sc.id_tipoab, 
          sc.id_ptovta, 
          sc.id_numdoc, 
          v.id_cliente, 
          v.de_cliente 
HAVING Sum(sc.ca_articulos) > 90 

--4) Compruebe que los comprobantes obtenidos en el ejercicio anterior realmente estén correctos. Para ello 
--mostrar el listado de comprobantes que cumplen la condición de dicho ejercicio proyectando id_fcnc, id_tipoab, 
--id_ptovta, id_numdoc, y la cantidad de articulos por comprobantes (esta columna renombrarla).
--opcion 1
SELECT vd.id_fcnc, 
               vd.id_tipoab, 
               vd.id_ptovta, 
               vd.id_numdoc,
			   vd.id_secuencia, 
			   cantidad = vd.ca_articulos
        FROM   ventas_detalle vd 
        WHERE  vd.ca_articulos > 90

--opcion 2
SELECT sc.id_fcnc, 
       sc.id_tipoab, 
       sc.id_ptovta, 
       sc.id_numdoc, 
       v.id_cliente, 
       v.de_cliente, 
       totalVendido=Sum(sc.ca_articulos) 
FROM   (SELECT vd.id_fcnc, 
               vd.id_tipoab, 
               vd.id_ptovta, 
               vd.id_numdoc, 
               vd.id_secuencia, 
               vd.ca_articulos 
        FROM   ventas_detalle vd) AS sc 
       JOIN ventas v 
         ON sc.id_fcnc = v.id_fcnc 
            AND sc.id_numdoc = v.id_numdoc 
            AND sc.id_ptovta = v.id_ptovta 
            AND sc.id_tipoab = v.id_tipoab 
GROUP  BY sc.id_fcnc, 
          sc.id_tipoab, 
          sc.id_ptovta, 
          sc.id_numdoc, 
          v.id_cliente, 
          v.de_cliente 
HAVING Sum(sc.ca_articulos) > 90 

--5) Mostrar el total de ventas de del cliente 200007 de la sucursal 1, considerando tanto las ventas 
--almacenadas en las tabla "ventas" como también en "h_ventas" (Considerar los comprobantes "FC", "NC" y "ND", 
--y recordar que las "NC" restan). Mostrar la clave del cliente y la descripción (en clientes la descripción se 
--llama "de_organizacion")
SELECT id_cliente, 
       de_organizacion, 
       total = (SELECT total = Sum(CASE 
                                     WHEN sc.id_fcnc = 'NC' THEN -1 
                                     ELSE 1 
                                   END * sc.pr_total) 
                FROM   (SELECT * 
                        FROM   ventas v 
                        WHERE  v.id_cliente = 200007 
                               AND v.id_sucursal = 1 
                               AND id_fcnc IN ( 'NC', 'FC', 'ND' )) AS sc) 
               + (SELECT total = Sum(CASE 
                                       WHEN sc.id_fcnc = 'NC' THEN -1 
                                       ELSE 1 
                                     END * sc.pr_total) 
                  FROM   (SELECT * 
                          FROM   h_ventas hv 
                          WHERE  hv.id_cliente = 200007 
                                 AND hv.id_sucursal = 1 
                                 AND hv.id_fcnc IN ( 'NC', 'FC', 'ND' )) AS sc) 
FROM   clientes 
WHERE  id_cliente = 200007 
       AND id_sucursal = 1; 
			   
			   

		