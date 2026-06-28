USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Gastos_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Gasto INT = NULL,
    @Id_Presupuesto_Detalle INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

       SELECT 
        Id_Gasto,
        Descripcion_Gasto,
        Monto_Gasto,
        Fecha_Gasto,
        Numero_Factura,
        Id_Proveedor,
        Proveedor,
        Id_Tipo_Gasto,
        Tipo_Gasto,
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Nombre_Centro,
        Nombre_Departamento,
        Id_Estado_Gasto AS Id_Estado,
        Estado_Gasto AS Nombre_Estado,
        Id_Creador,
        Fecha_Creacion
    FROM VW_Gastos_Transaccionales_General (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Descripcion_Gasto LIKE '%' + @SearchTerm + '%'
        OR Numero_Factura LIKE '%' + @SearchTerm + '%'
        OR Tipo_Gasto LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Gasto = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Gasto IS NULL OR Id_Gasto = @Id_Gasto)
    AND (@Id_Presupuesto_Detalle IS NULL OR Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Gastos_Filtrar;
GO

EXEC sp_Tbl_Gastos_Filtrar @SearchTerm = 'AWS';
GO

EXEC sp_Tbl_Gastos_Filtrar @Id_Gasto = 1;
GO
