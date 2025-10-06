USE flashing_db;
-- 
INSERT INTO Usuarios (nombre, apellido, email, telefono, direccion)
VALUES ('Valentina','Molina','valentina@mail.com','3511234567','Calle Falsa 123'),
       ('Ana','Gomez','ana@mail.com','3517654321','Calle Verdadera 456');

-- 
INSERT INTO Proveedores (nombre, telefono, email, direccion)
VALUES ('Hilos S.A.','3511111111','contacto@hilos.com','Calle Hilo 12'),
       ('Accesorios Ltda.','3512222222','ventas@accesorios.com','Calle Dije 34');

-- 
INSERT INTO Materiales (nombre, color, tipo, stock_actual, id_proveedor)
VALUES ('Hilo chino', 'Rojo', 'Hilo', 100, 1),
       ('Hilo encerado', 'Negro', 'Hilo', 50, 1),
       ('Dije estrella', 'Dorado', 'Accesorio', 30, 2);

-- 
INSERT INTO Productos (nombre, descripcion, precio)
VALUES ('Pulsera roja','Pulsera hecha con hilo rojo y dijes', 500.00),
       ('Pulsera negra','Pulsera hecha con hilo negro', 400.00);

-- 
INSERT INTO Producto_material (id_producto, id_material, cantidad_usada)
VALUES (1, 1, 2),
       (1, 3, 1),
       (2, 2, 3);

-- 
INSERT INTO Pedidos (id_usuario, fecha_pedido, estado)
VALUES (1, CURRENT_DATE, 'pendiente');

-- 
INSERT INTO Pedido_items (id_pedido, id_producto, cantidad, subtotal)
VALUES (1, 1, 2, 1000.00);

-- 
INSERT INTO Pagos (id_pedido, monto, metodo_pago)
VALUES (1, 1000.00, 'efectivo');

-- 
INSERT INTO Fotos_productos (id_producto, url_foto, descripcion)
VALUES (1, 'https://linkfoto.com/pulsera_roja.jpg','Pulsera roja con dije'),
       (2, 'https://linkfoto.com/pulsera_negra.jpg','Pulsera negra simple');
