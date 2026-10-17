USE NovaMarket;
GO

CREATE OR ALTER VIEW vw_VentasCategoriaMes AS
SELECT 
    YEAR(p.FechaPedido) AS Anio,
    MONTH(p.FechaPedido) AS Mes,
    cat.CategoriaID,
    cat.Nombre AS NombreCategoria,
    SUM(dp.Cantidad) AS TotalUnidades,
    SUM(dp.Cantidad * dp.PrecioUnitario) AS MontoTotal
FROM Pedido p
INNER JOIN DetallePedido dp ON p.PedidoID = dp.PedidoID
INNER JOIN Producto pr ON dp.ProductoID = pr.ProductoID
INNER JOIN Categoria cat ON pr.CategoriaID = cat.CategoriaID
WHERE p.Estado = 'CONFIRMADO'
GROUP BY YEAR(p.FechaPedido), MONTH(p.FechaPedido), cat.CategoriaID, cat.Nombre;
GO

SELECT * FROM vw_VentasCategoriaMes
WHERE Anio = 2026
ORDER BY Mes ASC, MontoTotal DESC;
GO

CREATE OR ALTER VIEW vw_ClientesSinCompra2026 AS
SELECT DISTINCT
    c.ClienteID,
    c.Nombre,
    c.Ciudad
FROM Cliente c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Pedido p 
    WHERE p.ClienteID = c.ClienteID 
      AND p.Estado = 'CONFIRMADO'
      AND p.FechaPedido >= '2026-01-01' 
      AND p.FechaPedido <= '2026-12-31'
);
GO

SELECT c.ClienteID, c.Nombre, c.Ciudad
FROM Cliente c
LEFT JOIN Pedido p ON c.ClienteID = p.ClienteID 
                   AND p.Estado = 'CONFIRMADO' 
                   AND p.FechaPedido BETWEEN '2026-01-01' AND '2026-12-31'
WHERE p.PedidoID IS NULL;
