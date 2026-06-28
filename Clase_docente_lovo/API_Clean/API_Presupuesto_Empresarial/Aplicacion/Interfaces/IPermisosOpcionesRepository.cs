using Domain.PermisosOpciones;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IPermisosOpcionesRepository
    {
        Task<IEnumerable<DM_PermisosOpciones_listar>> Listar_Cat_PermisosOpcionesAsync();
        Task<IEnumerable<DM_PermisosOpciones_listar>> Filtrar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_filtrar modelo);
        Task<DBResult> Crear_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_crear modelo);
        Task<DBResult> Actualizar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_actualizar modelo);
        Task<DBResult> Eliminar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_eliminar modelo);
    }
}
