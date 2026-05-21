USE tienda_discos_1;

# VW1: Vista para mostrar el catálogo de discos con su artista, género, formato y precio.
# Puede funcionar para mostrar el catálogo en la página principal de la tienda o para búsquedas específicas.
CREATE VIEW tienda_discos_1.vista_catalogo_discos AS
SELECT 
    p.id_producto,
    p.titulo_album AS disco,
    a.nombre_artista AS artista,
    g.nombre_genero AS genero,
    p.formato,
    p.precio_venta AS precio

FROM tienda_discos_1.productos p
INNER JOIN tienda_discos_1.artistas a ON p.id_artista = a.id_artista
INNER JOIN tienda_discos_1.generos g ON p.id_genero = g.id_genero;

# VW2: Vista para mostrar un resumen de las ventas por cliente, incluyendo el total gastado y la fecha de su última compra.
# Esta vista puede ser útil para el área de marketing o para ofrecer promociones personalizadas a los clientes.
CREATE VIEW tienda_discos_1.vista_resumen_ventas_clientes AS
SELECT 
    o.id_orden AS numero_orden,
    c.nombre_completo AS cliente,
    c.email AS correo,
    o.fecha_orden AS fecha,
    o.estado_orden AS estatus,
    o.total_bruto AS total_pago
FROM tienda_discos_1.ordenes o
INNER JOIN tienda_discos_1.clientes c ON o.id_cliente = c.id_cliente;

# Ver la información de los discos más vendidos.
SELECT * FROM tienda_discos_1.vista_catalogo_discos;
SELECT * FROM tienda_discos_1.vista_resumen_ventas_clientes;