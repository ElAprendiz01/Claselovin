using Domain.Departamento;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IDepartamentoRepository
    {
        Task<IEnumerable<DM_Departamento_listar>> Listar_Cat_DepartamentosAsync();
        Task<IEnumerable<DM_Departamento_listar>> Filtrar_Cat_DepartamentosAsync(DM_Departamento_filtrar modelo);
        Task<DBResult> Crear_Cat_DepartamentosAsync(DM_Departamento_crear modelo);
        Task<DBResult> Actualizar_Cat_DepartamentosAsync(DM_Departamento_actualizar modelo);
        Task<DBResult> Eliminar_Cat_DepartamentosAsync(DM_Departamento_eliminar modelo);
    }
}
