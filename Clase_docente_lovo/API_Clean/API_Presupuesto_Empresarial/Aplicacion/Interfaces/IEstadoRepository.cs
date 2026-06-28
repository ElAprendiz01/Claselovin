using Domain.Estado;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IEstadoRepository
    {
        Task<IEnumerable<DM_Estado_listar>> Listar_Cat_EstadoAsync();
        Task<IEnumerable<DM_Estado_listar>> Filtrar_Cat_EstadoAsync(DM_Estado_filtrar modelo);
        Task<DBResult> Crear_Cat_EstadoAsync(DM_Estado_crear modelo);
        Task<DBResult> Actualizar_Cat_EstadoAsync(DM_Estado_actualizar modelo);
        Task<DBResult> Eliminar_Cat_EstadoAsync(DM_Estado_eliminar modelo);
    }
}
