#joins
#inner join para clientes y productos, solo muestra ordenes que si tienen clientes, detalle y productos (en teoria todos) porque si uno faltara el join no serviria
#Qué compró cada cliente y ccuanto pago por cada producto
#el inner practicamente muestra cosas que coincidan en ambas tablas
SELECT 
    c.nombre_completo AS cliente,
    o.id_ordene AS numero_orden,
    o.fecha_orden,
    p.titulo_album AS producto,
    p.formato,
    do.cantidad,
    do.subtotal
FROM ordenes o
INNER JOIN cilentes c ON o.id_cliente = c.id_cliente
INNER JOIN detalle_orden do ON o.id_ordene = do.id_orden
#une orden con los detalles especificos de esa orden
INNER JOIN productos p ON do.id_producto = p.id_producto
#pasa del id a la info, por ejemplo el id puede ser 1 y ya pero lo que hace aca es que en lugar de poner "1" pone el titulo de los productos y el total
ORDER BY o.fecha_orden DESC; 
#el desc solo le dice a el codigo como acomodar las ordenes, es decir order by /la fehca/ en orden del mas reciente al mas viejo
#c -> clientes
#o -> ordenes
#do -> detalle orden
#p -> productos

#ventas con metodo de pago, igual inner join, como se pago cada venta ? 
SELECT 
    c.nombre_completo AS cliente,
    o.id_ordene AS orden,
    o.estado_orden,
    mp.tipo AS tipo_pago,
    mp.proveedor AS banco_o_plataforma,
    hv.monto_pago,
    hv.folio_confirmacion
FROM historial_ventas hv
INNER JOIN ordenes o ON hv.id_orden = o.id_ordene
INNER JOIN cilentes c ON o.id_cliente = c.id_cliente
INNER JOIN metodos_pago mp ON hv.id_metodo = mp.id_metodo
#lo mismo que arriba, digamos que traduce de "1" (el id) a el metodo que se utilizo para pagar 
ORDER BY hv.fecha_pago DESC;
#hv -> historial ventas
#mp -> metodos pago
#quien compro, cuanto pago, como pago, cuando pago 

#left join, clientes que existen pero que no han comprado nada 
#aca lo importante tambien es el where, porque el left join va a mostrar todo lo de clientes aunque no tengan ordenes, pero el where o.id_ordene is null va a filtrar solo los que no tienen ordenes, los que no han comprado nada
SELECT 
    c.id_cliente,
    c.nombre_completo,
    c.email,
    c.fecha_de_registro,
    o.id_ordene AS orden
FROM cilentes c
#tabla izquierda , muestra todo lo de esta tabla aunque no tenga relación
LEFT JOIN ordenes o ON c.id_cliente = o.id_cliente
WHERE o.id_ordene IS NULL;
#filtra solo los clientes que no tienen ordenes,los que no han comprado nada
#o.id -> orden id 

#right join, las tiendas con su inventario, el stock de cada sucursal, incluso si es que no tienen invenatario subido 
SELECT 
    s.nombre_sucursal,
    s.direccion,
    p.titulo_album,
    p.formato,
    i.cantidad_stock,
    i.pasillo,
    i.estante
FROM inventario i
RIGHT JOIN sucursales s ON i.id_sucursal = s.id_sucursal
#lo mismo que arriba solo que por la derecha, muestra todo de la derecha aunque no  tenga coincidencias, 
#la tabla derecha es suscursales entonces muestra todas las sucursales aunque no tengan invenatrio
LEFT JOIN productos p ON i.id_producto = p.id_producto 
#convierte el id en los nombres de los discos, lo mismo que en los de arriba so lo dejare de mencionar 
ORDER BY s.nombre_sucursal;

#cross join, combinaciones de formato y genero 
SELECT DISTINCT
#el distinct lo que hace es que elimina los repetidos para que en lugar de que aparezca "vinilo vinilo vinilo o cd cd cd cd, solo aparezca vinilo, cd y yap"
    g.nombre_genero,
    sub.formato
FROM generos g
CROSS JOIN (
    SELECT DISTINCT formato FROM productos
) sub
ORDER BY g.nombre_genero, sub.formato;