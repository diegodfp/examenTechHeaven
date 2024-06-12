

DROP DATABASE IF EXISTS tiendaonline;
create database tiendaonline;
use tiendaonline;

CREATE TABLE productos(
    id int AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DOUBLE(10,2),
    descripcion TEXT
);

CREATE TABLE usuarios(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    correo_electronico VARCHAR(100),
    fecha_registro DATE
);

CREATE TABLE pedidos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario int,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE detallespedidos(
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY(id_pedido, id_producto),
    FOREIGN KEY(id_pedido) REFERENCES pedidos (id),
    FOREIGN KEY(id_producto) REFERENCES productos (id)
);

INSERT INTO productos (nombre, precio, descripcion) VALUES
('iPhone 13', 799.99,'Apple iPhone 13 con pantalla de 6.1 pulgadas y cámara dual.'),
('Samsung Galaxy S21', 699.99, 'Samsung Galaxy S21 con pantalla de 6.2 pulgadas y cámara triple'),
('Sony WH-1000XM4', 349.99,'Auriculares inalámbricos Sony con cancelación de ruido.'),
('MacBook Pro', 1299.99,'Apple MacBook Pro con pantalla Retina de 13 pulgadas.'),
('Dell XPS 13', 999.99, 'Portátil Dell XPS 13 con pantalla de 13.3 pulgadas y procesador Intel i7.'),
('GoPro HERO9', 399.99,'Cámara de acción GoPro HERO9 con resolucion 5K.'),
('Amazon Echo Dot', 49.99,'Altavoz inteligente Amazon Echo Dot con Alexa.'),
('Kindle Paperwhite', 129.99, 'Amazon Kindle Paperwhite con pantalla de 6 pulgadas y luz ajustable'),
('Apple Watch Series 7', 399.99,'Apple Watch Series 7 con GPS y pantalla Retina siempre activa'),
('Bose QuietComfort 35 II', 299.99,'Auriculares inalambricos Bose con cancelacion de ruido'),
('Nintendo Switch', 299.99, 'Consola de videojuegos Nintendo Switch con controles Joy-con'),
('Fitbig Charge 5', 179.95, 'Monitor de actividad fisica Fitbit Charge 5 con GPS y seguimiento del sueño.'); 

INSERT INTO usuarios (nombre, correo_electronico, fecha_registro) VALUES
('Juan Perez', 'juan.perez@example.com','2024-01-01'),
('Maria Lopez', 'maria.lopez@example.com','2024-01-05'),
('Carlos Mendoza','carlos.mendoza@example.com','2024-02-10'),
('Ana Gonzáles','ana.gonzales@example.com','2024-02-20'),
('Luis Torres','luis.torres@example.com','2024-05-05'),
('Laura Rivera', 'laura.rivera@example.com','2024-03-15');

INSERT INTO pedidos(id_usuario, fecha, total) VALUES
(1, '2024-02-25', 1049.98),
(2, '2024-03-10', 1349.98),
(3, '2024-03-20', 1249.98),
(4, '2024-03-25', 449.98),
(5, '2024-04-05', 699.98),
(6, '2024-04-10', 399.98);

INSERT INTO detallespedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1 , 1, 799.99),
(1, 7 , 5, 49.99),
(2, 4 , 1, 1299.99),
(2, 8 , 1, 129.99),
(3, 2 , 1, 699.99),
(3, 9 , 1, 399.99),
(4, 5 , 1, 999.99),
(4, 10 , 1, 299.99),
(5, 11, 1, 299.99),
(5, 3 , 1, 349.99),
(6, 6 , 1, 399.99);

