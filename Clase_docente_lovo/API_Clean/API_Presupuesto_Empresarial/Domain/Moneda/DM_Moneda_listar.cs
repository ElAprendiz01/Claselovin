using System;

namespace Domain.Moneda
{
    public class DM_Moneda_listar
    {
        public int? Id_Moneda { get; set; }
        public string? Codigo_ISO { get; set; }
        public string? Nombre_Moneda { get; set; }
        public string? Simbolo { get; set; }
        public bool? Activo { get; set; }
    }
}
