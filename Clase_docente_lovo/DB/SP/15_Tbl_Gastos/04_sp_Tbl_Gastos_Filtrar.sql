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

    -- Consultar datos con filtros
    SELECT 
        G.Id_Gasto,
        G.Descripcion_Gasto,
        G.Monto_Gasto,
        G.Fecha_Gasto,
        G.Numero_Factura,
        G.Id_Proveedor,
        G_PROV.Nombre AS Proveedor,
        G.Id_Tipo_Gasto,
        G_TIPO.Nombre AS Tipo_Gasto,
        G.Id_Presupuesto_Detalle,
        DP.Id_Presupuesto,
        P.Anio_Fiscal,
        CC.Nombre_Centro,
        D.Nombre_Departamento,
        G.Id_Estado,
        E.Estado AS Nombre_Estado,
        G.Id_Creador,
        G.Fecha_Creacion
    FROM Tbl_Gastos G (NOLOCK)
    INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON G.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
    INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
    INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
    INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
    INNER JOIN Cat_General G_PROV (NOLOCK) ON G.Id_Proveedor = G_PROV.Id_Catalogo
    INNER JOIN Cat_General G_TIPO (NOLOCK) ON G.Id_Tipo_Gasto = G_TIPO.Id_Catalogo
    INNER JOIN Cat_Estado E (NOLOCK) ON G.Id_Estado = E.Id_Estado
    WHERE (
        @SearchTerm IS NULL
        OR G.Descripcion_Gasto LIKE '%' + @SearchTerm + '%'
        OR G.Numero_Factura LIKE '%' + @SearchTerm + '%'
        OR G_PROV.Nombre LIKE '%' + @SearchTerm + '%'
        OR (
            TRY_CAST(@SearchTerm AS INT) IS NOT NULL 
            AND G.Id_Gasto = TRY_CAST(@SearchTerm AS INT)
        )
    )
    AND (@Id_Gasto IS NULL OR G.Id_Gasto = @Id_Gasto)
    AND (@Id_Presupuesto_Detalle IS NULL OR G.Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
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
