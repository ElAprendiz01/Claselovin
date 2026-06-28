using System;

namespace Aplicacion.DTOs.Presupuesto
{
    public class PresupuestoListarDTOs
    {
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
        public int? Id_Moneda { get; set; }
        public string? Codigo_ISO { get; set; }
        public string? Nombre_Moneda { get; set; }
        public string? Simbolo { get; set; }
        public string? Descripcion { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
