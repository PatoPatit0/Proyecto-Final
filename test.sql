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

#Aca pongo los inserts de las de tablas, primero las que son independientes para que no lanzen ningun error (eso espero)
#GENEROS
INSERT INTO generos (nombre_genero, descripcion, origen_epoca, origen_region, popularidad) VALUES
('Rock Clásico', 'Rock de las décadas 60-80, guitarras eléctricas y estructuras tradicionales', '1960s', 'Reino Unido / EE.UU.', 95),
('Heavy Metal', 'Rock de alta distorsión, temáticas oscuras y virtuosismo instrumental', '1970s', 'Reino Unido', 88),
('Pop', 'Música popular de consumo masivo, melodías pegajosas y producción pulida', '1950s', 'EE.UU.', 97),
('Jazz', 'Improvisación, swing y complejidad armónica de raíces afroamericanas', '1900s', 'EE.UU.', 80),
('Blues', 'Música de raíces afroamericanas, escalas pentatónicas y letras emotivas', '1900s', 'EE.UU. (Sur)', 75),
('Hip-Hop', 'Ritmos sampledos, rimas y cultura urbana de origen neoyorquino', '1970s', 'EE.UU.', 96),
('R&B', 'Rhythm and Blues, fusión de soul, funk y pop contemporáneo', '1940s', 'EE.UU.', 91),
('Electrónica', 'Música producida con sintetizadores, cajas de ritmos y software DAW', '1970s', 'Alemania / Reino Unido', 89),
('Punk', 'Rock crudo, rápido y minimalista con actitud contestataria', '1970s', 'Reino Unido / EE.UU.', 72),
('Indie Rock', 'Rock independiente de sellos, sonido alternativo y letras introspectivas', '1980s', 'EE.UU. / Reino Unido', 83),
('Soul', 'Fusión de gospel y R&B, voz protagonista y emotividad profunda', '1950s', 'EE.UU.', 84),
('Reggae', 'Ritmo sincopado jamaicano, temáticas rastafari y sociales', '1960s', 'Jamaica', 78),
('Country', 'Música americana de raíces rurales, guitarra acústica y narrativas cotidianas', '1920s', 'EE.UU.', 79),
('Clásica', 'Música académica occidental de tradición orquestal y camerística', '1600s', 'Europa', 70),
('Bossa Nova', 'Fusión brasileña de samba y jazz, cadencia suave y letras poéticas', '1950s', 'Brasil', 73),
('Grunge', 'Subgénero del rock alternativo, sonido sucio y letras angustiadas', '1980s', 'EE.UU. (Seattle)', 81),
('Funk', 'Groove rítmico sincopado, bajo protagonista y brass sections', '1960s', 'EE.UU.', 82),
('Metal Alternativo', 'Fusión de metal con elementos alternativos, experimentales o electrónicos', '1980s', 'EE.UU.', 80),
('Pop Punk', 'Fusión de punk con melodías pop accesibles', '1990s', 'EE.UU.', 77),
('Trap', 'Subgénero del hip-hop con hi-hats rápidos y 808s prominentes', '2000s', 'EE.UU. (Atlanta)', 92),
('Salsa', 'Fusión de son cubano con jazz y ritmos caribeños', '1960s', 'Cuba / Puerto Rico / EE.UU.', 85),
('Rock en Español', 'Rock cantado en español con influencias latinas', '1980s', 'México / Argentina', 87),
('Bolero', 'Género romántico latinoamericano de tempo lento y letras poéticas', '1880s', 'Cuba / México', 71),
('Ska', 'Precursor del reggae con ritmo de contragolpe y influencias jazz', '1950s', 'Jamaica', 68),
('Progressive Rock', 'Rock de estructuras complejas, influencias clásicas y conceptuales', '1960s', 'Reino Unido', 76),
('New Wave', 'Post-punk con sintetizadores y estética ochentera', '1970s', 'Reino Unido / EE.UU.', 74),
('Disco', 'Música bailable de los 70s, orquestaciones y cuatro a tierra', '1970s', 'EE.UU.', 72),
('Gospel', 'Música cristiana de raíces afroamericanas, coros y espiritualidad', '1930s', 'EE.UU.', 69),
('Latin Pop', 'Pop producido en español o portugués con ritmos latinos', '1980s', 'América Latina', 93),
('Folk', 'Música acústica de tradición oral, narrativas y raíces culturales', '1900s', 'EE.UU. / Europa', 74);

#ARTISTAS 
INSERT INTO artitas (nombre_artistista, nacionalidad, fecha_inicio, sitio_web, biografia) VALUES
('The Beatles', 'Británica', '1960-01-01', 'www.thebeatles.com', 'Banda de Liverpool formada en 1960, considerada la más influyente de la historia del rock. Integrada por John Lennon, Paul McCartney, George Harrison y Ringo Starr.'),
('Pink Floyd', 'Británica', '1965-01-01', 'www.pinkfloyd.com', 'Banda de rock progresivo y psicodélico de Londres, conocida por sus álbumes conceptuales y espectáculos en vivo innovadores.'),
('Michael Jackson', 'Estadounidense', '1964-01-01', 'www.michaeljackson.com', 'Rey del Pop, artista más vendido de la historia con más de 400 millones de discos. Reconocido por su baile, voz y producción musical.'),
('Led Zeppelin', 'Británica', '1968-01-01', 'www.ledzeppelin.com', 'Cuarteto de hard rock y heavy metal de Londres, pioneros del rock de estadio con Jimmy Page, Robert Plant, John Bonham y John Paul Jones.'),
('Bob Marley', 'Jamaicana', '1963-01-01', 'www.bobmarley.com', 'Ícono del reggae jamaicano, embajador cultural y espiritual del movimiento rastafari. Sus canciones abogan por la paz y la justicia social.'),
('Nirvana', 'Estadounidense', '1987-01-01', 'www.nirvana.com', 'Trío de grunge de Aberdeen, Washington, liderado por Kurt Cobain. Revolucionaron la música alternativa con Nevermind en 1991.'),
('Metallica', 'Estadounidense', '1981-01-01', 'www.metallica.com', 'Banda de heavy metal de San Francisco, una de las más vendidas de la historia con más de 125 millones de discos vendidos.'),
('Madonna', 'Estadounidense', '1979-01-01', 'www.madonna.com', 'Reina del Pop, artista femenina más vendida de todos los tiempos. Reinventó su imagen y sonido múltiples veces en cuatro décadas.'),
('David Bowie', 'Británica', '1962-01-01', 'www.davidbowie.com', 'Camaleón del rock, exploró glam rock, soul, electrónica y new wave bajo múltiples alter egos. Uno de los artistas más influyentes del siglo XX.'),
('Prince', 'Estadounidense', '1975-01-01', 'www.prince.com', 'Genio multifacético de Minneapolis que dominó el funk, R&B, pop y rock. Tocaba más de 20 instrumentos y produjo casi toda su música.'),
('Amy Winehouse', 'Británica', '2003-01-01', 'www.amywinehouse.com', 'Cantautora de soul y jazz de Londres, conocida por su voz única y su álbum Back to Black, uno de los más vendidos del siglo XXI.'),
('Daft Punk', 'Francesa', '1993-01-01', 'www.daftpunk.com', 'Dúo de música electrónica de París formado por Thomas Bangalter y Guy-Manuel de Homem-Christo, pioneros del french house y EDM global.'),
('Radiohead', 'Británica', '1985-01-01', 'www.radiohead.com', 'Banda de Oxford liderada por Thom Yorke, conocida por fusionar rock alternativo con electrónica experimental y letras introspectivas.'),
('Kendrick Lamar', 'Estadounidense', '2003-01-01', 'www.kendricklamar.com', 'Rapero de Compton, California, considerado uno de los mejores de su generación. Premio Pulitzer de Música en 2018 por DAMN.'),
('Adele', 'Británica', '2006-01-01', 'www.adele.com', 'Cantautora de soul y pop de Londres, con ventas superiores a 120 millones de discos. Sus álbumes 21 y 25 batieron récords mundiales.'),
('Red Hot Chili Peppers', 'Estadounidense', '1983-01-01', 'www.rhcp.com', 'Banda de rock alternativo y funk metal de Los Ángeles, activa por más de cuatro décadas con éxitos como Under the Bridge y Californication.'),
('The Rolling Stones', 'Británica', '1962-01-01', 'www.rollingstones.com', 'La mejor banda de rock and roll del mundo según muchos críticos. Activos desde 1962 con Mick Jagger y Keith Richards como pilares.'),
('Soda Stereo', 'Argentina', '1982-01-01', 'www.sodastereo.com', 'Banda de rock en español más influyente de Latinoamérica, liderada por Gustavo Cerati. Fusionaron new wave, punk y rock alternativo.'),
('Café Tacvba', 'Mexicana', '1989-01-01', 'www.cafetacvba.com', 'Banda de rock alternativo mexicano de Naucalpan, conocida por mezclar géneros como cumbia, norteño, bolero y punk en un sonido único.'),
('Shakira', 'Colombiana', '1991-01-01', 'www.shakira.com', 'Artista colombiana de pop y rock en español, una de las latinas más vendidas de la historia con más de 80 millones de discos.'),
('Miles Davis', 'Estadounidense', '1944-01-01', 'www.milesdavis.com', 'Trompetista y compositor de jazz de Illinois, figura central en el desarrollo del cool jazz, modal jazz y jazz fusión.'),
('Johnny Cash', 'Estadounidense', '1950-01-01', 'www.johnnycash.com', 'El Hombre de Negro, ícono del country y rockabilly de Arkansas. Sus grabaciones en la cárcel de Folsom son legendarias.'),
('Beyoncé', 'Estadounidense', '1997-01-01', 'www.beyonce.com', 'Reina del pop y R&B de Houston, Texas. Ganadora de múltiples Grammys y una de las artistas más influyentes del siglo XXI.'),
('Queen', 'Británica', '1970-01-01', 'www.queenonline.com', 'Banda de rock de Londres liderada por Freddie Mercury, conocida por sus óperas de rock y temas como Bohemian Rhapsody.'),
('Foo Fighters', 'Estadounidense', '1994-01-01', 'www.foofighters.com', 'Banda de rock alternativo fundada por Dave Grohl tras Nirvana. Ganadores de 12 Grammys y referencia del rock de estadio moderno.'),
('The Clash', 'Británica', '1976-01-01', 'www.theclash.com', 'Banda de punk rock de Londres que incorporó reggae, ska y rockabilly. Considerados the only band that matters.'),
('Portishead', 'Británica', '1991-01-01', 'www.portishead.co.uk', 'Trío de Bristol pionero del trip-hop, conocido por su atmósfera oscura, samples de cine negro y la voz de Beth Gibbons.'),
('Massive Attack', 'Británica', '1988-01-01', 'www.massiveattack.co.uk', 'Colectivo de Bristol y pioneros absolutos del trip-hop. Su álbum Blue Lines de 1991 definió el género.'),
('Celia Cruz', 'Cubana', '1950-01-01', 'www.celiacruz.com', 'La Reina de la Salsa, nacida en La Habana. Voz inconfundible y presencia escénica que la convirtieron en leyenda de la música latina.'),
('Juan Gabriel', 'Mexicana', '1971-01-01', 'www.juangabriel.com', 'El Divo de Juárez, compositor e intérprete mexicano con más de 1500 canciones. Mezcló ranchera, pop y bolero como nadie más.');

#CLIENTES 
INSERT INTO cilentes (nombre_completo, email, telefono, direccion_envio, fecha_de_registro) VALUES
('Carlos Mendoza Ríos', 'carlos.mendoza@gmail.com', '+52-55-1234-5678', 'Av. Insurgentes 245, CDMX', '2023-01-15 10:30:00'),
('Sofía Hernández López', 'sofia.hernandez@hotmail.com', '+52-33-9876-5432', 'Calle Morelos 12, Guadalajara', '2023-02-03 14:20:00'),
('Alejandro Torres Vega', 'alex.torres@yahoo.com', '+52-81-5555-1234', 'Av. Constitución 890, Monterrey', '2023-02-20 09:15:00'),
('Valentina Castro Ruiz', 'vale.castro@gmail.com', '+52-55-4444-7890', 'Calle Juárez 67, Puebla', '2023-03-05 16:45:00'),
('Diego Ramírez Soto', 'diego.ramirez@outlook.com', '+52-55-2222-3456', 'Blvd. Díaz Ordaz 34, CDMX', '2023-03-18 11:00:00'),
('Isabella Morales Fuentes', 'isabella.morales@gmail.com', '+52-999-333-4567', 'Paseo Montejo 150, Mérida', '2023-04-02 08:30:00'),
('Rodrigo Jiménez Peña', 'rodrigo.jimenez@gmail.com', '+52-222-777-8901', 'Calle 5 de Mayo 78, Puebla', '2023-04-14 13:20:00'),
('Mariana Gómez Ortiz', 'mariana.gomez@hotmail.com', '+52-55-6666-2345', 'Av. Reforma 1200, CDMX', '2023-05-01 17:10:00'),
('Fernando Vargas Luna', 'fernando.vargas@gmail.com', '+52-33-1111-6789', 'Calle López Cotilla 456, Guadalajara', '2023-05-22 10:45:00'),
('Camila Reyes Blanco', 'camila.reyes@yahoo.com', '+52-664-888-9012', 'Av. Revolución 321, Tijuana', '2023-06-08 15:30:00'),
('Sebastián Flores Díaz', 'sebastian.flores@gmail.com', '+52-55-3333-4567', 'Calle Madero 89, CDMX', '2023-06-25 09:00:00'),
('Lucía Martínez Ramos', 'lucia.martinez@outlook.com', '+52-81-4444-5678', 'Av. Garza Sada 789, Monterrey', '2023-07-10 14:15:00'),
('Andrés Gutiérrez Cruz', 'andres.gutierrez@gmail.com', '+52-55-8888-9012', 'Insurgentes Sur 567, CDMX', '2023-07-28 11:30:00'),
('Paula Sánchez Mora', 'paula.sanchez@hotmail.com', '+52-33-5555-6789', 'Av. Vallarta 234, Guadalajara', '2023-08-12 16:00:00'),
('Mateo Pérez Aguilar', 'mateo.perez@gmail.com', '+52-444-222-3456', 'Calle Allende 11, San Luis Potosí', '2023-08-30 08:45:00'),
('Natalia López Serrano', 'natalia.lopez@gmail.com', '+52-55-7777-1234', 'Av. Universidad 890, CDMX', '2023-09-14 13:00:00'),
('Javier Romero Ibáñez', 'javier.romero@yahoo.com', '+52-229-666-7890', 'Blvd. Ávila Camacho 45, Veracruz', '2023-09-28 10:20:00'),
('Andrea Núñez Campos', 'andrea.nunez@gmail.com', '+52-55-9999-3456', 'Calle Hidalgo 234, CDMX', '2023-10-15 15:45:00'),
('Miguel Ángel Delgado', 'miguelangel.delgado@outlook.com', '+52-614-333-4567', 'Av. Juárez 678, Chihuahua', '2023-10-30 09:30:00'),
('Renata Vázquez Mora', 'renata.vazquez@gmail.com', '+52-33-2222-7890', 'Calle Independencia 90, Guadalajara', '2023-11-12 14:00:00'),
('Luis Antonio Cervantes', 'luis.cervantes@hotmail.com', '+52-55-1111-8901', 'Av. Polanco 456, CDMX', '2023-11-25 11:15:00'),
('Daniela Espinoza Ríos', 'daniela.espinoza@gmail.com', '+52-81-6666-2345', 'Calle Degollado 123, Monterrey', '2023-12-08 16:30:00'),
('Pablo Moreno Leal', 'pablo.moreno@yahoo.com', '+52-55-4444-5678', 'Insurgentes Norte 789, CDMX', '2023-12-20 08:00:00'),
('Gabriela Olvera Pinto', 'gabriela.olvera@gmail.com', '+52-222-888-9012', 'Calle 16 de Septiembre 34, Puebla', '2024-01-05 13:45:00'),
('Roberto Salinas Vega', 'roberto.salinas@outlook.com', '+52-33-3333-1234', 'Av. Chapultepec 567, Guadalajara', '2024-01-18 10:00:00'),
('Valeria Mendez Torres', 'valeria.mendez@gmail.com', '+52-55-2222-9012', 'Calle Venustiano Carranza 78, CDMX', '2024-02-01 15:20:00'),
('Eduardo Herrera Blanco', 'eduardo.herrera@hotmail.com', '+52-998-444-5678', 'Av. Tulum 234, Cancún', '2024-02-14 09:45:00'),
('Mónica Aguilar Fuentes', 'monica.aguilar@gmail.com', '+52-55-5555-3456', 'Blvd. Miguel de Cervantes 890, CDMX', '2024-02-28 14:30:00'),
('Héctor Villanueva Cruz', 'hector.villanueva@yahoo.com', '+52-33-7777-4567', 'Calle Pedro Moreno 12, Guadalajara', '2024-03-10 11:00:00'),
('Ximena Rojas Serrano', 'ximena.rojas@gmail.com', '+52-55-3333-7890', 'Av. Ejército Nacional 345, CDMX', '2024-03-22 16:15:00');

#SUCURSALES

INSERT INTO sucursales (nombre_sucursal, direccion, telefono_sucursal, horario_sucursal) VALUES
('Sucursal CDMX Centro', 'Av. Madero 145, Col. Centro, CDMX', '+52-55-1000-2000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-18:00'),
('Sucursal CDMX Polanco', 'Av. Presidente Masaryk 256, Polanco, CDMX', '+52-55-1000-3000', 'Lunes a Sábado 10:00-21:00, Domingo 11:00-19:00'),
('Sucursal Guadalajara Centro', 'Av. Juárez 340, Col. Centro, Guadalajara', '+52-33-2000-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Guadalajara Zapopan', 'Blvd. Puerta de Hierro 1200, Zapopan', '+52-33-2000-2000', 'Lunes a Sábado 10:00-21:00, Domingo 11:00-18:00'),
('Sucursal Monterrey Centro', 'Calle Morelos 789, Col. Centro, Monterrey', '+52-81-3000-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Monterrey San Pedro', 'Av. Vasconcelos 456, San Pedro Garza García', '+52-81-3000-2000', 'Lunes a Sábado 10:00-21:00, Domingo 11:00-19:00'),
('Sucursal Puebla', 'Blvd. Atlixco 234, Col. Anzures, Puebla', '+52-222-4000-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-17:00'),
('Sucursal Tijuana', 'Av. Revolución 567, Zona Centro, Tijuana', '+52-664-5000-1000', 'Lunes a Sábado 10:00-21:00, Domingo 11:00-18:00'),
('Sucursal Mérida', 'Calle 60 #450, Col. Centro, Mérida', '+52-999-6000-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Cancún', 'Av. Tulum 890, Sm 20, Cancún', '+52-998-7000-1000', 'Lunes a Domingo 10:00-22:00'),
('Sucursal Querétaro', 'Av. Constituyentes 123, Col. Cimatario, Querétaro', '+52-442-8000-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal León', 'Blvd. Adolfo López Mateos 345, León, Gto.', '+52-477-9000-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Veracruz', 'Av. Díaz Mirón 678, Col. Centro, Veracruz', '+52-229-1100-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal San Luis Potosí', 'Calle Álvaro Obregón 234, Centro, SLP', '+52-444-1200-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Chihuahua', 'Av. Tecnológico 789, Col. San Felipe, Chihuahua', '+52-614-1300-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Hermosillo', 'Blvd. Solidaridad 456, Col. Bugambilias, Hermosillo', '+52-662-1400-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Oaxaca', 'Calle García Vigil 123, Col. Centro, Oaxaca', '+52-951-1500-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-15:00'),
('Sucursal Acapulco', 'Av. Costera M. Alemán 567, Acapulco', '+52-744-1600-1000', 'Lunes a Domingo 10:00-21:00'),
('Sucursal Culiacán', 'Blvd. Zapata 890, Col. Chapultepec, Culiacán', '+52-667-1700-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Toluca', 'Paseo Tollocan 234, Col. Universidad, Toluca', '+52-722-1800-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Aguascalientes', 'Av. López Mateos 456, Fracc. Del Prado, Ags.', '+52-449-1900-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Morelia', 'Av. Madero Poniente 678, Col. Centro, Morelia', '+52-443-2000-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Saltillo', 'Blvd. Fundadores 123, Col. Los Pinos, Saltillo', '+52-844-2100-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Mexicali', 'Calzada Justo Sierra 345, Col. Nueva, Mexicali', '+52-686-2200-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Tuxtla Gutiérrez', 'Blvd. Belisario Domínguez 789, Tuxtla Gtz.', '+52-961-2300-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Tepic', 'Av. México 234, Fracc. Los Fresnos, Tepic', '+52-311-2400-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Durango', 'Av. 20 de Noviembre 567, Col. Centro, Durango', '+52-618-2500-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-16:00'),
('Sucursal Villahermosa', 'Blvd. Grijalva 890, Col. Atasta, Villahermosa', '+52-993-2600-1000', 'Lunes a Sábado 9:00-20:00, Domingo 10:00-17:00'),
('Sucursal Mazatlán', 'Av. del Mar 123, Zona Dorada, Mazatlán', '+52-669-2700-1000', 'Lunes a Domingo 10:00-22:00'),
('Sucursal Zacatecas', 'Av. López Velarde 456, Col. Centro, Zacatecas', '+52-492-2800-1000', 'Lunes a Sábado 9:00-19:00, Domingo 10:00-15:00');

#PROVEEDORES

INSERT INTO proveedores (nombre_provedor, contacto_nombre, telefono, email_provedor) VALUES
('Universal Music México', 'Jorge Castañeda', '+52-55-5001-1000', 'jcastaneda@universalmusic.com.mx'),
('Sony Music México', 'Laura Benítez', '+52-55-5002-2000', 'lbenitez@sonymusic.com.mx'),
('Warner Music México', 'Tomás Ríos', '+52-55-5003-3000', 'trios@warnermusic.com.mx'),
('EMI Music México', 'Patricia Lozano', '+52-55-5004-4000', 'plozano@emimusic.com.mx'),
('BMG México', 'Ernesto Fuentes', '+52-55-5005-5000', 'efuentes@bmg.com.mx'),
('Discos Américas', 'Claudia Varela', '+52-55-5006-6000', 'cvarela@discosamericas.com.mx'),
('Importaciones Vinyl Pro', 'Ramón Guzmán', '+52-33-6001-1000', 'rguzmán@vinylpro.com.mx'),
('CD Express Internacional', 'Norma Salazar', '+52-33-6002-2000', 'nsalazar@cdexpress.com'),
('MusicDist Latinoamérica', 'Ignacio Blanco', '+52-81-7001-1000', 'iblanco@musicdist.com'),
('VinylWorld Distribuciones', 'Sandra Torres', '+52-55-5010-0000', 'storres@vinylworld.com.mx'),
('Cassette Revival México', 'Héctor Mendoza', '+52-55-5011-1000', 'hmendoza@cassetterevival.mx'),
('Global Records Supply', 'Amanda Pierce', '+1-212-555-0101', 'apierce@globalrecords.com'),
('European Vinyl Imports', 'Klaus Weber', '+49-30-555-0202', 'kweber@europeanvinyl.de'),
('Japan Music Export', 'Kenji Tanaka', '+81-3-555-0303', 'ktanaka@japanmusic.jp'),
('UK Record Distributors', 'James Harrington', '+44-20-555-0404', 'jharrington@ukrecords.co.uk'),
('Latin Sound Distributors', 'María Contreras', '+52-55-5016-6000', 'mcontreras@latinsound.com'),
('Indie Label Supply', 'Pablo Guerrero', '+52-33-6005-5000', 'pguerrero@indielabelsupply.com'),
('Audio Format México', 'Cecilia Ríos', '+52-81-7005-5000', 'crios@audioformat.com.mx'),
('Distribuidora Musical Norte', 'Arturo Serna', '+52-81-7006-6000', 'aserna@musicalnorte.com'),
('Fonoteca Distribuciones', 'Elena Castro', '+52-55-5020-0000', 'ecastro@fonoteca.com.mx'),
('Record Factory MX', 'Sergio Peñaloza', '+52-55-5021-1000', 'spenaloza@recordfactory.mx'),
('Sonido Sur Distribuciones', 'Lorena Aguilar', '+52-33-6008-8000', 'laguilar@sonidosur.com'),
('Multimedia Imports SA', 'Fernando Vega', '+52-55-5023-3000', 'fvega@multimediaimports.com.mx'),
('Beats & Vinyl Co.', 'Diana Molina', '+52-55-5024-4000', 'dmolina@beatsandvinyl.com.mx'),
('Rhino Records Supply', 'Kevin Johnson', '+1-310-555-0505', 'kjohnson@rhinosupply.com'),
('Concord Music México', 'Rebeca Sandoval', '+52-55-5026-6000', 'rsandoval@concordmusic.com.mx'),
('Discos Internacionales SA', 'Manuel Reyes', '+52-33-6010-0000', 'mreyes@discosint.com.mx'),
('Pacific Music Imports', 'Yuki Nakamura', '+81-6-555-0606', 'ynakamura@pacificmusic.jp'),
('Analog Sound México', 'Gustavo Paredes', '+52-55-5029-9000', 'gparedes@analogsound.mx'),
('Digital & Physical Dist.', 'Adriana López', '+52-55-5030-0000', 'alopez@dpdist.com.mx');

#METODOS DE PAGO

INSERT INTO metodos_pago (tipo, proveedor, comison, moneda, estado_activo) VALUES
('credito', 'Visa', 2.50, 'MXN', TRUE),
('credito', 'Mastercard', 2.50, 'MXN', TRUE),
('credito', 'American Express', 3.50, 'MXN', TRUE),
('debito', 'Visa Débito', 1.50, 'MXN', TRUE),
('debito', 'Mastercard Débito', 1.50, 'MXN', TRUE),
('efectivo', 'Efectivo en tienda', 0.00, 'MXN', TRUE),
('efectivo', 'OXXO Pay', 1.00, 'MXN', TRUE),
('credito', 'Visa', 2.50, 'USD', TRUE),
('credito', 'Mastercard', 2.50, 'USD', TRUE),
('debito', 'PayPal', 2.90, 'USD', TRUE),
('credito', 'American Express', 3.50, 'USD', TRUE),
('debito', 'PayPal', 2.90, 'MXN', TRUE),
('credito', 'Visa', 2.50, 'EUR', TRUE),
('credito', 'Mastercard', 2.50, 'EUR', TRUE),
('debito', 'PayPal', 2.90, 'EUR', TRUE),
('credito', 'Visa', 2.50, 'GBP', TRUE),
('credito', 'Mastercard', 2.50, 'GBP', TRUE),
('debito', 'Visa Débito', 1.50, 'USD', TRUE),
('efectivo', 'Efectivo en tienda', 0.00, 'USD', FALSE),
('credito', 'Banamex Citibank', 2.80, 'MXN', TRUE),
('debito', 'BBVA Débito', 1.20, 'MXN', TRUE),
('credito', 'BBVA Crédito', 2.60, 'MXN', TRUE),
('debito', 'Santander Débito', 1.30, 'MXN', TRUE),
('credito', 'Santander Crédito', 2.70, 'MXN', TRUE),
('credito', 'HSBC Crédito', 2.80, 'MXN', TRUE),
('debito', 'HSBC Débito', 1.40, 'MXN', TRUE),
('efectivo', 'Transferencia SPEI', 0.50, 'MXN', TRUE),
('debito', 'Stripe', 2.90, 'USD', TRUE),
('debito', 'Stripe', 2.90, 'MXN', TRUE),
('credito', 'Clip', 2.40, 'MXN', TRUE);

#USUARIOS ADMIN 
INSERT INTO usuarios_admin (nombre_usuario, email_admin, contraseña_admin, rol_admin, fecha_creacion) VALUES
('superadmin', 'superadmin@tiendadiscos.com', 'Admin123', 'Super Administrador', '2022-06-01 09:00:00'),
('admin_cdmx', 'admin.cdmx@tiendadiscos.com', 'Cdmx2022', 'Administrador Regional', '2022-06-01 09:30:00'),
('admin_gdl', 'admin.gdl@tiendadiscos.com', 'Gdl2022', 'Administrador Regional', '2022-06-01 10:00:00'),
('admin_mty', 'admin.mty@tiendadiscos.com', 'Mty2022', 'Administrador Regional', '2022-06-01 10:30:00'),
('gerente_ventas', 'gerente.ventas@tiendadiscos.com', 'Ventas01', 'Gerente de Ventas', '2022-06-15 09:00:00'),
('gerente_inventario', 'gerente.inventario@tiendadiscos.com', 'Inv2022', 'Gerente de Inventario', '2022-06-15 09:30:00'),
('editor_catalogo', 'editor.catalogo@tiendadiscos.com', 'Catalogo1', 'Editor de Catálogo', '2022-07-01 10:00:00'),
('soporte_cliente1', 'soporte1@tiendadiscos.com', 'Sop0rt1', 'Soporte al Cliente', '2022-07-01 10:30:00'),
('soporte_cliente2', 'soporte2@tiendadiscos.com', 'Sop0rt2', 'Soporte al Cliente', '2022-07-15 09:00:00'),
('analista_datos', 'analista@tiendadiscos.com', 'Datos22', 'Analista de Datos', '2022-08-01 09:00:00'),
('admin_envios', 'admin.envios@tiendadiscos.com', 'Envios1', 'Administrador de Envíos', '2022-08-15 09:30:00'),
('editor_promo', 'editor.promo@tiendadiscos.com', 'Promo22', 'Editor de Promociones', '2022-09-01 10:00:00'),
('caja_cdmx1', 'caja.cdmx1@tiendadiscos.com', 'Caja001', 'Cajero', '2022-09-15 09:00:00'),
('caja_gdl1', 'caja.gdl1@tiendadiscos.com', 'Caja002', 'Cajero', '2022-09-15 09:30:00'),
('caja_mty1', 'caja.mty1@tiendadiscos.com', 'Caja003', 'Cajero', '2022-09-15 10:00:00'),
('bodega_central', 'bodega@tiendadiscos.com', 'Bodega1', 'Encargado de Bodega', '2022-10-01 09:00:00'),
('mktg_digital', 'marketing@tiendadiscos.com', 'Mktg22', 'Marketing Digital', '2022-10-15 09:30:00'),
('compras_admin', 'compras@tiendadiscos.com', 'Compras1', 'Encargado de Compras', '2022-11-01 10:00:00'),
('rrhh_admin', 'rrhh@tiendadiscos.com', 'Rrhh22', 'Recursos Humanos', '2022-11-15 09:00:00'),
('finanzas_admin', 'finanzas@tiendadiscos.com', 'Fin2022', 'Finanzas', '2022-12-01 09:30:00'),
('sistemas_admin', 'sistemas@tiendadiscos.com', 'Sist22', 'Administrador de Sistemas', '2023-01-10 09:00:00'),
('audit_admin', 'auditoria@tiendadiscos.com', 'Audit22', 'Auditoría', '2023-02-01 10:00:00'),
('coord_sucursales', 'coord.sucursales@tiendadiscos.com', 'Coord22', 'Coordinador de Sucursales', '2023-03-01 09:30:00'),
('admin_web', 'admin.web@tiendadiscos.com', 'Web2023', 'Administrador Web', '2023-04-01 10:00:00'),
('editor_redes', 'redes.sociales@tiendadiscos.com', 'Redes23', 'Editor Redes Sociales', '2023-05-01 09:00:00'),
('logistica_jefe', 'logistica@tiendadiscos.com', 'Log2023', 'Jefe de Logística', '2023-06-01 09:30:00'),
('caja_pue1', 'caja.pue1@tiendadiscos.com', 'Caja004', 'Cajero', '2023-07-01 10:00:00'),
('caja_can1', 'caja.can1@tiendadiscos.com', 'Caja005', 'Cajero', '2023-08-01 10:30:00'),
('soporte_int', 'soporte.intl@tiendadiscos.com', 'Intl23', 'Soporte Internacional', '2023-09-01 09:00:00'),
('admin_restock', 'admin.restock@tiendadiscos.com', 'Rest23', 'Administrador de Restock', '2023-10-01 09:30:00');

#Aca empiezan las tablas con una llave foranea, estas dependen de las de arriba soo por eso el orden, por cierto sorry si mis notas aveces son confusas, 
#anoto para que no se me olvide el orden de como debo de poner las cosas 

#PRODUCTOS

INSERT INTO productos (titulo_album, id_artista, id_genero, precio_venta, formato) VALUES
-- The Beatles (id_artista=1, Rock Clásico=1)
('Abbey Road', 1, 1, 450.00, 'Vinilo'),
('Sgt. Peppers Lonely Hearts Club Band', 1, 1, 480.00, 'Vinilo'),
('Revolver', 1, 1, 420.00, 'Vinilo'),
-- Pink Floyd (id_artista=2, Progressive Rock=25)
('The Dark Side of the Moon', 2, 25, 520.00, 'Vinilo'),
('The Wall', 2, 25, 580.00, 'Vinilo'),
('Wish You Were Here', 2, 25, 490.00, 'Vinilo'),
-- Michael Jackson (id_artista=3, Pop=3)
('Thriller', 3, 3, 350.00, 'CD'),
('Bad', 3, 3, 300.00, 'CD'),
('Off the Wall', 3, 3, 320.00, 'Vinilo'),
-- Led Zeppelin (id_artista=4, Rock Clásico=1)
('Led Zeppelin IV', 4, 1, 500.00, 'Vinilo'),
('Physical Graffiti', 4, 1, 560.00, 'Vinilo'),
-- Bob Marley (id_artista=5, Reggae=12)
('Legend', 5, 12, 380.00, 'CD'),
('Exodus', 5, 12, 420.00, 'Vinilo'),
-- Nirvana (id_artista=6, Grunge=16)
('Nevermind', 6, 16, 390.00, 'Vinilo'),
('In Utero', 6, 16, 370.00, 'Vinilo'),
-- Metallica (id_artista=7, Heavy Metal=2)
('Metallica (The Black Album)', 7, 2, 430.00, 'Vinilo'),
('Master of Puppets', 7, 2, 450.00, 'Vinilo'),
-- Madonna (id_artista=8, Pop=3)
('Like a Prayer', 8, 3, 310.00, 'CD'),
('Ray of Light', 8, 3, 295.00, 'CD'),
-- David Bowie (id_artista=9, Rock Clásico=1)
('The Rise and Fall of Ziggy Stardust', 9, 1, 480.00, 'Vinilo'),
('Heroes', 9, 1, 460.00, 'Vinilo'),
-- Prince (id_artista=10, Funk=17)
('Purple Rain', 10, 17, 470.00, 'Vinilo'),
('Sign O the Times', 10, 17, 490.00, 'Vinilo'),
-- Amy Winehouse (id_artista=11, Soul=11)
('Back to Black', 11, 11, 400.00, 'Vinilo'),
('Frank', 11, 11, 360.00, 'CD'),
-- Daft Punk (id_artista=12, Electrónica=8)
('Random Access Memories', 12, 8, 550.00, 'Vinilo'),
('Discovery', 12, 8, 480.00, 'Vinilo'),
-- Radiohead (id_artista=13, Indie Rock=10)
('OK Computer', 13, 10, 460.00, 'Vinilo'),
('Kid A', 13, 10, 440.00, 'Vinilo'),
-- Kendrick Lamar (id_artista=14, Hip-Hop=6)
('To Pimp a Butterfly', 14, 6, 420.00, 'Vinilo'),
-- Adele (id_artista=15, Soul=11)
('21', 15, 11, 280.00, 'CD'),
('25', 15, 11, 290.00, 'CD'),
-- Red Hot Chili Peppers (id_artista=16, Rock Clásico=1)
('Blood Sugar Sex Magik', 16, 1, 430.00, 'Vinilo'),
('Californication', 16, 1, 410.00, 'CD'),
-- The Rolling Stones (id_artista=17, Rock Clásico=1)
('Exile on Main St.', 17, 1, 510.00, 'Vinilo'),
('Sticky Fingers', 17, 1, 490.00, 'Vinilo'),
-- Soda Stereo (id_artista=18, Rock en Español=22)
('Dynamo', 18, 22, 440.00, 'Vinilo'),
('Doble Vida', 18, 22, 400.00, 'CD'),
-- Café Tacvba (id_artista=19, Rock en Español=22)
('Re', 19, 22, 390.00, 'CD'),
('Cuatro Caminos', 19, 22, 370.00, 'CD'),
-- Shakira (id_artista=20, Latin Pop=29)
('Laundry Service', 20, 29, 260.00, 'CD'),
('She Wolf', 20, 29, 240.00, 'CD'),
-- Miles Davis (id_artista=21, Jazz=4)
('Kind of Blue', 21, 4, 480.00, 'Vinilo'),
('Bitches Brew', 21, 4, 500.00, 'Vinilo'),
-- Johnny Cash (id_artista=22, Country=13)
('At Folsom Prison', 22, 13, 420.00, 'Vinilo'),
('American IV: The Man Comes Around', 22, 13, 390.00, 'CD'),
-- Beyoncé (id_artista=23, R&B=7)
('Lemonade', 23, 7, 470.00, 'Vinilo'),
('Dangerously in Love', 23, 7, 300.00, 'CD'),
-- Queen (id_artista=24, Rock Clásico=1)
('A Night at the Opera', 24, 1, 500.00, 'Vinilo'),
('News of the World', 24, 1, 470.00, 'Vinilo'),
-- Foo Fighters (id_artista=25, Rock Clásico=1)
('The Colour and the Shape', 25, 1, 400.00, 'CD'),
-- The Clash (id_artista=26, Punk=9)
('London Calling', 26, 9, 460.00, 'Vinilo'),
-- Portishead (id_artista=27, Electrónica=8)
('Dummy', 27, 8, 430.00, 'Vinilo'),
-- Massive Attack (id_artista=28, Electrónica=8)
('Mezzanine', 28, 8, 450.00, 'Vinilo'),
-- Celia Cruz (id_artista=29, Salsa=21)
('La Negra Tiene Tumbao', 29, 21, 340.00, 'CD'),
-- Juan Gabriel (id_artista=30, Bolero=23)
('El Noa Noa', 30, 23, 320.00, 'CD'),
('Recuerdos Vol. I', 30, 23, 350.00, 'CD'); 

#dirección de clientes
INSERT INTO direccion_cliente (id_cliente, calle_numero, colonia, codigo_postal, ciudad_estado) VALUES
(1, 'Av. Insurgentes 245', 'Col. Roma Norte', '06700', 'Ciudad de México'),
(2, 'Calle Morelos 12', 'Col. Centro', '44100', 'Guadalajara, Jalisco'),
(3, 'Av. Constitución 890', 'Col. Centro', '64000', 'Monterrey, Nuevo León'),
(4, 'Calle Juárez 67', 'Col. Centro', '72000', 'Puebla, Puebla'),
(5, 'Blvd. Díaz Ordaz 34', 'Col. Polanco', '11550', 'Ciudad de México'),
(6, 'Paseo Montejo 150', 'Col. Centro', '97000', 'Mérida, Yucatán'),
(7, 'Calle 5 de Mayo 78', 'Col. Centro', '72000', 'Puebla, Puebla'),
(8, 'Av. Reforma 1200', 'Col. Juárez', '06600', 'Ciudad de México'),
(9, 'Calle López Cotilla 456', 'Col. Americana', '44160', 'Guadalajara, Jalisco'),
(10, 'Av. Revolución 321', 'Zona Centro', '22000', 'Tijuana, Baja California'),
(11, 'Calle Madero 89', 'Col. Centro', '06000', 'Ciudad de México'),
(12, 'Av. Garza Sada 789', 'Col. Tecnológico', '64849', 'Monterrey, Nuevo León'),
(13, 'Insurgentes Sur 567', 'Col. Del Valle', '03100', 'Ciudad de México'),
(14, 'Av. Vallarta 234', 'Col. Americana', '44100', 'Guadalajara, Jalisco'),
(15, 'Calle Allende 11', 'Col. Centro', '78000', 'San Luis Potosí, SLP'),
(16, 'Av. Universidad 890', 'Col. Copilco', '04360', 'Ciudad de México'),
(17, 'Blvd. Ávila Camacho 45', 'Col. Centro', '91700', 'Veracruz, Veracruz'),
(18, 'Calle Hidalgo 234', 'Col. Centro', '06300', 'Ciudad de México'),
(19, 'Av. Juárez 678', 'Col. Centro', '31000', 'Chihuahua, Chihuahua'),
(20, 'Calle Independencia 90', 'Col. Centro', '44100', 'Guadalajara, Jalisco'),
(21, 'Av. Polanco 456', 'Col. Polanco V Sección', '11560', 'Ciudad de México'),
(22, 'Calle Degollado 123', 'Col. Centro', '64000', 'Monterrey, Nuevo León'),
(23, 'Insurgentes Norte 789', 'Col. Lindavista', '07300', 'Ciudad de México'),
(24, 'Calle 16 de Septiembre 34', 'Col. Centro', '72000', 'Puebla, Puebla'),
(25, 'Av. Chapultepec 567', 'Col. Americana', '44160', 'Guadalajara, Jalisco'),
(26, 'Calle Venustiano Carranza 78', 'Col. Centro', '06010', 'Ciudad de México'),
(27, 'Av. Tulum 234', 'Sm 20', '77500', 'Cancún, Quintana Roo'),
(28, 'Blvd. Miguel de Cervantes 890', 'Col. Polanco', '11560', 'Ciudad de México'),
(29, 'Calle Pedro Moreno 12', 'Col. Americana', '44100', 'Guadalajara, Jalisco'),
(30, 'Av. Ejército Nacional 345', 'Col. Granada', '11520', 'Ciudad de México');

#aca las tablas que tienen más de una llave 
#Inventario 
INSERT INTO inventario (id_producto, id_sucursal, cantidad_stock, pasillo, estante) VALUES
(1, 1, 15, 'A', 'E1'),
(2, 1, 10, 'A', 'E1'),
(3, 1, 8, 'A', 'E1'),
(4, 2, 12, 'B', 'E2'),
(5, 2, 7, 'B', 'E2'),
(6, 2, 9, 'B', 'E2'),
(7, 3, 20, 'C', 'E3'),
(8, 3, 18, 'C', 'E3'),
(9, 3, 5, 'C', 'E4'),
(10, 4, 11, 'A', 'E2'),
(11, 4, 6, 'A', 'E2'),
(12, 5, 25, 'D', 'E1'),
(13, 5, 14, 'D', 'E1'),
(14, 6, 13, 'A', 'E3'),
(15, 6, 9, 'A', 'E3'),
(16, 7, 8, 'B', 'E1'),
(17, 7, 10, 'B', 'E1'),
(18, 8, 22, 'C', 'E2'),
(19, 8, 17, 'C', 'E2'),
(20, 9, 7, 'A', 'E4'),
(21, 9, 6, 'A', 'E4'),
(22, 10, 12, 'D', 'E2'),
(23, 10, 9, 'D', 'E2'),
(24, 1, 11, 'B', 'E3'),
(25, 1, 8, 'B', 'E3'),
(26, 2, 6, 'C', 'E1'),
(27, 2, 10, 'C', 'E1'),
(28, 3, 9, 'D', 'E3'),
(29, 3, 7, 'D', 'E3'),
(30, 4, 14, 'A', 'E1'),
(31, 4, 11, 'A', 'E1'),
(32, 5, 8, 'B', 'E4'),
(33, 5, 9, 'B', 'E4'),
(34, 6, 16, 'C', 'E3'),
(35, 6, 12, 'C', 'E3'),
(36, 7, 10, 'D', 'E1'),
(37, 7, 8, 'D', 'E1'),
(38, 8, 7, 'A', 'E2'),
(39, 8, 11, 'A', 'E2'),
(40, 9, 13, 'B', 'E1'),
(41, 9, 9, 'B', 'E1'),
(42, 10, 6, 'C', 'E4'),
(43, 10, 8, 'C', 'E4'),
(44, 1, 10, 'D', 'E2'),
(45, 1, 7, 'D', 'E2'),
(46, 2, 12, 'A', 'E3'),
(47, 2, 9, 'A', 'E3'),
(48, 3, 5, 'B', 'E2'),
(49, 3, 14, 'B', 'E2'),
(50, 4, 10, 'C', 'E1'),
(51, 4, 8, 'C', 'E1'),
(52, 5, 11, 'D', 'E3'),
(53, 5, 7, 'D', 'E3'),
(54, 6, 9, 'A', 'E1'),
(55, 6, 6, 'A', 'E1'),
(56, 7, 13, 'B', 'E3'),
(57, 7, 10, 'B', 'E3');

#restock
INSERT INTO restock (id_producto, id_provedor, cantidad_recibida, costo_unitario, fecha_solicitud, fecha_recepcion, fecha_restock) VALUES
(1, 1, 20, 200.00, '2023-10-01', '2023-10-08', 'Octubre 2023'),
(2, 1, 15, 210.00, '2023-10-01', '2023-10-08', 'Octubre 2023'),
(3, 1, 15, 190.00, '2023-10-05', '2023-10-12', 'Octubre 2023'),
(4, 2, 18, 230.00, '2023-10-10', '2023-10-17', 'Octubre 2023'),
(5, 2, 12, 250.00, '2023-10-10', '2023-10-17', 'Octubre 2023'),
(7, 3, 30, 140.00, '2023-10-15', '2023-10-20', 'Octubre 2023'),
(8, 3, 25, 130.00, '2023-10-15', '2023-10-20', 'Octubre 2023'),
(10, 4, 20, 220.00, '2023-11-01', '2023-11-08', 'Noviembre 2023'),
(11, 4, 10, 245.00, '2023-11-01', '2023-11-08', 'Noviembre 2023'),
(12, 5, 35, 165.00, '2023-11-05', '2023-11-12', 'Noviembre 2023'),
(14, 7, 22, 175.00, '2023-11-10', '2023-11-20', 'Noviembre 2023'),
(16, 6, 15, 195.00, '2023-11-15', '2023-11-22', 'Noviembre 2023'),
(17, 6, 18, 200.00, '2023-11-15', '2023-11-22', 'Noviembre 2023'),
(18, 3, 28, 125.00, '2023-12-01', '2023-12-08', 'Diciembre 2023'),
(20, 1, 12, 215.00, '2023-12-05', '2023-12-12', 'Diciembre 2023'),
(22, 8, 20, 170.00, '2023-12-10', '2023-12-17', 'Diciembre 2023'),
(24, 2, 18, 180.00, '2023-12-15', '2023-12-22', 'Diciembre 2023'),
(26, 9, 10, 245.00, '2024-01-05', '2024-01-14', 'Enero 2024'),
(27, 9, 15, 215.00, '2024-01-05', '2024-01-14', 'Enero 2024'),
(28, 10, 16, 205.00, '2024-01-10', '2024-01-18', 'Enero 2024'),
(30, 5, 22, 185.00, '2024-01-15', '2024-01-22', 'Enero 2024'),
(32, 3, 25, 120.00, '2024-02-01', '2024-02-08', 'Febrero 2024'),
(34, 7, 14, 225.00, '2024-02-05', '2024-02-14', 'Febrero 2024'),
(36, 1, 18, 195.00, '2024-02-10', '2024-02-18', 'Febrero 2024'),
(38, 4, 12, 195.00, '2024-02-15', '2024-02-22', 'Febrero 2024'),
(40, 2, 16, 185.00, '2024-03-01', '2024-03-08', 'Marzo 2024'),
(42, 6, 20, 145.00, '2024-03-05', '2024-03-12', 'Marzo 2024'),
(44, 8, 15, 195.00, '2024-03-10', '2024-03-18', 'Marzo 2024'),
(46, 10, 18, 210.00, '2024-03-15', '2024-03-22', 'Marzo 2024'),
(50, 3, 22, 155.00, '2024-04-01', '2024-04-09', 'Abril 2024');

#orden
INSERT INTO ordenes (id_cliente, id_direccion, fecha_orden, estado_orden, total_bruto) VALUES
(1, 1, '2024-01-10 11:30:00', 'entregada', 900.00),
(2, 2, '2024-01-12 14:00:00', 'entregada', 420.00),
(3, 3, '2024-01-15 09:45:00', 'entregada', 850.00),
(4, 4, '2024-01-18 16:20:00', 'entregada', 380.00),
(5, 5, '2024-01-22 10:00:00', 'entregada', 1000.00),
(6, 6, '2024-01-25 13:30:00', 'entregada', 460.00),
(7, 7, '2024-02-01 11:00:00', 'entregada', 390.00),
(8, 8, '2024-02-05 15:45:00', 'entregada', 760.00),
(9, 9, '2024-02-08 09:15:00', 'entregada', 480.00),
(10, 10, '2024-02-12 14:30:00', 'entregada', 820.00),
(11, 11, '2024-02-18 11:20:00', 'entregada', 400.00),
(12, 12, '2024-02-22 16:00:00', 'entregada', 550.00),
(13, 13, '2024-03-01 10:30:00', 'entregada', 470.00),
(14, 14, '2024-03-05 13:00:00', 'entregada', 310.00),
(15, 15, '2024-03-10 09:00:00', 'entregada', 750.00),
(16, 16, '2024-03-15 15:30:00', 'entregada', 430.00),
(17, 17, '2024-03-20 11:45:00', 'entregada', 890.00),
(18, 18, '2024-03-25 14:15:00', 'entregada', 420.00),
(19, 19, '2024-04-01 10:00:00', 'entregada', 480.00),
(20, 20, '2024-04-05 12:30:00', 'enviada', 960.00),
(21, 21, '2024-04-08 09:45:00', 'enviada', 310.00),
(22, 22, '2024-04-12 16:00:00', 'enviada', 430.00),
(23, 23, '2024-04-15 11:30:00', 'en proceso', 460.00),
(24, 24, '2024-04-18 14:00:00', 'en proceso', 390.00),
(25, 25, '2024-04-20 10:15:00', 'en proceso', 520.00),
(26, 26, '2024-04-22 13:45:00', 'pendiente', 470.00),
(27, 27, '2024-04-24 09:30:00', 'pendiente', 550.00),
(28, 28, '2024-04-26 15:00:00', 'pendiente', 290.00),
(29, 29, '2024-04-28 11:00:00', 'cancelada', 480.00),
(30, 30, '2024-04-30 14:30:00', 'cancelada', 350.00);

#carrito 
INSERT INTO carrito (id_cliente, id_producto, cantidad) VALUES
(1, 4, 1),
(1, 26, 1),
(2, 14, 1),
(2, 28, 1),
(3, 22, 1),
(4, 49, 1),
(5, 43, 1),
(6, 7, 1),
(7, 16, 2),
(8, 47, 1),
(9, 35, 1),
(10, 12, 1),
(10, 13, 1),
(11, 54, 1),
(12, 17, 1),
(13, 39, 1),
(14, 18, 1),
(15, 24, 1),
(16, 50, 1),
(17, 37, 1),
(18, 44, 1),
(19, 52, 1),
(20, 1, 1),
(21, 26, 1),
(22, 4, 1),
(23, 27, 1),
(24, 16, 1),
(25, 43, 1),
(26, 5, 1),
(27, 29, 1),
(28, 38, 1),
(29, 47, 1),
(30, 3, 1);

#reseñas
INSERT INTO resenas (id_cliente, id_producto, calificacion, comentario, fecha_resena) VALUES
(1, 1, 5, 'Abbey Road es perfecto. El vinilo suena increíble, llegó en excelente estado y el empaque fue impecable.', '2024-01-18 10:00:00'),
(1, 2, 5, 'Sgt. Peppers en vinilo es una experiencia única. Recomendadísimo para coleccionistas.', '2024-01-18 10:15:00'),
(2, 12, 5, 'Legend de Bob Marley nunca falla. Buen CD, calidad de sonido excelente.', '2024-01-20 14:00:00'),
(3, 16, 5, 'El Black Album de Metallica en vinilo es espectacular. Envío rápido desde la tienda.', '2024-01-22 09:00:00'),
(3, 17, 4, 'Master of Puppets es una obra maestra. Solo le quito una estrella porque tardó un día extra.', '2024-01-22 09:30:00'),
(4, 14, 5, 'Nevermind en vinilo, ¿qué más puedo pedir? Sonido brutal, estado perfecto.', '2024-01-25 16:00:00'),
(5, 4, 5, 'The Dark Side of the Moon es el mejor disco de la historia. El vinilo de esta tienda es de primera.', '2024-01-29 10:00:00'),
(5, 5, 4, 'The Wall llegó con la portada ligeramente doblada pero el disco está perfecto. Buena atención al reportarlo.', '2024-01-29 10:30:00'),
(6, 52, 5, 'London Calling es un disco que todo amante del punk debe tener. Excelente precio.', '2024-02-02 13:00:00'),
(7, 28, 5, 'OK Computer de Radiohead en vinilo es lo máximo. Audio cristalino.', '2024-02-09 11:00:00'),
(8, 26, 5, 'Random Access Memories es una joya de la electrónica moderna. La calidad del vinilo es premium.', '2024-02-12 15:00:00'),
(8, 27, 4, 'Discovery es un clásico. Llegó en buen estado aunque la funda tenía una pequeña raspadura.', '2024-02-12 15:30:00'),
(9, 43, 5, 'Kind of Blue de Miles Davis es el álbum de jazz definitivo. Esta tienda tiene buen precio.', '2024-02-15 09:00:00'),
(10, 10, 5, 'Physical Graffiti de Led Zeppelin en doble vinilo es una experiencia auditiva sin igual.', '2024-02-18 14:00:00'),
(10, 11, 5, 'Led Zeppelin IV es otra obra maestra. Toda la colección que he comprado aquí es auténtica.', '2024-02-18 14:30:00'),
(11, 24, 5, 'Back to Black de Amy Winehouse me llega al alma. Vinilo con sonido cálido y perfecto.', '2024-02-25 11:00:00'),
(12, 22, 5, 'Purple Rain de Prince en vinilo es simplemente mágico. Un tesoro musical.', '2024-02-28 16:00:00'),
(13, 47, 4, 'Lemonade de Beyoncé en vinilo es precioso. Me llegó un día tarde pero bien empacado.', '2024-03-07 10:00:00'),
(14, 18, 3, 'El CD de Like a Prayer está bien pero esperaba mejor sonido. Quizás me falta mejor equipo.', '2024-03-12 13:00:00'),
(15, 49, 5, 'A Night at the Opera de Queen en vinilo es uno de los mejores discos de rock. Impecable.', '2024-03-17 09:00:00'),
(16, 7, 5, 'Thriller es el mejor disco pop de la historia y este CD lo confirma. Sonido increíble.', '2024-03-22 15:00:00'),
(17, 35, 5, 'Exile on Main St. de The Rolling Stones en vinilo suena brutal. Envío internacional rápido.', '2024-03-26 11:00:00'),
(18, 13, 4, 'Exodus de Bob Marley en vinilo muy bien. El reggae suena increíble en formato análogo.', '2024-04-01 14:00:00'),
(19, 44, 5, 'Bitches Brew de Miles Davis es jazz puro y duro. Doble vinilo en perfecto estado.', '2024-04-07 10:00:00'),
(20, 37, 5, 'Dynamo de Soda Stereo es el mejor disco del rock en español. Orgullo latinoamericano.', '2024-04-10 12:00:00'),
(21, 19, 3, 'Ray of Light llegó con el estuche del CD ligeramente dañado. El disco está bien, pero la presentación falló.', '2024-04-14 09:00:00'),
(22, 54, 5, 'Mezzanine de Massive Attack es oscuro y perfecto. El vinilo suena exactamente como debe sonar.', '2024-04-16 16:00:00'),
(25, 53, 5, 'Dummy de Portishead es una obra de arte del trip-hop. El vinilo llegó perfectamente embalado.', '2024-04-24 10:00:00'),
(26, 21, 5, 'Heroes de David Bowie en vinilo es eterno. Vale cada peso. Gran tienda.', '2024-04-26 13:00:00'),
(28, 32, 4, '25 de Adele en CD es muy buen disco. Entrega puntual y empaque correcto.', '2024-04-30 15:00:00');

#historial de ventas
INSERT INTO historial_ventas (id_orden, id_metodo, monto_pago, fecha_pago, folio_confirmacion) VALUES
(1, 1, 900.00, '2024-01-10 11:35:00', 'TXN-20240110-0001'),
(2, 4, 420.00, '2024-01-12 14:05:00', 'TXN-20240112-0002'),
(3, 2, 850.00, '2024-01-15 09:50:00', 'TXN-20240115-0003'),
(4, 6, 380.00, '2024-01-18 16:25:00', 'TXN-20240118-0004'),
(5, 21, 1000.00, '2024-01-22 10:05:00', 'TXN-20240122-0005'),
(6, 10, 460.00, '2024-01-25 13:35:00', 'TXN-20240125-0006'),
(7, 5, 390.00, '2024-02-01 11:05:00', 'TXN-20240201-0007'),
(8, 22, 760.00, '2024-02-05 15:50:00', 'TXN-20240205-0008'),
(9, 12, 480.00, '2024-02-08 09:20:00', 'TXN-20240208-0009'),
(10, 3, 820.00, '2024-02-12 14:35:00', 'TXN-20240212-0010'),
(11, 7, 400.00, '2024-02-18 11:25:00', 'TXN-20240218-0011'),
(12, 1, 550.00, '2024-02-22 16:05:00', 'TXN-20240222-0012'),
(13, 29, 470.00, '2024-03-01 10:35:00', 'TXN-20240301-0013'),
(14, 4, 310.00, '2024-03-05 13:05:00', 'TXN-20240305-0014'),
(15, 23, 750.00, '2024-03-10 09:05:00', 'TXN-20240310-0015'),
(16, 2, 430.00, '2024-03-15 15:35:00', 'TXN-20240315-0016'),
(17, 27, 890.00, '2024-03-20 11:50:00', 'TXN-20240320-0017'),
(18, 6, 420.00, '2024-03-25 14:20:00', 'TXN-20240325-0018'),
(19, 20, 480.00, '2024-04-01 10:05:00', 'TXN-20240401-0019'),
(20, 10, 960.00, '2024-04-05 12:35:00', 'TXN-20240405-0020'),
(21, 1, 310.00, '2024-04-08 09:50:00', 'TXN-20240408-0021'),
(22, 5, 430.00, '2024-04-12 16:05:00', 'TXN-20240412-0022'),
(23, 28, 460.00, '2024-04-15 11:35:00', 'TXN-20240415-0023'),
(24, 4, 390.00, '2024-04-18 14:05:00', 'TXN-20240418-0024'),
(25, 2, 520.00, '2024-04-20 10:20:00', 'TXN-20240420-0025'),
(26, 30, 470.00, '2024-04-22 13:50:00', 'TXN-20240422-0026'),
(27, 8, 550.00, '2024-04-24 09:35:00', 'TXN-20240424-0027'),
(28, 15, 290.00, '2024-04-26 15:05:00', 'TXN-20240426-0028'),
(29, 1, 480.00, '2024-04-28 11:05:00', 'TXN-20240428-0029'),
(30, 13, 350.00, '2024-04-30 14:35:00', 'TXN-20240430-0030');

#detalle orden -> productos qyue tenia esa orden y cuanto costo cada uno de ellos, es diferente de ordenes pues ordenes nos dice quien compro, cuando y el total. 
INSERT INTO detalle_orden (id_orden, id_producto, cantidad, precio_unitario, subtotal) VALUES
-- Orden 1: cliente 1 compra Abbey Road + Sgt. Peppers
(1, 1, 1, 450.00, 450.00),
(1, 2, 1, 480.00, 480.00),
-- Orden 2: cliente 2 compra Legend
(2, 12, 1, 380.00, 380.00),
-- Orden 3: cliente 3 compra Metallica Black Album + Master of Puppets
(3, 16, 1, 430.00, 430.00),
(3, 17, 1, 450.00, 450.00),
-- Orden 4: cliente 4 compra Nevermind
(4, 14, 1, 390.00, 390.00),
-- Orden 5: cliente 5 compra Dark Side of Moon + The Wall
(5, 4, 1, 520.00, 520.00),
(5, 5, 1, 580.00, 580.00),
-- Orden 6: cliente 6 compra London Calling
(6, 52, 1, 460.00, 460.00),
-- Orden 7: cliente 7 compra OK Computer
(7, 28, 1, 460.00, 460.00),
-- Orden 8: cliente 8 compra Random Access Memories + Discovery
(8, 26, 1, 550.00, 550.00),
(8, 27, 1, 480.00, 480.00),
-- Orden 9: cliente 9 compra Kind of Blue
(9, 43, 1, 480.00, 480.00),
-- Orden 10: cliente 10 compra Physical Graffiti + Led Zeppelin IV
(10, 10, 1, 500.00, 500.00),
(10, 11, 1, 560.00, 560.00),
-- Orden 11: cliente 11 compra Back to Black
(11, 24, 1, 400.00, 400.00),
-- Orden 12: cliente 12 compra Purple Rain + Sign O the Times
(12, 22, 1, 470.00, 470.00),
(12, 23, 1, 490.00, 490.00),  -- total 960 ajustado a 550 por promo
-- Orden 13: cliente 13 compra Lemonade
(13, 47, 1, 470.00, 470.00),
-- Orden 14: cliente 14 compra Like a Prayer
(14, 18, 1, 310.00, 310.00),
-- Orden 15: cliente 15 compra A Night at the Opera + News of the World
(15, 49, 1, 500.00, 500.00),
(15, 50, 1, 470.00, 470.00),
-- Orden 16: cliente 16 compra Thriller
(16, 7, 1, 350.00, 350.00),
-- Orden 17: cliente 17 compra Exile on Main St. + Sticky Fingers
(17, 35, 1, 510.00, 510.00),
(17, 36, 1, 490.00, 490.00),
-- Orden 18: cliente 18 compra Exodus
(18, 13, 1, 420.00, 420.00),
-- Orden 19: cliente 19 compra Bitches Brew
(19, 44, 1, 500.00, 500.00),
-- Orden 20: cliente 20 compra Dynamo + Doble Vida
(20, 37, 1, 440.00, 440.00),
(20, 38, 1, 400.00, 400.00),
-- Orden 21: cliente 21 compra Ray of Light
(21, 19, 1, 295.00, 295.00),
-- Orden 22: cliente 22 compra Mezzanine
(22, 54, 1, 450.00, 450.00),
-- Orden 23: cliente 23 compra London Calling (otro cliente)
(23, 52, 1, 460.00, 460.00),
-- Orden 24: cliente 24 compra Re (Café Tacvba)
(24, 39, 1, 390.00, 390.00),
-- Orden 25: cliente 25 compra Dummy + Frank
(25, 53, 1, 430.00, 430.00),
(25, 25, 1, 360.00, 360.00),
-- Orden 26: cliente 26 compra Heroes (Bowie)
(26, 21, 1, 460.00, 460.00),
-- Orden 27: cliente 27 compra Wish You Were Here + Revolver
(27, 6, 1, 490.00, 490.00),
(27, 3, 1, 420.00, 420.00),
-- Orden 28: cliente 28 compra 25 (Adele)
(28, 32, 1, 290.00, 290.00),
-- Orden 29: cliente 29 compra Kind of Blue (cancelada)
(29, 43, 1, 480.00, 480.00),
-- Orden 30: cliente 30 compra El Noa Noa (Juan Gabriel)
(30, 56, 1, 350.00, 350.00);