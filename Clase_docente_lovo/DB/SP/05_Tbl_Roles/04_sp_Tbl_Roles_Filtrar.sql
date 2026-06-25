USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Roles_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Rol INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
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
    WHERE (
        @SearchTerm IS NULL
        OR R.Nombre LIKE '%' + @SearchTerm + '%'
        OR R.Descripcion LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND R.Id_Rol = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Rol IS NULL OR R.Id_Rol = @Id_Rol)
	AND R.Id_Estado NOT IN (
        SELECT Id_Estado 
        FROM Cat_Estado (NOLOCK)
        WHERE Estado LIKE '%Inactivo%'
           OR Estado LIKE '%Eliminado%'
           OR Estado LIKE '%Desactivado%'
           OR Estado LIKE '%Baja%'
		   )
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Roles_Filtrar;
GO

EXEC sp_Tbl_Roles_Filtrar @SearchTerm = 'Admin';
GO

EXEC sp_Tbl_Roles_Filtrar @Id_Rol = 1;
GO
