USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Detalle_Presupuesto_Actualizar
(
    @Id_Presupuesto_Detalle INT,
    @Monto_Presupuestado DECIMAL(18,2),
    @Id_Modificador INT,
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

    IF @Monto_Presupuestado IS NULL OR @Monto_Presupuestado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto presupuestado debe ser mayor a 0';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar existencia del detalle
    DECLARE @Monto_Ejecutado DECIMAL(18,2);
    SELECT @Monto_Ejecutado = Monto_Ejecutado
    FROM Tbl_Detalle_Presupuesto
    WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

    IF @Monto_Ejecutado IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El detalle de presupuesto especificado no existe';
        RETURN;
    END;

    -- Validar que el monto presupuestado sea estrictamente mayor al ejecutado
    IF @Monto_Presupuestado <= @Monto_Ejecutado
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El monto presupuestado debe ser mayor al monto ejecutado';
        RETURN;
    END;

    -- Validar modificador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Modificador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Tbl_Detalle_Presupuesto
        SET Monto_Presupuestado = @Monto_Presupuestado,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Detalle de presupuesto actualizado correctamente';
        SET @o_templateId = @Id_Presupuesto_Detalle;
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

EXEC sp_Tbl_Detalle_Presupuesto_Actualizar
    @Id_Presupuesto_Detalle = 1,
    @Monto_Presupuestado = 45000.00,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS DetalleIdModificado;
GO
