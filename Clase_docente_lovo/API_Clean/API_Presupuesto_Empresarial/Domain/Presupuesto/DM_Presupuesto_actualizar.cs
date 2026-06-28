using System;

namespace Domain.Presupuesto
{
    public class DM_Presupuesto_actualizar
    {
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
        public int? Id_Moneda { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
