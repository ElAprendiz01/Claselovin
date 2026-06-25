USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Roles_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        R.Id_Rol,
        R.Nombre,
        R.Descripcion,
        R.Fecha_Creacion,
        R.Fecha_Modificacion,
        R.Id_Creador,
        R.Id_Modificador,
        R.Id_Estado,
        E.Estado AS Nombre_Estado
    FROM Tbl_Roles R (NOLOCK)
    INNER JOIN Cat_Estado E (NOLOCK) ON R.Id_Estado = E.Id_Estado
    WHERE R.Id_Estado NOT IN (
        SELECT Id_Estado 
        FROM Cat_Estado (NOLOCK)
        WHERE Estado LIKE '%Inactivo%'
           OR Estado LIKE '%Eliminado%'
           OR Estado LIKE '%Desactivado%'
           OR Estado LIKE '%Baja%'
    );
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Roles_Listar;
GO