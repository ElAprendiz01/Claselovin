USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Ajustes_Presupuesto_Actualizar
(
    @Id_Ajuste INT,
    @Monto_Ajuste DECIMAL(18,2),
    @Justificacion NVARCHAR(255),
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
    SET @o_message = 'Actualizaciones de ajustes estan prohibidas por auditoria interna';
    SET @o_templateId = @Id_Ajuste;
    RETURN;
END;
GO

-- Ejemplo ejecucion
DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
EXEC sp_Tbl_Ajustes_Presupuesto_Actualizar
    @Id_Ajuste = 1,
    @Monto_Ajuste = 1000.00,
    @Justificacion = 'Modificar',
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT;
SELECT @v_code AS Codigo, @v_message AS Mensaje;
GO
