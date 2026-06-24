USE Presupuesto_Empresarial;
GO

-- Vista para consolidar transacciones de gastos
CREATE OR ALTER VIEW VW_Gastos_Transaccionales_General
AS
SELECT 
    G.Id_Gasto,
    G.Descripcion_Gasto,
    G.Monto_Gasto,
    G.Fecha_Gasto,
    G.Numero_Factura,
    G_PROV.Nombre AS Proveedor,
    G_TIPO.Nombre AS Tipo_Gasto,
    DP.Id_Presupuesto_Detalle,
    P.Anio_Fiscal,
    CC.Nombre_Centro,
    D.Nombre_Departamento,
    E.Estado AS Estado_Gasto,
    G.Id_Estado AS Id_Estado_Gasto,
    G.Id_Proveedor,
    G.Id_Tipo_Gasto,
    DP.Id_Presupuesto,
    G.Id_Creador,
    G.Fecha_Creacion
FROM Tbl_Gastos G (NOLOCK)
INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON G.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
INNER JOIN Tbl_Presupuestos P (NOLOCK) ON DP.Id_Presupuesto = P.Id_Presupuesto
INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_General G_PROV (NOLOCK) ON G.Id_Proveedor = G_PROV.Id_Catalogo
INNER JOIN Cat_General G_TIPO (NOLOCK) ON G.Id_Tipo_Gasto = G_TIPO.Id_Catalogo
INNER JOIN Cat_Estado E (NOLOCK) ON G.Id_Estado = E.Id_Estado;
GO

SELECT * FROM VW_Gastos_Transaccionales_General;
GO
