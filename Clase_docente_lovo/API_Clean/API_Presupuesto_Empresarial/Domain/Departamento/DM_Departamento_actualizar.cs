using System;

namespace Domain.Departamento
{
    public class DM_Departamento_actualizar
    {
        public int? Id_Departamento { get; set; }
        public string? Nombre_Departamento { get; set; }
        public string? Codigo_Softland { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
