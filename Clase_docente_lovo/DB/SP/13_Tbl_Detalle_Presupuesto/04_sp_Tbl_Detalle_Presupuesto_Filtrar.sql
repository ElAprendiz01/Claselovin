USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Detalle_Presupuesto_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Presupuesto_Detalle INT = NULL,
    @Id_Presupuesto INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar datos con filtros
     SELECT 
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Id_Centro_Costo,
        Nombre_Centro,
        Codigo_Centro AS Codigo_Contable,
        Id_Departamento,
        Nombre_Departamento,
        Id_Categoria_Gasto,
        Categoria_Gasto AS Nombre_Categoria_Gasto,
        Monto_Presupuestado,
        Monto_Ejecutado,
        Saldo_Disponible,
        Id_Creador,
        Id_Modificador,
        Fecha_Creacion,
        Fecha_Modificacion
    FROM VW_Presupuestos_Detalle_General (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR Nombre_Departamento LIKE '%' + @SearchTerm + '%'
        OR Categoria_Gasto LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Presupuesto_Detalle = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Presupuesto_Detalle IS NULL OR Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    AND (@Id_Presupuesto IS NULL OR Id_Presupuesto = @Id_Presupuesto)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Detalle_Presupuesto_Filtrar;
GO

EXEC sp_Tbl_Detalle_Presupuesto_Filtrar @SearchTerm = 'Marketing ';
GO

EXEC sp_Tbl_Detalle_Presupuesto_Filtrar @Id_Presupuesto = 1;
GO
