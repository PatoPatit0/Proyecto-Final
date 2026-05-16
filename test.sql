CREATE DATABASE tienda_discos;
USE tienda_discos;

CREATE TABLE cilentes ( 
    id_cliente INT AUTO_INCREMENT PRIMARY KEY, 
    nombre_completo VARCHAR (100) NOT NULL,
    email VARCHAR (100) NOT NULL UNIQUE,
    telefono VARCHAR (20) NOT NULL, 
    direccion_envio VARCHAR (150), 
    fecha_de_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE generos (
    id_genero INT AUTO_INCREMENT PRIMARY KEY, 
    nombre_genero VARCHAR (50) NOT NULL, 
    descripcion VARCHAR (250), 
    origen_epoca VARCHAR (50),
    origen_region VARCHAR (50), 
    popularidad INT
);

CREATE TABLE artitas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY, 
    nombre_artistista VARCHAR (100) NOT NULL, 
    nacionalidad VARCHAR (50),
    fecha_inicio DATE, 
    sitio_web VARCHAR (50), 
    biografia VARCHAR (500)
);

CREATE TABLE sucursales (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY, 
    nombre_sucursal VARCHAR (100) NOT NULL, 
    direccion VARCHAR (150), 
    telefono_sucursal VARCHAR (20), 
    horario_sucursal VARCHAR (100)
);

CREATE TABLE proveedores (
    id_provedor INT AUTO_INCREMENT PRIMARY KEY, 
    nombre_provedor VARCHAR (100) NOT NULL, 
    contacto_nombre VARCHAR (100), 
    telefono VARCHAR (20), 
    email_provedor VARCHAR (100) UNIQUE
);

CREATE TABLE metodos_pago (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('debito', 'credito', 'efectivo') NOT NULL,
    proveedor VARCHAR (50), 
    comison DECIMAL(5,2),
    moneda VARCHAR (20), 
    estado_activo BOOLEAN DEFAULT TRUE  
);

CREATE TABLE usuarios_admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR (50) UNIQUE NOT NULL, 
    email_admin VARCHAR (100) UNIQUE NOT NULL,
    contraseña_admin VARCHAR (255) NOT NULL,
    rol_admin VARCHAR (50), 
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
); 

CREATE TABLE direccion_cliente (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY, 
    id_cliente INT NOT NULL, 
    calle_numero VARCHAR (50), 
    colonia VARCHAR (100), 
    codigo_postal VARCHAR (20), 
    ciudad_estado VARCHAR (50),

    FOREIGN KEY (id_cliente) REFERENCES ciLentes(id_cliente)
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY, 
    titulo_album VARCHAR (100) NOT NULL,
    id_artista INT NOT NULL,
    id_genero INT NOT NULL,
    precio_venta DECIMAL(10,2) ,
    formato VARCHAR (50),

    FOREIGN KEY (id_artista)
    REFERENCES artitas(id_artista),

    FOREIGN KEY (id_genero)
    REFERENCES generos(id_genero)
);

CREATE TABLE inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY, 
    id_producto INT NOT NULL, 
    id_sucursal INT NOT NULL, 
    cantidad_stock INT, 
    pasillo VARCHAR (50),
    estante VARCHAR (50),

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto),

    FOREIGN KEY (id_sucursal)
    REFERENCES sucursales(id_sucursal)
); 

CREATE TABLE restock (
    id_restock INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_provedor INT NOT NULL,
    cantidad_recibida INT, 
    costo_unitario DECIMAL(10,2),
    fecha_solicitud DATE,
    fecha_recepcion DATE, 
    fecha_restock VARCHAR (50),

    FOREIGN KEY (id_producto) 
    REFERENCES productos(id_producto),

    FOREIGN KEY (id_provedor) 
    REFERENCES proveedores(id_provedor)
);

CREATE TABLE ordenes (
    id_ordene INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_direccion INT NOT NULL,
    fecha_orden DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado_orden VARCHAR (50),
    total_bruto DECIMAL (10,2),

    FOREIGN KEY (id_cliente)
    REFERENCES cilentes(id_cliente),

    FOREIGN KEY (id_direccion)
    REFERENCES direccion_cliente(id_direccion)
);

CREATE TABLE historial_ventas(
    id_pagos INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT UNIQUE, 
    id_metodo INT, 
    monto_pago DECIMAL (10,2),
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    folio_confirmacion VARCHAR (100),
    FOREIGN KEY (id_orden)
    REFERENCES ordenes(id_ordene),

    FOREIGN KEY (id_metodo)
    REFERENCES metodos_pago(id_metodo)  
);

CREATE TABLE carrito (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY, 
    id_cliente INT NOT NULL, 
    id_producto INT, 
    cantidad INT, 

    FOREIGN KEY (id_cliente)
    REFERENCES cilentes(id_cliente),

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
);

CREATE TABLE resenas (
    id_resena INT AUTO_INCREMENT PRIMARY KEY, 
    id_cliente INT NOT NULL, 
    id_producto INT NOT NULL, 
    calificacion INT CHECK (calificacion >= 1 AND calificacion <= 5), 
    comentario VARCHAR (500), 
    fecha_resena DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_cliente)
    REFERENCES cilentes(id_cliente),

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
)

CREATE TABLE detalle_orden (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY, 
    id_orden INT NOT NULL, 
    id_producto INT NOT NULL, 
    cantidad INT, 
    precio_unitario DECIMAL (10,2), 
    subtotal DECIMAL (10,2),

    FOREIGN KEY (id_orden)
    REFERENCES ordenes(id_ordene),

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
);



#Todos los date funcionan de date time es donde va a guardar la fecha y hora, y el formato es este YYYY-MM-DD HH:MM:SS
#la diferencia netre date y date time es que date solo guarda la fecha y el date time, ya sea el default o current usan la hora y fehca del sistema 