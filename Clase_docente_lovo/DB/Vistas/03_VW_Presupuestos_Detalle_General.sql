USE Presupuesto_Empresarial;
GO

-- Vista para consolidar detalle de presupuestos
CREATE OR ALTER VIEW VW_Presupuestos_Detalle_General
AS
SELECT 
    DP.Id_Presupuesto_Detalle,
    P.Id_Presupuesto,
    P.Anio_Fiscal,
    M.Id_Moneda,
    M.Codigo_ISO AS Moneda_ISO,
    M.Simbolo AS Moneda_Simbolo,
    P.Descripcion AS Descripcion_Presupuesto,
    E.Estado AS Estado_Presupuesto,
    CC.Id_Centro_Costo,
    CC.Nombre_Centro,
    CC.Codigo_Contable AS Codigo_Centro,
    D.Id_Departamento,
    D.Nombre_Departamento,
    CG.Id_Catalogo AS Id_Categoria_Gasto,
    CG.Nombre AS Categoria_Gasto,
    DP.Monto_Presupuestado,
    DP.Monto_Ejecutado,
    (DP.Monto_Presupuestado - DP.Monto_Ejecutado) AS Saldo_Disponible
FROM Tbl_Detalle_Presupuesto DP (NOLOCK)
INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_Monedas M (NOLOCK) ON P.Id_Moneda = M.Id_Moneda
INNER JOIN Cat_General CG (NOLOCK) ON DP.Id_Categoria_Gasto = CG.Id_Catalogo
INNER JOIN Cat_Estado E (NOLOCK) ON P.Id_Estado = E.Id_Estado;
GO

SELECT * FROM VW_Presupuestos_Detalle_General;
GO
