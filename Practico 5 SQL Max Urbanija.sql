--14/11/18 20:51hs maxurbanija
--1.Contar la cantidad de clientes habilitados que existen por sucursal, mostrar el nombre de la sucursal y 
--el total de clientes, la salida debe estar ordenada por el nombre de la sucursal.
SELECT s.de_sucursal, 
       Count(c.id_cliente) 
FROM   clientes c 
       JOIN sucursales s 
         ON s.id_sucursal = c.id_sucursal 
WHERE  c.sn_habilitado = 'S' 
GROUP  BY s.de_sucursal 

--2.Listar los clientes del vendedor ‘4’ que no tuvieron ventas entre julio y octubre del 2008, mostrar el
-- código del vendedor, código del cliente, nombre del cliente, dirección del cliente, y el teléfono del cliente.
insert into vend_clie values(4,1,5,null,null)

SELECT v1.id_vendedor,
       c.id_cliente,
       c.de_organizacion,
       co.de_direccion,
       co.nu_telefono
FROM   vend_clie v1
       JOIN clientes c
         ON c.id_sucursal = v1.id_sucursal
            AND v1.id_cliente = c.id_cliente
       JOIN comercio co
         ON co.id_sucursal = c.id_sucursal
            AND co.id_cliente = c.id_cliente
WHERE  v1.id_vendedor = 4
       AND NOT EXISTS(SELECT 1
                      FROM   ventas v
                      WHERE  v.fe_venta BETWEEN '20080701' AND '20081031'
                             AND v1.id_cliente = v.id_cliente
                             AND v1.id_sucursal = v.id_sucursal) 
							 
--15/11/18 17:00hs maxurbanija
--3.Informar  para todos los artículos, la ultima fecha que tuvo una venta, sino tuvo venta debe informase igual, mostrar el código 
--del artículo, nombre del artículo,  la ultima fecha de venta. No tomar las ventas anuladas y excluir las Notas de Crédito.
SELECT a.id_articulos, 
       a.de_articulos, 
       ult_venta = Isnull(sc.ult_venta, 'sin ventas') 
FROM   articulos a 
       LEFT JOIN (SELECT vd.id_articulos, 
                         ult_venta = CONVERT(VARCHAR(10), Max(v.fe_venta), 103) 
                  FROM   ventas_detalle vd 
                         JOIN ventas v 
                           ON v.id_fcnc = vd.id_fcnc 
                              AND v.id_ptovta = vd.id_ptovta 
                              AND vd.id_numdoc = v.id_numdoc 
                              AND vd.id_tipoab = v.id_tipoab 
                              AND v.sn_anulo = 'N' 
                              AND v.id_fcnc != 'NC' 
                  GROUP  BY vd.id_articulos) sc 
              ON sc.id_articulos = a.id_articulos 


--4.Obtener los clientes que tienen más de 2 domicilios, mostrar el 
--código del cliente, el nombre del cliente, cantidad de domicilios
SELECT id_sucursal, 
       id_cliente, 
       ca_domicilios = Count(de_direccion) 
FROM   comercio 
GROUP  BY id_sucursal, 
          id_cliente 
HAVING Count(de_direccion) > 2 

--5.Mostrar el promedio de venta, la mínima venta, la máxima venta y la cantidad de comprobantes
--realizados por los clientes en el mes de agosto de 2009 separados por sucursal y comprobante y clientes.
SELECT v.id_sucursal, 
       v.id_cliente, 
       v.id_fcnc, 
       promedio = Avg(v.pr_total), 
       min_venta = Min(v.pr_total), 
       max_venta = Max(v.pr_total), 
       ca_comprobantes = Count(*) 
FROM   ventas v 
GROUP  BY v.id_sucursal, 
          v.id_cliente, 
          v.id_fcnc 


