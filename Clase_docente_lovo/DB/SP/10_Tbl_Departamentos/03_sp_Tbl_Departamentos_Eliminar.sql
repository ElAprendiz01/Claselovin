USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Departamentos_Eliminar
(
    @Id_Departamento INT,
    @Id_Modificador INT,
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
        SET @o_message = 'El ID del departamento es obligatorio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y estado activo del departamento
    DECLARE @ExisteDepartamento INT;

    SELECT @ExisteDepartamento = 1
    FROM Tbl_Departamentos d
    INNER JOIN Cat_Estado e ON d.Id_Estado = e.Id_Estado
    WHERE d.Id_Departamento = @Id_Departamento
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteDepartamento IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El departamento no existe o esta inactivo';
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

    -- Validar existencia de centros de costo activos asociados
    IF EXISTS (
        SELECT 1 
        FROM Tbl_Centros_Costo cc
        INNER JOIN Cat_Estado e ON cc.Id_Estado = e.Id_Estado
        WHERE cc.Id_Departamento = @Id_Departamento 
          AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
          AND e.Activo = 1
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se puede desactivar: Tiene centros de costo activos asociados';
        RETURN;
    END;

    -- Obtener ID de estado inactivo
    DECLARE @Id_Estado_Inactivo INT;

    SELECT TOP 1 @Id_Estado_Inactivo = Id_Estado
    FROM Cat_Estado
    WHERE Estado IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND Activo = 1
    ORDER BY Id_Estado;

    IF @Id_Estado_Inactivo IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se encontro estado inactivo en catalogo';
        RETURN;
    END;

    -- Iniciar transaccion
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Tbl_Departamentos
        SET Id_Estado = @Id_Estado_Inactivo,
            Id_Modificador = @Id_Modificador,
            Fecha_Modificacion = SYSDATETIME()
        WHERE Id_Departamento = @Id_Departamento;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Departamento inhabilitado correctamente';
        SET @o_templateId = @Id_Departamento;
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

EXEC sp_Tbl_Departamentos_Eliminar
    @Id_Departamento = 3,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS DepartamentoIdEliminado;
GO
