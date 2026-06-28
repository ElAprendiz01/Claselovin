using System;

namespace Aplicacion.DTOs.CentroCosto
{
    public class CentroCostoActualizarDTOs
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
