using System;

namespace Aplicacion.DTOs.Gasto
{
    public class GastoListarDTOs
    {
        public int? Id_Gasto { get; set; }
        public string? Descripcion_Gasto { get; set; }
        public decimal? Monto_Gasto { get; set; }
        public DateTime? Fecha_Gasto { get; set; }
        public string? Numero_Factura { get; set; }
        public int? Id_Proveedor { get; set; }
        public string? Proveedor { get; set; }
        public int? Id_Tipo_Gasto { get; set; }
        public string? Tipo_Gasto { get; set; }
        public int? Id_Presupuesto_Detalle { get; set; }
        public int? Id_Presupuesto { get; set; }
        public int? Anio_Fiscal { get; set; }
        public string? Nombre_Centro { get; set; }
        public string? Nombre_Departamento { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
    }
}
