USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Cat_Monedas_Crear
(
    @Codigo_ISO VARCHAR(3),
    @Nombre_Moneda NVARCHAR(50),
    @Simbolo VARCHAR(5),
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
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

    -- Validar duplicidad de codigo ISO
    IF EXISTS (SELECT 1 FROM Cat_Monedas WHERE Codigo_ISO = TRIM(UPPER(@Codigo_ISO)))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El codigo ISO ya esta registrado';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Cat_Monedas (Codigo_ISO, Nombre_Moneda, Simbolo, Activo)
        VALUES (TRIM(UPPER(@Codigo_ISO)), TRIM(@Nombre_Moneda), TRIM(@Simbolo), 1);

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda creada correctamente';
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

EXEC sp_Cat_Monedas_Crear
    @Codigo_ISO = 'CAD',
    @Nombre_Moneda = 'Dolar Canadiense',
    @Simbolo = 'C$',
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdGenerada;
GO
