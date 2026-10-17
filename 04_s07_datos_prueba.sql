USE NovaMarket_EP02;
GO

DECLARE @i INT = 1;
DECLARE @ClienteID INT;
DECLARE @FechaPedido DATE;
DECLARE @Estado VARCHAR(20);
DECLARE @Canal VARCHAR(30);

WHILE (SELECT COUNT(*) FROM Pedido) < 205
BEGIN
    SET @ClienteID = ((@i - 1) % (SELECT COUNT(*) FROM Cliente WHERE Activo = 1)) + 1;
    
    IF @i % 2 = 0
        SET @FechaPedido = DATEADD(DAY, -(@i * 3), '2026-10-01');
    ELSE
        SET @FechaPedido = DATEADD(DAY, -(@i * 4), '2025-12-15');

    IF @i % 5 = 0 SET @Estado = 'BORRADOR';
    ELSE IF @i % 7 = 0 SET @Estado = 'ANULADO';
    ELSE IF @i % 9 = 0 SET @Estado = 'PENDIENTE';
    ELSE SET @Estado = 'CONFIRMADO';

    SET @Canal = CASE WHEN @i % 2 = 0 THEN 'Web' ELSE 'Tienda Física' END;

    INSERT INTO Pedido (ClienteID, FechaPedido, Estado, Canal)
    VALUES (@ClienteID, @FechaPedido, @Estado, @Canal);

    SET @i = @i + 1;
END;
GO

DECLARE @PedidoID INT;
DECLARE @ProductoID INT;
DECLARE @Cantidad INT;
DECLARE @PrecioUnitario DECIMAL(10,2);

DECLARE cur_pedidos CURSOR FOR 
SELECT PedidoID FROM Pedido 
WHERE Estado <> 'BORRADOR' OR (PedidoID % 2 = 0);

OPEN cur_pedidos;
FETCH NEXT FROM cur_pedidos INTO @PedidoID;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @ProductoID = (@PedidoID % 12) + 1;
    SELECT @PrecioUnitario = PrecioLista FROM Producto WHERE ProductoID = @ProductoID;
    
    INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario)
    VALUES (@PedidoID, @ProductoID, 2, @PrecioUnitario);

    SET @ProductoID = ((@ProductoID + 3) % 12) + 1;
    SELECT @PrecioUnitario = PrecioLista FROM Producto WHERE ProductoID = @ProductoID;
    
    INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario)
    VALUES (@PedidoID, @ProductoID, 1, @PrecioUnitario);

    FETCH NEXT FROM cur_pedidos INTO @PedidoID;
END;

CLOSE cur_pedidos;
DEALLOCATE cur_pedidos;
GO

SELECT 'Cliente' AS Tabla, COUNT(*) AS TotalRegistros FROM Cliente
UNION ALL
SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL
SELECT 'Producto', COUNT(*) FROM Producto
UNION ALL
SELECT 'Pedido', COUNT(*) FROM Pedido
UNION ALL
SELECT 'DetallePedido', COUNT(*) FROM DetallePedido;

SELECT 
    YEAR(FechaPedido) AS Año,
    Estado,
    COUNT(*) AS CantidadPedidos
FROM Pedido
GROUP BY YEAR(FechaPedido), Estado
ORDER BY Año DESC, Estado;
