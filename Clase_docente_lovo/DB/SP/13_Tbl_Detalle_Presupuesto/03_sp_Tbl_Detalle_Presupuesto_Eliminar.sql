USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Detalle_Presupuesto_Eliminar
(
    @Id_Presupuesto_Detalle INT,
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

    -- Validar existencia y ejecucion del detalle
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

    -- Bloquear eliminacion si hay ejecucion
    IF @Monto_Ejecutado > 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se puede eliminar: Tiene transacciones de gastos asociadas (ejecutado > 0)';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Tbl_Detalle_Presupuesto
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Detalle de presupuesto eliminado permanentemente';
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

EXEC sp_Tbl_Detalle_Presupuesto_Eliminar
    @Id_Presupuesto_Detalle = 9999, -- ID que no existe
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS DetalleIdEliminado;
GO
