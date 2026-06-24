USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Gastos_Actualizar
(
    @Id_Gasto INT,
    @Id_Tipo_Gasto INT = NULL,
    @Descripcion_Gasto NVARCHAR(255) = NULL,
    @Monto_Gasto DECIMAL(18,2) = NULL,
    @Fecha_Gasto DATETIME2(2) = NULL,
    @Numero_Factura NVARCHAR(50) = NULL,
    @Id_Proveedor INT = NULL,
    @Id_Modificador INT,
    @Id_Estado INT = NULL,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Gasto IS NULL OR @Id_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del gasto es obligatorio';
        RETURN;
    END;

    IF @Descripcion_Gasto IS NOT NULL AND LTRIM(RTRIM(@Descripcion_Gasto)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripcion del gasto no puede estar vacia';
        RETURN;
    END;

    IF @Monto_Gasto IS NOT NULL AND @Monto_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto del gasto debe ser mayor a 0';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar si esta inactivo y @ForzarRecuperacion = 0
    IF @ForzarRecuperacion = 0
        AND EXISTS (
            SELECT 1
            FROM Tbl_Gastos p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Gasto = @Id_Gasto
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Obtener datos actuales del gasto
    DECLARE @Current_Detalle INT;
    DECLARE @Current_Monto DECIMAL(18,2);
    DECLARE @Current_Estado INT;
    SELECT @Current_Detalle = Id_Presupuesto_Detalle,
           @Current_Monto = Monto_Gasto,
           @Current_Estado = Id_Estado
    FROM Tbl_Gastos
    WHERE Id_Gasto = @Id_Gasto;

    IF @Current_Estado IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El gasto especificado no existe';
        RETURN;
    END;

    -- Prohibir modificar gasto aprobado
    IF @Current_Estado = 4
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se puede modificar un gasto aprobado';
        RETURN;
    END;

    -- Validar tipo de gasto si se envia
    IF @Id_Tipo_Gasto IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_Gasto AND Id_Tipo_Catalogo = 7 AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El tipo de gasto no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Validar proveedor si se envia
    IF @Id_Proveedor IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Proveedor AND Id_Tipo_Catalogo = 6 AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El proveedor no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Validar modificador activo
    DECLARE @ExisteModificador INT;
    SELECT @ExisteModificador = 1
    FROM Tbl_Usuarios u
    INNER JOIN Cat_Estado e ON u.Id_Estado = e.Id_Estado
    WHERE u.Id_Usuario = @Id_Modificador
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteModificador IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del estado si se envia
    IF @Id_Estado IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El estado del gasto no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Obtener montos del detalle para validar disponibilidad
    DECLARE @Monto_Presupuestado DECIMAL(18,2);
    DECLARE @Monto_Ejecutado DECIMAL(18,2);
    SELECT @Monto_Presupuestado = Monto_Presupuestado, @Monto_Ejecutado = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @Current_Detalle;

    -- Calcular diferencia y validar limites
    DECLARE @EvalMonto DECIMAL(18,2);
    SET @EvalMonto = COALESCE(@Monto_Gasto, @Current_Monto);
    DECLARE @Diferencia DECIMAL(18,2);
    SET @Diferencia = @EvalMonto - @Current_Monto;

    IF (@Monto_Ejecutado + @Diferencia) >= @Monto_Presupuestado
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La actualizacion excede el limite presupuestario disponible';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener ID de estado activo
        DECLARE @Id_Estado_Activo INT;
        SELECT TOP 1 @Id_Estado_Activo = Id_Estado
        FROM Cat_Estado
        WHERE Estado = 'Activo' AND Activo = 1;

        -- Obtener ID de estado inactivo
        DECLARE @Id_Estado_Inactivo INT;
        SELECT TOP 1 @Id_Estado_Inactivo = Id_Estado
        FROM Cat_Estado
        WHERE Estado IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND Activo = 1
        ORDER BY Id_Estado;

        IF @Id_Estado_Inactivo IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'No se encontro estado inactivo en catalogo';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Actualizar el gasto
        UPDATE Tbl_Gastos
        SET Id_Tipo_Gasto = COALESCE(@Id_Tipo_Gasto, Id_Tipo_Gasto),
            Descripcion_Gasto = TRIM(COALESCE(@Descripcion_Gasto, Descripcion_Gasto)),
            Monto_Gasto = COALESCE(@Monto_Gasto, Monto_Gasto),
            Fecha_Gasto = COALESCE(@Fecha_Gasto, Fecha_Gasto),
            Numero_Factura = TRIM(COALESCE(@Numero_Factura, Numero_Factura)),
            Id_Proveedor = COALESCE(@Id_Proveedor, Id_Proveedor),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Gasto = @Id_Gasto;

        -- Actualizar ejecutado con la diferencia
        UPDATE Tbl_Detalle_Presupuesto
        SET Monto_Ejecutado = Monto_Ejecutado + @Diferencia,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Modificador = @Id_Modificador
        WHERE Id_Presupuesto_Detalle = @Current_Detalle;

        -- Calcular nuevo porcentaje de ejecucion
        DECLARE @Nuevo_Monto_Ejecutado DECIMAL(18,2);
        SELECT @Nuevo_Monto_Ejecutado = Monto_Ejecutado 
        FROM Tbl_Detalle_Presupuesto 
        WHERE Id_Presupuesto_Detalle = @Current_Detalle;

        DECLARE @Porcentaje DECIMAL(5,2);
        SET @Porcentaje = (@Nuevo_Monto_Ejecutado / @Monto_Presupuestado) * 100.00;

        -- Alerta automatica si supera el 85 por ciento
        IF @Porcentaje > 85.00
        BEGIN
            DECLARE @v_alerta_code INT;
            DECLARE @v_alerta_message VARCHAR(255);
            DECLARE @v_alerta_id INT;

            EXEC sp_Tbl_Alertas_Crear
                @Id_Presupuesto_Detalle = @Current_Detalle,
                @Porcentaje_Consumido = @Porcentaje,
                @Mensaje_Alerta = 'Consumo de presupuesto excede el 85 por ciento',
                @Id_Estado = 1,
                @o_code = @v_alerta_code OUTPUT,
                @o_message = @v_alerta_message OUTPUT,
                @o_templateId = @v_alerta_id OUTPUT;

            IF @v_alerta_code <> 200
            BEGIN
                SET @o_code = @v_alerta_code;
                SET @o_message = @v_alerta_message;
                ROLLBACK TRANSACTION;
                RETURN;
            END;
        END;
        ELSE
        BEGIN
            -- Desactivar alertas si baja del 85
            UPDATE Tbl_Alertas
            SET Leida = 1,
                Id_Estado = @Id_Estado_Inactivo
            WHERE Id_Presupuesto_Detalle = @Current_Detalle 
              AND Leida = 0 
              AND Id_Estado <> @Id_Estado_Inactivo;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Gasto actualizado correctamente';
        SET @o_templateId = @Id_Gasto;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO

-- Ejemplo ejecucion
DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC sp_Tbl_Gastos_Actualizar
    @Id_Gasto = 2,
    @Id_Tipo_Gasto = 16,
    @Descripcion_Gasto = 'Renovacion de Licencias IDEs Modificado',
    @Monto_Gasto = 4800.00,
    @Id_Proveedor = 13,
    @Id_Modificador = 1,
    @Id_Estado = 3,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS GastoIdModificado;
GO
