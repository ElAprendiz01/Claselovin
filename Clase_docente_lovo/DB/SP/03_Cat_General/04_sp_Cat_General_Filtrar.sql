USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_General_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Catalogo INT = NULL,
    @Id_Tipo_Catalogo INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        G.Id_Catalogo,
        G.Id_Tipo_Catalogo,
        T.Nombre AS Tipo_Catalogo,
        G.Nombre,
        G.Fecha_Creacion,
        G.Fecha_Modificacion,
        G.Id_Creador,
        G.Id_Modificador,
        G.Activo
    FROM Cat_General G (NOLOCK)
    INNER JOIN Cat_Tipo_Catalogo T (NOLOCK) ON G.Id_Tipo_Catalogo = T.Id_Tipo_Catalogo
    WHERE (
        @SearchTerm IS NULL
        OR G.Nombre LIKE '%' + @SearchTerm + '%'
        OR T.Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND G.Id_Catalogo = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Catalogo IS NULL OR G.Id_Catalogo = @Id_Catalogo)
    AND (@Id_Tipo_Catalogo IS NULL OR G.Id_Tipo_Catalogo = @Id_Tipo_Catalogo)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_General_Filtrar;
GO

EXEC sp_Cat_General_Filtrar @SearchTerm = 'Masculino';
GO

EXEC sp_Cat_General_Filtrar @Id_Tipo_Catalogo = 1;
GO
