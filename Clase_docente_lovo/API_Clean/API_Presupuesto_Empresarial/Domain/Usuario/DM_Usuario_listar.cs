using System;

namespace Domain.Usuario
{
    public class DM_Usuario_listar
    {
        public int? Id_Usuario { get; set; }
        public string? Usuario { get; set; }
        public int? Id_Persona { get; set; }
        public string? Nombre_Completo { get; set; }
        public string? DNI { get; set; }
        public int? Id_Rol { get; set; }
        public string? Nombre_Rol { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
