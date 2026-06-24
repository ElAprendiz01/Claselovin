USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Permisos_Opciones_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        P.Id_Permiso,
        P.Id_Rol,
        R.Nombre AS Nombre_Rol,
        P.Modulo,
        P.Puede_Crear,
        P.Puede_Leer,
        P.Puede_Actualizar,
        P.Puede_Eliminar,
        P.Fecha_Creacion,
        P.Id_Creador
    FROM Tbl_Permisos_Opciones P (NOLOCK)
    INNER JOIN Tbl_Roles R (NOLOCK) ON P.Id_Rol = R.Id_Rol;
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Permisos_Opciones_Listar;
GO
