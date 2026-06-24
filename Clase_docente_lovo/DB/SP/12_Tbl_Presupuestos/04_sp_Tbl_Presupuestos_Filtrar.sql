USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Presupuestos_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Presupuesto INT = NULL,
    @Anio_Fiscal INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
    SELECT 
        P.Id_Presupuesto,
        P.Anio_Fiscal,
        P.Id_Moneda,
        M.Codigo_ISO,
        M.Nombre_Moneda,
        M.Simbolo,
        P.Descripcion,
        P.Id_Estado,
        E.Estado AS Nombre_Estado,
        P.Id_Creador,
        P.Id_Modificador,
        P.Fecha_Creacion,
        P.Fecha_Modificacion
    FROM Tbl_Presupuestos P (NOLOCK)
    INNER JOIN Cat_Monedas M (NOLOCK) ON P.Id_Moneda = M.Id_Moneda
    INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR P.Descripcion LIKE '%' + @SearchTerm + '%'
        OR M.Codigo_ISO LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND P.Anio_Fiscal = TRY_CAST(@SearchTerm AS INT)
        )
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND P.Id_Presupuesto = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Presupuesto IS NULL OR P.Id_Presupuesto = @Id_Presupuesto)
    AND (@Anio_Fiscal IS NULL OR P.Anio_Fiscal = @Anio_Fiscal)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Presupuestos_Filtrar;
GO

EXEC sp_Tbl_Presupuestos_Filtrar @SearchTerm = '2026';
GO

EXEC sp_Tbl_Presupuestos_Filtrar @Id_Presupuesto = 1;
GO
