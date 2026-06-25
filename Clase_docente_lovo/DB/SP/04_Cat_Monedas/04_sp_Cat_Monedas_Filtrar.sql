USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Monedas_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Moneda INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        Id_Moneda,
        Codigo_ISO,
        Nombre_Moneda,
        Simbolo,
        Activo
    FROM Cat_Monedas (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Codigo_ISO LIKE '%' + @SearchTerm + '%'
        OR Nombre_Moneda LIKE '%' + @SearchTerm + '%'
        OR Simbolo LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Moneda = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Moneda IS NULL OR Id_Moneda = @Id_Moneda)
	ANd Activo =1
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Cat_Monedas_Filtrar;
GO

EXEC sp_Cat_Monedas_Filtrar @SearchTerm = 'USD';
GO

EXEC sp_Cat_Monedas_Filtrar @Id_Moneda = 1;
GO
