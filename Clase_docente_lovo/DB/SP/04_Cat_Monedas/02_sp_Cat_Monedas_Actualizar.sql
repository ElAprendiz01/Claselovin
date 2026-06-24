USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Monedas_Actualizar
(
    @Id_Moneda INT,
    @Codigo_ISO VARCHAR(3),
    @Nombre_Moneda NVARCHAR(50),
    @Simbolo VARCHAR(5),
    @Activo BIT,
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

    IF @Codigo_ISO IS NULL OR LTRIM(RTRIM(@Codigo_ISO)) = '' OR LEN(LTRIM(RTRIM(@Codigo_ISO))) <> 3
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El codigo ISO es obligatorio y debe tener 3 caracteres';
        RETURN;
    END;

    IF @Nombre_Moneda IS NULL OR LTRIM(RTRIM(@Nombre_Moneda)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la moneda es obligatorio';
        RETURN;
    END;

    IF @Simbolo IS NULL OR LTRIM(RTRIM(@Simbolo)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El simbolo es obligatorio';
        RETURN;
    END;

    IF @Activo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado activo es obligatorio';
        RETURN;
    END;

    -- Validar existencia de la moneda
    IF NOT EXISTS (SELECT 1 FROM Cat_Monedas WHERE Id_Moneda = @Id_Moneda)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda especificada no existe';
        RETURN;
    END;

    -- Validar duplicidad de codigo ISO con otra moneda
    IF EXISTS (SELECT 1 FROM Cat_Monedas WHERE Codigo_ISO = TRIM(UPPER(@Codigo_ISO)) AND Id_Moneda <> @Id_Moneda)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra moneda con ese codigo ISO';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Cat_Monedas
        SET Codigo_ISO = TRIM(UPPER(@Codigo_ISO)),
            Nombre_Moneda = TRIM(@Nombre_Moneda),
            Simbolo = TRIM(@Simbolo),
            Activo = @Activo
        WHERE Id_Moneda = @Id_Moneda;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda actualizada correctamente';
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

EXEC sp_Cat_Monedas_Actualizar
    @Id_Moneda = 1,
    @Codigo_ISO = 'USD',
    @Nombre_Moneda = 'Dolar Modificado',
    @Simbolo = '$',
    @Activo = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdModificada;
GO
