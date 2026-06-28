USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Ajustes_Presupuesto_Filtrar
(
    @SearchTerm VARCHAR(50) = NULL,
    @Id_Ajuste INT = NULL,
    @Id_Presupuesto_Detalle INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

       SELECT 
        Id_Ajuste,
        Id_Presupuesto_Detalle,
        Id_Presupuesto,
        Anio_Fiscal,
        Nombre_Centro,
        Nombre_Categoria_Gasto,
        Tipo_Ajuste,
        Monto_Ajuste,
        Justificacion,
        Fecha_Ajuste,
        Id_Creador
    FROM VW_Ajustes_Presupuesto_General (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR Tipo_Ajuste LIKE '%' + @SearchTerm + '%'
        OR Justificacion LIKE '%' + @SearchTerm + '%'
        OR Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND Id_Ajuste = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Ajuste IS NULL OR Id_Ajuste = @Id_Ajuste)
    AND (@Id_Presupuesto_Detalle IS NULL OR Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Ajustes_Presupuesto_Filtrar;
GO

EXEC sp_Tbl_Ajustes_Presupuesto_Filtrar @SearchTerm = 'INCREMENTO';
GO

EXEC sp_Tbl_Ajustes_Presupuesto_Filtrar @Id_Ajuste = 1;
GO
