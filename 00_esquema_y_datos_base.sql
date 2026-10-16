CREATE DATABASE NovaMarket_EP02;
GO

USE NovaMarket_EP02;
GO

-- 1. Tabla Categoria
CREATE TABLE Categoria (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

-- 2. Tabla Cliente 
CREATE TABLE Cliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Documento VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 3. Tabla Producto 
CREATE TABLE Producto (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriaID INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    PrecioLista DECIMAL(10,2) NOT NULL,
    PrecioOferta DECIMAL(10,2) NULL,
    Stock INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (CategoriaID) REFERENCES Categoria(CategoriaID)
);
GO

-- 4. Tabla Pedido
CREATE TABLE Pedido (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaPedido DATE NOT NULL,
    Estado VARCHAR(20) NOT NULL CHECK (Estado IN ('CONFIRMADO', 'PENDIENTE', 'ANULADO', 'BORRADOR')),
    Canal VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);
GO

-- 5. Tabla Detalle Pedido 
CREATE TABLE DetallePedido (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Detalle_Pedido FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);
GO

--Introducción de datos
-- Categorías obligatorias (3)
INSERT INTO Categoria (Nombre) VALUES ('Redes'), ('Seguridad'), ('Accesorios');
GO

-- 15 Clientes
INSERT INTO Cliente (Documento, Nombre, Ciudad, Activo) VALUES 
('45123456', 'Juan Pérez', 'Lima', 1),
('46234567', 'María Gómez', 'Arequipa', 1),
('47345678', 'Carlos Ruiz', 'Trujillo', 1),
('48456789', 'Ana Torres', 'Lima', 1),
('49567890', 'Luis Ramos', 'Cusco', 1),
('50678901', 'Sofía Castro', 'Piura', 1),
('51789012', 'Miguel Ángel Paz', 'Huancayo', 1),
('52890123', 'Lucía Mendoza', 'Iquitos', 1),
('53901234', 'Jorge Silva', 'Tacna', 1),
('54012345', 'Carmen Ríos', 'Chimbote', 1),
('55123456', 'Pedro Infante', 'Lima', 1),
('56234567', 'Rosa Elvira', 'Arequipa', 1),
('57345678', 'Gabriel Soto', 'Cusco', 1),
('58456789', 'Valeria Luna', 'Trujillo', 1),
('59567890', 'Daniel Vega', 'Lima', 1);
GO

-- 12 Productos
INSERT INTO Producto (CategoriaID, Nombre, PrecioLista, PrecioOferta, Stock, Activo) VALUES 
(1, 'Router Gigabit TP-Link', 250.00, NULL, 30, 1),
(1, 'Switch Administrable 24P', 600.00, NULL, 15, 1),
(1, 'Cable UTP Cat6 x 100m', 180.00, NULL, 50, 1),
(1, 'Access Point Wi-Fi 6', 350.00, NULL, 20, 1),
(2, 'Cámara IP Domo HD', 220.00, NULL, 25, 1),
(2, 'Kit de Alarma Residencial', 850.00, NULL, 10, 1),
(2, 'Sensor de Movimiento Infrarrojo', 90.00, NULL, 40, 1),
(2, 'Grabador NVR 8 Canales', 500.00, NULL, 12, 1),
(3, 'Mouse Inalámbrico Ergonomico', 60.00, NULL, 100, 1),
(3, 'Teclado Mecánico RGB', 200.00, NULL, 45, 1),
(3, 'Audífonos Gamer con Micrófono', 150.00, NULL, 35, 1),
(3, 'Hub USB-C Multipuerto', 110.00, NULL, 60, 1);
GO

-- 40 Pedidos 
INSERT INTO Pedido (ClienteID, FechaPedido, Estado, Canal) VALUES 
(1, '2025-05-10', 'CONFIRMADO', 'Web'),
(2, '2025-08-15', 'CONFIRMADO', 'Tienda'),
(3, '2025-11-20', 'CONFIRMADO', 'Web'),
(1, '2026-01-15', 'CONFIRMADO', 'Web'),
(2, '2026-02-10', 'CONFIRMADO', 'Tienda'),
(3, '2026-02-18', 'PENDIENTE', 'Web'),
(4, '2026-03-01', 'CONFIRMADO', 'Web'),
(5, '2026-03-05', 'ANULADO', 'Tienda'),
(6, '2026-03-10', 'CONFIRMADO', 'Web'),
(7, '2026-03-12', 'BORRADOR', 'Web'),
(8, '2026-03-15', 'PENDIENTE', 'Tienda'),
(9, '2026-03-20', 'CONFIRMADO', 'Web'),
(10, '2026-03-22', 'BORRADOR', 'Tienda'),
(11, '2025-06-11', 'CONFIRMADO', 'Web'),
(12, '2025-11-03', 'CONFIRMADO', 'Tienda'),
(13, '2026-05-05', 'PENDIENTE', 'Web'),
(14, '2026-06-06', 'ANULADO', 'Web'),
(15, '2025-09-21', 'CONFIRMADO', 'Web'),
(1, '2025-10-10', 'CONFIRMADO', 'Tienda'),
(2, '2025-07-07', 'CONFIRMADO', 'Web'),
(3, '2025-12-15', 'CONFIRMADO', 'Telefono'),
(4, '2025-03-14', 'CONFIRMADO', 'Web'),
(5, '2025-05-20', 'CONFIRMADO', 'Tienda'),
(6, '2025-04-01', 'CONFIRMADO', 'Web'),
(7, '2026-01-20', 'PENDIENTE', 'Web'),
(8, '2026-08-08', 'BORRADOR', 'Web'),
(9, '2026-09-15', 'BORRADOR', 'Tienda'),
(10, '2026-07-01', 'BORRADOR', 'Web'),
(11, '2025-11-11', 'BORRADOR', 'Web'),
(12, '2026-10-05', 'BORRADOR', 'Tienda'),
(13, '2025-12-01', 'BORRADOR', 'Web'),
(14, '2026-11-02', 'BORRADOR', 'Web'),
(15, '2026-06-30', 'BORRADOR', 'Telefono'),
(1, '2026-02-12', 'CONFIRMADO', 'Web'),
(2, '2026-04-18', 'CONFIRMADO', 'Tienda'),
(3, '2026-05-01', 'CONFIRMADO', 'Web'),
(4, '2026-06-12', 'PENDIENTE', 'Web'),
(5, '2026-07-20', 'CONFIRMADO', 'Web'),
(6, '2026-08-15', 'CONFIRMADO', 'Tienda'),
(7, '2026-09-22', 'CONFIRMADO', 'Web');
GO

-- 80 Detalles de Pedido 
INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES 
(1, 1, 2, 250.00), (1, 3, 1, 180.00), (1, 2, 1, 600.00), (1, 4, 1, 350.00),
(2, 5, 1, 220.00), (2, 6, 1, 850.00), (2, 7, 2, 90.00),  (2, 8, 1, 500.00),
(3, 9, 3, 60.00),  (3, 10, 2, 200.00), (3, 11, 1, 150.00), (3, 12, 1, 110.00),
(4, 1, 1, 250.00), (4, 2, 1, 600.00), (4, 3, 2, 180.00), (4, 5, 1, 220.00),
(5, 4, 2, 350.00), (5, 6, 1, 850.00), (5, 8, 1, 500.00),  (5, 9, 2, 60.00),
(6, 7, 2, 90.00),  (6, 10, 1, 200.00), (6, 11, 2, 150.00), (6, 12, 1, 110.00),
(7, 8, 1, 500.00), (7, 1, 2, 250.00), (7, 3, 1, 180.00),  (7, 5, 1, 220.00),
(8, 2, 1, 600.00), (8, 4, 1, 350.00), (8, 6, 2, 850.00),  (8, 9, 1, 60.00),
(9, 10, 1, 200.00),(9, 11, 2, 150.00),(9, 12, 2, 110.00), (9, 1, 1, 250.00),
(10, 3, 2, 180.00),(10, 5, 1, 220.00),(10, 7, 1, 90.00),  (10, 8, 1, 500.00),
(11, 12, 1, 110.00),(11, 3, 2, 180.00),(11, 1, 1, 250.00), (11, 2, 1, 600.00),
(12, 4, 1, 350.00), (12, 6, 1, 850.00), (12, 10, 2, 60.00), (12, 11, 1, 150.00),
(13, 5, 2, 220.00), (13, 7, 1, 90.00),  (13, 8, 1, 500.00),  (13, 9, 1, 60.00),
(14, 10, 1, 200.00),(14, 11, 1, 150.00),(14, 12, 2, 110.00), (14, 1, 1, 250.00),
(15, 2, 1, 600.00), (15, 3, 1, 180.00), (15, 4, 1, 350.00), (15, 5, 1, 220.00),
(16, 6, 1, 850.00), (16, 7, 2, 90.00),  (16, 8, 1, 500.00),  (16, 9, 1, 60.00),
(17, 10, 2, 200.00),(17, 11, 1, 150.00),(17, 12, 1, 110.00), (17, 1, 1, 250.00),
(18, 2, 1, 600.00), (18, 3, 1, 180.00), (18, 5, 2, 220.00), (18, 6, 1, 850.00),
(19, 7, 1, 90.00),  (19, 8, 1, 500.00), (19, 9, 3, 60.00),  (19, 10, 1, 200.00),
(20, 11, 1, 150.00),(20, 12, 2, 110.00),(20, 1, 1, 250.00), (20, 2, 1, 600.00);
GO

-- Verificación de volumen base
SELECT 'Cliente' AS Tabla, COUNT(*) AS Filas FROM Cliente UNION ALL
SELECT 'Producto', COUNT(*) FROM Producto UNION ALL
SELECT 'Pedido', COUNT(*) FROM Pedido UNION ALL
SELECT 'DetallePedido', COUNT(*) FROM DetallePedido;
GO
