USE NovaMarket_EP02;
GO

SELECT DISTINCT 
    c.ClienteID, 
    c.Nombre, 
    c.Ciudad
FROM Cliente c
WHERE 
    -- Condición 1: Compró al menos un producto de 'Redes' (CategoriaID = 1) con pedido CONFIRMADO en 2026
    EXISTS (
        SELECT 1 
        FROM Pedido p
        JOIN DetallePedido dp ON p.PedidoID = dp.PedidoID
        JOIN Producto pr ON dp.ProductoID = pr.ProductoID
        WHERE p.ClienteID = c.ClienteID
          AND p.Estado = 'CONFIRMADO'
          AND pr.CategoriaID = 1 -- Redes
          AND YEAR(p.FechaPedido) = 2026
    )
    AND 
    -- Condición 2: NO tiene pedidos CONFIRMADOS de productos de 'Seguridad' (CategoriaID = 2) en 2026
    NOT EXISTS (
        SELECT 1 
        FROM Pedido p
        JOIN DetallePedido dp ON p.PedidoID = dp.PedidoID
        JOIN Producto pr ON dp.ProductoID = pr.ProductoID
        WHERE p.ClienteID = c.ClienteID
          AND p.Estado = 'CONFIRMADO'
          AND pr.CategoriaID = 2 -- Seguridad
          AND YEAR(p.FechaPedido) = 2026
    );
GO



SELECT 
    p.ProductoID,
    p.Nombre,
    cat.Nombre AS Categoria,
    p.PrecioLista,
    (
        SELECT AVG(p_sub.PrecioLista) 
        FROM Producto p_sub 
        WHERE p_sub.CategoriaID = p.CategoriaID
    ) AS PromedioCategoria
FROM Producto p
JOIN Categoria cat ON p.CategoriaID = cat.CategoriaID
WHERE p.PrecioLista > (
    SELECT AVG(p_sub.PrecioLista) 
    FROM Producto p_sub 
    WHERE p_sub.CategoriaID = p.CategoriaID
)
ORDER BY p.CategoriaID, p.PrecioLista DESC;
GO