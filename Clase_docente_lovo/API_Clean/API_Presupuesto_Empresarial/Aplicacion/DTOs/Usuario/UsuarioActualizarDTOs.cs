using System;

namespace Aplicacion.DTOs.Usuario
{
    public class UsuarioActualizarDTOs
    {
        public int? Id_Usuario { get; set; }
        public string? Usuario { get; set; }
        public string? Contrasena { get; set; }
        public int? Id_Persona { get; set; }
        public int? Id_Rol { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
