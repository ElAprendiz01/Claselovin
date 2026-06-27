using System;

namespace Aplicacion.DTOs.TipoCatalogo
{
    public class TipoCatalogoActualizarDTOs
    {
        public int? Id_Tipo_Catalogo { get; set; }
        public string? Nombre { get; set; }
        public int? Id_Modificador { get; set; }
        public bool? Activo { get; set; }
    }
}
