USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Usuarios_Crear
(
    @Usuario NVARCHAR(50),
    @Contrasena NVARCHAR(255),
    @Id_Persona INT,
    @Id_Rol INT,
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
    IF @Usuario IS NULL OR LTRIM(RTRIM(@Usuario)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de usuario es obligatorio';
        RETURN;
    END;

    IF @Contrasena IS NULL OR LTRIM(RTRIM(@Contrasena)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La contrasena es obligatoria';
        RETURN;
    END;

    IF @Id_Persona IS NULL OR @Id_Persona <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona es obligatoria';
        RETURN;
    END;

    IF @Id_Rol IS NULL OR @Id_Rol <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar duplicidad de usuario
    IF EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Usuario = TRIM(@Usuario))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de usuario ya esta registrado';
        RETURN;
    END;

    -- Validar existencia y estado de la persona
    IF NOT EXISTS (SELECT 1 FROM Tbl_Datos_Personales WHERE Id_Persona = @Id_Persona AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona no existe o esta inactiva';
        RETURN;
    END;

    -- Validar que la persona no tenga otro usuario
    IF EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Persona = @Id_Persona)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La persona ya tiene asignado un usuario';
        RETURN;
    END;

    -- Validar existencia del rol activo
    IF NOT EXISTS (SELECT 1 FROM Tbl_Roles WHERE Id_Rol = @Id_Rol AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol no existe o esta inactivo';
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
    IF @Id_Creador IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tbl_Usuarios WHERE Id_Usuario = @Id_Creador AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El creador no existe o esta inactivo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Usuarios
        (
            Usuario,
            Contrasena,
            Id_Persona,
            Id_Rol,
            Id_Creador,
            Id_Estado
        )
        VALUES
        (
            TRIM(@Usuario),
            @Contrasena,
            @Id_Persona,
            @Id_Rol,
            @Id_Creador,
            @Id_Estado
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Usuario creado correctamente';
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

EXEC sp_Tbl_Usuarios_Crear
    @Usuario = 'nuevo_usuario',
    @Contrasena = 'Contrasena123',
    @Id_Persona = 2,
    @Id_Rol = 3,
    @Id_Creador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS UsuarioIdGenerado;
GO
