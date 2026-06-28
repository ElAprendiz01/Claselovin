using System;

namespace Aplicacion.DTOs.AjustePresupuesto
{
    public class AjustePresupuestoFiltrarDTOs
    {
        public string? SearchTerm { get; set; }
        public int? Id_Ajuste { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
    }
}
