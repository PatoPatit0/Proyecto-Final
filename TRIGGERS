USE tienda_discos_1;

# TGG1: Para restar un producto del inventario.
# Se activa después de insertar un detalle de orden, y automáticamente descuenta la cantidad vendida del inventario.
DELIMITER //

CREATE TRIGGER tienda_discos_1.tg_descontar_stock_venta
AFTER INSERT ON tienda_discos_1.detalle_orden
FOR EACH ROW
BEGIN
    -- Busca el producto vendido en el inventario y le resta la cantidad de la venta
    UPDATE tienda_discos_1.inventario
    SET cantidad_stock = cantidad_stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

DELIMITER ;

#TGG2: Para generar una orden de compra al proveedor cuando el stock de un producto llegue a 0.
# Se activa después de actualizar el inventario, y si se actualiza a 0, se inserta automáticamente una orden de compra al proveedor para reabastecer.
# Yoshi me explicó que esto es putil para que el sistema solito alerte que se quedó sin stock sin que el encargado tenga que estar revisando todo el tiempo el inventario.
DELIMITER //

CREATE TRIGGER tienda_discos_1.tg_auto_restock
AFTER UPDATE ON tienda_discos_1.inventario
FOR EACH ROW
BEGIN

    IF NEW.cantidad_stock = 0 AND OLD.cantidad_stock > 0 THEN
        
        INSERT INTO tienda_discos_1.restock (
            id_producto, 
            id_proveedor, 
            cantidad_recibida, 
            costo_unitario, 
            fecha_solicitud, 
            fecha_recepcion, 
            fecha_restock
        )
        VALUES (
            NEW.id_producto,   -- ID del producto en 0.
            1,                 -- id_proveedor
            50,                -- Cantidad a pedir.
            150.00,            -- Costo estimado por unidad.`tienda_discos_1.restock`
            CURDATE(),         -- Fecha de solicitud (HOY)
            NULL,              -- Fecha de recepción (se llena cuando llegue el pedido)
            'PEDIDO AUTOMÁTICO POR FALTA DE STOCK'
        );
        
    END IF;
END //

DELIMITER ;

# Prueba de funcionamiento.
-- INSERT INTO tienda_discos_1.detalle_orden (id_orden, id_producto, cantidad, precio_unitario)
-- VALUES (1, 1, 5, 250.00);