USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Aprobaciones_Actualizar
(
    @Id_Aprobacion INT,
    @Id_Resultado_Aprobacion INT,
    @Comentarios NVARCHAR(255),
    @Id_Modificador INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Bloqueo por auditoria interna
    SET @o_code = -1;
    SET @o_message = 'Actualizaciones de aprobaciones estan prohibidas por auditoria interna';
    SET @o_templateId = @Id_Aprobacion;
    RETURN;
END;
GO

-- Ejemplo ejecucion
DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
EXEC sp_Tbl_Aprobaciones_Actualizar
    @Id_Aprobacion = 1,
    @Id_Resultado_Aprobacion = 11,
    @Comentarios = 'Cambiar comentario',
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT;
SELECT @v_code AS Codigo, @v_message AS Mensaje;
GO
