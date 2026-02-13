
-- 1. Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TallerTextilDB')
BEGIN
    CREATE DATABASE TallerTextilDB;
END
GO

USE TallerTextilDB;
GO

-- 2. Tabla: Categorias
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categorias]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Categorias](
        [ID] INT PRIMARY KEY IDENTITY(1,1),
        [Nombre] NVARCHAR(100) NOT NULL
    );
END
GO

-- 3. Tabla: Productos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Productos](
        [ID] INT PRIMARY KEY IDENTITY(1,1),
        [Nombre] NVARCHAR(150) NOT NULL,
        [Precio] DECIMAL(18, 2) NOT NULL,
        [CategoriaID] INT,
        CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaID) 
            REFERENCES [dbo].[Categorias]([ID])
    );
END
GO

-- 4. Tabla: Clientes
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Clientes](
        [ID] INT PRIMARY KEY IDENTITY(1,1),
        [NombreCompleto] NVARCHAR(200) NOT NULL,
        [Email] NVARCHAR(100) NULL,
        [Telefono] NVARCHAR(20) NULL
    );
END
GO

-- 5. Tabla: Pedidos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Pedidos](
        [ID] INT PRIMARY KEY IDENTITY(1,1),
        [Fecha] DATETIME DEFAULT GETDATE(),
        [ClienteID] INT,
        [Total] DECIMAL(18,2),
        CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (ClienteID) 
            REFERENCES [dbo].[Clientes]([ID])
    );
END
GO
