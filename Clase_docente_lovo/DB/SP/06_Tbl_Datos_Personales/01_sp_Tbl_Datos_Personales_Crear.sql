USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Datos_Personales_Crear
(
    @Id_Genero INT,
    @Primer_Nombre NVARCHAR(50),
    @Segundo_Nombre NVARCHAR(50) = NULL,
    @Primer_Apellido NVARCHAR(50),
    @Segundo_Apellido NVARCHAR(50) = NULL,
    @Fecha_Nacimiento DATE = NULL,
    @Id_Tipo_DNI INT,
    @DNI VARCHAR(20),
    @Id_Creador INT = NULL,
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
    IF @Primer_Nombre IS NULL OR LTRIM(RTRIM(@Primer_Nombre)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El primer nombre es obligatorio';
        RETURN;
    END;

	IF @Fecha_Nacimiento IS NOT NULL
    BEGIN
        IF @Fecha_Nacimiento > DATEADD(YEAR, -18, CAST(SYSDATETIME() AS DATE))
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La persona debe ser mayor de 18 años';
            RETURN;
        END;
    END;

    IF @Primer_Apellido IS NULL OR LTRIM(RTRIM(@Primer_Apellido)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El primer apellido es obligatorio';
        RETURN;
    END;

    IF @DNI IS NULL OR LTRIM(RTRIM(@DNI)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El DNI es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia del genero
    IF @Id_Genero IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Genero AND Id_Tipo_Catalogo = 1 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El genero no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del tipo DNI
    IF @Id_Tipo_DNI IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_DNI AND Id_Tipo_Catalogo = 2 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo DNI no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del estado
    IF NOT EXISTS (SELECT 1 FROM Cat_Estado WHERE Id_Estado = @Id_Estado AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado no existe o esta inactivo';
        RETURN;
    END;

    -- Validar existencia del creador
    IF @Id_Creador IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Validar duplicidad de DNI
    IF EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE DNI = TRIM(@DNI))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El DNI ya esta registrado';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Datos_Personales 
        (
            Id_Genero, 
            Primer_Nombre, 
            Segundo_Nombre, 
            Primer_Apellido, 
            Segundo_Apellido, 
            Fecha_Nacimiento, 
            Id_Tipo_DNI, 
            DNI, 
            Id_Creador, 
            Id_Estado
        )
        VALUES 
        (
            @Id_Genero, 
            TRIM(@Primer_Nombre), 
            TRIM(@Segundo_Nombre), 
            TRIM(@Primer_Apellido), 
            TRIM(@Segundo_Apellido), 
            @Fecha_Nacimiento, 
            @Id_Tipo_DNI, 
            TRIM(@DNI), 
            @Id_Creador, 
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Datos personales creados correctamente';
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

EXEC sp_Tbl_Datos_Personales_Crear
    @Id_Genero = 1,
    @Primer_Nombre = 'Ramon',
    @Primer_Apellido = 'Valdez',
    @Fecha_Nacimiento = '1970-01-01',
    @Id_Tipo_DNI = 3,
    @DNI = '001-010170-8600X',
    @Id_Creador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PersonaIdGenerada;
GO
