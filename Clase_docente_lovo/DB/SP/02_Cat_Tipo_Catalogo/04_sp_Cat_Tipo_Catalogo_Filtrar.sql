USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Tipo_Catalogo_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Tipo_Catalogo INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        Id_Tipo_Catalogo,
        Nombre,
        Fecha_Creacion,
        Fecha_Modificacion,
        Id_Creador,
        Id_Modificador,
        Activo
    FROM Cat_Tipo_Catalogo (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Tipo_Catalogo = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Tipo_Catalogo IS NULL OR Id_Tipo_Catalogo = @Id_Tipo_Catalogo)
	and Activo = 1
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Tipo_Catalogo_Filtrar;
GO

EXEC sp_Cat_Tipo_Catalogo_Filtrar @SearchTerm = 'G';
GO

EXEC sp_Cat_Tipo_Catalogo_Filtrar @Id_Tipo_Catalogo = 1;
GO
