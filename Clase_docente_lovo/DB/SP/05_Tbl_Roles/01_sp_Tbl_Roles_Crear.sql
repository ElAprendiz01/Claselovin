USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Roles_Crear
(
    @Nombre NVARCHAR(50),
    @Descripcion NVARCHAR(150) = NULL,
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
    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre es obligatorio';
        RETURN;
    END;

    IF @Id_Estado IS NULL OR @Id_Estado <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio';
        RETURN;
    END;

    -- Validar existencia del estado activo
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

    -- Validar duplicidad de nombre
    IF EXISTS (SELECT 1 FROM Tbl_Roles WHERE Nombre = TRIM(@Nombre) AND Id_Estado = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El rol ya existe';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tbl_Roles (Nombre, Descripcion, Id_Creador, Id_Estado)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion), @Id_Creador, @Id_Estado);

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Rol creado correctamente';
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

EXEC sp_Tbl_Roles_Crear
    @Nombre = 'Gerente RRHH',
    @Descripcion = 'Gerente del area de Recursos Humanos ',
    @Id_Creador = 1,
    @Id_Estado = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS RolIdGenerado;
GO
