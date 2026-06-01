-- =========================================================================
-- SISTEMA DE CONTROL PRESUPUESTARIO EMPRESARIAL
-- MÓDULO: PROGRAMABILIDAD, RENDIMIENTO Y OBJETOS DE CONTROL (ÚNICO)
-- =========================================================================

USE Presupuesto_Empresarial;
GO

-- =========================================================================
-- 1. CAPA DE RENDIMIENTO: ÍNDICES NO AGRUPADOS (NON-CLUSTERED INDEXES)
-- =========================================================================
-- Nota: Optimizan las búsquedas en cruces de tablas (JOINs) recurrentes.

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CentrosCosto_Departamento')
    DROP INDEX IX_CentrosCosto_Departamento ON Tbl_Centros_Costo;
GO
CREATE INDEX IX_CentrosCosto_Departamento 
    ON Tbl_Centros_Costo(Id_Departamento);
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetallePresupuesto_Presupuesto')
    DROP INDEX IX_DetallePresupuesto_Presupuesto ON Tbl_Detalle_Presupuesto;
GO
CREATE INDEX IX_DetallePresupuesto_Presupuesto 
    ON Tbl_Detalle_Presupuesto(Id_Presupuesto);
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DetallePresupuesto_CentroCosto')
    DROP INDEX IX_DetallePresupuesto_CentroCosto ON Tbl_Detalle_Presupuesto;
GO
CREATE INDEX IX_DetallePresupuesto_CentroCosto 
    ON Tbl_Detalle_Presupuesto(Id_Centro_Costo);
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Gastos_DetallePresupuesto')
    DROP INDEX IX_Gastos_DetallePresupuesto ON Tbl_Gastos;
GO
CREATE INDEX IX_Gastos_DetallePresupuesto 
    ON Tbl_Gastos(Id_Presupuesto_Detalle);
GO


-- =========================================================================
-- 2. ABSTRACCIÓN CALCULADA: VISTA DE CONSOLIDACIÓN MULTIDIVISA
-- =========================================================================
-- Nota: Resuelve el cálculo síncrono integrando de forma segura la moneda.

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER VIEW Vw_Presupuestos_Consolidados
AS
SELECT 
    P.Id_Presupuesto,
    P.Anio_Fiscal,
    M.Codigo_ISO AS Moneda,
    P.Descripcion,
    ISNULL(SUM(D.Monto_Presupuestado), 0.00) AS Monto_Total_Asignado,
    ISNULL(SUM(D.Monto_Ejecutado), 0.00) AS Monto_Total_Ejecutado,
    P.Id_Estado
FROM Tbl_Presupuestos P
INNER JOIN Cat_Monedas M ON P.Id_Moneda = M.Id_Moneda
LEFT JOIN Tbl_Detalle_Presupuesto D ON P.Id_Presupuesto = D.Id_Presupuesto
GROUP BY 
    P.Id_Presupuesto, 
    P.Anio_Fiscal, 
    M.Codigo_ISO, 
    P.Descripcion, 
    P.Id_Estado;
GO


-- nota para  recibir los datos del gasto, y  meter el registro, actualizar  el detalle presupuestario automáticamente y, en ese mismo instante, calcular si debe o no registrar la alerta, este hacerlo en sl sp de los gastos hacer el update y asi mismo trabajar  las otras tablas para no crear trigges que eso estan activos y asi no se gast recurso solo se ejcunta cuando se ejcuta el sp nada mas