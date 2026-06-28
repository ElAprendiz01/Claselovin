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
 SELECT 
        Id_Presupuesto,
        Anio_Fiscal,
        Id_Moneda,
        Codigo_ISO,
        Nombre_Moneda,
        Simbolo,
        Descripcion,
        Id_Estado,
        Nombre_Estado,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Presupuestos_Cabecera_General (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Descripcion LIKE '%' + @SearchTerm + '%'
        OR Codigo_ISO LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Anio_Fiscal = TRY_CAST(@SearchTerm AS INT)
        )
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Presupuesto = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Presupuesto IS NULL OR Id_Presupuesto = @Id_Presupuesto)
    AND (@Anio_Fiscal IS NULL OR Anio_Fiscal = @Anio_Fiscal)
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
