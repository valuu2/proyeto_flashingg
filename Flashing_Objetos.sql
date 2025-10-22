USE flashing_db;

-- VISTAS
CREATE VIEW vista_pedidos_clientes AS
SELECT p.id_pedido, u.nombre, u.apellido, p.fecha_pedido, p.estado, p.total
FROM Pedidos p
JOIN Usuarios u ON p.id_usuario = u.id_usuario;

CREATE VIEW vista_productos_materiales AS
SELECT pr.id_producto, pr.nombre AS nombre_producto, m.nombre AS nombre_material, pm.cantidad_usada
FROM Productos pr
JOIN Producto_material pm ON pr.id_producto = pm.id_producto
JOIN Materiales m ON pm.id_material = m.id_material;

CREATE VIEW vista_stock_materiales AS
SELECT m.id_material, m.nombre AS material, m.stock_actual, p.nombre AS proveedor
FROM Materiales m
LEFT JOIN Proveedores p ON m.id_proveedor = p.id_proveedor;

-- FUNCIONES
DELIMITER $$
CREATE FUNCTION fn_total_pedido(pid INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(subtotal) INTO total FROM Pedido_items WHERE id_pedido = pid;
    RETURN IFNULL(total,0);
END $$

CREATE FUNCTION fn_stock_disponible(mid INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    SELECT stock_actual INTO stock FROM Materiales WHERE id_material = mid;
    RETURN IFNULL(stock,0);
END $$
DELIMITER ;

-- STORED PROCEDURES
DELIMITER $$
CREATE PROCEDURE sp_agregar_pedido(IN p_usuario INT)
BEGIN
    INSERT INTO Pedidos (id_usuario, fecha_pedido, estado, total)
    VALUES (p_usuario, CURRENT_DATE, 'pendiente', 0.00);
END $$

CREATE PROCEDURE sp_actualizar_stock(IN p_material INT, IN p_cant INT, IN p_tipo VARCHAR(10))
BEGIN
    INSERT INTO Stock_movimientos (id_material, tipo_movimiento, cantidad, fecha_movimiento)
    VALUES (p_material, p_tipo, p_cant, CURRENT_DATE);

    IF p_tipo='entrada' THEN
        UPDATE Materiales SET stock_actual = stock_actual + p_cant WHERE id_material = p_material;
    ELSEIF p_tipo='salida' THEN
        UPDATE Materiales SET stock_actual = stock_actual - p_cant WHERE id_material = p_material;
    END IF;
END $$
DELIMITER ;

-- TRIGGERS
DELIMITER $$
CREATE TRIGGER trg_actualizar_stock_producto
AFTER INSERT ON Pedido_items
FOR EACH ROW
BEGIN
    DECLARE material_id INT;
    DECLARE cantidad_material INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT id_material, cantidad_usada FROM Producto_material WHERE id_producto = NEW.id_producto;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO material_id, cantidad_material;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        CALL sp_actualizar_stock(material_id, cantidad_material * NEW.cantidad, 'salida');
    END LOOP;
    CLOSE cur;
END $$
DELIMITER ;
