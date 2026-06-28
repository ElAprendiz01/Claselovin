USE Presupuesto_Empresarial;
GO

CREATE OR ALTER PROCEDURE sp_Tbl_Gastos_Eliminar
(
    @Id_Gasto INT,
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
    IF @Id_Gasto IS NULL OR @Id_Gasto <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del gasto es obligatorio';
        RETURN;
    END;

    IF @Id_Modificador IS NULL OR @Id_Modificador <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El modificador es obligatorio';
        RETURN;
    END;

    -- Validar existencia y actividad del gasto
    DECLARE @Id_Presupuesto_Detalle INT;
    DECLARE @Monto_Gasto DECIMAL(18,2);
    DECLARE @ExisteGasto INT;

    SELECT @Id_Presupuesto_Detalle = g.Id_Presupuesto_Detalle,
           @Monto_Gasto = g.Monto_Gasto,
           @ExisteGasto = 1
    FROM Tbl_Gastos g
    INNER JOIN Cat_Estado e ON g.Id_Estado = e.Id_Estado
    WHERE g.Id_Gasto = @Id_Gasto
      AND e.Estado NOT IN ('Desactivado', 'Inactivo', 'Eliminado')
      AND e.Activo = 1;

    IF @ExisteGasto IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El gasto no existe o esta inactivo';
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

        -- Inactivar el gasto
        UPDATE Tbl_Gastos
        SET Id_Estado = @Id_Estado_Inactivo
        WHERE Id_Gasto = @Id_Gasto;

        -- Restar monto ejecutado en el detalle de presupuesto
        UPDATE Tbl_Detalle_Presupuesto
        SET Monto_Ejecutado = Monto_Ejecutado - @Monto_Gasto,
            Fecha_Modificacion = SYSDATETIME(),
            Id_Modificador = @Id_Modificador
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        -- Calcular nuevo porcentaje de ejecucion
        DECLARE @Nuevo_Monto_Ejecutado DECIMAL(18,2);
        DECLARE @Monto_Presupuestado DECIMAL(18,2);
        
        SELECT @Nuevo_Monto_Ejecutado = Monto_Ejecutado,
               @Monto_Presupuestado = Monto_Presupuestado
        FROM Tbl_Detalle_Presupuesto 
        WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle;

        DECLARE @Porcentaje DECIMAL(5,2);
        IF @Monto_Presupuestado > 0
            SET @Porcentaje = (@Nuevo_Monto_Ejecutado / @Monto_Presupuestado) * 100.00;
        ELSE
            SET @Porcentaje = 0.00;

        -- Desactivar alertas si baja del 85
        IF @Porcentaje <= 85.00
        BEGIN
            UPDATE Tbl_Alertas
            SET Leida = 1,
                Id_Estado = @Id_Estado_Inactivo
            WHERE Id_Presupuesto_Detalle = @Id_Presupuesto_Detalle 
              AND Leida = 0 
              AND Id_Estado <> @Id_Estado_Inactivo;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Gasto inhabilitado y restado del presupuesto correctamente';
        SET @o_templateId = @Id_Gasto;
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

EXEC sp_Tbl_Gastos_Eliminar
    @Id_Gasto = 2,
    @Id_Modificador = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS GastoIdEliminado;
GO
select * from Tbl_Gastos 
select * from Tbl_Detalle_Presupuesto

UPDATE Tbl_Detalle_Presupuesto
SET  
    Monto_Ejecutado = 0  
WHERE Id_Presupuesto_Detalle = 2;
