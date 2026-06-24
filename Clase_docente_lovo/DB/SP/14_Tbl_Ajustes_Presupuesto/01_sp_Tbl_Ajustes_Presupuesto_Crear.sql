USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Ajustes_Presupuesto_Crear
(
    @Id_Presupuesto_Detalle INT,
    @Tipo_Ajuste VARCHAR(15),
    @Monto_Ajuste DECIMAL(18,2),
    @Justificacion NVARCHAR(255),
    @Id_Creador INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Presupuesto_Detalle IS NULL OR @Id_Presupuesto_Detalle <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del detalle es obligatorio';
        RETURN;
    END;

    IF @Tipo_Ajuste IS NULL OR @Tipo_Ajuste NOT IN ('INCREMENTO', 'REDUCCION')
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de ajuste debe ser INCREMENTO o REDUCCION';
        RETURN;
    END;

    IF @Monto_Ajuste IS NULL OR @Monto_Ajuste <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto del ajuste debe ser mayor a 0';
        RETURN;
    END;

    IF @Justificacion IS NULL OR LTRIM(RTRIM(@Justificacion)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La justificacion es obligatoria';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del detalle de presupuesto y obtener montos
    DECLARE @Monto_Presupuestado DECIMAL(18,2);
    DECLARE @Monto_Ejecutado DECIMAL(18,2);
    SELECT @Monto_Presupuestado = Monto_Presupuestado, @Monto_Ejecutado = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

    IF @Monto_Presupuestado IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El detalle de presupuesto especificado no existe';
        RETURN;
    END;

    -- Validar limites si es REDUCCION
    IF @Tipo_Ajuste = 'REDUCCION'
    BEGIN
        -- Validar que Monto_Presupuestado - Monto_Ajuste > Monto_Ejecutado
        IF (@Monto_Presupuestado - @Monto_Ajuste) <= @Monto_Ejecutado
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La reduccion haria que el presupuesto sea menor o igual al ejecutado';
            RETURN;
        END;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar el ajuste
        INSERT INTO Tbl_Ajustes_Presupuesto
        (
            Id_Presupuesto_Detalle,
            Tipo_Ajuste,
            Monto_Ajuste,
            Justificacion,
            Id_Creador
        )
        VALUES
        (
            @Id_Presupuesto_Detalle,
            @Tipo_Ajuste,
            @Monto_Ajuste,
            TRIM(@Justificacion),
            @Id_Creador
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- Actualizar el detalle de presupuesto
        IF @Tipo_Ajuste = 'INCREMENTO'
        BEGIN
            UPDATE Tbl_Detalle_Presupuesto
            SET Monto_Presupuestado = Monto_Presupuestado + @Monto_Ajuste,
                Fecha_Modificacion = SYSDATETIME(),
                Id_Modificador = @Id_Creador
            WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;
        END;
        ELSE IF @Tipo_Ajuste = 'REDUCCION'
        BEGIN
            UPDATE Tbl_Detalle_Presupuesto
            SET Monto_Presupuestado = Monto_Presupuestado - @Monto_Ajuste,
                Fecha_Modificacion = SYSDATETIME(),
                Id_Modificador = @Id_Creador
            WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;
        END;

        -- Calcular nuevo porcentaje de ejecucion
        DECLARE @Nuevo_Monto_Ejecutado DECIMAL(18,2);
        DECLARE @Nuevo_Monto_Presupuestado DECIMAL(18,2);
        
        SELECT @Nuevo_Monto_Ejecutado = Monto_Ejecutado,
               @Nuevo_Monto_Presupuestado = Monto_Presupuestado
        FROM Tbl_Detalle_Presupuesto 
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        DECLARE @Porcentaje DECIMAL(5,2);
        IF @Nuevo_Monto_Presupuestado > 0
            SET @Porcentaje = (@Nuevo_Monto_Ejecutado / @Nuevo_Monto_Presupuestado) * 100.00;
        ELSE
            SET @Porcentaje = 0.00;

        -- Alerta si supera el 85 por ciento
        IF @Porcentaje > 85.00
        BEGIN
            DECLARE @v_alerta_code INT;
            DECLARE @v_alerta_message VARCHAR(255);
            DECLARE @v_alerta_id INT;

            EXEC sp_Tbl_Alertas_Crear
                @Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle,
                @Porcentaje_Consumido = @Porcentaje,
                @Mensaje_Alerta = 'Consumo de presupuesto excede el 85 por ciento por ajuste',
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
                Id_Estado = 2
            WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle AND Leida = 0 AND Id_Estado = 1;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Ajuste de presupuesto aplicado correctamente';
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

EXEC sp_Tbl_Ajustes_Presupuesto_Crear
    @Id_Presupuesto_Detalle = 1,
    @Tipo_Ajuste = 'INCREMENTO',
    @Monto_Ajuste = 5000.00,
    @Justificacion = 'Ajuste de incremento para pruebas de adenda',
    @Id_Creador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AjusteIdGenerado;
GO
