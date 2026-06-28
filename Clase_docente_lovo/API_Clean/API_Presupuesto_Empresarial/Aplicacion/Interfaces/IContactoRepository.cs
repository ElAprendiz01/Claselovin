using Domain.Contacto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IContactoRepository
    {
        Task<IEnumerable<DM_Contacto_listar>> Listar_Cat_ContactoAsync();
        Task<DBResult> Crear_Cat_ContactoAsync(DM_Contacto_crear modelo);
        Task<DBResult> Actualizar_Cat_ContactoAsync(DM_Contacto_actualizar modelo);
        Task<DBResult> Eliminar_Cat_ContactoAsync(DM_Contacto_eliminar modelo);
    }
}
