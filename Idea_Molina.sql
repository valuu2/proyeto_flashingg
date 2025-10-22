-- Archivo SQL para proyecto final: Tienda de Pulseras Artesanales
-- Alumna: Valentina Molina

CREATE DATABASE IF NOT EXISTS flashing_db;
USE flashing_db;

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(150)
);

CREATE TABLE Materiales (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    color VARCHAR(50),
    tipo VARCHAR(50),
    stock_actual INT DEFAULT 0,
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    fecha_creacion DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Producto_material (
    id_producto INT,
    id_material INT,
    cantidad_usada INT NOT NULL,
    PRIMARY KEY (id_producto, id_material),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_material) REFERENCES Materiales(id_material)
);

CREATE TABLE Stock_movimientos (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_material INT,
    tipo_movimiento VARCHAR(20) CHECK (tipo_movimiento IN ('entrada','salida')),
    cantidad INT NOT NULL,
    fecha_movimiento DATE DEFAULT (CURRENT_DATE),
    observaciones TEXT,
    FOREIGN KEY (id_material) REFERENCES Materiales(id_material)
);

CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha_pedido DATE DEFAULT (CURRENT_DATE),
    estado VARCHAR(50) DEFAULT 'pendiente',
    total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Pedido_items (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),
    fecha_pago DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);

CREATE TABLE Fotos_productos (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    url_foto VARCHAR(255) NOT NULL,
    descripcion VARCHAR(150),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);
