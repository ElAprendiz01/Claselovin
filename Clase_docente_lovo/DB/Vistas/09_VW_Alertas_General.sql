USE Presupuesto_Empresarial;
GO

-- Vista para consolidar alertas
CREATE OR ALTER VIEW VW_Alertas_General
AS
SELECT 
    A.Id_Alerta,
    A.Id_Presupuesto_Detalle,
    CC.Nombre_Centro,
    D.Nombre_Departamento,
    A.Porcentaje_Consumido,
    A.Mensaje_Alerta,
    A.Fecha_Generada,
    A.Leida,
    A.Id_Estado,
    E.Estado AS Nombre_Estado
FROM Tbl_Alertas A (NOLOCK)
INNER JOIN Tbl_Detalle_Presupuesto DP (NOLOCK) ON A.Id_Presupuesto_Detalle = DP.Id_Presupuesto_Detalle
INNER JOIN Tbl_Centros_Costo CC (NOLOCK) ON DP.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_Estado E (NOLOCK) ON A.Id_Estado = E.Id_Estado
WHERE A.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%')
  AND CC.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%')
  AND D.Id_Estado NOT IN (SELECT Id_Estado FROM Cat_Estado (NOLOCK) WHERE Estado LIKE '%Inactivo%' OR Estado LIKE '%Eliminado%' OR Estado LIKE '%Cancelado%' OR Estado LIKE '%Borrado%' OR Estado LIKE '%Baja%');
GO

select * from VW_Alertas_General