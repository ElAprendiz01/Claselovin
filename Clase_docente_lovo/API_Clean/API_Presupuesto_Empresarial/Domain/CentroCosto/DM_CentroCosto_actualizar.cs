using System;

namespace Domain.CentroCosto
{
    public class DM_CentroCosto_actualizar
    {
        public int? Id_Centro_Costo { get; set; }
        public int? Id_Departamento { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Codigo_Contable { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
