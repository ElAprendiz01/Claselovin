USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Presupuestos_Crear
(
    @Anio_Fiscal INT,
    @Id_Moneda INT,
    @Descripcion NVARCHAR(150) = NULL,
    @Id_Creador INT,
    @Id_Estado INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validar parametros de entrada
    IF @Anio_Fiscal IS NULL OR @Anio_Fiscal <= 2020
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ano fiscal debe ser mayor a 2020';
        RETURN;
    END;

    IF @Id_Moneda IS NULL OR @Id_Moneda <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda es obligatoria';
        RETURN;
    END;

    IF @Id_Creador IS NULL OR @Id_Creador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia de la moneda
    IF NOT EXISTS (SELECT 1 FROM Cat_Monedas WHERE Id_Moneda = @Id_Moneda AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda no existe o esta inactiva';
        RETURN;
    END;

    -- Validar existencia del estado
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado no existe o esta inactivo';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar presupuesto aprobado unico por ano fiscal
    IF @Id_Estado = 4 AND EXISTS (SELECT 1 FROM Tbl_Presupuestos WHERE Anio_Fiscal = @Anio_Fiscal AND Id_Estado = 4)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un presupuesto aprobado para este ano fiscal';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Presupuestos
        (
            Anio_Fiscal,
            Id_Moneda,
            Descripcion,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            @Anio_Fiscal,
            @Id_Moneda,
            TRIM(@Descripcion),
            @Id_Creador,
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Presupuesto creado correctamente';
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

EXEC sp_Tbl_Presupuestos_Crear
    @Anio_Fiscal = 2027,
    @Id_Moneda = 1,
    @Descripcion = 'Presupuesto de prueba 2027',
    @Id_Creador = 1,
    @Id_Estado = 6, -- Borrador
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PresupuestoIdGenerado;
GO
