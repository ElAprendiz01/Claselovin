USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Departamentos_Crear
(
    @Nombre_Departamento NVARCHAR(100),
    @Codigo_Softland NVARCHAR(20) = NULL,
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
    IF @Nombre_Departamento IS NULL OR LTRIM(RTRIM(@Nombre_Departamento)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del departamento es obligatorio';
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

    -- Validar duplicidad de nombre de departamento
    IF EXISTS (SELECT 1 FROM Tbl_Departamentos WHERE Nombre_Departamento = TRIM(@Nombre_Departamento))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El departamento ya esta registrado';
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

        INSERT INTO Tbl_Departamentos
        (
            Nombre_Departamento,
            Codigo_Softland,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            TRIM(@Nombre_Departamento),
            TRIM(@Codigo_Softland),
            @Id_Creador,
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Departamento creado correctamente';
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

EXEC sp_Tbl_Departamentos_Crear
    @Nombre_Departamento = 'Operaciones',
    @Codigo_Softland = 'DEP-OPE',
    @Id_Creador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS DepartamentoIdGenerado;
GO
