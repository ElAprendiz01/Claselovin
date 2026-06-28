USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Aprobaciones_Listar
AS
BEGIN
    SET NOCOUNT ON;

    -- Consultar todos los registros
    SELECT 
        Id_Aprobacion,
        Id_Presupuesto,
        Id_Gasto,
        Id_Usuario_Aprobador,
        Nombre_Aprobador,
		Usuario,
        Fecha_Decision,
        Comentarios,
        Id_Resultado_Aprobacion,
        Resultado_Aprobacion,
        Fecha_Creacion,
        Id_Creador
    FROM VW_Auditoria_Aprobaciones_General (NOLOCK);
END;
GO

-- Ejemplo ejecucion
EXEC sp_Tbl_Aprobaciones_Listar;
GO


select * from VW_Auditoria_Aprobaciones_General