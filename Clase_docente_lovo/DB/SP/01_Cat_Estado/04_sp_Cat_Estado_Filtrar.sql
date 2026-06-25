USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Estado_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Estado INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        Id_Estado,
        Estado,
        Fecha_Creacion,
        Fecha_Modificacion,
        Id_Creador,
        Id_Modificador,
        Activo
    FROM Cat_Estado (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Estado LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Estado = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Estado IS NULL OR Id_Estado = @Id_Estado)
	AND Activo = 1
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Estado_Filtrar;
GO

EXEC sp_Cat_Estado_Filtrar @SearchTerm = 'A';
GO

EXEC sp_Cat_Estado_Filtrar @Id_Estado = 1;
GO
