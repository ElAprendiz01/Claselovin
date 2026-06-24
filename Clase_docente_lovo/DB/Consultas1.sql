-- =========================================================================
--  : CONSULTAS ANALÍTICAS Y AUDITORÍA DE CONTROL (ACTUALIZADO, PARA QUE LO TENGAS EN CUENTA YERIS ACTUALZA)
-- =========================================================================

USE Presupuesto_Empresarial;
GO

-- 1. Comparativo de Presupuesto vs. Gasto Real (Soporte Multidivisa)
-- =========================================================================
SELECT 
    D.Nombre_Departamento,
    CC.Nombre_Centro,
    CAT.Nombre AS Categoria_Gasto,
    PM.Anio_Fiscal,
    MON.Codigo_ISO AS Moneda,
    PD.Monto_Presupuestado,
    PD.Monto_Ejecutado,
    (PD.Monto_Presupuestado - PD.Monto_Ejecutado) AS Saldo_Disponible,
    CAST((PD.Monto_Ejecutado / PD.Monto_Presupuestado) * 100.00 AS DECIMAL(5,2)) AS Porcentaje_Ejecucion
FROM Tbl_Detalle_Presupuesto PD
INNER JOIN Tbl_Presupuestos PM ON PD.Id_Presupuesto = PM.Id_Presupuesto
INNER JOIN Cat_Monedas MON ON PM.Id_Moneda = MON.Id_Moneda
INNER JOIN Tbl_Centros_Costo CC ON PD.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos D ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_General CAT ON PD.Id_Categoria_Gasto = CAT.Id_Catalogo
WHERE PM.Anio_Fiscal = 2026; -- Filtrable por el año requerido
GO


-- 2. Auditoría de Alertas Críticas por Sobregiro Presupuestario
-- =========================================================================
SELECT 
    D.Nombre_Departamento,
    CC.Nombre_Centro,
    CAT.Nombre AS Categoria_Gasto,
    A.Porcentaje_Consumido,
    A.Mensaje_Alerta,
    A.Fecha_Generada,
    CASE 
        WHEN A.Leida = 0 THEN 'No Leída'
        ELSE 'Leída'
    END AS Estado_Alerta
FROM Tbl_Alertas A
INNER JOIN Tbl_Detalle_Presupuesto PD ON A.Id_Presupuesto_Detalle = PD.Id_Presupuesto_Detalle
INNER JOIN Tbl_Centros_Costo CC ON PD.Id_Centro_Costo = CC.Id_Centro_Costo
INNER JOIN Tbl_Departamentos D ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_General CAT ON PD.Id_Categoria_Gasto = CAT.Id_Catalogo
WHERE A.Leida = 0 
ORDER BY A.Porcentaje_Consumido DESC;
GO