using System;

namespace Aplicacion.DTOs.DatosPersonales
{
    public class DatosPersonalesListarDTOs
    {
        public int? Id_Persona { get; set; }
        public string? Primer_Nombre { get; set; }
        public string? Segundo_Nombre { get; set; }
        public string? Primer_Apellido { get; set; }
        public string? Segundo_Apellido { get; set; }
        public string? Nombre_Completo { get; set; }
        public string? DNI { get; set; }
        public int? Id_Tipo_DNI { get; set; }
        public string? Nombre_Tipo_DNI { get; set; }
        public int? Id_Genero { get; set; }
        public string? Nombre_Genero { get; set; }
        public DateTime? Fecha_Nacimiento { get; set; }
        public int? Id_Estado { get; set; }
        public string? Nombre_Estado { get; set; }
        public int? Id_Creador { get; set; }
        public int? Id_Modificador { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public DateTime? Fecha_Modificacion { get; set; }
    }
}
