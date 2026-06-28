using System;

namespace Aplicacion.DTOs.Departamento
{
    public class DepartamentoListarDTOs
    {
        public int? Id_Departamento { get; set; }
        public string? Nombre_Departamento { get; set; }
        public string? Codigo_Softland { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
