USE tienda_discos_1;

# Conocer cuantos productos compró cada cliente.
SELECT 
    c.nombre_completo AS cliente,
    o.id_orden AS numero_orden,
    o.fecha_orden,
    p.titulo_album AS producto,
    p.formato,
    do.cantidad,
    (do.cantidad * do.precio_unitario) AS subtotal
FROM tienda_discos_1.ordenes o
INNER JOIN tienda_discos_1.clientes c ON o.id_cliente = c.id_cliente
INNER JOIN tienda_discos_1.detalle_orden do ON o.id_orden = do.id_orden
INNER JOIN tienda_discos_1.productos p ON do.id_producto = p.id_producto
ORDER BY o.fecha_orden DESC;

# Pagos recibidos.
SELECT 
    c.nombre_completo AS cliente,
    o.id_orden AS orden,
    o.estado_orden,
    hv.metodo_pago AS tipo_pago, -- Se extrae directo de historial_ventas
    hv.monto_pago,
    hv.folio_confirmacion,
    hv.fecha_pago
FROM tienda_discos_1.historial_ventas hv
INNER JOIN tienda_discos_1.ordenes o ON hv.id_orden = o.id_orden
INNER JOIN tienda_discos_1.clientes c ON o.id_cliente = c.id_cliente
ORDER BY hv.fecha_pago DESC;

# Reconocer clientea que no han realizado compras.
SELECT 
    c.id_cliente,
    c.nombre_completo,
    c.email,
    c.fecha_de_registro,
    o.id_orden AS orden
FROM tienda_discos_1.clientes c
LEFT JOIN tienda_discos_1.ordenes o ON c.id_cliente = o.id_cliente
WHERE o.id_orden IS NULL;

# Productos disponibles en cada sucursal, incluyendo aquellos sin stock.
SELECT 
    s.nombre_sucursal,
    s.direccion,
    p.titulo_album,
    p.formato,
    i.cantidad_stock,
    i.pasillo,
    i.estante
FROM tienda_discos_1.inventario i
RIGHT JOIN tienda_discos_1.sucursales s ON i.id_sucursal = s.id_sucursal
LEFT JOIN tienda_discos_1.productos p ON i.id_producto = p.id_producto 
ORDER BY s.nombre_sucursal;

# Listado de géneros musicales junto con los formatos disponibles (incluye productos que no están para algún género o formato).
SELECT DISTINCT
    g.nombre_genero,
    sub.formato
FROM tienda_discos_1.generos g
CROSS JOIN (
    SELECT DISTINCT formato FROM tienda_discos_1.productos
) sub
ORDER BY g.nombre_genero, sub.formato;

# Listado de todos los productos junto con el nombre del proveedor (también productos sin proveedor asignado).
# Tanto por derecha como por izquierda para mostrar ambos casos (productos sin proveedor y proveedores sin productos).
SELECT 
    p.titulo_album,
    prov.nombre_provedor
FROM tienda_discos_1.productos p
LEFT JOIN tienda_discos_1.restock r ON p.id_producto = r.id_producto
LEFT JOIN tienda_discos_1.proveedores prov ON r.id_proveedor = prov.id_proveedor;

SELECT 
    p.titulo_album,
    prov.nombre_provedor
FROM tienda_discos_1.productos p
RIGHT JOIN tienda_discos_1.restock r ON p.id_producto = r.id_producto
RIGHT JOIN tienda_discos_1.proveedores prov ON r.id_proveedor = prov.id_proveedor;