using System;

namespace Domain.Contacto
{
    public class DM_Contacto_listar
    {
        public int? Id_Contacto { get; set; }
        public int? Id_Persona { get; set; }
        public string? Nombre_Persona { get; set; }
        public int? Id_Tipo_Contacto { get; set; }
        public string? Nombre_Tipo_Contacto { get; set; }
        public string? Contacto { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
