DROP DATABASE IF EXISTS tienda_discos;

CREATE DATABASE tienda_discos_1;
USE tienda_discos_1;

#Creación de tablas.
create table tienda_discos_1.artistas
(
    id_artista     int auto_increment
        primary key,
    nombre_artista varchar(100) not null,
    nacionalidad   varchar(50)  null,
    fecha_inicio   date         null,
    sitio_web      varchar(50)  null,
    biografia      varchar(500) null
);

create table tienda_discos_1.clientes
(
    id_cliente        int auto_increment
        primary key,
    nombre_completo   varchar(100)                        not null,
    email             varchar(100)                        not null,
    telefono          varchar(15)                         not null,
    id_direccion      int                                 null,
    fecha_de_registro timestamp default CURRENT_TIMESTAMP null,
    constraint email
        unique (email)
);

create index id_direccion on tienda_discos_1.clientes (id_direccion);

create table tienda_discos_1.direccion_cliente
(
    id_direccion  int auto_increment
        primary key,
    id_cliente    int          not null,
    calle_numero  varchar(100) null,
    colonia       varchar(50)  null,
    codigo_postal varchar(20)  null,
    ciudad_estado varchar(50)  null,
    constraint direccion_cliente_ibfk_1
        foreign key (id_cliente) references tienda_discos_1.clientes (id_cliente)
);

# Permite la creacion de las tablas de clientes y direcciones.
alter table tienda_discos_1.clientes add constraint clientes_ibfk_1 foreign key (id_direccion) references tienda_discos_1.direccion_cliente (id_direccion);

create index id_cliente on tienda_discos_1.direccion_cliente (id_cliente);

create table tienda_discos_1.generos
(
    id_genero     int auto_increment
        primary key,
    nombre_genero varchar(50)  not null,
    descripcion   varchar(250) null,
    origen_epoca  varchar(50)  null,
    origen_region varchar(50)  null,
    popularidad   int          null
);

create table tienda_discos_1.ordenes
(
    id_orden     int auto_increment
        primary key,
    id_cliente   int                                not null,
    id_direccion int                                not null,
    fecha_orden  datetime default CURRENT_TIMESTAMP null,
    estado_orden varchar(50)                        null,
    total_bruto  decimal(10, 2)                     null,
    constraint ordenes_ibfk_1
        foreign key (id_cliente) references tienda_discos_1.clientes (id_cliente),
    constraint ordenes_ibfk_2
        foreign key (id_direccion) references tienda_discos_1.direccion_cliente (id_direccion)
);

create table tienda_discos_1.historial_ventas
(
    id_pagos           int auto_increment
        primary key,
    id_orden           int                                null,
    monto_pago         decimal(10, 2)                     null,
    metodo_pago        varchar(50)                        null,
    fecha_pago         datetime default CURRENT_TIMESTAMP null,
    folio_confirmacion varchar(100)                       null,
    constraint id_orden
        unique (id_orden),
    constraint historial_ventas_ibfk_1
        foreign key (id_orden) references tienda_discos_1.ordenes (id_orden)
);

create index id_cliente
    on tienda_discos_1.ordenes (id_cliente);

create index id_direccion
    on tienda_discos_1.ordenes (id_direccion);

create table tienda_discos_1.productos
(
    id_producto  int auto_increment
        primary key,
    titulo_album varchar(100)   not null,
    id_artista   int            not null,
    id_genero    int            not null,
    precio_venta decimal(10, 2) null,
    formato      varchar(50)    null,
    constraint productos_ibfk_1
        foreign key (id_artista) references tienda_discos_1.artistas (id_artista),
    constraint productos_ibfk_2
        foreign key (id_genero) references tienda_discos_1.generos (id_genero)
);

create table tienda_discos_1.carrito
(
    id_carrito  int auto_increment
        primary key,
    id_cliente  int not null,
    id_producto int not null,
    cantidad    int null,
    constraint carrito_ibfk_1
        foreign key (id_cliente) references tienda_discos_1.clientes (id_cliente),
    constraint carrito_ibfk_2
        foreign key (id_producto) references tienda_discos_1.productos (id_producto)
);

create index id_cliente
    on tienda_discos_1.carrito (id_cliente);

create index id_producto
    on tienda_discos_1.carrito (id_producto);

create table tienda_discos_1.detalle_orden
(
    id_orden        int            not null,
    id_producto     int            not null,
    cantidad        int            not null,
    precio_unitario decimal(10, 2) not null,
    primary key (id_orden, id_producto),
    constraint detalle_orden_ibfk_1
        foreign key (id_orden) references tienda_discos_1.ordenes (id_orden),
    constraint detalle_orden_ibfk_2
        foreign key (id_producto) references tienda_discos_1.productos (id_producto)
);

create index id_producto
    on tienda_discos_1.detalle_orden (id_producto);

create index id_artista
    on tienda_discos_1.productos (id_artista);

create index id_genero
    on tienda_discos_1.productos (id_genero);

create table tienda_discos_1.proveedores
(
    id_proveedor    int auto_increment
        primary key,
    nombre_provedor varchar(100) not null,
    direccion       varchar(150) null,
    ciudad_estado   varchar(50)  null,
    contacto_nombre varchar(100) null,
    telefono        varchar(20)  null,
    email_provedor  varchar(100) null,
    constraint email_provedor
        unique (email_provedor)
);

create table tienda_discos_1.pago_proveedor
(
    id_pago       int auto_increment
        primary key,
    tipo          enum ('debito', 'credito', 'efectivo') not null,
    id_proveedor  int                                    not null,
    comison       decimal(5, 2)                          null,
    moneda        varchar(20)                            null,
    estado_activo tinyint(1) default 1                   null,
    constraint pago_proveedor_ibfk_1
        foreign key (id_proveedor) references tienda_discos_1.proveedores (id_proveedor)
);

create index id_proveedor
    on tienda_discos_1.pago_proveedor (id_proveedor);

create table tienda_discos_1.resenas
(
    id_resena    int auto_increment
        primary key,
    id_cliente   int                                not null,
    id_producto  int                                not null,
    calificacion int                                null,
    comentario   varchar(500)                       null,
    fecha_resena datetime default CURRENT_TIMESTAMP null,
    constraint resenas_ibfk_1
        foreign key (id_cliente) references tienda_discos_1.clientes (id_cliente),
    constraint resenas_ibfk_2
        foreign key (id_producto) references tienda_discos_1.productos (id_producto),
    check ((`calificacion` >= 0) and (`calificacion` <= 5))
);

create index id_cliente
    on tienda_discos_1.resenas (id_cliente);

create index id_producto
    on tienda_discos_1.resenas (id_producto);

create table tienda_discos_1.restock
(
    id_restock        int auto_increment
        primary key,
    id_producto       int            not null,
    id_proveedor      int            not null,
    cantidad_recibida int            null,
    costo_unitario    decimal(10, 2) null,
    fecha_solicitud   date           null,
    fecha_recepcion   date           null,
    fecha_restock     varchar(50)    null,
    constraint restock_ibfk_1
        foreign key (id_producto) references tienda_discos_1.productos (id_producto),
    constraint restock_ibfk_2
        foreign key (id_proveedor) references tienda_discos_1.proveedores (id_proveedor)
);

create index id_producto
    on tienda_discos_1.restock (id_producto);

create index id_proveedor
    on tienda_discos_1.restock (id_proveedor);

create table tienda_discos_1.sucursales
(
    id_sucursal       int auto_increment
        primary key,
    nombre_sucursal   varchar(100) not null,
    direccion         varchar(150) null,
    ciudad_estado     varchar(50)  null,
    telefono_sucursal varchar(20)  null,
    horario_sucursal  varchar(100) null
);

create table tienda_discos_1.inventario
(
    id_inventario  int auto_increment
        primary key,
    id_producto    int         not null,
    id_sucursal    int         not null,
    cantidad_stock int         null,
    pasillo        varchar(50) null,
    estante        varchar(50) null,
    constraint inventario_ibfk_1
        foreign key (id_producto) references tienda_discos_1.productos (id_producto),
    constraint inventario_ibfk_2
        foreign key (id_sucursal) references tienda_discos_1.sucursales (id_sucursal)
);

create index id_producto
    on tienda_discos_1.inventario (id_producto);

create index id_sucursal
    on tienda_discos_1.inventario (id_sucursal);

create table tienda_discos_1.usuarios_admin
(
    id_admin         int auto_increment
        primary key,
    nombre_usuario   varchar(50)                        not null,
    email_admin      varchar(100)                       not null,
    contraseña_admin varchar(255)                       not null,
    rol_admin        varchar(50)                        null,
    fecha_creacion   datetime default CURRENT_TIMESTAMP null,
    constraint email_admin
        unique (email_admin),
    constraint nombre_usuario
        unique (nombre_usuario)
);

