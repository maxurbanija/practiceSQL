--02/11/18 12:50hs maxurbanija

--1) Mostrar los clientes a los que se realizaron ventas. 
--Proyectar los valores id_cliente, de_cliente (ambos campos se encuentran en la tabla ventas)
select id_cliente,de_cliente from ventas group by id_cliente,de_cliente;

--2) Mostrar cuantos días pasaron desde la última venta realizada al cliente 201549.
select diasTranscurridos = DATEDIFF(day, max(fe_venta), GETDATE() )from ventas where id_cliente=201549;
--Tener en cuenta que getdate devuelve la fecha y hora del so donde esta corriendo la corriendo la instancia de bd
--por lo que pueden ser distintas a las del cliente

--3) Mostrar los vendedores que realizaron ventas con importe (pr_total) mayor a $100.
select id_vendedor from ventas where pr_total > 100;

--4)Seleccionar las ventas realizadas por los vendedores 2,3,4,5 
--cuyo importe sea mayor a 100 durante el mes de agosto de 2008.
select * 
from ventas 
where id_vendedor in (2,3,4,5) and month(fe_venta) = 08 and year(fe_venta)=2008 and pr_total > 100;


--5) Seleccionar ventas que no hayan sido realizadas por los vendedores 10,12,13,14.
select * from ventas where id_vendedor not in(10,12,13,14);

--6) Mostrar los monotributistas e inscriptos que tengan cuit o los consumidores finales que 
--tengan número de documento en los clientes.
select * 
from clientes 
where ((ti_contribuyente='MT' or ti_contribuyente = 'IN') 
and id_cuit is not null) 
or (ti_contribuyente = 'CF' and id_nrodoc is not null);
--verificar, porque todos los CF tienen null en nro doc.


--03/11/18 14:50hs maxurbanija

--7) Obtener El importe total de ventas del cliente 216138. 
--Tomar solo las factura ‘FC’ (id_fcnc) en el periodo ’01.01.2008’ y 31.01.2008’ (fe_venta) 
--y que los comprobantes no estén anulados (sn_anulo)
select sum(pr_total) 
from ventas
where id_cliente = 216138
and id_fcnc = 'FC'
and fe_venta between '20080101' and '20080131'
and sn_anulo = 'N'

--8) Modificar la consulta anterior incluir en el análisis 
--las NOTAS DE CREDITO ‘NC’ y NOTAS DE DÉBITO ‘ND’.
select sum(pr_total) 
from ventas
where id_cliente = 216138
and id_fcnc in ('FC','NC','ND')
and fe_venta between '20080101' and '20081231'
and sn_anulo = 'N'

--9) Obtener el total de ventas realizada por sucursal y vendedores 
--de la empresa en el periodo 01.01.2009 y 01.04.2009. Proyectar los siguientes datos. 
--Código de la Sucursal, Código del Vendedor, Total de Ventas sin iva (pr_subtotal), 
--Total de Ventas con IVA (pr_total).
select  
	id_sucursal,
	id_vendedor,
	subtotal = sum(pr_subtotal),
	total = sum(pr_total)
from ventas
where fe_venta between '20090101' and '20090401'
group by ventas.id_sucursal,ventas.id_vendedor

--10) Obtener la cantidad de ventas realizadas por cliente (mostrando id_cliente y de_cliente) 
--en el período comprendido entre '01.03.2008' y '30.11.2008' y las cuales hayan sido realizadas 
--por el vendedor 10 (id_vendedor) o hayan sido distribuidas por el repartidor 307 (id_repartidor). 
--Considerar solo los comprobantes "FC" (id_fcnc).
select 
	ventas.id_cliente,
	de_cliente,
	cantVentas = count(ventas.id_cliente)
from ventas
where fe_venta between '20080301' and '20081130'
and( id_vendedor = 10
or id_repartidor = 307)
group by id_cliente,de_cliente

--11) Lo mismo que el ejercicio 10 pero solo de los clientes que posean 
--el nombre "Maria" (sin tilde) o "Mario" en de_cliente. Aclaración: por ejemplo, 
--el nombre "Mariano" no debe ser considerado como "Maria"
select 
	id_cliente,
	de_cliente,
	cantVentas = count(id_cliente)
from ventas
where fe_venta between '20080301' and '20081130'
and( id_vendedor = 10
or id_repartidor = 307)
and (de_cliente like '%Maria'
or de_cliente like '%Maria[^a-z]%')
group by id_cliente,de_cliente








 
