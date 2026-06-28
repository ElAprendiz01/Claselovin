using System;

namespace Aplicacion.DTOs.CentroCosto
{
    public class CentroCostoCrearDTOs
    {
        public int? Id_Departamento { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Codigo_Contable { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
