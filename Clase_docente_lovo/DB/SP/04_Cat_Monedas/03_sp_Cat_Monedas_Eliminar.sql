USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Monedas_Eliminar
(
    @Id_Moneda INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Id_Moneda IS NULL OR @Id_Moneda <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la moneda es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado activo
    DECLARE @Activo BIT;
    SELECT @Activo = Activo 
    FROM Cat_Monedas 
    WHERE Id_Moneda = @Id_Moneda;

    IF @Activo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda especificada no existe';
        RETURN;
    END;

    IF @Activo = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda ya esta inactiva';
        RETURN;
    END;

    -- Validar integridad relacional
    IF EXISTS (SELECT 1 FROM Tbl_Presupuestos WHERE Id_Moneda = @Id_Moneda)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda esta en uso y no puede desactivarse';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_Monedas
        SET Activo = 0
        WHERE Id_Moneda = @Id_Moneda;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda eliminada logicamente';
        SET @o_templateId = @Id_Moneda;
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

EXEC sp_Cat_Monedas_Eliminar
    @Id_Moneda = 4,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdEliminada;
GO
