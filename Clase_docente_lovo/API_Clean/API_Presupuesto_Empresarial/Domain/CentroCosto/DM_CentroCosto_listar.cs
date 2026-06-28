using System;

namespace Domain.CentroCosto
{
    public class DM_CentroCosto_listar
    {
        public int? Id_Centro_Costo { get; set; }
        public int? Id_Departamento { get; set; }
        public string? Nombre_Departamento { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Codigo_Contable { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
