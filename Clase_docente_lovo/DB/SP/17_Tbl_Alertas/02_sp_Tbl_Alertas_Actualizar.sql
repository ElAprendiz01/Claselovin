USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Alertas_Actualizar
(
    @Id_Alerta INT,
    @Leida BIT = NULL,
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

    -- Validar parametro ID de alerta
    IF @Id_Alerta IS NULL OR @Id_Alerta <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la alerta es obligatorio';
        RETURN;
    END;

    -- Validar si esta inactivo
    IF @ForzarRecuperacion = 0
        AND EXISTS (
            SELECT 1
            FROM Tbl_Alertas p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Alerta = @Id_Alerta
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia de alerta
    IF NOT EXISTS (SELECT 1 FROM Tbl_Alertas WHERE Id_Alerta = @Id_Alerta)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La alerta especificada no existe';
        RETURN;
    END;

    -- Validar existencia del estado si se envia
    IF @Id_Estado IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El estado no existe o esta inactivo';
            RETURN;
        END;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Obtener ID de estado activo
        DECLARE @Id_Estado_Activo INT;
        SELECT TOP 1 @Id_Estado_Activo = Id_Estado
        FROM Cat_Estado
        WHERE Estado = 'Activo' AND Activo = 1;

        UPDATE Tbl_Alertas
        SET Leida = COALESCE(@Leida, Leida),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Alerta = @Id_Alerta;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Alerta actualizada correctamente';
        SET @o_templateId = @Id_Alerta;
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

EXEC sp_Tbl_Alertas_Actualizar
    @Id_Alerta = 1,
    @Leida = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AlertaIdModificada;
GO
