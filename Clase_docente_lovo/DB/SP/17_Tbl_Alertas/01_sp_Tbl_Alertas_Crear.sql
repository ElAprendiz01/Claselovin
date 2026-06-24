USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Alertas_Crear
(
    @Id_Presupuesto_Detalle INT,
    @Porcentaje_Consumido DECIMAL(5,2),
    @Mensaje_Alerta NVARCHAR(255),
    @Id_Estado INT = 1, -- Por defecto Activo (ID: 1)
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
        SET @o_message = 'El ID del detalle de presupuesto es obligatorio';
        RETURN;
    END;

    IF @Porcentaje_Consumido IS NULL OR @Porcentaje_Consumido < 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El porcentaje consumido no puede ser negativo';
        RETURN;
    END;

    IF @Mensaje_Alerta IS NULL OR LTRIM(RTRIM(@Mensaje_Alerta)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El mensaje de alerta es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia del detalle de presupuesto
    IF NOT EXISTS (SELECT 1 FROM Tbl_Detalle_Presupuesto WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El detalle de presupuesto especificado no existe';
        RETURN;
    END;

    -- Validar existencia del estado
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado no existe o esta inactivo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Alertas
        (
            Id_Presupuesto_Detalle,
            Porcentaje_Consumido,
            Mensaje_Alerta,
            Fecha_Generada,
            Leida,
            Id_Estado
        )
        VALUES
        (
            @Id_Presupuesto_Detalle,
            @Porcentaje_Consumido,
            TRIM(@Mensaje_Alerta),
            SYSDATETIME(),
            0, -- No leida por defecto
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Alerta creada correctamente';
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

EXEC sp_Tbl_Alertas_Crear
    @Id_Presupuesto_Detalle = 1,
    @Porcentaje_Consumido = 88.50,
    @Mensaje_Alerta = 'Consumo de presupuesto excede el 85 por ciento en pruebas',
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AlertaIdGenerada;
GO
