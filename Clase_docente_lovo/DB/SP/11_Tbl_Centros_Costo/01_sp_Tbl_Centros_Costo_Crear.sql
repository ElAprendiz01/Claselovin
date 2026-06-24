USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Centros_Costo_Crear
(
    @Id_Departamento INT,
    @Nombre_Centro NVARCHAR(100),
    @Codigo_Contable NVARCHAR(50),
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
    IF @Id_Departamento IS NULL OR @Id_Departamento <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El departamento es obligatorio';
        RETURN;
    END;

    IF @Nombre_Centro IS NULL OR LTRIM(RTRIM(@Nombre_Centro)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del centro de costo es obligatorio';
        RETURN;
    END;

    IF @Codigo_Contable IS NULL OR LTRIM(RTRIM(@Codigo_Contable)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El codigo contable es obligatorio';
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

    -- Validar existencia y estado del departamento
    IF NOT EXISTS (SELECT 1 FROM Tbl_Departamentos WHERE Id_Departamento = @Id_Departamento AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El departamento no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad del codigo contable
    IF EXISTS (SELECT 1 FROM Tbl_Centros_Costo WHERE Codigo_Contable = TRIM(@Codigo_Contable))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El codigo contable ya esta registrado';
        RETURN;
    END;

    -- Validar creador activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
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

        INSERT INTO Tbl_Centros_Costo
        (
            Id_Departamento,
            Nombre_Centro,
            Codigo_Contable,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            @Id_Departamento,
            TRIM(@Nombre_Centro),
            TRIM(@Codigo_Contable),
            @Id_Creador,
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Centro de costo creado correctamente';
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

EXEC sp_Tbl_Centros_Costo_Crear
    @Id_Departamento = 1,
    @Nombre_Centro = 'Soporte Tecnico',
    @Codigo_Contable = 'CC-TI-03',
    @Id_Creador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CentroCostoIdGenerado;
GO
