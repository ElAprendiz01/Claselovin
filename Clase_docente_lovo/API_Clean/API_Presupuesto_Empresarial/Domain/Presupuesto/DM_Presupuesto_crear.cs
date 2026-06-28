using System;

namespace Domain.Presupuesto
{
    public class DM_Presupuesto_crear
    {
        public int? Anio_Fiscal { get; set; }
        public int? Id_Moneda { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
