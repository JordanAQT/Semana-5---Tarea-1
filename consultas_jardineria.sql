-- 1. Listar información básica de las oficinas
SELECT codigo_oficina, ciudad, pais, telefono 
FROM oficina;

-- 2. Obtener los empleados por oficina
SELECT e.codigo_oficina, e.nombre, e.apellido1, e.apellido2, e.puesto 
FROM empleado e 
ORDER BY e.codigo_oficina;

-- 3. Calcular el promedio de salario (límite de crédito) de los clientes por región
SELECT region, AVG(limite_credito) AS promedio_limite_credito 
FROM cliente 
GROUP BY region;

-- 4. Listar clientes con sus representantes de ventas
SELECT c.nombre_cliente, CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS nombre_representante 
FROM cliente c 
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 5. Obtener productos disponibles y en stock
SELECT codigo_producto, nombre, cantidad_en_stock 
FROM producto 
WHERE cantidad_en_stock > 0;

-- 6. Productos con precios por debajo del promedio
SELECT codigo_producto, nombre, precio_venta 
FROM producto 
WHERE precio_venta < (SELECT AVG(precio_venta) FROM producto);

-- 7. Pedidos pendientes por cliente
SELECT p.codigo_pedido, p.estado, c.nombre_cliente 
FROM pedido p 
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente 
WHERE p.estado != 'Entregado';

-- 8. Total de productos por categoría (gama)
SELECT gama, COUNT(*) AS total_productos 
FROM producto 
GROUP BY gama;

-- 9. Ingresos totales generados por cliente
SELECT c.nombre_cliente, SUM(p.total) AS ingresos_totales 
FROM cliente c 
JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
GROUP BY c.nombre_cliente;

-- 10. Pedidos realizados en un rango de fechas
SELECT codigo_pedido, fecha_pedido 
FROM pedido 
WHERE fecha_pedido BETWEEN '2008-01-01' AND '2008-12-31';

-- 11. Detalles de un pedido específico
SELECT dp.codigo_pedido, dp.codigo_producto, dp.cantidad, dp.precio_unidad, (dp.cantidad * dp.precio_unidad) AS precio_total 
FROM detalle_pedido dp 
WHERE dp.codigo_pedido = 1;

-- 12. Productos más vendidos
SELECT dp.codigo_producto, p.nombre, SUM(dp.cantidad) AS total_vendido 
FROM detalle_pedido dp 
JOIN producto p ON dp.codigo_producto = p.codigo_producto 
GROUP BY dp.codigo_producto 
ORDER BY total_vendido DESC;

-- 13. Pedidos con un valor total superior al promedio
SELECT dp.codigo_pedido, SUM(dp.cantidad * dp.precio_unidad) AS valor_total 
FROM detalle_pedido dp 
GROUP BY dp.codigo_pedido 
HAVING valor_total > (SELECT AVG(dp.cantidad * dp.precio_unidad) FROM detalle_pedido dp);

-- 14. Clientes sin representante de ventas asignado
SELECT nombre_cliente 
FROM cliente 
WHERE codigo_empleado_rep_ventas IS NULL;

-- 15. Número total de empleados por oficina
SELECT codigo_oficina, COUNT(*) AS total_empleados 
FROM empleado 
GROUP BY codigo_oficina;

-- 16. Pagos realizados en una forma específica
SELECT * 
FROM pago 
WHERE forma_pago = 'PayPal';

-- 17. Ingresos mensuales
SELECT YEAR(fecha_pago) AS año, MONTH(fecha_pago) AS mes, SUM(total) AS ingresos_mensuales 
FROM pago 
GROUP BY YEAR(fecha_pago), MONTH(fecha_pago);

-- 18. Clientes con múltiples pedidos
SELECT c.nombre_cliente, COUNT(p.codigo_pedido) AS total_pedidos 
FROM cliente c 
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente 
GROUP BY c.nombre_cliente 
HAVING total_pedidos > 1;

-- 19. Pedidos con productos agotados
SELECT DISTINCT p.codigo_pedido 
FROM pedido p 
JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido 
JOIN producto pr ON dp.codigo_producto = pr.codigo_producto 
WHERE pr.cantidad_en_stock = 0;

-- 20. Promedio, máximo y mínimo del límite de crédito de los clientes por país
SELECT pais, AVG(limite_credito) AS promedio_limite_credito, MAX(limite_credito) AS max_limite_credito, MIN(limite_credito) AS min_limite_credito 
FROM cliente 
GROUP BY pais;

-- 21. Historial de transacciones de un cliente
SELECT fecha_pago, total, forma_pago 
FROM pago 
WHERE codigo_cliente = 1;

-- 22. Empleados sin jefe directo asignado
SELECT nombre, apellido1, apellido2 
FROM empleado 
WHERE codigo_jefe IS NULL;

-- 23. Productos cuyo precio supera el promedio de su categoría (gama)
SELECT p.codigo_producto, p.nombre, p.precio_venta 
FROM producto p 
JOIN (SELECT gama, AVG(precio_venta) AS promedio_gama FROM producto GROUP BY gama) pg 
ON p.gama = pg.gama 
WHERE p.precio_venta > pg.promedio_gama;

-- 24. Promedio de días de entrega por estado
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias_entrega 
FROM pedido 
WHERE fecha_entrega IS NOT NULL 
GROUP BY estado;

-- 25. Clientes por país con más de un pedido
SELECT c.pais, COUNT(DISTINCT c.codigo_cliente) AS total_clientes 
FROM cliente c 
JOIN pedido p ON c.codigo_cliente = p.codigo_cliente 
GROUP BY c.pais 
HAVING total_clientes > 1;