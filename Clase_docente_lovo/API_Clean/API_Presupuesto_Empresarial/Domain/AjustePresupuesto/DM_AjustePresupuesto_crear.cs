using System;

namespace Domain.AjustePresupuesto
{
    public class DM_AjustePresupuesto_crear
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public string? Tipo_Ajuste { get; set; }
        public decimal? Monto_Ajuste { get; set; }
        public string? Justificacion { get; set; }
        public int? Id_Creador { get; set; }
    }
}
