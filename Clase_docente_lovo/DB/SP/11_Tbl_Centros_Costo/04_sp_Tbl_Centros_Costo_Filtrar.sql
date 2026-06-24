USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Centros_Costo_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Centro_Costo INT = NULL,
    @Id_Departamento INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        CC.Id_Centro_Costo,
        CC.Id_Departamento,
        D.Nombre_Departamento,
        CC.Nombre_Centro,
        CC.Codigo_Contable,
        CC.Id_Estado,
        E.Estado AS Nombre_Estado,
        CC.Id_Creador,
        CC.Id_Modificador,
        CC.Fecha_Creacion,
        CC.Fecha_Modificacion
    FROM Tbl_Centros_Costo CC (NOLOCK)
    INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
    INNER JOIN Cat_Estado E (NOLOCK) ON CC.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR CC.Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR CC.Codigo_Contable LIKE '%' + @SearchTerm + '%'
        OR D.Nombre_Departamento LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND CC.Id_Centro_Costo = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Centro_Costo IS NULL OR CC.Id_Centro_Costo = @Id_Centro_Costo)
    AND (@Id_Departamento IS NULL OR CC.Id_Departamento = @Id_Departamento)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Centros_Costo_Filtrar;
GO

EXEC sp_Tbl_Centros_Costo_Filtrar @SearchTerm = 'Cloud';
GO

EXEC sp_Tbl_Centros_Costo_Filtrar @Id_Departamento = 1;
GO
