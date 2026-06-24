USE Presupuesto_Empresarial;
GO

-- Vista para consolidar departamentos y centros costo
CREATE OR ALTER VIEW VW_Estructura_Organizacional_General
AS
SELECT 
    CC.Id_Centro_Costo,
    CC.Nombre_Centro,
    CC.Codigo_Contable AS Codigo_Centro,
    D.Id_Departamento,
    D.Nombre_Departamento,
    D.Codigo_Softland AS Codigo_Depto,
    E_CC.Estado AS Estado_Centro,
    E_D.Estado AS Estado_Depto,
    CC.Id_Estado AS Id_Estado_Centro,
    D.Id_Estado AS Id_Estado_Depto,
    CC.Id_Creador,
    CC.Id_Modificador,
    CC.Fecha_Creacion,
    CC.Fecha_Modificacion
FROM Tbl_Centros_Costo CC (NOLOCK)
INNER JOIN Tbl_Departamentos D (NOLOCK) ON CC.Id_Departamento = D.Id_Departamento
INNER JOIN Cat_Estado E_CC (NOLOCK) ON CC.Id_Estado = E_CC.Id_Estado
INNER JOIN Cat_Estado E_D (NOLOCK) ON D.Id_Estado = E_D.Id_Estado;
GO

SELECT * FROM VW_Estructura_Organizacional_General;
GO
