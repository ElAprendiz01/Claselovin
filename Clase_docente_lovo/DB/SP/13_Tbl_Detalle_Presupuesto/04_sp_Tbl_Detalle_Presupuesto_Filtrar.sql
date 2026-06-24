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
        DP.Id_Presupuesto_Detalle,
        DP.Id_Presupuesto,
        P.Anio_Fiscal,
        DP.Id_Centro_Costo,
        CC.Nombre_Centro,
        CC.Codigo_Contable,
        CC.Id_Departamento,
        D.Nombre_Departamento,
        DP.Id_Categoria_Gasto,
        CG.Nombre AS Nombre_Categoria_Gasto,
        DP.Monto_Presupuestado,
        DP.Monto_Ejecutado,
        (DP.Monto_Presupuestado - DP.Monto_Ejecutado) AS Saldo_Disponible,
        DP.Id_Creador,
        DP.Id_Modificador,
        DP.Fecha_Creacion,
        DP.Fecha_Modificacion
    FROM Tbl_Detalle_Presupuesto DP (NOLOCK)
    INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
    INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
    INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
    INNER JOIN Cat_General CG (NOLOCK) ON DP.Id_Categoria_Gasto = CG.Id_Catalogo
    WHERE (
        @SearchTerm IS NULL
        OR CC.Nombre_Centro LIKE '%' + @SearchTerm + '%'
        OR D.Nombre_Departamento LIKE '%' + @SearchTerm + '%'
        OR CG.Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND DP.Id_Presupuesto_Detalle = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Presupuesto_Detalle IS NULL OR DP.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    AND (@Id_Presupuesto IS NULL OR DP.Id_Presupuesto = @Id_Presupuesto)
    OPTION (RECOMPILE);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Detalle_Presupuesto_Filtrar;
GO

EXEC sp_Tbl_Detalle_Presupuesto_Filtrar @SearchTerm = 'Cloud';
GO

EXEC sp_Tbl_Detalle_Presupuesto_Filtrar @Id_Presupuesto = 1;
GO
