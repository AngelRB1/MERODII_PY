USE [master]
GO
/****** Object:  Database [MerodiiDB]    Script Date: 11/05/2025 06:29:45 p. m. ******/
CREATE DATABASE [MerodiiDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MerodiiDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MerodiiDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MerodiiDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MerodiiDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MerodiiDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MerodiiDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MerodiiDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MerodiiDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MerodiiDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MerodiiDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MerodiiDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MerodiiDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MerodiiDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MerodiiDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MerodiiDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MerodiiDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MerodiiDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MerodiiDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MerodiiDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MerodiiDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MerodiiDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MerodiiDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MerodiiDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MerodiiDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MerodiiDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MerodiiDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MerodiiDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MerodiiDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MerodiiDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MerodiiDB] SET  MULTI_USER 
GO
ALTER DATABASE [MerodiiDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MerodiiDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MerodiiDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MerodiiDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MerodiiDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MerodiiDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MerodiiDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [MerodiiDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MerodiiDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_UsuarioTienePermiso]    Script Date: 11/05/2025 06:29:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_UsuarioTienePermiso](
    @UsuarioID INT,
    @CodigoPermiso NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @TienePermiso BIT = 0;
    
    IF EXISTS (
        SELECT 1
        FROM Usuario u
        JOIN UsuarioRol ur ON u.UsuarioID = ur.UsuarioID AND ur.Activo = 1
        JOIN Rol r ON ur.RolID = r.RolID AND r.Activo = 1
        JOIN RolPermiso rp ON r.RolID = rp.RolID
        JOIN Permiso p ON rp.PermisoID = p.PermisoID AND p.Activo = 1
        WHERE u.UsuarioID = @UsuarioID
          AND p.Codigo = @CodigoPermiso
          AND u.Activo = 1
    )
    BEGIN
        SET @TienePermiso = 1;
    END
    
    RETURN @TienePermiso;
END
GO
/****** Object:  Table [dbo].[Rol]    Script Date: 11/05/2025 06:29:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rol](
	[RolID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[HashContrasena] [nvarchar](255) NOT NULL,
	[Salt] [nvarchar](255) NOT NULL,
	[NombreCompleto] [nvarchar](100) NULL,
	[FotoPerfil] [nvarchar](255) NULL,
	[Biografia] [nvarchar](500) NULL,
	[FechaRegistro] [datetime] NOT NULL,
	[UltimoAcceso] [datetime] NULL,
	[Activo] [bit] NOT NULL,
	[EmailVerificado] [bit] NOT NULL,
	[CodigoVerificacion] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioRol]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioRol](
	[UsuarioID] [int] NOT NULL,
	[RolID] [int] NOT NULL,
	[FechaAsignacion] [datetime] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_UsuarioRol] PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC,
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_UsuariosConRoles]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_UsuariosConRoles] AS
SELECT 
    u.UsuarioID,
    u.NombreUsuario,
    u.Email,
    u.NombreCompleto,
    r.RolID,
    r.Nombre AS NombreRol,
    ur.FechaAsignacion
FROM Usuario u
LEFT JOIN UsuarioRol ur ON u.UsuarioID = ur.UsuarioID AND ur.Activo = 1
LEFT JOIN Rol r ON ur.RolID = r.RolID;
GO
/****** Object:  Table [dbo].[Permiso]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permiso](
	[PermisoID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PermisoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolPermiso]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolPermiso](
	[RolPermisoID] [int] IDENTITY(1,1) NOT NULL,
	[RolID] [int] NOT NULL,
	[PermisoID] [int] NOT NULL,
	[FechaAsignacion] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RolPermisoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_RolPermiso] UNIQUE NONCLUSTERED 
(
	[RolID] ASC,
	[PermisoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_PermisosUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PermisosUsuario] AS
SELECT 
    u.UsuarioID,
    u.NombreUsuario,
    r.Nombre AS Rol,
    p.Codigo AS CodigoPermiso,
    p.Nombre AS NombrePermiso
FROM Usuario u
JOIN UsuarioRol ur ON u.UsuarioID = ur.UsuarioID AND ur.Activo = 1
JOIN Rol r ON ur.RolID = r.RolID AND r.Activo = 1
JOIN RolPermiso rp ON r.RolID = rp.RolID
JOIN Permiso p ON rp.PermisoID = p.PermisoID AND p.Activo = 1
WHERE u.Activo = 1;
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Permiso_Codigo]    Script Date: 11/05/2025 06:29:46 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_Permiso_Codigo] ON [dbo].[Permiso]
(
	[Codigo] ASC
)
WHERE ([Activo]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_RolPermiso_Rol]    Script Date: 11/05/2025 06:29:46 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_RolPermiso_Rol] ON [dbo].[RolPermiso]
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UsuarioRol_Rol]    Script Date: 11/05/2025 06:29:46 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_UsuarioRol_Rol] ON [dbo].[UsuarioRol]
(
	[RolID] ASC
)
WHERE ([Activo]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UsuarioRol_Usuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_UsuarioRol_Usuario] ON [dbo].[UsuarioRol]
(
	[UsuarioID] ASC
)
WHERE ([Activo]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permiso] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Rol] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Rol] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  DEFAULT (getdate()) FOR [FechaAsignacion]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT ((0)) FOR [EmailVerificado]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  DEFAULT (getdate()) FOR [FechaAsignacion]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Permiso] FOREIGN KEY([PermisoID])
REFERENCES [dbo].[Permiso] ([PermisoID])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Permiso]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Rol] FOREIGN KEY([RolID])
REFERENCES [dbo].[Rol] ([RolID])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Rol]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Rol] FOREIGN KEY([RolID])
REFERENCES [dbo].[Rol] ([RolID])
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Rol]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Usuario] FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuario] ([UsuarioID])
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Usuario]
GO
/****** Object:  StoredProcedure [dbo].[sp_AsignarRolUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AsignarRolUsuario]
    @UsuarioID INT,
    @RolID INT,
    @AdminID INT -- Este parámetro puede ser usado para auditoría futura
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar si ya tiene el rol activo
        IF EXISTS (
            SELECT 1 
            FROM dbo.UsuarioRol 
            WHERE UsuarioID = @UsuarioID AND RolID = @RolID AND Activo = 1
        )
        BEGIN
            RETURN 0; -- Ya tiene el rol activo
        END

        -- Si existe pero está inactivo, reactivarlo
        IF EXISTS (
            SELECT 1 
            FROM dbo.UsuarioRol 
            WHERE UsuarioID = @UsuarioID AND RolID = @RolID AND Activo = 0
        )
        BEGIN
            UPDATE dbo.UsuarioRol
            SET Activo = 1,
                FechaAsignacion = GETDATE()
            WHERE UsuarioID = @UsuarioID AND RolID = @RolID;

            RETURN 1; -- Éxito al reactivar
        END

        -- Insertar nuevo registro de rol
        INSERT INTO dbo.UsuarioRol (UsuarioID, RolID, FechaAsignacion)
        VALUES (@UsuarioID, @RolID, GETDATE());

        RETURN 1; -- Éxito al insertar nuevo
    END TRY
    BEGIN CATCH
        -- Opcional: puedes registrar el error en una tabla de auditoría
        PRINT 'Error al asignar rol al usuario: ' + ERROR_MESSAGE();
        RETURN -1; -- Error
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerPermisosUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerPermisosUsuario]
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT p.PermisoID, p.Nombre, p.Descripcion, p.Codigo
    FROM Permiso p
    JOIN RolPermiso rp ON p.PermisoID = rp.PermisoID
    JOIN Rol r ON rp.RolID = r.RolID
    JOIN UsuarioRol ur ON r.RolID = ur.RolID
    WHERE ur.UsuarioID = @UsuarioID
      AND ur.Activo = 1
      AND r.Activo = 1
      AND p.Activo = 1
    ORDER BY p.Nombre;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerRolesUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerRolesUsuario]
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT r.RolID, r.Nombre, r.Descripcion, ur.FechaAsignacion
    FROM Rol r
    JOIN UsuarioRol ur ON r.RolID = ur.RolID
    WHERE ur.UsuarioID = @UsuarioID AND ur.Activo = 1 AND r.Activo = 1
    ORDER BY r.Nombre;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_QuitarRolUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_QuitarRolUsuario]
    @UsuarioID INT,
    @RolID INT,
    @AdminID INT -- Aunque no se usa para auditoría, lo puedes usar para futuras modificaciones si es necesario
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar si el usuario tiene el rol activo
        IF NOT EXISTS (SELECT 1 FROM dbo.UsuarioRol WHERE UsuarioID = @UsuarioID AND RolID = @RolID AND Activo = 1)
        BEGIN
            RETURN 0; -- No tiene el rol activo
        END

        -- Desactivar el rol
        UPDATE dbo.UsuarioRol
        SET Activo = 0
        WHERE UsuarioID = @UsuarioID AND RolID = @RolID;

        RETURN 1; -- Éxito
    END TRY
    BEGIN CATCH
        PRINT 'Error al quitar rol de usuario: ' + ERROR_MESSAGE();
        RETURN -1; -- Error
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VerificarPermisoUsuario]    Script Date: 11/05/2025 06:29:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VerificarPermisoUsuario]
    @UsuarioID INT,
    @CodigoPermiso NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TienePermiso BIT = 0;

    SELECT @TienePermiso = 1
    FROM dbo.Usuario u
    JOIN dbo.UsuarioRol ur ON u.UsuarioID = ur.UsuarioID AND ur.Activo = 1
    JOIN dbo.Rol r ON ur.RolID = r.RolID AND r.Activo = 1
    JOIN dbo.RolPermiso rp ON r.RolID = rp.RolID
    JOIN dbo.Permiso p ON rp.PermisoID = p.PermisoID AND p.Activo = 1
    WHERE u.UsuarioID = @UsuarioID
      AND p.Codigo = @CodigoPermiso
      AND u.Activo = 1;

    SELECT @TienePermiso AS TienePermiso;
END
GO
USE [master]
GO
ALTER DATABASE [MerodiiDB] SET  READ_WRITE 
GO
