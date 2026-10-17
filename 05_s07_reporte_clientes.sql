USE NovaMarket_EP02;
GO

SELECT 
    c.ClienteID,
    c.Nombre,
    COUNT(DISTINCT p.PedidoID) AS TotalPedidos2026,
    ISNULL(SUM(dp.Cantidad * dp.PrecioUnitario), 0.00) AS MontoVendido2026
FROM Cliente c
LEFT JOIN Pedido p ON c.ClienteID = p.ClienteID 
                  AND p.Estado = 'CONFIRMADO'
                  AND p.FechaPedido BETWEEN '2026-01-01' AND '2026-12-31'
LEFT JOIN DetallePedido dp ON p.PedidoID = dp.PedidoID
WHERE c.Activo = 1
GROUP BY c.ClienteID, c.Nombre;
