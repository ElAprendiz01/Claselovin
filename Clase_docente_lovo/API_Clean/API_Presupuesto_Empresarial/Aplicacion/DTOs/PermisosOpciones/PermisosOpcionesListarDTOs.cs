using System;

namespace Aplicacion.DTOs.PermisosOpciones
{
    public class PermisosOpcionesListarDTOs
    {
        public int? Id_Permiso { get; set; }
        public int? Id_Rol { get; set; }
        public string? Nombre_Rol { get; set; }
        public string? Modulo { get; set; }
        public bool? Puede_Crear { get; set; }
        public bool? Puede_Leer { get; set; }
        public bool? Puede_Actualizar { get; set; }
        public bool? Puede_Eliminar { get; set; }
        public DateTime? Fecha_Creacion { get; set; }
        public int? Id_Creador { get; set; }
    }
}
