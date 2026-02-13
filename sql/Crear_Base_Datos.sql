USE TallerTextilDB;
GO

-----------------------------------------------------------
-- 1. TABLAS BASE (Sin llaves foráneas de otras tablas)
-----------------------------------------------------------

-- Tabla: Cliente
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Cliente](
        [id_cliente] INT PRIMARY KEY IDENTITY(1,1),
        [Nombre] NVARCHAR(150) NOT NULL,
        [Telefono] NVARCHAR(20),
        [Direccion] NVARCHAR(255)
    );
END
GO

-- Tabla: Material
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Material]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Material](
        [id_material] INT PRIMARY KEY IDENTITY(1,1),
        [nombre] NVARCHAR(100) NOT NULL,
        [tipo] NVARCHAR(50),
        [unidad] NVARCHAR(20)
    );
END
GO

-- Tabla: Empleado
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empleado]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Empleado](
        [id_empleado] INT PRIMARY KEY IDENTITY(1,1),
        [nombre] NVARCHAR(150) NOT NULL,
        [tipo] NVARCHAR(50),
        [salario_base] DECIMAL(18,2)
    );
END
GO

-----------------------------------------------------------
-- 2. TABLAS DE PROCESO (Con dependencias)
-----------------------------------------------------------

-- Tabla: Pedido
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Pedido](
        [id_pedido] INT PRIMARY KEY IDENTITY(1,1),
        [id_cliente] INT NOT NULL,
        [fecha_pedido] DATETIME DEFAULT GETDATE(),
        [fecha_entrega] DATETIME,
        CONSTRAINT FK_Pedido_Cliente FOREIGN KEY ([id_cliente]) REFERENCES [dbo].[Cliente]([id_cliente])
    );
END
GO

-- Tabla: Pago
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pago]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Pago](
        [id_pago] INT PRIMARY KEY IDENTITY(1,1),
        [id_pedido] INT NOT NULL,
        [fecha_pago] DATETIME DEFAULT GETDATE(),
        [monto] DECIMAL(18,2) NOT NULL,
        CONSTRAINT FK_Pago_Pedido FOREIGN KEY ([id_pedido]) REFERENCES [dbo].[Pedido]([id_pedido])
    );
END
GO

-- Tabla: Detalle_pedido
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Detalle_pedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Detalle_pedido](
        [id_detalle] INT PRIMARY KEY IDENTITY(1,1),
        [id_pedido] INT NOT NULL,
        [modelo] NVARCHAR(100),
        [talla] NVARCHAR(10),
        [color] NVARCHAR(30),
        CONSTRAINT FK_Detalle_Pedido FOREIGN KEY ([id_pedido]) REFERENCES [dbo].[Pedido]([id_pedido])
    );
END
GO

-- Tabla: Orden_produccion
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orden_produccion]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Orden_produccion](
        [id_orden] INT PRIMARY KEY IDENTITY(1,1),
        [id_pedido] INT NOT NULL,
        [Fecha_inicio] DATETIME,
        [Fecha_fin] DATETIME,
        CONSTRAINT FK_Orden_Pedido FOREIGN KEY ([id_pedido]) REFERENCES [dbo].[Pedido]([id_pedido])
    );
END
GO

-- Tabla: movimiento_inventario
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[movimiento_inventario]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[movimiento_inventario](
        [id_movimiento] INT PRIMARY KEY IDENTITY(1,1),
        [id_material] INT NOT NULL,
        [cantidad] DECIMAL(18,2) NOT NULL,
        [fechas] DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Movimiento_Material FOREIGN KEY ([id_material]) REFERENCES [dbo].[Material]([id_material])
    );
END
GO

-----------------------------------------------------------
-- 3. TABLAS DE ASIGNACIÓN Y USO (Relaciones N:M o Detalle)
-----------------------------------------------------------

-- Tabla: Uso_material_en_orden
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Uso_material_en_orden]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Uso_material_en_orden](
        [id_uso] INT PRIMARY KEY IDENTITY(1,1),
        [id_orden] INT NOT NULL,
        [id_material] INT NOT NULL,
        [cantidad_usada] DECIMAL(18,2) NOT NULL,
        CONSTRAINT FK_Uso_Orden FOREIGN KEY ([id_orden]) REFERENCES [dbo].[Orden_produccion]([id_orden]),
        CONSTRAINT FK_Uso_Material FOREIGN KEY ([id_material]) REFERENCES [dbo].[Material]([id_material])
    );
END
GO

-- Tabla: Asignacion_Produccion
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Asignacion_Produccion]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Asignacion_Produccion](
        [id_asignacion] INT PRIMARY KEY IDENTITY(1,1),
        [id_orden] INT NOT NULL,
        [id_empleado] INT NOT NULL,
        [cantidad_trabajada] INT,
        CONSTRAINT FK_Asignacion_Orden FOREIGN KEY ([id_orden]) REFERENCES [dbo].[Orden_produccion]([id_orden]),
        CONSTRAINT FK_Asignacion_Empleado FOREIGN KEY ([id_empleado]) REFERENCES [dbo].[Empleado]([id_empleado])
    );
END
GO
