using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.VariablesSalida
{
    public class DBResult
    {
        public int? Code { get; set; }
        public string? Message { get; set; }
        public int? TemplateId { get; set; }

        // Propiedad calculada útil para los Controladores
        public bool IsSuccess => Code >= 0;
    }
}
