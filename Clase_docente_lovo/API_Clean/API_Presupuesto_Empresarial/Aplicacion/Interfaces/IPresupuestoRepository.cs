using Domain.Presupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IPresupuestoRepository
    {
        Task<IEnumerable<DM_Presupuesto_listar>> Listar_PresupuestoAsync();
        Task<IEnumerable<DM_Presupuesto_listar>> Filtrar_PresupuestoAsync(DM_Presupuesto_filtrar modelo);
        Task<DBResult> Crear_PresupuestoAsync(DM_Presupuesto_crear modelo);
        Task<DBResult> Actualizar_PresupuestoAsync(DM_Presupuesto_actualizar modelo);
        Task<DBResult> Eliminar_PresupuestoAsync(DM_Presupuesto_eliminar modelo);
    }
}
