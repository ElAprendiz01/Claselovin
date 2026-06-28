using System;

namespace Domain.DatosPersonales
{
    public class DM_DatosPersonales_actualizar
    {
        public int? Id_Persona { get; set; }
        public int? Id_Genero { get; set; }
        public string? Primer_Nombre { get; set; }
        public string? Segundo_Nombre { get; set; }
        public string? Primer_Apellido { get; set; }
        public string? Segundo_Apellido { get; set; }
        public DateTime? Fecha_Nacimiento { get; set; }
        public int? Id_Tipo_DNI { get; set; }
        public string? DNI { get; set; }
        public int? Id_Modificador { get; set; }
        public int? Id_Estado { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
