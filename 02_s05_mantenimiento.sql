-- ACTIVIDAD 2
-- 1. Estructura de la tabla histórica
USE NovaMarket_EP02;
GO
IF OBJECT_ID('PedidoHistorico2025', 'U') IS NULL
BEGIN
    CREATE TABLE PedidoHistorico2025 (
        PedidoID INT PRIMARY KEY,
        ClienteID INT NOT NULL,
        FechaPedido DATE NOT NULL,
        Estado VARCHAR(20) NOT NULL,
        Canal VARCHAR(30) NOT NULL
    );
END;
GO

-- 2. Validación PRE-EJECUCIÓN
SELECT COUNT(*) AS [Filas A Insertar (Origen)] 
FROM Pedido 
WHERE Estado = 'CONFIRMADO' 
  AND FechaPedido < '2026-01-01';

-- 3. Carga Idempotente (Segura ante re-ejecuciones)
INSERT INTO PedidoHistorico2025 (PedidoID, ClienteID, FechaPedido, Estado, Canal)
SELECT p.PedidoID, p.ClienteID, p.FechaPedido, p.Estado, p.Canal
FROM Pedido p
WHERE p.Estado = 'CONFIRMADO' 
  AND p.FechaPedido < '2026-01-01'
  AND NOT EXISTS (
      SELECT 1 
      FROM PedidoHistorico2025 ph 
      WHERE ph.PedidoID = p.PedidoID
  );

-- 4. Validación POST-EJECUCIÓN
SELECT COUNT(*) AS [Total Filas en PedidoHistorico2025] 
FROM PedidoHistorico2025;
GO


-- B. UPDATE Condicionado (Ofertas de Redes)
-- 1. Validación PRE-EJECUCIÓN (Estado inicial del catálogo de Redes)
SELECT p.ProductoID, p.Nombre, p.PrecioLista, p.PrecioOferta, p.Stock, p.Activo
FROM Producto p
INNER JOIN Categoria c ON p.CategoriaID = c.CategoriaID
WHERE c.Nombre = 'Redes';

-- 2. UPDATE idempotente sobre la base de PrecioLista
UPDATE p
SET p.PrecioOferta = ROUND(p.PrecioLista * 0.90, 2)
FROM Producto p
INNER JOIN Categoria c ON p.CategoriaID = c.CategoriaID
WHERE c.Nombre = 'Redes' 
  AND p.Activo = 1 
  AND p.Stock >= 10;

-- 3. Validación POST-EJECUCIÓN
SELECT p.ProductoID, p.Nombre, p.PrecioLista, p.PrecioOferta, p.Stock
FROM Producto p
INNER JOIN Categoria c ON p.CategoriaID = c.CategoriaID
WHERE c.Nombre = 'Redes';
GO

-- C. DELETE Protegido 

-- 1. Validación PRE-EJECUCIÓN
-- Identificar borradores sin detalle (filas objetivo)
SELECT p.PedidoID, p.Estado 
FROM Pedido p
LEFT JOIN DetallePedido dp ON p.PedidoID = dp.PedidoID
WHERE p.Estado = 'BORRADOR' 
  AND dp.DetalleID IS NULL;

-- Conteo por estado para verificar resguardo de datos
SELECT Estado, COUNT(*) AS CantidadInicial
FROM Pedido
GROUP BY Estado;

-- 2. DELETE controlado por subconsulta de detalle
DELETE FROM Pedido
WHERE Estado = 'BORRADOR'
  AND PedidoID NOT IN (
      SELECT DISTINCT PedidoID 
      FROM DetallePedido
  );

-- 3. Validación POST-EJECUCIÓN
SELECT Estado, COUNT(*) AS CantidadFinal
FROM Pedido
GROUP BY Estado;
GO