using Domain.DetallePresupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IDetallePresupuestoRepository
    {
        Task<IEnumerable<DM_DetallePresupuesto_listar>> Listar_DetallePresupuestoAsync();
        Task<IEnumerable<DM_DetallePresupuesto_listar>> Filtrar_DetallePresupuestoAsync(DM_DetallePresupuesto_filtrar modelo);
        Task<DBResult> Crear_DetallePresupuestoAsync(DM_DetallePresupuesto_crear modelo);
        Task<DBResult> Actualizar_DetallePresupuestoAsync(DM_DetallePresupuesto_actualizar modelo);
        Task<DBResult> Eliminar_DetallePresupuestoAsync(DM_DetallePresupuesto_eliminar modelo);
    }
}
