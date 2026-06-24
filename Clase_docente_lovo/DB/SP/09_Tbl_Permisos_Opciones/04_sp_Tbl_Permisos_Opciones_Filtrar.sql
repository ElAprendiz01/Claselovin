USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Permisos_Opciones_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Permiso INT = NULL,
    @Id_Rol INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
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
    INNER JOIN Tbl_Roles R (NOLOCK) ON P.Id_Rol = R.Id_Rol
    WHERE (
        @SearchTerm IS NULL
        OR P.Modulo LIKE '%' + @SearchTerm + '%'
        OR R.Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND P.Id_Permiso = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Permiso IS NULL OR P.Id_Permiso = @Id_Permiso)
    AND (@Id_Rol IS NULL OR P.Id_Rol = @Id_Rol)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Permisos_Opciones_Filtrar;
GO

EXEC sp_Tbl_Permisos_Opciones_Filtrar @SearchTerm = 'Gastos';
GO

EXEC sp_Tbl_Permisos_Opciones_Filtrar @Id_Rol = 2;
GO
