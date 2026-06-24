USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Usuario,
        Usuario,
        Id_Persona,
        Nombre_Completo,
        DNI,
        Id_Rol,
        Nombre_Rol,
        Id_Estado_Usuario AS Id_Estado,
        Estado_Usuario AS Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Usuarios_Personal_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Usuarios_Listar;
GO
