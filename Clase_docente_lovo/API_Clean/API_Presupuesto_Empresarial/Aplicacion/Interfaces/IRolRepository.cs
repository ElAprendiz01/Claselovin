using Domain.Rol;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IRolRepository
    {
        Task<IEnumerable<DM_Rol_listar>> Listar_Cat_RolesAsync();
        Task<IEnumerable<DM_Rol_listar>> Filtrar_Cat_RolesAsync(DM_Rol_filtrar modelo);
        Task<DBResult> Crear_Cat_RolesAsync(DM_Rol_crear modelo);
        Task<DBResult> Actualizar_Cat_RolesAsync(DM_Rol_actualizar modelo);
        Task<DBResult> Eliminar_Cat_RolesAsync(DM_Rol_eliminar modelo);
    }
}
