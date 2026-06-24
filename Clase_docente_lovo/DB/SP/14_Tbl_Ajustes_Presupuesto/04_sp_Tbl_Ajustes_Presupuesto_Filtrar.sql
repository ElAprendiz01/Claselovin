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

    -- Consultar datos con filtros
    SELECT 
        A.Id_Ajuste,
        A.Id_Presupuesto_Detalle,
        DP.Id_Presupuesto,
        P.Anio_Fiscal,
        CC.Nombre_Centro,
        CG.Nombre AS Nombre_Categoria_Gasto,
        A.Tipo_Ajuste,
        A.Monto_Ajuste,
        A.Justificacion,
        A.Fecha_Ajuste,
        A.Id_Creador
    FROM Tbl_Ajustes_Presupuesto A (NOLOCK)
    INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
    INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
    INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
    INNER JOIN Cat_General CG (NOLOCK) ON DP.Id_Categoria_Gasto = CG.Id_Catalogo
    WHERE (
        @SearchTerm IS NULL
        OR A.Tipo_Ajuste LIKE '%' + @SearchTerm + '%'
        OR A.Justificacion LIKE '%' + @SearchTerm + '%'
        OR CC.Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND A.Id_Ajuste = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Ajuste IS NULL OR A.Id_Ajuste = @Id_Ajuste)
    AND (@Id_Presupuesto_Detalle IS NULL OR A.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
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
