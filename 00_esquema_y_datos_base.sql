
--Proyecto: NovaMarket - Esquema y Datos Base


CREATE DATABASE NovaMarket_EP02;
GO

USE NovaMarket_EP02;
GO

-- Tabla Categoria
CREATE TABLE Categoria (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

-- Tabla Cliente 
CREATE TABLE Cliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Documento VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- Tabla Producto 
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

--Insertamos datos

-- Categorías obligatorias
INSERT INTO Categoria (Nombre) VALUES ('Redes'), ('Seguridad'), ('Accesorios');
GO

--15 Clientes
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

-- 2. 12 Productos
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

-- 3. Pedidos 
INSERT INTO Pedido (ClienteID, FechaPedido, Estado, Canal) VALUES 
-- Pedidos históricos del 2025
(1, '2025-05-10', 'CONFIRMADO', 'Web'),
(2, '2025-08-15', 'CONFIRMADO', 'Tienda'),
(3, '2025-11-20', 'CONFIRMADO', 'Web'),
-- Pedidos del 2026 
(1, '2026-01-15', 'CONFIRMADO', 'Web'),
(2, '2026-02-10', 'CONFIRMADO', 'Tienda'),
(3, '2026-02-18', 'PENDIENTE', 'Web'),
(4, '2026-03-01', 'CONFIRMADO', 'Web'),
(5, '2026-03-05', 'ANULADO', 'Tienda'),
(6, '2026-03-10', 'CONFIRMADO', 'Web'),
(7, '2026-03-12', 'BORRADOR', 'Web'), 
(8, '2026-03-15', 'PENDIENTE', 'Tienda'),
(9, '2026-03-20', 'CONFIRMADO', 'Web'),
(10, '2026-03-22', 'BORRADOR', 'Tienda');
GO

-- 4. Detalles de Pedido
INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES 
(1, 1, 2, 250.00),
(1, 3, 1, 180.00),
(2, 5, 1, 220.00),
(2, 6, 1, 850.00),
(3, 9, 3, 60.00),
(4, 1, 1, 250.00),
(4, 2, 1, 600.00),
(5, 4, 2, 350.00),
(6, 7, 2, 90.00),
(7, 8, 1, 500.00),
(9, 10, 1, 200.00),
(9, 11, 2, 150.00),
(11, 12, 1, 110.00),
(11, 3, 2, 180.00);
GO