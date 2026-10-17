# NovaMarket — Examen PA2 - Programación Avanzada de Base de Datos
Repositorio que contiene un conjunto de scripts el proyecto **NovaMarket**: creación y población de la base de datos `NovaMarket_EP02`, subconsultas, mantenimiento de datos (INSERT / UPDATE / DELETE controlados), vistas, generación masiva de datos de prueba y reportes de clientes.
## Integrantes del equipo

| N° | Nombre completo                      | Correo institucional  | Aporte |
|----|--------------------------------------|-----------------------|--------|
| 1  | Imanol Ponce de León                 | 76221830@mail.isil.pe |  100%  |
| 2  | Jose Manuel Aponte Tanta             | 75619512@mail.isil.pe |  100%  |
| 3  | Andrés Francisco Pimentel Saldaña    | 73213777@mail.isil.pe |  0%    |
| 4  | Jhonn Paul Ccasani Enciso            | 44061898@mail.isil.pe |  0%    |

## 📹 Link YouTube: *(pegar aquí el enlace del video de la EP02)*

## 📋 Estructura del Proyecto

Los scripts están numerados en el orden en que deben ejecutarse:

| Script | Sesión | Contenido |
|--------|--------|-----------|
| `00_esquema_y_datos_base.sql` | Base | Creación de la BD, tablas, restricciones y datos iniciales |
| `01_s04_subconsultas.sql` | S04 | Subconsultas correlacionadas (`EXISTS` / `NOT EXISTS`) y subconsultas escalares |
| `02_s05_mantenimiento.sql` | S05 | Carga histórica idempotente, `UPDATE` condicionado y `DELETE` protegido |
| `03_s06_vistas.sql` | S06 | Vistas de ventas por categoría/mes y clientes sin compra en 2026 |
| `04_s07_datos_prueba.sql` | S07 | Generación masiva de pedidos y detalles (`WHILE` + `CURSOR`) |
| `05_s07_reporte_clientes.sql` | S07 | Reporte de pedidos y monto vendido por cliente en 2026 |

## 🗄️ Modelo de Datos y Restricciones

La base de datos **`NovaMarket_EP02`** consta de 5 tablas relacionadas:

```mermaid
erDiagram
    CATEGORIA ||--o{ PRODUCTO : clasifica
    CLIENTE ||--o{ PEDIDO : realiza
    PEDIDO ||--o{ DETALLEPEDIDO : contiene
    PRODUCTO ||--o{ DETALLEPEDIDO : "aparece en"

    CATEGORIA {
        int CategoriaID PK
        varchar Nombre UK
    }
    CLIENTE {
        int ClienteID PK
        varchar Documento UK
        varchar Nombre
        varchar Ciudad
        bit Activo
    }
    PRODUCTO {
        int ProductoID PK
        int CategoriaID FK
        varchar Nombre
        decimal PrecioLista
        decimal PrecioOferta
        int Stock
        bit Activo
    }
    PEDIDO {
        int PedidoID PK
        int ClienteID FK
        date FechaPedido
        varchar Estado
        varchar Canal
    }
    DETALLEPEDIDO {
        int DetalleID PK
        int PedidoID FK
        int ProductoID FK
        int Cantidad
        decimal PrecioUnitario
    }
```

### 1. Tabla `Categoria` 🟣
* **Propósito:** Clasifica los productos del catálogo.
* **Campos:** `CategoriaID` (**PK**, `IDENTITY`), `Nombre` (`UNIQUE`, `NOT NULL`).
* **Relación:** Una categoría tiene **muchos** productos (1 a N).

### 2. Tabla `Cliente` 🟢
* **Propósito:** Almacena a los compradores registrados.
* **Campos:** `ClienteID` (**PK**, `IDENTITY`), `Documento` (`UNIQUE`, `NOT NULL`), `Nombre`, `Ciudad`, `Activo` (`DEFAULT 1`).
* **Relación:** Un cliente puede realizar **muchos** pedidos (1 a N).

### 3. Tabla `Producto` 🔵
* **Propósito:** Catálogo de productos de redes, seguridad y accesorios.
* **Campos:** `ProductoID` (**PK**, `IDENTITY`), `CategoriaID` (**FK**), `Nombre`, `PrecioLista`, `PrecioOferta` (acepta `NULL`), `Stock`, `Activo` (`DEFAULT 1`).
* **Relación:** Pertenece a una categoría y puede aparecer en **muchos** detalles de pedido.

### 4. Tabla `Pedido` 🟠
* **Propósito:** Cabecera de cada pedido realizado por un cliente.
* **Campos:** `PedidoID` (**PK**, `IDENTITY`), `ClienteID` (**FK**), `FechaPedido`, `Estado`, `Canal`.
* **Restricción:** `CHECK` en `Estado` → solo admite `CONFIRMADO`, `PENDIENTE`, `ANULADO` o `BORRADOR`.
* **Relación:** Pertenece a un cliente y contiene **muchos** detalles.

### 5. Tabla `DetallePedido` 🔴
* **Propósito:** Detalle línea por línea de cada pedido; resuelve la relación **muchos a muchos** entre `Pedido` y `Producto`.
* **Campos:** `DetalleID` (**PK**, `IDENTITY`), `PedidoID` (**FK**), `ProductoID` (**FK**), `Cantidad`, `PrecioUnitario` (precio al momento de la venta).

📦 Datos base cargados (00_esquema_y_datos_base.sql)
- Primero creamos la date de base y la usamos para esta ocasión hemos decidido llamarlo NovaMarket_EP02
<img width="806" height="577" alt="image" src="https://github.com/user-attachments/assets/6a469d79-da4b-4353-8a91-867023a72aa3" />
- Creamos las tablas con sus restricciones:
<img width="1485" height="780" alt="image" src="https://github.com/user-attachments/assets/e7c6dcc5-d630-442e-a333-37ed1bb0b4b9" />
- Insertamos los datos
<img width="1368" height="814" alt="image" src="https://github.com/user-attachments/assets/9a3dcd48-fd7f-483c-98d2-517827c1e0e5" />
- Verificamos nuestros datos:

<img width="991" height="301" alt="image" src="https://github.com/user-attachments/assets/665fd98e-8f8a-41d0-84b7-ee75e5b1d6a3" />
Tenemos lo siguiente: 

Tabla	Registros
Categoria	3 (Redes, Seguridad, Accesorios)
Cliente	15
Producto	12
Pedido	40 (23 CONFIRMADO, 5 PENDIENTE, 2 ANULADO y 10 BORRADOR; canales Web, Tienda y Teléfono)
DetallePedido	80 (4 líneas por cada pedido del 1 al 20; los pedidos 21 al 40 no tienen detalle)

Al final, el script ejecuta una verificación de volumen que cuenta los registros de Cliente, Producto, Pedido y DetallePedido.



## 🔎 Resumen de Scripts

### 🔹 `01_s04_subconsultas.sql` — Subconsultas

* **Consulta 1: `EXISTS` + `NOT EXISTS`.** Clientes que compraron al menos un producto de **Redes** en un pedido `CONFIRMADO` de 2026 y que **no** tienen compras confirmadas de **Seguridad** en 2026. Con los datos base devuelve a *Juan Pérez* y *María Gómez*.
<img width="1128" height="726" alt="image" src="https://github.com/user-attachments/assets/ec537cd0-c71d-4fbe-befc-055cf0b25e20" />


* **Consulta 2: subconsulta escalar.** Productos cuyo `PrecioLista` supera el promedio de su propia categoría (se muestra también el promedio de la categoría). Con los datos base devuelve 6 productos: Switch Administrable 24P, Access Point Wi-Fi 6, Kit de Alarma Residencial, Grabador NVR 8 Canales, Teclado Mecánico RGB y Audífonos Gamer.
<img width="729" height="669" alt="image" src="https://github.com/user-attachments/assets/0941e39f-5a15-4f85-b6f1-311c809fb224" />

### 🔹 `02_s05_mantenimiento.sql` — Mantenimiento de datos

Cada operación incluye una **validación PRE-ejecución** y una **validación POST-ejecución**.

* **A. Carga histórica idempotente.** Crea (si no existe) la tabla `PedidoHistorico2025` y copia los pedidos `CONFIRMADO` anteriores al 01/01/2026. El `NOT EXISTS` evita duplicados si el script se vuelve a ejecutar. Con los datos base se cargan 3 filas.
<img width="1324" height="763" alt="image" src="https://github.com/user-attachments/assets/76657929-1a86-4cc0-a1e2-03bdf224b52c" />


* **B. `UPDATE` condicionado.** Asigna `PrecioOferta = ROUND(PrecioLista * 0.90, 2)` (10 % de descuento) a los productos de **Redes** que estén activos y con `Stock >= 10`. Al calcularse siempre sobre `PrecioLista`, es idempotente: no aplica el descuento de forma acumulativa.
<img width="834" height="196" alt="image" src="https://github.com/user-attachments/assets/7b21be99-5540-47cd-9c67-89c24fcffe15" />
<img width="1010" height="754" alt="image" src="https://github.com/user-attachments/assets/d5f9f7f3-d8cb-4166-b81b-aeb600c82409" />

* **C. `DELETE` protegido.** Elimina únicamente los pedidos en estado `BORRADOR` **sin detalle** (`NOT IN` sobre `DetallePedido`). Con los datos base elimina 2 pedidos y no afecta a ningún otro estado.
<img width="1470" height="827" alt="image" src="https://github.com/user-attachments/assets/4f14f70b-d0e5-48c2-b03f-957f6ea3f7b2" />

### 🔹 `03_s06_vistas.sql` — Vistas

* **`vw_VentasCategoriaMes`:** ventas **confirmadas** agrupadas por año, mes y categoría, con total de unidades y monto total. Se consulta filtrando 2026 y ordenando por mes y monto.
<img width="652" height="394" alt="image" src="https://github.com/user-attachments/assets/1a891fce-3c59-4d86-8217-95310199873d" />
<img width="1600" height="820" alt="image" src="https://github.com/user-attachments/assets/27cbe072-f027-4065-ac0e-cb7e8eec5c6d" />

* **`vw_ClientesSinCompra2026`:** clientes sin ningún pedido `CONFIRMADO` dentro de 2026 (`NOT EXISTS`). Se incluye una consulta equivalente con `LEFT JOIN ... IS NULL` para **contrastar** ambos enfoques.
<img width="948" height="544" alt="image" src="https://github.com/user-attachments/assets/5e335546-acc5-486f-a9d4-e160e7c00c15" />
<img width="1037" height="563" alt="image" src="https://github.com/user-attachments/assets/f502daf4-09a4-4fdd-8846-24a5dd7361e5" />


### 🔹 `04_s07_datos_prueba.sql` — Datos de prueba masivos

* **Bloque 1 (`WHILE`):** inserta pedidos hasta que la tabla `Pedido` llegue a **205 registros**, repartiendo clientes de forma cíclica, fechas entre 2025 y 2026, canales (`Web` / `Tienda Física`) y estados según múltiplos (`BORRADOR`, `ANULADO`, `PENDIENTE`, `CONFIRMADO`).
  <img width="1475" height="816" alt="image" src="https://github.com/user-attachments/assets/08d522b8-cfe0-4a36-b69b-49a58f6ba7b9" />

* **Bloque 2 (`CURSOR`):** recorre los pedidos (excepto los borradores de ID impar) e inserta **2 líneas de detalle** por pedido, tomando `PrecioLista` como `PrecioUnitario`.
  <img width="1483" height="843" alt="image" src="https://github.com/user-attachments/assets/1aab50a0-ebfd-4a49-9e9b-ead28b118510" />

* **Verificación:** conteo de registros por tabla y distribución de pedidos por año y estado.
<img width="1009" height="590" alt="image" src="https://github.com/user-attachments/assets/0bb48d25-a09a-4ae1-a326-15b3d164a04f" />

### 🔹 `05_s07_reporte_clientes.sql` — Reporte de clientes

Reporte por cliente **activo** con el total de pedidos confirmados en 2026 (`COUNT(DISTINCT PedidoID)`) y el monto vendido (`SUM(Cantidad * PrecioUnitario)`). Se usan `LEFT JOIN` para no perder a los clientes sin compras, que aparecen con `0` pedidos y `0.00` de monto gracias a `ISNULL`.
<img width="1002" height="602" alt="image" src="https://github.com/user-attachments/assets/d30de542-4449-4af3-bbd3-d2b87a8228c6" />




## 🛠️ Tecnologías

* SQL Server (T-SQL)
* SQL Server Management Studio (SSMS)
* Git y GitHub
