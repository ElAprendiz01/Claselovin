USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Usuario INT = NULL,
    @Id_Rol INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
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
    FROM VW_Usuarios_Personal_General (NOLOCK)

	 WHERE (
			@SearchTerm IS NULL
			OR Usuario LIKE '%' + @SearchTerm + '%'
			OR Nombre_Completo LIKE '%' + @SearchTerm + '%'
			OR Nombre_Rol LIKE '%' + @SearchTerm + '%'
			OR DNI LIKE '%' + @SearchTerm + '%' 
			OR (
				TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
				AND Id_Usuario = TRY_CAST(@SearchTerm AS INT)
			)
		)
		AND (@Id_Usuario IS NULL OR Id_Usuario = @Id_Usuario)
		AND (@Id_Rol IS NULL OR Id_Rol = @Id_Rol)
		OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Usuarios_Filtrar;
GO

EXEC sp_Tbl_Usuarios_Filtrar @SearchTerm = 'admin';
GO

EXEC sp_Tbl_Usuarios_Filtrar @Id_Usuario = 1;
GO
