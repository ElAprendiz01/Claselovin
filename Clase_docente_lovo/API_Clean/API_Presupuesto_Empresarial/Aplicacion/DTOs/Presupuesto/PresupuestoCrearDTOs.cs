using System;

namespace Aplicacion.DTOs.Presupuesto
{
    public class PresupuestoCrearDTOs
    {
        public int? Anio_Fiscal { get; set; }
        public int? Id_Moneda { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Estado { get; set; }
    }
}
