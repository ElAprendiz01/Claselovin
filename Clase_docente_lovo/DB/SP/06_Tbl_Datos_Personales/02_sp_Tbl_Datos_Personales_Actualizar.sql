USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Datos_Personales_Actualizar
(
    @Id_Persona INT,
    @Id_Genero INT = NULL,
    @Primer_Nombre NVARCHAR(50) = NULL,
    @Segundo_Nombre NVARCHAR(50) = NULL,
    @Primer_Apellido NVARCHAR(50) = NULL,
    @Segundo_Apellido NVARCHAR(50) = NULL,
    @Fecha_Nacimiento DATE = NULL,
    @Id_Tipo_DNI INT = NULL,
    @DNI VARCHAR(20) = NULL,
    @Id_Modificador INT,
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

    -- Validar parametros de entrada
    IF @Id_Persona IS NULL OR @Id_Persona <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la persona es obligatorio';
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

    IF @Primer_Nombre IS NOT NULL AND LTRIM(RTRIM(@Primer_Nombre)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El primer nombre no puede estar vacio';
        RETURN;
    END;

    IF @Primer_Apellido IS NOT NULL AND LTRIM(RTRIM(@Primer_Apellido)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El primer apellido no puede estar vacio';
        RETURN;
    END;

    IF @DNI IS NOT NULL AND LTRIM(RTRIM(@DNI)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El DNI no puede estar vacio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar si esta inactivo y @ForzarRecuperacion = 0
    IF @ForzarRecuperacion = 0
        AND EXISTS (
            SELECT 1
            FROM Tbl_Datos_Personales p
            INNER JOIN Cat_Estado e ON p.Id_Estado = e.Id_Estado
            WHERE p.Id_Persona = @Id_Persona
              AND e.Estado IN ('Desactivado', 'Inactivo', 'Eliminado', 'Suspendido')
        )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del registro indica que esta inactivo o desactivado. Si cree que es un error, comuniquese con administracion.';
        RETURN;
    END;

    -- Validar existencia de la persona
    IF NOT EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE Id_Persona = @Id_Persona)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona no existe';
        RETURN;
    END;

    -- Validar existencia del genero si se envia
    IF @Id_Genero IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Genero AND Id_Tipo_Catalogo = 1 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El genero no existe o esta inactivo';
        RETURN;
    END;

    -- Validar tipo DNI si se envia
    IF @Id_Tipo_DNI IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cat_General WHERE Id_Catalogo = @Id_Tipo_DNI AND Id_Tipo_Catalogo = 2 AND Activo = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo DNI no existe o esta inactivo';
        RETURN;
    END;

    -- Validar modificador activo
    DECLARE @ExisteModificador INT;
    SELECT @ExisteModificador = 1
    FROM Tbl_Usuarios u
    INNER JOIN Cat_Estado e ON u.Id_Estado = e.Id_Estado
    WHERE u.Id_Usuario = @Id_Modificador
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteModificador IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador no existe o esta inactivo';
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

    -- Validar duplicidad de DNI excluyendo actual
    IF @DNI IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE DNI = TRIM(@DNI) AND Id_Persona <> @Id_Persona)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El DNI ya esta registrado';
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

        UPDATE Tbl_Datos_Personales
        SET Id_Genero = COALESCE(@Id_Genero, Id_Genero),
            Primer_Nombre = TRIM(COALESCE(@Primer_Nombre, Primer_Nombre)),
            Segundo_Nombre = TRIM(COALESCE(@Segundo_Nombre, Segundo_Nombre)),
            Primer_Apellido = TRIM(COALESCE(@Primer_Apellido, Primer_Apellido)),
            Segundo_Apellido = TRIM(COALESCE(@Segundo_Apellido, Segundo_Apellido)),
            Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento),
            Id_Tipo_DNI = COALESCE(@Id_Tipo_DNI, Id_Tipo_DNI),
            DNI = TRIM(COALESCE(@DNI, DNI)),
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Estado = COALESCE(@Id_Estado, CASE WHEN @ForzarRecuperacion = 1 THEN @Id_Estado_Activo ELSE Id_Estado END)
        WHERE Id_Persona = @Id_Persona;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Datos personales actualizados correctamente';
        SET @o_templateId = @Id_Persona;
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

EXEC sp_Tbl_Datos_Personales_Actualizar
    @Id_Persona = 4,
    @Id_Genero = 1,
    @Primer_Nombre = 'Juan',
    @Id_Modificador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS PersonaIdModificada;
GO
