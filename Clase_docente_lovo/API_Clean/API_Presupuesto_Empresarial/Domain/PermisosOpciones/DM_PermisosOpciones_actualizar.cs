using System;

namespace Domain.PermisosOpciones
{
    public class DM_PermisosOpciones_actualizar
    {
        public int? Id_Permiso { get; set; }
        public int? Id_Rol { get; set; }
        public string? Modulo { get; set; }
        public bool? Puede_Crear { get; set; }
        public bool? Puede_Leer { get; set; }
        public bool? Puede_Actualizar { get; set; }
        public bool? Puede_Eliminar { get; set; }
    }
}
