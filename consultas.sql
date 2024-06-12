-- Active: 1717105247149@@127.0.0.1@3306@tiendaonline

-- 1. Obtener la lista de todos los productos con sus precio 

SELECT
    c.nombre, c.precio
FROM
    productos c;

-- 2. Encontrar todos los pedidos realizados por un usuario específico, por ejemplo, Juan Perez

SELECT
    p.id, p.fecha, p.total
FROM
    pedidos p
JOIN
    usuarios u ON u.id = p.id_usuario
WHERE
    u.nombre = 'Juan Perez';

-- 3.Listar los detalles de todos los pedidos, incluyendo el nombre del producto, cantidad y precio unitario

SELECT
    dp.id_pedido as PedidoId, p.nombre as Producto, dp.cantidad, dp.precio_unitario
FROM
    detallespedidos dp
JOIN 
    productos p ON p.id = dp.id_producto;

-- 4.  Calcular el total gastado por cada usuario en todos sus pedidos

SELECT
    u.nombre, SUM(p.total) 
FROM
    usuarios u
JOIN
    pedidos p ON u.id = p.id_usuario
GROUP BY 
    p.id_usuario;

-- 5. Encontrar los productos más caros (precio mayor a $500)

SELECT
    p.nombre, p.precio
FROM
    productos p
WHERE
    p.precio > 500;

-- 6. Listar los pedidos realizados en una fecha específica, por ejemplo, 2024-03-10

SELECT
    p.id, p.id_usuario, p.fecha, p.total
FROM
    pedidos p
WHERE
    p.fecha = '2024-03-10';

-- 7. Obtener el número total de pedidos realizados por cada usuario

SELECT
    u.nombre, COUNT(p.id_usuario) 
FROM
    usuarios u
JOIN
    pedidos p ON u.id = p.id_usuario
GROUP BY 
    p.id_usuario;

-- 8. Encontrar el nombre del producto más vendido (mayor cantidad total vendida)

SELECT
    p.nombre, SUM(dp.cantidad) as CantidadTotal 
FROM
    productos p
JOIN
    detallespedidos dp ON p.id = dp.id_producto
GROUP BY 
    dp.id_producto
ORDER BY
    SUM(dp.cantidad) DESC LIMIT 1;

-- 9. Listar todos los usuarios que han realizado al menos un pedido

SELECT
    u.nombre, u.correo_electronico
FROM
    usuarios u
JOIN
    pedidos p ON u.id = p.id_usuario;

-- 10. Obtener los detalles de un pedido específico, incluyendo los productos y cantidades, por ejemplo, pedido con id 1

SELECT
    p.id as PedidoID, u.nombre, pr.nombre, dp.cantidad, dp.precio_unitario
FROM
    usuarios u
JOIN
    pedidos p ON u.id = p.id_usuario
JOIN
    detallespedidos dp ON dp.id_pedido = p.id
JOIN
    productos pr ON pr.id = dp.id_producto
WHERE
    p.id = 1;

-- SUBCONSULTAS
-- 1. Encontrar el nombre del usuario que ha gastado más en total
SELECT
    u.nombre
FROM
    usuarios u
WHERE
    u.id = (
        SELECT
            p.id_usuario
        FROM
            pedidos p
        GROUP BY
            p.id_usuario
        ORDER BY
            SUM(p.total) DESC LIMIT 1
    );

-- 2. Listar los productos que han sido pedidos al menos una vez
SELECT
    p.nombre
FROM
    productos p
WHERE
    p.id IN (
        SELECT
            dp.id_producto
        FROM
            detallespedidos dp
    );

-- 3. Obtener los detalles del pedido con el total más alto

SELECT
    p.id, p.id_usuario, p.fecha, p.total
FROM
    pedidos p
WHERE
    p.id = (
        SELECT
            p.id
        FROM
            pedidos p
        GROUP BY
            p.id
        ORDER BY
            MAX(p.total) DESC LIMIT 1
    );

-- 4. Listar los usuarios que han realizado más de un pedido

SELECT
    u.nombre
FROM
    usuarios u
WHERE
    u.id IN (
        SELECT
            p.id_usuario
        FROM
            pedidos p
        GROUP BY
            p.id_usuario
        HAVING
            COUNT(id_usuario) > 1
    );

-- 5. Encontrar el producto más caro que ha sido pedido al menos una vez

SELECT
    p.nombre, p.precio
FROM
    productos p
WHERE
    p.id = (
        SELECT
            p.id
        FROM
            productos p
        JOIN
            detallespedidos dp ON dp.id_producto = p.id
        GROUP BY
            p.id
        ORDER BY
            p.precio DESC LIMIT 1
    );

-- Procedimientos Almacenados

--  Crear un procedimiento almacenado para agregar un nuevo producto

DELIMITER $$
DROP PROCEDURE IF EXISTS AgregarProducto;
CREATE PROCEDURE AgregarProducto(
    IN nombre VARCHAR(100),
    IN precio DOUBLE(10,2),
    IN descripcion TEXT)
BEGIN
    DECLARE mensaje VARCHAR(100);
    INSERT INTO productos  (id, nombre, precio, descripcion)
    VALUES (NULL, nombre, precio, descripcion);
    IF ROW_COUNT() > 0 THEN
        SET mensaje = 'El registro se ha creado correctamente.';
    ELSE
        SET mensaje = 'Error al crear el registro.';
    END IF;
    SELECT mensaje AS 'Mensaje';
END $$
DELIMITER ;

CALL AgregarProducto('Iphone 15 PRO MAX', 1179.95, 'PRODUCTO AGREGADO POR PROCEDURE');

-- 2. Crear un procedimiento almacenado para obtener los detalles de un pedido

DELIMITER $$
DROP PROCEDURE IF EXISTS ObtenerDetallesPedido;
CREATE PROCEDURE ObtenerDetallesPedido(
    IN id_buscar INT
)
BEGIN
    DECLARE productoID INT;

    SELECT id_producto INTO productoID
    FROM detallespedidos
    WHERE id_producto = id_buscar;

    IF productoID IS NULL THEN
        SELECT 'producto no encontrado' AS Mensaje;
    ELSE
        SELECT dp.id_producto, p.nombre, dp.cantidad, dp.precio_unitario
        FROM detallespedidos dp
        JOIN productos p ON dp.id_producto = p.id
        WHERE dp.id_producto = productoID;
    END IF;
END $$
DELIMITER ;

CALL ObtenerDetallesPedido(1);

-- 3. Crear un procedimiento almacenado para actualizar el precio de un producto


DELIMITER $$
DROP PROCEDURE IF EXISTS ActualizarPrecioProducto;
CREATE PROCEDURE ActualizarPrecioProducto(
    IN id_busqueda INT,
    IN nuevoPrecio INT
)
BEGIN
    DECLARE mensaje VARCHAR(100);
    DECLARE productoExiste INT;

    SELECT COUNT(*) INTO productoExiste
    FROM productos p
    WHERE p.id = id_busqueda;

    IF productoExiste > 0 THEN
        UPDATE productos
        SET precio = nuevoPrecio
        WHERE id = id_busqueda;
        SET mensaje = 'Registro actualizado correctamente';
    ELSE
        SET mensaje = 'Error al crear el registro. asegurese de ingresar bien el id';
    END IF;
    SELECT mensaje AS 'Mensaje';
END $$

DELIMITER ;

CALL ActualizarPrecioProducto(1, 899.00);

-- 4. Crear un procedimiento almacenado para eliminar un producto
DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarProducto;
CREATE PROCEDURE EliminarProducto(
    IN id_producto_busqueda INT
)
BEGIN
    DECLARE mensaje VARCHAR(100);
    DECLARE producto_existe INT;

    SELECT COUNT(*) INTO producto_existe
    FROM productos p
    WHERE p.id = id_producto_busqueda;

    IF producto_existe > 0 THEN
        DELETE FROM detallespedidos
        WHERE id_producto = id_producto_busqueda;
        DELETE FROM productos
        WHERE id = id_producto_busqueda;
        SET mensaje = 'producto eliminado correctamente';
    ELSE
        SET mensaje = 'Error: el producto no existe';
    END IF;

    SELECT mensaje AS 'Mensaje';
END $$

DELIMITER ;

CALL EliminarProducto(1);

-- 5.Crear un procedimiento almacenado para obtener el total gastado por un usuario

DELIMITER $$
DROP PROCEDURE IF EXISTS TotalGastadoPorUsuario;
CREATE PROCEDURE TotalGastadoPorUsuario(
    IN id_busqueda INT
)
BEGIN
    DECLARE usuarioID INT;

    SELECT id INTO usuarioID
    FROM usuarios
    WHERE id = id_busqueda;

    IF usuarioID IS NULL THEN  
        SELECT 'Usuario no encontrado ' AS 'mensaje';
    ELSE
        SELECT
            u.nombre, SUM(p.total)
        FROM   
            usuarios u
        JOIN
            pedidos p ON p.id_usuario = u.id
        WHERE
            u.id = id_busqueda
        GROUP BY
            p.id_usuario;
    END IF;
END $$
DELIMITER ;

CALL TotalGastadoPorUsuario(1);