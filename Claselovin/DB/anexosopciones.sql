
-- =========================================================================
-- 5. CAPA DE RENDIMIENTO: ÍNDICES NO AGRUPADOS (NON-CLUSTERED INDEXES)
-- =========================================================================

CREATE INDEX IX_CentrosCosto_Departamento ON Tbl_Centros_Costo(Id_Departamento);
CREATE INDEX IX_DetallePresupuesto_Presupuesto ON Tbl_Detalle_Presupuesto(Id_Presupuesto);
CREATE INDEX IX_DetallePresupuesto_CentroCosto ON Tbl_Detalle_Presupuesto(Id_Centro_Costo);
CREATE INDEX IX_Gastos_DetallePresupuesto ON Tbl_Gastos(Id_Presupuesto_Detalle);
GO

-- =========================================================================
-- 6. ABSTRACCIÓN CALCULADA (Monto total de cabeceras seguro)
-- =========================================================================

CREATE VIEW Vw_Presupuestos_Consolidados
AS
SELECT 
    P.Id_Presupuesto,
    P.Anio_Fiscal,
    P.Descripcion,
    ISNULL(SUM(D.Monto_Presupuestado), 0.00) AS Monto_Total_Asignado,
    ISNULL(SUM(D.Monto_Ejecutado), 0.00) AS Monto_Total_Ejecutado,
    P.Id_Estado
FROM Tbl_Presupuestos P
LEFT JOIN Tbl_Detalle_Presupuesto D ON P.Id_Presupuesto = D.Id_Presupuesto
GROUP BY P.Id_Presupuesto, P.Anio_Fiscal, P.Descripcion, P.Id_Estado;
GO

-- =========================================================================
-- 7. CAPA DE AUTOMATIZACIÓN TRANSACCIONAL Y RESGUARDOS ACID (TRIGGER)
-- =========================================================================

CREATE TRIGGER TR_TblGastos_Control_Presupuesto
ON Tbl_Gastos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaración de variables de control de negocio
    DECLARE @IdDetalle INT, @MontoGasto DECIMAL(18,2);
    DECLARE @MontoPresupuestado DECIMAL(18,2), @MontoEjecutadoNuevo DECIMAL(18,2);
    DECLARE @PorcentajeConsumido DECIMAL(5,2);

    -- Capturar el registro recién insertado
    SELECT @IdDetalle = Id_Presupuesto_Detalle, @MontoGasto = Monto_Gasto 
    FROM Inserted;

    -- Obtener la frontera de datos económicos del detalle presupuestario
    SELECT 
        @MontoPresupuestado = Monto_Presupuestado,
        @MontoEjecutadoNuevo = Monto_Ejecutado + @MontoGasto
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @IdDetalle;

    -- [REGLA DE NEGOCIO 1] CONTROL RIGUROSO DE LÍMITE TRANSACCIONAL
    IF (@MontoEjecutadoNuevo > @MontoPresupuestado)
    BEGIN
        RAISERROR('Exceso de Gasto: La operación excede los fondos remanentes del presupuesto asignado a este Centro de Costo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- [OPERACIÓN ATÓMICA] ACTUALIZACIÓN DEL SALDO EJECUTADO
    UPDATE Tbl_Detalle_Presupuesto
    SET Monto_Ejecutado = @MontoEjecutadoNuevo,
        Fecha_Modificacion = SYSDATETIME()
    WHERE Id_Presupuesto_Detalle = @IdDetalle;

    -- [REGLA DE NEGOCIO 2] MONITOREO Y GENERACIÓN AUTOMÁTICA DE ALERTAS (Umbral de aviso: >= 85%)
    SET @PorcentajeConsumido = (@MontoEjecutadoNuevo / @MontoPresupuestado) * 100.00;

    IF (@PorcentajeConsumido >= 85.00)
    BEGIN
        INSERT INTO Tbl_Alertas (Id_Presupuesto_Detalle, Porcentaje_Consumido, Mensaje_Alerta, Id_Estado)
        VALUES (
            @IdDetalle, 
            @PorcentajeConsumido, 
            CONCAT('Advertencia: Consumo crítico. Se ha comprometido el ', CAST(@PorcentajeConsumido AS VARCHAR(6)), '% del presupuesto en esta categoría.'),
            1 -- ID correspondiente al estado Activo o Alerta Generada
        );
    END;
END;
GO