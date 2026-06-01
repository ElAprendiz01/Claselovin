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


-- =========================================================================
-- 3. AUTOMATIZACIÓN TRANSACCIONAL Y ALERTA INTELIGENTE (TRIGGER)
-- =========================================================================
-- Nota: Actúa como guardián ACID para evitar sobregiros monetarios reales.

CREATE OR ALTER TRIGGER TR_TblGastos_Control_Presupuesto
ON Tbl_Gastos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Prevenir ejecuciones vacías o lecturas fantasma en inserciones masivas
    IF NOT EXISTS (SELECT 1 FROM Inserted) RETURN;

    -- Declaración de variables de control de negocio
    DECLARE @IdDetalle INT, @MontoGasto DECIMAL(18,2);
    DECLARE @MontoPresupuestado DECIMAL(18,2), @MontoEjecutadoActual DECIMAL(18,2);
    DECLARE @MontoEjecutadoNuevo DECIMAL(18,2), @PorcentajeConsumido DECIMAL(5,2);

    -- Capturar los datos del gasto que se está intentando registrar
    SELECT @IdDetalle = Id_Presupuesto_Detalle, @MontoGasto = Monto_Gasto 
    FROM Inserted;

    -- Obtener el estado financiero actual del detalle presupuestario afectado
    SELECT 
        @MontoPresupuestado = Monto_Presupuestado,
        @MontoEjecutadoActual = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @IdDetalle;

    -- Calcular la proyección de fondos con el nuevo gasto incorporado
    SET @MontoEjecutadoNuevo = @MontoEjecutadoActual + @MontoGasto;

    -- [REGLA DE NEGOCIO 1] BLINDAJE CONTRA SOBREGIROS
    IF (@MontoEjecutadoNuevo > @MontoPresupuestado)
    BEGIN
        DECLARE @ErrorMsg NVARCHAR(250);
        SET @ErrorMsg = CONCAT(
            'Violación de Techo Financiero: La operación de ', 
            CAST(@MontoGasto AS VARCHAR(20)), 
            ' excede los fondos remanentes disponibles en este Centro de Costo.'
        );
        
        RAISERROR(@ErrorMsg, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- [OPERACIÓN ATÓMICA] ACTUALIZACIÓN INTEGRAL DEL SALDO EJECUTADO
    UPDATE Tbl_Detalle_Presupuesto
    SET Monto_Ejecutado = @MontoEjecutadoNuevo,
        Fecha_Modificacion = SYSDATETIME()
    WHERE Id_Presupuesto_Detalle = @IdDetalle;

    -- [REGLA DE NEGOCIO 2] MONITOREO Y EMISIÓN DE ALERTAS (Umbral crítico >= 85.00%)
    SET @PorcentajeConsumido = (@MontoEjecutadoNuevo / @MontoPresupuestado) * 100.00;

    IF (@PorcentajeConsumido >= 85.00)
    BEGIN
        INSERT INTO Tbl_Alertas (Id_Presupuesto_Detalle, Porcentaje_Consumido, Mensaje_Alerta, Id_Estado)
        VALUES (
            @IdDetalle, 
            @PorcentajeConsumido, 
            CONCAT('Advertencia Automática: Consumo crítico del ', CAST(@PorcentajeConsumido AS VARCHAR(6)), '% del presupuesto total asignado para esta categoría.'),
            1 -- Estado Activo / Alerta no leída
        );
    END;
END;
GO