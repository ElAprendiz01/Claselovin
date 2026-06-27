using System;

namespace Domain.Estado
{
    public class DM_Estado_listar
    {
        public int? Id_Estado { get; set; }
        public string? Estado { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
