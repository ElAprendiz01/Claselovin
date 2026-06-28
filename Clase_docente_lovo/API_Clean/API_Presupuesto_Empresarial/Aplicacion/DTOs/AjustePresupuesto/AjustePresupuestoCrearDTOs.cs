using System;

namespace Aplicacion.DTOs.AjustePresupuesto
{
    public class AjustePresupuestoCrearDTOs
    {
        public int? Id_Presupuesto_Detalle { get; set; }
        public string? Tipo_Ajuste { get; set; }
        public decimal? Monto_Ajuste { get; set; }
        public string? Justificacion { get; set; }
        public int? Id_Creador { get; set; }
    }
}
